# Industrial Protocol Integration — Evernight

Evernight is the **mandatory hardware capability broker** for the celestia-island
ecosystem. No upstream crate imports `aoba` / `rust7` / etc. directly — all
physical I/O routes through evernight's protocol modules.

## Protocol tiers

Not all protocols are equal. Evernight classifies them in three tiers:

| Tier | What | Built-in? | In aris image? | Examples |
|------|------|-----------|----------------|----------|
| **Tier 1** | Open standards — always available | ✅ Yes | ✅ Yes | OPC UA, Modbus TCP/RTU, CAN, EtherCAT |
| **Tier 2** | Vendor-specific — official crates, opt-in | Optional feature | ❌ No | S7comm, MC Protocol, EtherNet/IP |
| **Tier 3** | Third-party plugins — runtime-loaded | ❌ External process | ❌ No | Anything you write |

### Why tiering?

**Tier 1 (open standards)** are the primary path. Modern PLCs from every major
vendor (Siemens S7-1500, Mitsubishi iQ-R, Rockwell ControlLogix 5580) ship with
built-in OPC UA servers. If a device speaks OPC UA, use it — no vendor-specific
code needed.

**Tier 2 (vendor-specific)** covers legacy installed base. Millions of PLCs in
the field (S7-300/1200, MELSEC Q, old Allen-Bradley) do not have OPC UA and only
speak their proprietary protocol. These protocols are:

- Implemented as **standalone crates** (not embedded in evernight core)
- Compiled in only when the Cargo feature is enabled
- **Not included** in the aris gateway OS image by default
- Each crate doubles as a **reference implementation** for Tier 3 plugin authors

**Tier 3 (third-party plugins)** lets anyone add protocol support without
touching evernight's source code. A plugin is an external process that speaks
JSON-RPC (using [arona](https://github.com/celestia-island/arona) types) over
WebSocket or Unix domain socket. The gateway's TOML config declares where each
plugin lives.

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

## Tier 1: Open standards

### Modbus (RTU over serial / TCP)

Modbus is the workhorse of industrial communication. It is an open standard
(IEC 61158) supported by virtually every PLC, sensor, and drive on the market.

**Always compiled in.** No feature flags needed.

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

OPC UA (IEC 62541) is the universal industrial communication standard. Modern
PLCs from Siemens, Mitsubishi, Rockwell, and others include built-in OPC UA
servers. If a device supports OPC UA, this is the preferred path — no
vendor-specific protocol needed.

```toml
[dependencies]
evernight = { version = "0.1", features = ["opcua"] }
```

### CAN 2.0B / EtherCAT

Open standards for fieldbus communication (fuel cells, servo drives, motion
control). Enabled via `can` and `ethercat` features.

-----------------------------------------------------------------------------

## Tier 2: Vendor-specific protocols

Each Tier 2 protocol is a **standalone crate** that implements the
`ProtocolBackend` and `ProtocolProbe` traits. They are opt-in — enable the
Cargo feature to compile them in, or leave them out to keep the binary small.

> **Tier 2 crates are NOT included in the aris gateway OS image by default.**
> The image ships with Tier 1 only. If you need a vendor-specific protocol on
> the gateway, either:
> 1. Build a custom aris image with the feature enabled, or
> 2. Run the protocol as a Tier 3 plugin (see below).

### S7comm (Siemens S7-1200/1500/300/400)

```toml
[dependencies]
evernight = { version = "0.1", features = ["s7comm"] }
```

S7comm is Siemens' native protocol over ISO-on-TCP (port 102). This is the
**highest-priority vendor protocol** — Siemens has the largest installed base
in the target markets (hydrogen energy, chemicals, pharma).

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

**Validation:** Verified against the Snap7 C reference implementation
(15-year open-source industry standard). Byte-level differential testing
confirms wire-format compliance. 19 integration tests pass in CI.

### MC Protocol (Mitsubishi MELSEC)

```toml
[dependencies]
evernight = { version = "0.1", features = ["mc"] }
```

MC Protocol (3E binary frame) covers Mitsubishi MELSEC Q/L/iQ-R series.
**Lowest priority** of the vendor protocols — the Mitsubishi ecosystem is
closed-source with no reference server implementation. However, modern
Mitsubishi PLCs (iQ-R, iQ-F) have built-in OPC UA, so **OPC UA is the
preferred path for Mitsubishi devices**.

**Validation:** Cross-referenced against six independent sources (Mitsubishi
official manual, Beijer Electronics driver, Neuron docs, Sym3 emulator,
pymcprotocol client, field-tested frame captures).

### EtherNet/IP (Rockwell/Allen-Bradley)

```toml
[dependencies]
evernight = { version = "0.1", features = ["enip"] }
```

EtherNet/IP + CIP covers Rockwell Automation / Allen-Bradley PLCs, primarily
in the North American market.

-----------------------------------------------------------------------------

## Tier 3: Plugin protocol — JSON-RPC over WebSocket / IPC

Tier 3 lets **anyone** add protocol support to evernight without modifying
evernight's source code. A plugin is an external process that:

1. Listens on a WebSocket (`ws://host:port`) or Unix domain socket (`ipc:///path`)
2. Speaks JSON-RPC 2.0 using [arona](https://github.com/celestia-island/arona) types
3. Implements the same `connect` / `read` / `write` / `ping` interface as built-in backends

### Declaring plugins in gateway TOML

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

At startup, evernight reads this file, instantiates a `RemotePluginBackend`
for each entry, and registers it in the `ProtocolRegistry`. From that point,
the plugin participates in auto-detection and data I/O exactly like a
built-in backend.

### JSON-RPC interface (arona types)

The plugin must respond to these JSON-RPC methods (defined in arona):

| Method | Parameters | Returns |
|--------|-----------|---------|
| `protocol.connect` | `{ transport: TransportInfo }` | `{ connected: bool }` |
| `protocol.read` | `{ address: DataAddress }` | `{ raw: [u8], latency_us: u64 }` |
| `protocol.write` | `{ address: DataAddress, data: [u8] }` | `{ confirmed: bool }` |
| `protocol.ping` | `{}` | `{ reachable: bool }` |
| `protocol.probe` | `{ transport: TransportInfo }` | `{ protocol: string, confidence: float }` |

See the [arona crate](https://github.com/celestia-island/arona) for the full
type definitions and TypeScript bindings.

### Writing a Tier 3 plugin

A Tier 2 crate (e.g. `evernight-s7comm`) doubles as a **reference
implementation**. Plugin authors can study its source to understand the
`ProtocolBackend` trait contract, then implement the same logic in any
language (Python, Go, C, Node.js) behind a JSON-RPC server.

Minimal Python plugin example:

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

## Architecture

Every protocol — regardless of tier — implements the same two traits:

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

## Auto-detection priority

When probing an unknown device, Tier 1 open-standard probes run first:

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

Open standards get the lowest priority numbers (probed first) because if a
device speaks OPC UA, that's the path you want — regardless of vendor.

## CLI command reference

| Command | Description |
|---------|-------------|
| `evernight probe <host> [--ports 502,102,...]` | Probe a host for protocols (all tiers) |
| `evernight sensor-poll [--manifest X.toml]` | Poll sensors, emit alarms |
| `evernight api-serve --transport ws` | Start the JSON-RPC API server |

## S7 field data types

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

> The fractional part of `offset` encodes the **bit index** for BOOL fields.

## Alarm routing

Sensor readings flow through a shared alarm pipeline. Each protocol gets its
own topic namespace:

| Protocol | Trigger topic | Source id |
|----------|---------------|-----------|
| Modbus | `modbus.{station}.{field}.{level}` | `evernight.modbus.{station}` |
| S7comm | `s7comm.{station}.{field}.{level}` | `evernight.s7comm.{station}` |
| OPC UA | `opcua.{node}.{field}.{level}` | `evernight.opcua.{node}` |

Alarm levels follow ISA-18.2: `ll` / `l` / `h` / `hh` / `roc`.
