# 산업 프로토콜 연동 — Evernight

Evernight은 celestia-island 생태계의 **필수 하드웨어 능력 브로커**입니다. 어떤 상위 crate도 `aoba` / `rust7` 등을 직접 임포트하지 않으며 — 모든 물리 I/O는 evernight의 프로토콜 모듈을 경유합니다.

## 프로토콜 티어

모든 프로토콜이 동등한 것은 아닙니다. Evernight은 이들을 세 개의 티어로 분류합니다:

| 티어 | 내용 | 빌트인? | aris 이미지 포함? | 예시 |
|------|------|-----------|----------------|----------|
| **Tier 1** | 오픈 표준 — 항상 사용 가능 | ✅ 예 | ✅ 예 | OPC UA, Modbus TCP/RTU, CAN, EtherCAT |
| **Tier 2** | 벤더 전용 — 공식 crate, 옵션 | 선택적 기능 | ❌ 아니오 | S7comm, MC Protocol, EtherNet/IP |
| **Tier 3** | 서드파티 플러그인 — 런타임 로드 | ❌ 외부 프로세스 | ❌ 아니오 | 직접 작성한 모든 것 |

### 왜 티어를 나누는가?

**Tier 1(오픈 표준)**이 기본 경로입니다. 주요 벤더(Siemens S7-1500, Mitsubishi iQ-R, Rockwell ControlLogix 5580)의 최신 PLC는 모두 내장 OPC UA 서버를 제공합니다. 장치가 OPC UA를 지원한다면 그것을 사용하세요 — 벤더 전용 코드가 필요 없습니다.

**Tier 2(벤더 전용)**는 기존 설치 기반을 다룹니다. 현장의 수백만 대 PLC(S7-300/1200, MELSEC Q, 구형 Allen-Bradley)은 OPC UA가 없고 자체 독점 프로토콜만 사용합니다. 이 프로토콜들은:

- evernight 코어에 내장되지 않은 **독립 crate**로 구현됩니다
- Cargo 기능이 활성화된 경우에만 컴파일됩니다
- 기본적으로 aris 게이트웨이 OS 이미지에 **포함되지 않습니다**
- 각 crate은 Tier 3 플러그인 작성자를 위한 **참조 구현** 역할도 합니다

**Tier 3(서드파티 플러그인)**은 누구나 evernight의 소스 코드를 수정하지 않고 프로토콜 지원을 추가할 수 있게 합니다. 플러그인은 WebSocket이나 Unix 도메인 소켓을 통해([arona](https://github.com/celestia-island/arona) 타입 사용) JSON-RPC를 사용하는 외부 프로세스입니다. 게이트웨이의 TOML 설정이 각 플러그인의 위치를 선언합니다.

```
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

## Tier 1: 오픈 표준

### Modbus (시리얼 RTU / TCP)

Modbus는 산업 통신의 핵심 역할을 합니다. 시장의 거의 모든 PLC, 센서, 드라이브가 지원하는 오픈 표준(IEC 61158)입니다.

**항상 컴파일에 포함됩니다.** 기능 플래그가 필요 없습니다.

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

OPC UA(IEC 62541)는 범용 산업 통신 표준입니다. Siemens, Mitsubishi, Rockwell 등의 최신 PLC에는 내장 OPC UA 서버가 포함되어 있습니다. 장치가 OPC UA를 지원한다면 이것이 권장 경로입니다 — 벤더 전용 프로토콜이 필요 없습니다.

```toml
[dependencies]
evernight = { version = "0.1", features = ["opcua"] }
```

### CAN 2.0B / EtherCAT

필드버스 통신(연료전지, 서보 드라이브, 모션 제어)을 위한 오픈 표준입니다. `can` 및 `ethercat` 기능으로 활성화합니다.

---

## Tier 2: 벤더 전용 프로토콜

각 Tier 2 프로토콜은 `ProtocolBackend` 및 `ProtocolProbe` 트레이트를 구현하는 **독립 crate**입니다. 이들은 옵션입니다 — 컴파일에 포함하려면 Cargo 기능을 활성화하거나, 바이너리 크기를 줄이려면 제외하세요.

> **Tier 2 crate은 기본적으로 aris 게이트웨이 OS 이미지에 포함되지 않습니다.**
> 이미지는 Tier 1만 제공합니다. 게이트웨이에서 벤더 전용 프로토콜이 필요한 경우:
> 1. 해당 기능을 활성화한 커스텀 aris 이미지를 빌드하거나,
> 2. 프로토콜을 Tier 3 플러그인으로 실행하세요(아래 참조).

### S7comm (Siemens S7-1200/1500/300/400)

```toml
[dependencies]
evernight = { version = "0.1", features = ["s7comm"] }
```

S7comm은 ISO-on-TCP(포트 102) 위에서 동작하는 Siemens의 네이티브 프로토콜입니다. 이것은 **최우선 벤더 프로토콜**입니다 — 타겟 시장(수소 에너지, 화학, 제약)에서 Siemens가 가장 큰 설치 기반을 보유하고 있습니다.

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

**검증:** Snap7 C 참조 구현(15년 된 오픈소스 산업 표준)을 기준으로 검증했습니다. 바이트 수준 차분 테스트를 통해 와이어 포맷 준수를 확인했습니다. CI에서 19개의 통합 테스트가 통과합니다.

### MC Protocol (Mitsubishi MELSEC)

```toml
[dependencies]
evernight = { version = "0.1", features = ["mc"] }
```

MC Protocol(3E 바이너리 프레임)은 Mitsubishi MELSEC Q/L/iQ-R 시리즈를 다룹니다. 벤더 프로토콜 중 **가장 낮은 우선순위**입니다 — Mitsubishi 생태계는 클로즈드 소스이며 참조 서버 구현이 없습니다. 다만, 최신 Mitsubishi PLC(iQ-R, iQ-F)는 내장 OPC UA를 갖추고 있으므로 **Mitsubishi 장치에는 OPC UA가 권장 경로**입니다.

**검증:** 6개의 독립적인 소스(Mitsubishi 공식 매뉴얼, Beijer Electronics 드라이버, Neuron 문서, Sym3 에뮬레이터, pymcprotocol 클라이언트, 실사용 환경의 프레임 캡처)를 교차 참조했습니다.

### EtherNet/IP (Rockwell/Allen-Bradley)

```toml
[dependencies]
evernight = { version = "0.1", features = ["enip"] }
```

EtherNet/IP + CIP은 북미 시장의 Rockwell Automation / Allen-Bradley PLC를 주로 다룹니다.

---

## Tier 3: 플러그인 프로토콜 — WebSocket / IPC 위의 JSON-RPC

Tier 3은 누구나 evernight의 소스 코드를 수정하지 않고 프로토콜 지원을 추가할 수 있게 합니다. 플러그인은 다음을 수행하는 외부 프로세스입니다:

1. WebSocket(`ws://host:port`) 또는 Unix 도메인 소켓(`ipc:///path`)에서 수신 대기
2. [arona](https://github.com/celestia-island/arona) 타입을 사용하여 JSON-RPC 2.0 통신
3. 빌트인 백엔드와 동일한 `connect` / `read` / `write` / `ping` 인터페이스 구현

### 게이트웨이 TOML에서 플러그인 선언

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

시작 시 evernight은 이 파일을 읽고, 각 항목에 대해 `RemotePluginBackend`를 인스턴스화하여 `ProtocolRegistry`에 등록합니다. 그 시점부터 플러그인은 빌트인 백엔드와 정확히 동일하게 자동 감지 및 데이터 I/O에 참여합니다.

### JSON-RPC 인터페이스 (arona 타입)

플러그인은 다음 JSON-RPC 메서드(arona에 정의됨)에 응답해야 합니다:

| Method | Parameters | Returns |
|--------|-----------|---------|
| `protocol.connect` | `{ transport: TransportInfo }` | `{ connected: bool }` |
| `protocol.read` | `{ address: DataAddress }` | `{ raw: [u8], latency_us: u64 }` |
| `protocol.write` | `{ address: DataAddress, data: [u8] }` | `{ confirmed: bool }` |
| `protocol.ping` | `{}` | `{ reachable: bool }` |
| `protocol.probe` | `{ transport: TransportInfo }` | `{ protocol: string, confidence: float }` |

전체 타입 정의 및 TypeScript 바인딩은 [arona crate](https://github.com/celestia-island/arona)을 참조하세요.

### Tier 3 플러그인 작성하기

Tier 2 crate(예: `evernight-s7comm`)는 **참조 구현** 역할도 합니다. 플러그인 작성자는 소스를 연구하여 `ProtocolBackend` 트레이트 계약을 이해한 뒤, JSON-RPC 서버 뒤에서 어떤 언어(Python, Go, C, Node.js)로든 동일한 로직을 구현할 수 있습니다.

최소 Python 플러그인 예시:

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

---

## 아키텍처

모든 프로토콜 — 티어와 무관하게 — 은 동일한 두 트레이트를 구현합니다:

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

```
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

## 자동 감지 우선순위

알 수 없는 장치를 프로빙할 때 Tier 1 오픈 표준 프로브가 가장 먼저 실행됩니다:

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

오픈 표준에 가장 낮은 우선순위 번호(가장 먼저 프로빙)를 부여하는 이유는, 장치가 OPC UA를 지원한다면 벤더와 무관하게 그것이 원하는 경로이기 때문입니다.

## CLI 명령 참조

| Command | Description |
|---------|-------------|
| `evernight probe <host> [--ports 502,102,...]` | 호스트의 프로토콜 프로빙 (모든 티어) |
| `evernight sensor-poll [--manifest X.toml]` | 센서 폴링, 알람 발생 |
| `evernight api-serve --transport ws` | JSON-RPC API 서버 시작 |

## S7 필드 데이터 타입

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

> `offset`의 소수 부분은 BOOL 필드의 **비트 인덱스**를 나타냅니다.

## 알람 라우팅

센서 판독값은 공유 알람 파이프라인을 거칩니다. 각 프로토콜마다 고유한 토픽 네임스페이스를 갖습니다:

| Protocol | Trigger topic | Source id |
|----------|---------------|-----------|
| Modbus | `modbus.{station}.{field}.{level}` | `evernight.modbus.{station}` |
| S7comm | `s7comm.{station}.{field}.{level}` | `evernight.s7comm.{station}` |
| OPC UA | `opcua.{node}.{field}.{level}` | `evernight.opcua.{node}` |

알람 레벨은 ISA-18.2를 따릅니다: `ll` / `l` / `h` / `hh` / `roc`.
