# 工業協定整合 — Evernight

Evernight 是 celestia-island 生態的**強制硬體能力代理人**。所有上游 crate
不直接依賴 `aoba` / `rust7` 等——所有物理 I/O 都透過 evernight 的協定模組。

## 協定分層

協定分為三層：

| 層級 | 內容 | 內嵌編譯？ | 在 aris 映像檔中？ | 範例 |
|------|------|-----------|----------------|------|
| **Tier 1** | 開放標準 — 始終可用 | ✅ 是 | ✅ 是 | OPC UA, Modbus TCP/RTU, CAN, EtherCAT |
| **Tier 2** | 廠商私有 — 官方 crate，可選 | 可選 feature | ❌ 否 | S7comm, MC Protocol, EtherNet/IP |
| **Tier 3** | 第三方外掛程式 — 執行時載入 | ❌ 外部處理程序 | ❌ 否 | 任何你自己寫的 |

### 為什麼分層？

**Tier 1（開放標準）是首選路徑。** 所有現代 PLC（西門子 S7-1500、三菱 iQ-R、
羅克韋爾 ControlLogix 5580）都內建 OPC UA 伺服器。如果裝置支援 OPC UA，
走 OPC UA 就行——不需要廠商私有協定。

**Tier 2（廠商私有）涵蓋存量裝置。** 現場大量的舊 PLC（S7-300/1200、MELSEC Q、
老 Allen-Bradley）沒有 OPC UA，只說自己的私有協定。這些協定：

- 以**獨立 crate** 實作（不嵌入 evernight 核心）
- 僅在啟用 Cargo feature 時編譯
- **不包含**在 aris 閘道 OS 映像檔中
- 每個 crate 同時作為 Tier 3 外掛程式的**參考實作**

**Tier 3（第三方外掛程式）允許任何人不修改 evernight 原始碼就新增協定支援。**
外掛程式是一個獨立處理程序，透過 JSON-RPC（使用
[arona](https://github.com/celestia-island/arona) 型別）經 WebSocket 或
Unix 網域 socket 通訊。在閘道 TOML 設定中宣告即可。

```
  ┌──────────────────────────────────────────────────────┐
  │                  ProtocolRegistry                     │
  │                                                       │
  │  Tier 1（始終載入）                                    │
  │  ├── Modbus TCP/RTU  (開放, IEC 61158)               │
  │  ├── OPC UA         (開放, IEC 62541)                │
  │  ├── CAN 2.0B       (開放, ISO 11898)                │
  │  └── EtherCAT       (開放, IEC 61158)                │
  │                                                       │
  │  Tier 2（可選 feature，不在 aris 映像檔中）             │
  │  ├── S7comm         (西門子, feature = "s7comm")     │
  │  ├── MC Protocol    (三菱, feature = "mc")           │
  │  └── EtherNet/IP    (羅克韋爾, feature = "enip")     │
  │                                                       │
  │  Tier 3（執行時外掛程式，在 TOML 中宣告）               │
  │  ├── fins_tcp       → ws://127.0.0.1:51001            │
  │  ├── mewtocol       → ipc:///run/evernight/mew.sock   │
  │  └── your_protocol  → ws://...                        │
  └──────────────────────────────────────────────────────┘
```

## Tier 1：開放標準

### Modbus（RTU 序列埠 / TCP）

Modbus 是工業通訊的主力。它是開放標準（IEC 61158），幾乎所有 PLC、感測器、
變頻器都支援。**始終編譯包含。**

### OPC UA

OPC UA（IEC 62541）是通用工業通訊標準。所有主要廠商的現代 PLC 都內建
OPC UA 伺服器。如果裝置支援 OPC UA，這是首選路徑。

### CAN 2.0B / EtherCAT

現場匯流排通訊的開放標準（燃料電池、伺服驅動、運動控制）。

## Tier 2：廠商私有協定

每個 Tier 2 協定是**獨立 crate**，實作了 `ProtocolBackend` 和
`ProtocolProbe` trait。可選啟用——啟用 Cargo feature 才編譯。

> **Tier 2 crate 不包含在 aris 閘道 OS 映像檔中。** 映像檔預設只包含 Tier 1。
> 如果需要在閘道上使用廠商私有協定，要嘛：
> 1. 建置自訂 aris 映像檔（啟用對應 feature），或
> 2. 以 Tier 3 外掛程式方式執行（見下文）。

### S7comm（西門子 S7-1200/1500/300/400）

```toml
evernight = { version = "0.1", features = ["s7comm"] }
```

S7comm 是西門子原生協定（ISO-on-TCP，埠 102）。**優先級最高的廠商協定**
——西門子在目標市場（氫能、化工、製藥）裝機量最大。

**驗證：** 與 Snap7 C 參考實作做了位元組級差分驗證。19 個整合測試在 CI 中通過。

### MC Protocol（三菱 MELSEC）

```toml
evernight = { version = "0.1", features = ["mc"] }
```

MC Protocol（3E 二進位訊框）涵蓋三菱 MELSEC Q/L/iQ-R 系列。**優先級最低**
——三菱生態封閉，無開源參考伺服器。但現代三菱 PLC（iQ-R、iQ-F）內建
OPC UA，**OPC UA 是三菱裝置的首選路徑**。

**驗證：** 與六個獨立來源做了交叉驗證（三菱官方手冊、Beijer 驅動文件、
Neuron 文件、Sym3 模擬器、pymcprotocol 客戶端、實測訊框結構）。

### EtherNet/IP（羅克韋爾/Allen-Bradley）

```toml
evernight = { version = "0.1", features = ["enip"] }
```

EtherNet/IP + CIP 涵蓋羅克韋爾 PLC，主要在北美市場。

## Tier 3：外掛程式協定 — JSON-RPC over WebSocket / IPC

Tier 3 允許**任何人**新增協定支援，不需要修改 evernight 原始碼。外掛程式是一個
獨立處理程序：

1. 監聽 WebSocket（`ws://host:port`）或 Unix 網域 socket（`ipc:///path`）
2. 使用 JSON-RPC 2.0（[arona](https://github.com/celestia-island/arona) 型別）
3. 實作與內建後端相同的 `connect` / `read` / `write` / `ping` 介面

### 在閘道 TOML 中宣告外掛程式

```toml
# /etc/evernight/gateway.toml

[[protocol_plugins]]
name = "fins_tcp"                    # 歐姆龍 FINS/TCP
transport = "ws://127.0.0.1:51001"   # 外掛程式處理程序的 WebSocket
priority = 60                        # 探測優先級（低 = 先試）

[[protocol_plugins]]
name = "mewtocol"                    # 松下 Mewtocol
transport = "ipc:///run/evernight/mewtocol.sock"  # Unix socket
priority = 70
```

### JSON-RPC 介面（arona 型別）

| 方法 | 參數 | 傳回 |
|------|------|------|
| `protocol.connect` | `{ transport: TransportInfo }` | `{ connected: bool }` |
| `protocol.read` | `{ address: DataAddress }` | `{ raw: [u8], latency_us: u64 }` |
| `protocol.write` | `{ address: DataAddress, data: [u8] }` | `{ confirmed: bool }` |
| `protocol.ping` | `{}` | `{ reachable: bool }` |
| `protocol.probe` | `{ transport: TransportInfo }` | `{ protocol: string, confidence: float }` |

### 撰寫 Tier 3 外掛程式

Tier 2 crate（如 `evernight-s7comm`）是**參考實作**。外掛程式作者可以閱讀其
原始碼理解 `ProtocolBackend` trait 的契約，然後用任何語言（Python、Go、C、
Node.js）在 JSON-RPC 伺服器後面實作相同邏輯。

最小 Python 外掛程式範例：

```python
#!/usr/bin/env python3
"""最小 Tier 3 外掛程式 — 透過 WebSocket 說 JSON-RPC"""
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

## 自動探測優先級

| 優先級 | 協定 | 埠 | 層級 |
|--------|------|------|------|
| 10 | OPC UA | 4840 | Tier 1 |
| 20 | Modbus TCP | 502 | Tier 1 |
| 30 | EtherCAT | — | Tier 1 |
| 40 | CAN | — | Tier 1 |
| 50 | S7comm | 102 | Tier 2 |
| 60 | MC Protocol | 5000 | Tier 2 |
| 70 | EtherNet/IP | 44818 | Tier 2 |
| 100+ | Tier 3 外掛程式 | 不定 | Tier 3 |

開放標準的探測優先級最低（最先嘗試），因為如果裝置支援 OPC UA，
那就是你想要的路徑——不管它是什麼品牌。
