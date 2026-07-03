# 集成指南 — Evernight

如何将 evernight 连接到每个受支持的协议、使用什么服务端软件，以及如何端到端地验证连接是否正常工作。

## 架构

```
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

---

## 1. Modbus RTU（串口）

### 服务端
- **设备**：任意 Modbus RTU 从站（PLC、传感器、变频器）
- **无服务器测试**：`socat PTY,raw,echo=0,link=/tmp/vcom_a PTY,raw,echo=0,link=/tmp/vcom_b &`
  ——创建一对虚拟串口；运行 `tests/modbus_slave_sim.rs` 可模拟 6 个站。

### Evernight 侧
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

---

## 2. S7comm（西门子）

### 服务端
- **设备**：S7-1200/1500/300/400 PLC
- **前置条件**：TIA Portal → 启用“允许 PUT/GET”+ 禁用“优化块访问”
- **无硬件测试**：`cargo test --features full --test s7comm_integration`（使用进程内的 snap7-server）

### Evernight 侧
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

---

## 3. MC 协议（三菱）

### 服务端
- **设备**：MELSEC FX/Q/L/iQ-R PLC
- **无硬件测试**：`tests/mc_test_server.rs`（进程内的 mock MC 服务器）

### Evernight 侧
```rust
use evernight::protocol::mc_protocol::{McProtocolClient, McDevice};

let client = McProtocolClient::new("192.168.1.5", 5000);
client.connect().await?;
let words = client.read_devices(McDevice::D, 0, 10).await?;
println!("D0-D9: {:?}", words);
```

---

## 4. EtherNet/IP（罗克韦尔）

### 服务端
- **设备**：Allen-Bradley CompactLogix / ControlLogix
- **无硬件测试**：使用手工构造的帧进行单元测试（无实时模拟器）

### Evernight 侧
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

---

## 5. OPC UA

### 服务端
- **设备/软件**：任意 OPC UA 服务器（KEPServerEX、Ignition、CODESYS 等）
- **自托管**：evernight 本身就可以充当 OPC UA 服务器：

```rust
use evernight::protocol::opcua_server::OpcUaSensorServer;

let mut server = OpcUaSensorServer::new("opc.tcp://0.0.0.0:4840", 4840)?;
let node = server.add_sensor_variable("temperature", 25.5)?;
// server.run();  // blocks — run in a separate thread
```

### Evernight 客户端侧
```rust
use evernight::protocol::opcua_client::{OpcUaClient, OpcUaEndpoint, OpcUaSecurity};

let endpoint = OpcUaEndpoint::new_anonymous("opc.tcp://192.168.1.50:4840");
let client = OpcUaClient::connect(&endpoint).await?;
let value = client.read_node("ns=2;s=Temperature").await?;
println!("Temperature: {}", value);
```

---

## 6. SSH

### 服务端
- 任意 SSH 服务器（OpenSSH、Dropbear 等）
- **密钥管理**：`evernight vault init ~/.config/evernight/vault "passphrase"`
  然后添加凭据。

### Evernight 侧
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

---

## 7. VNC

### 服务端
- **软件**：TigerVNC、x11vnc、RealVNC 等
- **安装**：`apt install tigervnc-standalone-server && vncserver :1`
- **浏览器访问**：evernight 可以将 VNC 代理到 WebSocket：

```bash
# Start a VNC-to-WebSocket proxy (noVNC-compatible)
# (programmatically via evernight::vnc::ws::serve_vnc_websocket)
```

### Evernight 侧
```bash
# CLI one-shot — handshake + server info + one frame capture
evernight connect vnc://192.168.1.100:5901
```

---

## 8. RDP

### 服务端
- **Windows**：原生 RDP（设置 → 远程桌面 → 启用）
- **Linux**：`apt install xrdp`
  - 启用 TLS：在 `/etc/xrdp/xrdp.ini` 中设置 `security_layer=tls`
  - 生成证书：`openssl req -x509 -newkey rsa:2048 -nodes -keyout key.pem -out cert.pem -days 365 -subj "/CN=localhost"`
  - 复制到 `/etc/xrdp/cert.pem` + `/etc/xrdp/key.pem`

### Evernight 侧
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

### RDP 当前进展
- ✅ 传输层：X.224 + TLS 升级（已对照真实 xrdp 验证）
- ✅ MCS：Connect-Initial/Response + Attach-User（已验证）
- ✅ 位图：无压缩 + Interleaved RLE 解码 → RGBA
- ✅ 输入：键盘扫描码 + 鼠标事件
- ✅ 通道：CLIPRDR + RDPDR + RDPSND + DVC
- ✅ NLA：NTLMv2 + CredSSP（Kerberos 需要 KDC）
- ◐ 会话：需要 Channel-Join → 能力交换 → 持续的 framebuffer 循环

---

## 9. Kubernetes

### 服务端
- 任意 k8s 集群（minikube、kind、EKS、GKE 等）
- 认证：`~/.kube/config` 或集群内 service account

### Evernight 侧
```rust
use evernight::cloud::k8s::K8sClient;

let client = K8sClient::from_kubeconfig("default").await?;
let pods = client.list_pods().await?;
for pod in &pods {
    println!("{}: {} ({} containers)", pod.name, pod.phase, pod.containers.len());
}
```

---

## 10. libvirt

### 服务端
- `apt install libvirt-daemon-system libvirt-dev`
- 启动 libvirtd：`systemctl start libvirtd`

### Evernight 侧
```rust
use evernight::cloud::libvirt_client::LibvirtClient;

let client = LibvirtClient::open_read_only("qemu:///system")?;
let domains = client.list_domains()?;
for d in &domains {
    println!("{}: {:?}", d.name, d.state);
}
```

---

## 客户端之问：你应该自己造一个查看器吗？

### 问题

Evernight 能把 RDP 位图解码为 RGBA 缓冲区、把 VNC 帧解码为像素，但
**无处显示**。没有一个渲染器：

- 你无法直观地验证位图解码是否正确（只能检查
  它有没有崩溃）
- 你无法 dogfood——evernight 被定位为“XPipe 级别的通用
  连接管理器”，而 XPipe 能显示远程桌面
- 手动测试需要外部查看器（mstsc.exe / xfreerdp / vinagre）

### 建议：是的——构建一个最小化的内嵌查看器

三个层次的投入，从最简单到最有用：

#### Tier 1：无头截图（最小投入，最高测试价值）

```
evernight connect rdp://host --screenshot out.png
```

在会话建立后捕获一帧，写入 PNG。无需 GUI。
使用现有的 `bitmap::decode_to_rgba` + 一个简单的 PNG 编码器（或 PPM，
后者零依赖）。这能带来：

- **自动化视觉回归**：跨提交对比截图
- **协议正确性**：你能直接看到 RDP 位图解码对不对
- **CI 友好**：无需显示服务器

预计工作量：约 100 行（PNG 编码 + 一次性捕获循环）。

#### Tier 2：egui 窗口（中等投入，完整手动测试）

```
evernight connect rdp://host --gui
```

打开一个 [egui](https://github.com/emilk/egui) 窗口显示实时 RDP
framebuffer。键盘/鼠标输入通过现有的输入编解码器回传。
这能带来：

- **完整闭环**：输入 → 看到输出 → 验证交互
- **无外部依赖**：egui 是纯 Rust、跨平台
- **单一二进制**：无需单独的查看器应用

预计工作量：约 300 行（egui 纹理上传 + 输入事件循环）。
egui 的 `eframe` crate 在生态中已很常见。

#### Tier 3：基于现有 API 的 Web 前端（最大投入，生产级）

Evernight 已有 `api-serve --transport ws`（基于 WebSocket 的 JSON-RPC）。
一个 Web 前端（shittim-chest / Tauri）连接到该 API 并：

- 在 `<canvas>` 上渲染 framebuffer
- 通过 JSON-RPC 发送输入事件
- 这是生产路径——Tier 1+2 是为开发/测试用的

这是前端工作（Vue/React/Tauri），而非 evernight 库代码。

### 应该做哪一层？

**从 Tier 1（无头截图）开始**——它的测试投资回报率最高，
约需 1 小时。它补上了最关键的缺口：你终于能直接看到
RDP 位图流水线是否产出了正确的像素。

当你需要交互式测试时再添加 Tier 2（egui）——例如验证
键盘输入、剪贴板、驱动重定向。

Tier 3 是生产前端，在 Web UI 准备就绪时构建。

---

## 快速开始：验证你的环境

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
