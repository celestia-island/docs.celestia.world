# 연동 가이드 — Evernight

Evernight을 각 지원 프로토콜에 연결하는 방법, 어떤 서버 소프트웨어를 사용할지, 그리고 연결이 엔드투엔드로 동작하는지 검증하는 방법을 다룹니다.

## 아키텍처

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

## 1. Modbus RTU (시리얼)

### 서버 측
- **장치**: 임의의 Modbus RTU 슬레이브(PLC, 센서, 인버터)
- **서버 없는 테스트**: `socat PTY,raw,echo=0,link=/tmp/vcom_a PTY,raw,echo=0,link=/tmp/vcom_b &`
  — 가상 시리얼 페어를 생성; 6개 스테이션에 대해 `tests/modbus_slave_sim.rs`를 실행.

### Evernight 측
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

## 2. S7comm (Siemens)

### 서버 측
- **장치**: S7-1200/1500/300/400 PLC
- **전제조건**: TIA Portal → "Permit PUT/GET" 활성화 + "Optimized block access" 비활성화
- **하드웨어 없는 테스트**: `cargo test --features full --test s7comm_integration`(인프로세스 snap7-server 사용)

### Evernight 측
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

## 3. MC Protocol (Mitsubishi)

### 서버 측
- **장치**: MELSEC FX/Q/L/iQ-R PLC
- **하드웨어 없는 테스트**: `tests/mc_test_server.rs`(인프로세스 mock MC 서버)

### Evernight 측
```rust
use evernight::protocol::mc_protocol::{McProtocolClient, McDevice};

let client = McProtocolClient::new("192.168.1.5", 5000);
client.connect().await?;
let words = client.read_devices(McDevice::D, 0, 10).await?;
println!("D0-D9: {:?}", words);
```

-----------------------------------------------------------------------------

## 4. EtherNet/IP (Rockwell)

### 서버 측
- **장치**: Allen-Bradley CompactLogix / ControlLogix
- **하드웨어 없는 테스트**: 손으로 만든 프레임을 사용한 단위 테스트(라이브 시뮬레이터 없음)

### Evernight 측
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

### 서버 측
- **장치/소프트웨어**: 임의의 OPC UA 서버(KEPServerEX, Ignition, CODESYS 등)
- **자체 호스팅**: evernight 자체가 OPC UA 서버로 동작할 수 있습니다:

```rust
use evernight::protocol::opcua_server::OpcUaSensorServer;

let mut server = OpcUaSensorServer::new("opc.tcp://0.0.0.0:4840", 4840)?;
let node = server.add_sensor_variable("temperature", 25.5)?;
// server.run();  // blocks — run in a separate thread
```

### Evernight 클라이언트 측
```rust
use evernight::protocol::opcua_client::{OpcUaClient, OpcUaEndpoint, OpcUaSecurity};

let endpoint = OpcUaEndpoint::new_anonymous("opc.tcp://192.168.1.50:4840");
let client = OpcUaClient::connect(&endpoint).await?;
let value = client.read_node("ns=2;s=Temperature").await?;
println!("Temperature: {}", value);
```

-----------------------------------------------------------------------------

## 6. SSH

### 서버 측
- 임의의 SSH 서버(OpenSSH, Dropbear 등)
- **키 관리**: `evernight vault init ~/.config/evernight/vault "passphrase"` 이후 자격증명을 추가.

### Evernight 측
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

### 서버 측
- **소프트웨어**: TigerVNC, x11vnc, RealVNC 등
- **설치**: `apt install tigervnc-standalone-server && vncserver :1`
- **브라우저 접근**: evernight은 VNC를 WebSocket으로 프록시할 수 있습니다:

```bash
# Start a VNC-to-WebSocket proxy (noVNC-compatible)
# (programmatically via evernight::vnc::ws::serve_vnc_websocket)
```

### Evernight 측
```bash
# CLI one-shot — handshake + server info + one frame capture
evernight connect vnc://192.168.1.100:5901
```

-----------------------------------------------------------------------------

## 8. RDP

### 서버 측
- **Windows**: 네이티브 RDP(설정 → 원격 데스크톱 → 활성화)
- **Linux**: `apt install xrdp`
  - TLS의 경우: `/etc/xrdp/xrdp.ini`에 `security_layer=tls` 설정
  - 인증서 생성: `openssl req -x509 -newkey rsa:2048 -nodes -keyout key.pem -out cert.pem -days 365 -subj "/CN=localhost"`
  - `/etc/xrdp/cert.pem` + `/etc/xrdp/key.pem`으로 복사

### Evernight 측
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

### 현재 RDP의 위치
- ✅ 전송: X.224 + TLS 업그레이드(실제 xrdp에 대해 검증됨)
- ✅ MCS: Connect-Initial/Response + Attach-User(검증됨)
- ✅ 비트맵: 압축해제 + Interleaved RLE 디코딩 → RGBA
- ✅ 입력: 키보드 스캔코드 + 마우스 이벤트
- ✅ 채널: CLIPRDR + RDPDR + RDPSND + DVC
- ✅ NLA: NTLMv2 + CredSSP(Kerberos는 KDC 필요)
- ◐ 세션: Channel-Join → 능력 교환 → 연속 framebuffer 루프가 필요

-----------------------------------------------------------------------------

## 9. Kubernetes

### 서버 측
- 임의의 k8s 클러스터(minikube, kind, EKS, GKE 등)
- 인증: `~/.kube/config` 또는 인클러스터 서비스 어카운트

### Evernight 측
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

### 서버 측
- `apt install libvirt-daemon-system libvirt-dev`
- libvirtd 시작: `systemctl start libvirtd`

### Evernight 측
```rust
use evernight::cloud::libvirt_client::LibvirtClient;

let client = LibvirtClient::open_read_only("qemu:///system")?;
let domains = client.list_domains()?;
for d in &domains {
    println!("{}: {:?}", d.name, d.state);
}
```

-----------------------------------------------------------------------------

## 클라이언트의 질문: 뷰어를 만들어야 하는가?

### 문제

Evernight은 RDP 비트맵을 RGBA 버퍼로, VNC 프레임을 픽셀로 디코딩하지만, 이를 **표시할 곳이 없습니다**. 렌더러가 없으면:

- 비트맵 디코딩이 올바른지 시각적으로 확인할 수 없습니다(충돌이 나지 않는지만 확인 가능)
- 도그푸딩을 할 수 없습니다 —— evernight은 "XPipe급 범용 연결 관리자"여야 하며, XPipe는 원격 데스크톱을 보여줍니다
- 수동 테스트에는 외부 뷰어(mstsc.exe / xfreerdp / vinagre)가 필요합니다

### 권장: 예 —— 최소한의 내장 뷰어를 만들 것

가장 단순한 것부터 가장 유용한 것까지, 세 단계의 노력:

#### Tier 1: 헤드리스 스크린샷 (최소 노력, 최고 테스트 가치)

```text
evernight connect rdp://host --screenshot out.png
```

세션 설정 후 한 프레임을 캡처해 PNG로 기록합니다. GUI가 필요 없습니다. 기존 `bitmap::decode_to_rgba` + 간단한 PNG 인코더(또는 의존성 제로인 PPM)를 사용합니다. 이는 다음을 제공합니다:

- **자동화된 시각 회귀**: 커밋 간 스크린샷 비교
- **프로토콜 정확성**: RDP 비트맵 디코딩이 올바른지 눈으로 확인 가능
- **CI 친화적**: 디스플레이 서버 불필요

예상 노력: ~100줄(PNG 인코딩 + 일회성 캡처 루프).

#### Tier 2: egui 윈도우 (중간 노력, 완전한 수동 테스트)

```text
evernight connect rdp://host --gui
```

[egui](https://github.com/emilk/egui) 윈도우를 열어 라이브 RDP framebuffer를 보여줍니다. 키보드/마우스 입력은 기존 입력 코덱을 통해 다시 전송됩니다. 이는 다음을 제공합니다:

- **완전한 폐루프**: 타이핑 → 출력 확인 → 상호작용 검증
- **외부 의존성 없음**: egui는 순수 Rust, 크로스 플랫폼
- **단일 바이너리**: 별도의 뷰어 앱 불필요

예상 노력: ~300줄(egui 텍스처 업로드 + 입력 이벤트 루프).
egui `eframe` crate은 이미 생태계에서 흔합니다.

#### Tier 3: 기존 API를 통한 웹 프론트엔드 (가장 큰 노력, 프로덕션)

Evernight은 이미 `api-serve --transport ws`(WebSocket 상 JSON-RPC)를 갖추고 있습니다. 웹 프론트엔드(shittim-chest / Tauri)가 이 API에 연결하여:

- framebuffer를 `<canvas>`에 렌더링
- JSON-RPC를 통해 입력 이벤트를 전송
- 이것이 프로덕션 경로입니다 —— Tier 1+2는 개발/테스트용

이것은 evernight 라이브러리 코드가 아닌 프론트엔드 작업(Vue/React/Tauri)입니다.

### 어느 단계를 만들 것인가?

**Tier 1(헤드리스 스크린샷)부터 시작** —— 테스트에서 가장 ROI가 높고 ~1시간이 걸립니다. 가장 중요한 간극을 메웁니다: 마침내 RDP 비트맵 파이프라인이 올바른 픽셀을 생성하는지 볼 수 있습니다.

그런 다음 상호작용 테스트가 필요할 때(예: 키보드 입력, 클립보드, 드라이브 리다이렉트 검증) Tier 2(egui)를 추가합니다.

Tier 3은 웹 UI가 준비되면 구축되는 프로덕션 프론트엔드입니다.

-----------------------------------------------------------------------------

## 퀵스타트: 설정 검증

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
