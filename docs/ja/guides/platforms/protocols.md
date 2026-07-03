# 産業プロトコル統合 — Evernight

Evernight は celestia-island エコシステムにおける**必須のハードウェア機能ブローカー**です。上流のクレートはいずれも `aoba` / `rust7` / などを直接インポートしません — すべての物理 I/O は evernight のプロトコルモジュールを経由します。

## プロトコルのティア

すべてのプロトコルが同等というわけではありません。Evernight はこれらを 3 つのティアに分類します:

| Tier | 内容 | 組み込み? | aris イメージに収録? | 例 |
|------|------|-----------|----------------------|------|
| **Tier 1** | オープン標準 — 常に利用可能 | ✅ はい | ✅ はい | OPC UA, Modbus TCP/RTU, CAN, EtherCAT |
| **Tier 2** | ベンダー固有 — 公式クレート、オプトイン | オプション機能 | ❌ いいえ | S7comm, MC Protocol, EtherNet/IP |
| **Tier 3** | サードパーティプラグイン — 実行時にロード | ❌ 外部プロセス | ❌ いいえ | 自作するものすべて |

### なぜティア分けするのか?

**Tier 1（オープン標準）** が主要な経路です。主要ベンダー各社（Siemens S7-1500、Mitsubishi iQ-R、Rockwell ControlLogix 5580）の最新 PLC は組み込みの OPC UA サーバーを同梱しています。デバイスが OPC UA を話すなら、それを使いましょう — ベンダー固有のコードは不要です。

**Tier 2（ベンダー固有）** は既存のレガシー設備をカバーします。現場にある数百万台の PLC（S7-300/1200、MELSEC Q、旧型 Allen-Bradley）は OPC UA を持たず、独自プロトコルしか話しません。これらのプロトコルは:

- **スタンドアロンクレート**として実装されている（evernight コアには組み込まれない）
- Cargo 機能を有効にしたときのみコンパイルされる
- aris ゲートウェイ OS イメージにはデフォルトで**収録されない**
- 各クレートは Tier 3 プラグイン作者向けの**リファレンス実装**も兼ねる

**Tier 3（サードパーティプラグイン）** は、evernight のソースコードに手を加えずに誰でもプロトコルサポートを追加できるようにします。プラグインは WebSocket または Unix ドメインソケット経由で JSON-RPC（[arona](https://github.com/celestia-island/arona) 型を使用）を話す外部プロセスです。ゲートウェイの TOML 設定で各プラグインの場所を宣言します。

```text
  ┌──────────────────────────────────────────────────────┐
  │                  ProtocolRegistry                     │
  │                                                       │
  │  Tier 1 (always loaded)                               │
  │  ├── Modbus TCP/RTU  (open, IEC 61158)               │
  │  ├── OPC UA         (open, IEC 62541)                │
  │  ├── CAN 2.0B       (open, ISO 11898)                │
  │  └── EtherCAT       (open, IEC 61158)                │
  │                                                       │
  │  Tier 2 (opt-in features, NOT in aris image)          │
  │  ├── S7comm         (Siemens, feature = "s7comm")    │
  │  ├── MC Protocol    (Mitsubishi, feature = "mc")     │
  │  └── EtherNet/IP    (Rockwell, feature = "enip")     │
  │                                                       │
  │  Tier 3 (runtime plugins, declared in TOML)           │
  │  ├── fins_tcp       → ws://127.0.0.1:51001            │
  │  ├── mewtocol       → ipc:///run/evernight/mew.sock   │
  │  └── your_protocol  → ws://...                        │
  └──────────────────────────────────────────────────────┘
```

## Tier 1: オープン標準

### Modbus（シリアル経由 RTU / TCP）

Modbus は産業通信の主役です。実質的に市場のすべての PLC、センサー、ドライブが対応するオープン規格（IEC 61158）です。

**常にコンパイル済み。** 機能フラグは不要です。

```rust
use evernight::protocol::{ProtocolRegistry, ModbusProbe, TransportInfo};
use std::sync::Arc;

let mut registry = ProtocolRegistry::new();
registry.register_probe(Arc::new(ModbusProbe));

let transport = TransportInfo::Tcp { host: "192.168.1.20".into(), port: 502 };
if let Some(result) = registry.auto_detect(&transport, 0.5).await {
    println!("Detected {} ({:.0}%)", result.protocol, result.confidence * 100.0);
}
```

### OPC UA

OPC UA（IEC 62541）は汎用の産業通信規格です。Siemens、Mitsubishi、Rockwell などの最新 PLC には組み込みの OPC UA サーバーが含まれます。デバイスが OPC UA に対応している場合、これが推奨される経路です — ベンダー固有のプロトコルは不要です。

```toml
[dependencies]
evernight = { version = "0.1", features = ["opcua"] }
```

### CAN 2.0B / EtherCAT

フィールドバス通信（燃料電池、サーボドライブ、モーション制御）のオープン規格です。`can` および `ethercat` 機能で有効化します。

-----------------------------------------------------------------------------

## Tier 2: ベンダー固有プロトコル

各 Tier 2 プロトコルは `ProtocolBackend` と `ProtocolProbe` トレイトを実装した**スタンドアロンクレート**です。これらはオプトインです — Cargo 機能を有効にしてコンパイルに含めるか、バイナリを小さく保つために外すかを選べます。

> **Tier 2 クレートはデフォルトでは aris ゲートウェイ OS イメージに含まれません。**
> イメージは Tier 1 のみを同梱します。ゲートウェイ上でベンダー固有プロトコルが必要な場合は、次のいずれかを行います:
> 1. 機能を有効にしたカスタム aris イメージをビルドする、または
> 2. プロトコルを Tier 3 プラグインとして実行する（後述）。

### S7comm（Siemens S7-1200/1500/300/400）

```toml
[dependencies]
evernight = { version = "0.1", features = ["s7comm"] }
```

S7comm は ISO-on-TCP（ポート 102）上の Siemens ネイティブプロトコルです。これは**最優先度のベンダープロトコル**です — 対象市場（水素エネルギー、化学、製薬）で Siemens が最大の設置基数を持っています。

```rust
use evernight::protocol::s7comm::{S7CommClient, S7ConnectParams};

let client = S7CommClient::new(S7ConnectParams {
    host: "192.168.1.10".into(),
    port: 102,
    rack: 0,
    slot: 1,
});
client.connect().await?;
let bytes = client.read_db(1, 0, 4).await?;
let temp = f32::from_be_bytes(bytes.try_into().unwrap());
println!("DB1.DBD0 = {:.1} °C", temp);
```

**検証:** Snap7 C リファレンス実装（15 年の歴史を持つオープンソースの業界標準）に対して検証済み。バイトレベルの差分テストでワイヤーフォーマットの準拠を確認。CI で 19 件の統合テストが合格しています。

### MC Protocol（Mitsubishi MELSEC）

```toml
[dependencies]
evernight = { version = "0.1", features = ["mc"] }
```

MC Protocol（3E バイナリフレーム）は Mitsubishi MELSEC Q/L/iQ-R シリーズをカバーします。ベンダープロトコルの中では**最も優先度が低い**です — Mitsubishi のエコシステムはクローズドソースで、リファレンスサーバー実装がありません。ただし、最新の Mitsubishi PLC（iQ-R、iQ-F）は組み込みの OPC UA を持つため、**Mitsubishi デバイスでは OPC UA が推奨される経路**です。

**検証:** 6 つの独立ソース（Mitsubishi 公式マニュアル、Beijer Electronics ドライバ、Neuron ドキュメント、Sym3 エミュレータ、pymcprotocol クライアント、現場検証済みフレームキャプチャ）と相互照合済み。

### EtherNet/IP（Rockwell/Allen-Bradley）

```toml
[dependencies]
evernight = { version = "0.1", features = ["enip"] }
```

EtherNet/IP + CIP は Rockwell Automation / Allen-Bradley PLC をカバーします。主に北米市場向けです。

-----------------------------------------------------------------------------

## Tier 3: プラグインプロトコル — WebSocket / IPC 経由 JSON-RPC

Tier 3 は、evernight のソースコードを変更せずに**誰もが** evernight にプロトコルサポートを追加できるようにします。プラグインは以下を行う外部プロセスです:

1. WebSocket（`ws://host:port`）または Unix ドメインソケット（`ipc:///path`）でリッスンする
2. [arona](https://github.com/celestia-island/arona) 型を使用して JSON-RPC 2.0 を話す
3. 組み込みバックエンドと同じ `connect` / `read` / `write` / `ping` インターフェースを実装する

### ゲートウェイ TOML でのプラグイン宣言

```toml
# /etc/evernight/gateway.toml

[[protocol_plugins]]
name = "fins_tcp"                    # Omron FINS/TCP
transport = "ws://127.0.0.1:51001"   # plugin process WebSocket
priority = 60                        # probe priority (lower = first)

[[protocol_plugins]]
name = "mewtocol"                    # Panasonic Mewtocol
transport = "ipc:///run/evernight/mewtocol.sock"  # Unix socket
priority = 70

[[protocol_plugins]]
name = "custom_protocol"
transport = "ws://192.168.1.100:8080"  # remote plugin on another machine
priority = 80
```

起動時に、evernight はこのファイルを読み込み、各エントリに対して `RemotePluginBackend` をインスタンス化し、`ProtocolRegistry` に登録します。そこからは、プラグインは組み込みバックエンドと全く同じように自動検出とデータ I/O に参加します。

### JSON-RPC インターフェース（arona 型）

プラグインは以下の JSON-RPC メソッド（arona で定義）に応答しなければなりません:

| Method | Parameters | Returns |
|--------|-----------|---------|
| `protocol.connect` | `{ transport: TransportInfo }` | `{ connected: bool }` |
| `protocol.read` | `{ address: DataAddress }` | `{ raw: [u8], latency_us: u64 }` |
| `protocol.write` | `{ address: DataAddress, data: [u8] }` | `{ confirmed: bool }` |
| `protocol.ping` | `{}` | `{ reachable: bool }` |
| `protocol.probe` | `{ transport: TransportInfo }` | `{ protocol: string, confidence: float }` |

完全な型定義と TypeScript バインディングは [arona クレート](https://github.com/celestia-island/arona)を参照してください。

### Tier 3 プラグインの作成

Tier 2 クレート（例: `evernight-s7comm`）は**リファレンス実装**も兼ねています。プラグイン作者はそのソースを調べて `ProtocolBackend` トレイトの契約を理解した上で、JSON-RPC サーバーの背後で同じロジックを任意の言語（Python、Go、C、Node.js）で実装できます。

最小限の Python プラグインの例:

```python
#!/usr/bin/env python3
"""Minimal Tier 3 plugin — speaks JSON-RPC over WebSocket."""
import json, asyncio, websockets

async def handle(ws):
    async for msg in ws:
        req = json.loads(msg)
        method = req["method"]
        if method == "protocol.connect":
            await ws.send(json.dumps({"id": req["id"], "result": {"connected": True}}))
        elif method == "protocol.read":
            # Your protocol-specific read logic here
            await ws.send(json.dumps({"id": req["id"], "result": {"raw": [0,0,1,92], "latency_us": 500}}))
        elif method == "protocol.ping":
            await ws.send(json.dumps({"id": req["id"], "result": {"reachable": True}}))

asyncio.run(websockets.serve(handle, "127.0.0.1", 51001))
```

-----------------------------------------------------------------------------

## アーキテクチャ

すべてのプロトコル — ティアを問わず — は同じ 2 つのトレイトを実装します:

```rust
pub trait ProtocolBackend: Send + Sync {
    fn protocol_name(&self) -> &'static str;
    fn tier(&self) -> ProtocolTier;
    async fn connect(&self, transport: &TransportInfo) -> Result<()>;
    async fn read(&self, addr: &DataAddress) -> Result<ProtocolReadResult>;
    async fn write(&self, addr: &DataAddress, data: &[u8]) -> Result<ProtocolWriteResult>;
}

pub trait ProtocolProbe: Send + Sync {
    fn protocol_name(&self) -> &'static str;
    async fn probe(&self, transport: &TransportInfo) -> Result<Option<ProtocolProbeResult>>;
    fn confidence(&self) -> f32;
    fn priority(&self) -> i32;
}
```

```text
                          ┌──────────────────────────────────┐
   Your application ────► │         evernight crate           │
   (CLI / library /       │                                   │
    sensor-poll /         │  ProtocolBackend trait            │
    API server)           │  ProtocolProbe trait              │
                          │  ProtocolRegistry                 │
                          │  ┌─────────┐ ┌─────────┐         │
                          │  │ Tier 1  │ │ Tier 2  │         │
                          │  │ Modbus  │ │ S7comm  │  …      │
                          │  │ OPC UA  │ │ MC Proto│         │
                          │  └────┬────┘ └────┬────┘         │
                          │       │           │              │
                          │       │     ┌─────┴──────┐       │
                          │       │     │ Tier 3 RPC │       │
                          │       │     │ (arona     │       │
                          │       │     │  JSON-RPC) │       │
                          │       │     └─────┬──────┘       │
                          └───────┼───────────┼──────────────┘
                                  │           │
                          ┌───────▼───┐ ┌─────▼──────────┐
                          │  aoba /   │ │ External plugin │
                          │  asyncua  │ │ process (any    │
                          │  (Tier 1) │ │  language)      │
                          └───────────┘ └────────────────┘
```

## 自動検出の優先度

未知のデバイスをプローブする際、Tier 1 のオープン標準プローブが最初に実行されます:

| Priority | Protocol | Port |
|----------|----------|------|
| 10 | OPC UA | 4840 |
| 20 | Modbus TCP | 502 |
| 30 | EtherCAT | — |
| 40 | CAN | — |
| 50 | S7comm (Tier 2) | 102 |
| 60 | MC Protocol (Tier 2) | 5000 |
| 70 | EtherNet/IP (Tier 2) | 44818 |
| 100+ | Tier 3 plugins | varies |

オープン標準が最も低い優先度番号（最初にプローブ）を得ます — デバイスが OPC UA を話すなら、ベンダーに関わらずそれが望む経路だからです。

## CLI コマンドリファレンス

| コマンド | 説明 |
|----------|------|
| `evernight probe <host> [--ports 502,102,...]` | ホストのプロトコルをプローブ（全ティア） |
| `evernight sensor-poll [--manifest X.toml]` | センサーをポーリングし、アラームを送出 |
| `evernight api-serve --transport ws` | JSON-RPC API サーバーを起動 |

## S7 フィールドデータ型

| Type | Size | Offset format | Decode |
|------|------|---------------|--------|
| `BOOL` | 1 bit | `8.0` (byte 8, bit 0) | bit test |
| `BYTE` | 1 byte | `8` | `u8` |
| `WORD` | 2 bytes | `8` | `u16::from_be_bytes` |
| `INT` | 2 bytes | `8` | `i16::from_be_bytes` |
| `DWORD` | 4 bytes | `8` | `u32::from_be_bytes` |
| `DINT` | 4 bytes | `8` | `i32::from_be_bytes` |
| `REAL` | 4 bytes | `0` | `f32::from_be_bytes` |
| `STRING` | var | `20` | length-prefixed ASCII |

> `offset` の小数部は BOOL フィールドの**ビットインデックス**を表します。

## アラームルーティング

センサーの読み取り値は共有のアラームパイプラインを通ります。各プロトコルは独自のトピック名前空間を持ちます:

| Protocol | Trigger topic | Source id |
|----------|---------------|-----------|
| Modbus | `modbus.{station}.{field}.{level}` | `evernight.modbus.{station}` |
| S7comm | `s7comm.{station}.{field}.{level}` | `evernight.s7comm.{station}` |
| OPC UA | `opcua.{node}.{field}.{level}` | `evernight.opcua.{node}` |

アラームレベルは ISA-18.2 に従います: `ll` / `l` / `h` / `hh` / `roc`。
