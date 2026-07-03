# 工业协议集成 — Evernight

Evernight 是 celestia-island 生态的**强制硬件能力代理人**。所有上游 crate
不直接依赖 `aoba` / `rust7` 等——所有物理 I/O 都通过 evernight 的协议模块。

## 协议分层

协议分为三层：

| 层级 | 内容 | 内嵌编译？ | 在 aris 镜像中？ | 示例 |
|------|------|-----------|----------------|------|
| **Tier 1** | 开放标准 — 始终可用 | ✅ 是 | ✅ 是 | OPC UA, Modbus TCP/RTU, CAN, EtherCAT |
| **Tier 2** | 厂商私有 — 官方 crate，可选 | 可选 feature | ❌ 否 | S7comm, MC Protocol, EtherNet/IP |
| **Tier 3** | 第三方插件 — 运行时加载 | ❌ 外部进程 | ❌ 否 | 任何你自己写的 |

### 为什么分层？

**Tier 1（开放标准）是首选路径。** 所有现代 PLC（西门子 S7-1500、三菱 iQ-R、
罗克韦尔 ControlLogix 5580）都内置 OPC UA 服务器。如果设备支持 OPC UA，
走 OPC UA 就行——不需要厂商私有协议。

**Tier 2（厂商私有）覆盖存量设备。** 现场大量的旧 PLC（S7-300/1200、MELSEC Q、
老 Allen-Bradley）没有 OPC UA，只说自己的私有协议。这些协议：

- 以**独立 crate** 实现（不嵌入 evernight 核心）
- 仅在启用 Cargo feature 时编译
- **不包含**在 aris 网关 OS 镜像中
- 每个 crate 同时作为 Tier 3 插件的**参考实现**

**Tier 3（第三方插件）允许任何人不修改 evernight 源码就添加协议支持。**
插件是一个独立进程，通过 JSON-RPC（使用
[arona](https://github.com/celestia-island/arona) 类型）经 WebSocket 或
Unix 域套接字通信。在网关 TOML 配置中声明即可。

```text
  ┌──────────────────────────────────────────────────────┐
  │                  ProtocolRegistry                     │
  │                                                       │
  │  Tier 1（始终加载）                                    │
  │  ├── Modbus TCP/RTU  (开放, IEC 61158)               │
  │  ├── OPC UA         (开放, IEC 62541)                │
  │  ├── CAN 2.0B       (开放, ISO 11898)                │
  │  └── EtherCAT       (开放, IEC 61158)                │
  │                                                       │
  │  Tier 2（可选 feature，不在 aris 镜像中）               │
  │  ├── S7comm         (西门子, feature = "s7comm")     │
  │  ├── MC Protocol    (三菱, feature = "mc")           │
  │  └── EtherNet/IP    (罗克韦尔, feature = "enip")     │
  │                                                       │
  │  Tier 3（运行时插件，在 TOML 中声明）                   │
  │  ├── fins_tcp       → ws://127.0.0.1:51001            │
  │  ├── mewtocol       → ipc:///run/evernight/mew.sock   │
  │  └── your_protocol  → ws://...                        │
  └──────────────────────────────────────────────────────┘
```

## Tier 1：开放标准

### Modbus（RTU 串口 / TCP）

Modbus 是工业通信的主力。它是开放标准（IEC 61158），几乎所有 PLC、传感器、
变频器都支持。**始终编译包含。**

### OPC UA

OPC UA（IEC 62541）是通用工业通信标准。所有主要厂商的现代 PLC 都内置
OPC UA 服务器。如果设备支持 OPC UA，这是首选路径。

### CAN 2.0B / EtherCAT

现场总线通信的开放标准（燃料电池、伺服驱动、运动控制）。

## Tier 2：厂商私有协议

每个 Tier 2 协议是**独立 crate**，实现了 `ProtocolBackend` 和
`ProtocolProbe` trait。可选启用——启用 Cargo feature 才编译。

> **Tier 2 crate 不包含在 aris 网关 OS 镜像中。** 镜像默认只包含 Tier 1。
> 如果需要在网关上使用厂商私有协议，要么：
> 1. 构建自定义 aris 镜像（启用对应 feature），或
> 2. 以 Tier 3 插件方式运行（见下文）。

### S7comm（西门子 S7-1200/1500/300/400）

```toml
evernight = { version = "0.1", features = ["s7comm"] }
```

S7comm 是西门子原生协议（ISO-on-TCP，端口 102）。**优先级最高的厂商协议**
——西门子在目标市场（氢能、化工、制药）装机量最大。

**验证：** 与 Snap7 C 参考实现做了字节级差分验证。19 个集成测试在 CI 中通过。

### MC Protocol（三菱 MELSEC）

```toml
evernight = { version = "0.1", features = ["mc"] }
```

MC Protocol（3E 二进制帧）覆盖三菱 MELSEC Q/L/iQ-R 系列。**优先级最低**
——三菱生态封闭，无开源参考服务器。但现代三菱 PLC（iQ-R、iQ-F）内置
OPC UA，**OPC UA 是三菱设备的首选路径**。

**验证：** 与六个独立来源做了交叉验证（三菱官方手册、Beijer 驱动文档、
Neuron 文档、Sym3 模拟器、pymcprotocol 客户端、实测帧结构）。

### EtherNet/IP（罗克韦尔/Allen-Bradley）

```toml
evernight = { version = "0.1", features = ["enip"] }
```

EtherNet/IP + CIP 覆盖罗克韦尔 PLC，主要在北美市场。

## Tier 3：插件协议 — JSON-RPC over WebSocket / IPC

Tier 3 允许**任何人**添加协议支持，不需要修改 evernight 源码。插件是一个
独立进程：

1. 监听 WebSocket（`ws://host:port`）或 Unix 域套接字（`ipc:///path`）
2. 使用 JSON-RPC 2.0（[arona](https://github.com/celestia-island/arona) 类型）
3. 实现与内置后端相同的 `connect` / `read` / `write` / `ping` 接口

### 在网关 TOML 中声明插件

```toml
# /etc/evernight/gateway.toml

[[protocol_plugins]]
name = "fins_tcp"                    # 欧姆龙 FINS/TCP
transport = "ws://127.0.0.1:51001"   # 插件进程的 WebSocket
priority = 60                        # 探测优先级（低 = 先试）

[[protocol_plugins]]
name = "mewtocol"                    # 松下 Mewtocol
transport = "ipc:///run/evernight/mewtocol.sock"  # Unix 套接字
priority = 70
```

### JSON-RPC 接口（arona 类型）

| 方法 | 参数 | 返回 |
|------|------|------|
| `protocol.connect` | `{ transport: TransportInfo }` | `{ connected: bool }` |
| `protocol.read` | `{ address: DataAddress }` | `{ raw: [u8], latency_us: u64 }` |
| `protocol.write` | `{ address: DataAddress, data: [u8] }` | `{ confirmed: bool }` |
| `protocol.ping` | `{}` | `{ reachable: bool }` |
| `protocol.probe` | `{ transport: TransportInfo }` | `{ protocol: string, confidence: float }` |

### 编写 Tier 3 插件

Tier 2 crate（如 `evernight-s7comm`）是**参考实现**。插件作者可以阅读其
源码理解 `ProtocolBackend` trait 的契约，然后用任何语言（Python、Go、C、
Node.js）在 JSON-RPC 服务器后面实现相同逻辑。

最小 Python 插件示例：

```python
#!/usr/bin/env python3
"""最小 Tier 3 插件 — 通过 WebSocket 说 JSON-RPC"""
import json, asyncio, websockets

async def handle(ws):
    async for msg in ws:
        req = json.loads(msg)
        method = req["method"]
        if method == "protocol.connect":
            await ws.send(json.dumps({"id": req["id"], "result": {"connected": True}}))
        elif method == "protocol.read":
            await ws.send(json.dumps({"id": req["id"], "result": {"raw": [0,0,1,92], "latency_us": 500}}))
        elif method == "protocol.ping":
            await ws.send(json.dumps({"id": req["id"], "result": {"reachable": True}}))

asyncio.run(websockets.serve(handle, "127.0.0.1", 51001))
```

## 自动探测优先级

| 优先级 | 协议 | 端口 | 层级 |
|--------|------|------|------|
| 10 | OPC UA | 4840 | Tier 1 |
| 20 | Modbus TCP | 502 | Tier 1 |
| 30 | EtherCAT | — | Tier 1 |
| 40 | CAN | — | Tier 1 |
| 50 | S7comm | 102 | Tier 2 |
| 60 | MC Protocol | 5000 | Tier 2 |
| 70 | EtherNet/IP | 44818 | Tier 2 |
| 100+ | Tier 3 插件 | 不定 | Tier 3 |

开放标准的探测优先级最低（最先尝试），因为如果设备支持 OPC UA，
那就是你想要的路径——不管它是什么品牌。
