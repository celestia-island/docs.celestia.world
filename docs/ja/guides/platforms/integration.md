# 統合ガイド — Evernight

各サポート対象プロトコルへ evernight を接続する方法、使用するサーバーソフトウェア、そして接続がエンドツーエンドで機能することを検証する方法を説明します。

## アーキテクチャ

```text
  Your app (CLI / TUI / Web / Agent)
         │
         ▼
   evernight crate
   ├── Industrial protocols (Modbus / S7comm / MC / EtherNet/IP / OPC UA / CAN / IPMI / EtherCAT)
   ├── Remote control (SSH / VNC / RDP)
   ├── Cloud (Proxmox / EC2 / k8s / libvirt / Tailscale / CODESYS / OpenPLC)
   ├── Security (vault / broker gates / write-approval)
   └── Tooling (MCP server / FFI / scripting / CLI)
         │
         ▼
   Physical hardware / remote servers / cloud APIs
```

-----------------------------------------------------------------------------

## 1. Modbus RTU（シリアル）

### サーバー側
- **デバイス**：任意の Modbus RTU スレーブ（PLC、センサー、インバータ）
- **サーバー不要のテスト**：`socat PTY,raw,echo=0,link=/tmp/vcom_a PTY,raw,echo=0,link=/tmp/vcom_b &`
  —— 仮想シリアルペアを作成します。`tests/modbus_slave_sim.rs` を 6 局ぶん実行してください。

### evernight 側
```rust
use evernight::serial::modbus::ModbusMaster;

let master = ModbusMaster::builder(19)      // station 19
    .with_port("/dev/ttyUSB0")
    .with_baud_rate(57600)
    .with_timeout(2000)
    .open()?;

let result = master.read_registers(RegisterMode::Holding, 0x10, 33)?;
println!("Pressures: {:?}", &result.values[..3]);
```

### CLI
```bash
evernight sensor-poll --manifest corridor.toml
```

-----------------------------------------------------------------------------

## 2. S7comm（シーメンス）

### サーバー側
- **デバイス**：S7-1200/1500/300/400 PLC
- **前提条件**：TIA Portal → "Permit PUT/GET" を有効化 + "Optimized block access" を無効化
- **ハードウェア不要のテスト**：`cargo test --features full --test s7comm_integration`（インプロセスの snap7 サーバーを使用）

### evernight 側
```rust
use evernight::protocol::s7comm::{S7CommClient, S7ConnectParams};

let client = S7CommClient::new(S7ConnectParams {
    host: "192.168.1.10".into(), port: 102, rack: 0, slot: 1,
});
client.connect().await?;
let bytes = client.read_db(1, 0, 4).await?;       // DB1 offset 0, 4 bytes
let temp = f32::from_be_bytes(bytes.try_into().unwrap());
println!("Temperature: {:.1} °C", temp);
```

-----------------------------------------------------------------------------

## 3. MC プロトコル（三菱）

### サーバー側
- **デバイス**：MELSEC FX/Q/L/iQ-R PLC
- **ハードウェア不要のテスト**：`tests/mc_test_server.rs`（インプロセスのモック MC サーバー）

### evernight 側
```rust
use evernight::protocol::mc_protocol::{McProtocolClient, McDevice};

let client = McProtocolClient::new("192.168.1.5", 5000);
client.connect().await?;
let words = client.read_devices(McDevice::D, 0, 10).await?;
println!("D0-D9: {:?}", words);
```

-----------------------------------------------------------------------------

## 4. EtherNet/IP（ロックウェル）

### サーバー側
- **デバイス**：Allen-Bradley CompactLogix / ControlLogix
- **ハードウェア不要のテスト**：手作りフレームによるユニットテスト（実サーバーのシミュレータなし）

### evernight 側
```rust
use evernight::protocol::ethernet_ip_backend::EthernetIpBackend;
use evernight::protocol::backend::{ProtocolBackend, TransportInfo, DataAddress};

let mut backend = EthernetIpBackend::new("192.168.1.10", 44818);
backend.connect(&TransportInfo::Tcp { host: "192.168.1.10".into(), port: 44818 })?;
let result = backend.read(&DataAddress::Raw {
    data: b"0x6E:0x01:0x05".to_vec(),  // class 0x6E, instance 1, attr 5
    size: 4,
})?;
println!("Value: {:02X?}", result.raw);
```

-----------------------------------------------------------------------------

## 5. OPC UA

### サーバー側
- **デバイス／ソフトウェア**：任意の OPC UA サーバー（KEPServerEX、Ignition、CODESYS など）
- **セルフホスト**：evernight 自身が OPC UA サーバーとして動作できます：

```rust
use evernight::protocol::opcua_server::OpcUaSensorServer;

let mut server = OpcUaSensorServer::new("opc.tcp://0.0.0.0:4840", 4840)?;
let node = server.add_sensor_variable("temperature", 25.5)?;
// server.run();  // blocks — run in a separate thread
```

### evernight クライアント側
```rust
use evernight::protocol::opcua_client::{OpcUaClient, OpcUaEndpoint, OpcUaSecurity};

let endpoint = OpcUaEndpoint::new_anonymous("opc.tcp://192.168.1.50:4840");
let client = OpcUaClient::connect(&endpoint).await?;
let value = client.read_node("ns=2;s=Temperature").await?;
println!("Temperature: {}", value);
```

-----------------------------------------------------------------------------

## 6. SSH

### サーバー側
- 任意の SSH サーバー（OpenSSH、Dropbear など）
- **鍵管理**：`evernight vault init ~/.config/evernight/vault "passphrase"`
  を実行後、認証情報を追加します。

### evernight 側
```bash
# Interactive terminal
evernight connect ssh://user@192.168.1.100

# One-shot command
evernight exec --host 192.168.1.100 --user root --key ~/.ssh/id_ed25519 \
  --command "uname -a"

# File transfer
evernight file put ./config.yaml root@192.168.1.100:/etc/app/config.yaml

# SOCKS5 proxy through SSH
evernight proxy 1080 --host 192.168.1.100 --user root
```

-----------------------------------------------------------------------------

## 7. VNC

### サーバー側
- **ソフトウェア**：TigerVNC、x11vnc、RealVNC など
- **インストール**：`apt install tigervnc-standalone-server && vncserver :1`
- **ブラウザアクセス**：evernight は VNC を WebSocket へプロキシできます：

```bash
# Start a VNC-to-WebSocket proxy (noVNC-compatible)
# (programmatically via evernight::vnc::ws::serve_vnc_websocket)
```

### evernight 側
```bash
# CLI one-shot — handshake + server info + one frame capture
evernight connect vnc://192.168.1.100:5901
```

-----------------------------------------------------------------------------

## 8. RDP

### サーバー側
- **Windows**：ネイティブ RDP（設定 → リモートデスクトップ → 有効化）
- **Linux**：`apt install xrdp`
  - TLS の場合：`/etc/xrdp/xrdp.ini` に `security_layer=tls` を設定
  - 証明書を生成：`openssl req -x509 -newkey rsa:2048 -nodes -keyout key.pem -out cert.pem -days 365 -subj "/CN=localhost"`
  - `/etc/xrdp/cert.pem` と `/etc/xrdp/key.pem` へコピー

### evernight 側
```rust
use evernight::rdp::x224::{RdpClient, RdpConfig};

let config = RdpConfig {
    host: "192.168.1.100".to_string(),
    port: 3389,
    username: Some("admin".into()),
    password: Some("password".into()),
    ..Default::default()
};
let mut client = RdpClient::connect(&config).await?;
println!("Connected: {}x{}, TLS", client.width(), client.height());
// Send MCS Connect-Initial, Attach-User, Channel-Join, ...
// Receive bitmap updates, decode to RGBA via bitmap::decode_to_rgba
```

```bash
# CLI one-shot — handshake + protocol/desktop info
evernight connect rdp://192.168.1.100:3389
```

### 現在の RDP の状況
- ✅ トランスポート：X.224 + TLS アップグレード（実際の xrdp で検証済み）
- ✅ MCS：Connect-Initial/Response + Attach-User（検証済み）
- ✅ ビットマップ：非圧縮 + Interleaved RLE デコード → RGBA
- ✅ 入力：キーボードスキャンコード + マウスイベント
- ✅ チャネル：CLIPRDR + RDPDR + RDPSND + DVC
- ✅ NLA：NTLMv2 + CredSSP（Kerberos には KDC が必要）
- ◐ セッション：Channel-Join → ケイパビリティ交換 → 連続フレームバッファループが必要

-----------------------------------------------------------------------------

## 9. Kubernetes

### サーバー側
- 任意の k8s クラスタ（minikube、kind、EKS、GKE など）
- 認証：`~/.kube/config` またはクラスタ内サービスアカウント

### evernight 側
```rust
use evernight::cloud::k8s::K8sClient;

let client = K8sClient::from_kubeconfig("default").await?;
let pods = client.list_pods().await?;
for pod in &pods {
    println!("{}: {} ({} containers)", pod.name, pod.phase, pod.containers.len());
}
```

-----------------------------------------------------------------------------

## 10. libvirt

### サーバー側
- `apt install libvirt-daemon-system libvirt-dev`
- libvirtd を起動：`systemctl start libvirtd`

### evernight 側
```rust
use evernight::cloud::libvirt_client::LibvirtClient;

let client = LibvirtClient::open_read_only("qemu:///system")?;
let domains = client.list_domains()?;
for d in &domains {
    println!("{}: {:?}", d.name, d.state);
}
```

-----------------------------------------------------------------------------

## クライアントの問い：ビューワーを自作すべきか？

### 問題

evernight は RDP ビットマップを RGBA バッファへ、VNC フレームをピクセルへデコードしますが、**それを表示する場所がありません**。レンダラがないと：

- ビットマップデコードが正しいことを視覚的に検証できません（クラッシュしないことしか確認できません）
- ドッグフーディングできません —— evernight は「XPipe クラスの汎用コネクションマネージャ」であるはずで、XPipe はリモートデスクトップを表示します
- 手動テストには外部ビューワーが必要です（mstsc.exe / xfreerdp / vinagre）

### 推奨：はい —— 最小限の組み込みビューワーを作る

労力の観点で 3 段階あります。最もシンプルなものから有用なものへ：

#### Tier 1：ヘッドレススクリーンショット（最小の労力、最高のテスト価値）

```text
evernight connect rdp://host --screenshot out.png
```

セッションセットアップ後に 1 フレームをキャプチャし、PNG へ書き出します。GUI は不要です。既存の `bitmap::decode_to_rgba` + シンプルな PNG エンコーダ（あるいは依存ゼロの PPM）を使います。これにより得られるもの：

- **自動ビジュアルリグレッション**：コミット間でスクリーンショットを比較
- **プロトコルの正しさ**：RDP ビットマップデコードが正しいかを目で確認できます
- **CI 向き**：ディスプレイサーバーが不要

見積もり労力：~100 行（PNG エンコード + ワンショットキャプチャループ）。

#### Tier 2：egui ウィンドウ（中程度の労力、完全な手動テスト）

```text
evernight connect rdp://host --gui
```

[egui](https://github.com/emilk/egui) ウィンドウを開き、ライブの RDP フレームバッファを表示します。キーボード／マウス入力は既存の入力コーデック経由で送り返されます。これにより得られるもの：

- **完全なクローズドループ**：入力 → 出力を確認 → インタラクションを検証
- **外部依存なし**：egui はピュア Rust、クロスプラットフォーム
- **シングルバイナリ**：別のビューワーアプリが不要

見積もり労力：~300 行（egui テクスチャアップロード + 入力イベントループ）。
egui の `eframe` クレートはすでにエコシステムで一般的です。

#### Tier 3：既存 API 経由のウェブフロントエンド（最大の労力、本番向け）

evernight にはすでに `api-serve --transport ws`（WebSocket 上の JSON-RPC）があります。ウェブフロントエンド（shittim-chest / Tauri）がこの API に接続し、以下を行います：

- フレームバッファを `<canvas>` 上にレンダリング
- 入力イベントを JSON-RPC 経由で送信
- これが本番の経路です —— Tier 1+2 は開発／テスト用

これはフロントエンドの作業（Vue／React／Tauri）であり、evernight ライブラリのコードではありません。

### どの段階を作るべきか？

**まず Tier 1（ヘッドレススクリーンショット）から始めてください** —— テストに対する ROI が最も高く、~1 時間で済みます。これが最も重大なギャップを埋めます：ついに RDP ビットマップパイプラインが正しいピクセルを生成しているかを目で確認できます。

インタラクティブなテストが必要になったら（例：キーボード入力、クリップボード、ドライブリダイレクトの検証）、Tier 2（egui）を追加します。

Tier 3 は本番のフロントエンドで、ウェブ UI の準備が整ったときに構築します。

-----------------------------------------------------------------------------

## クイックスタート：セットアップの検証

```bash
# 1. Build
cargo build --features full --release

# 2. Test all protocols (878 tests)
cargo test --features full

# 3. Probe a host for industrial protocols
evernight probe 192.168.1.20 --ports 502,102,4840,5000

# 4. Connect to an SSH host
evernight connect ssh://user@192.168.1.100

# 5. Poll sensors from a manifest
evernight sensor-poll --manifest corridor.toml

# 6. Check hardware telemetry
evernight hw

# 7. Start the MCP server (for AI agents)
evernight api-serve --transport ws --port 50000
```
