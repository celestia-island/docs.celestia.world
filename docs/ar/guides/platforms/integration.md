# دليل التكامل — Evernight

كيفية ربط evernight بكل بروتوكول مدعوم، وما هي برمجيات الخادم التي يجب استخدامها، وكيفية التحقق من أن الاتصال يعمل من طرف إلى طرف.

## البنية

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

## 1. Modbus RTU (تسلسلي)

### جهة الخادم
- **الجهاز**: أي عبد Modbus RTU (PLC، مستشعر، عاكس)
- **اختبار بلا خادم**: `socat PTY,raw,echo=0,link=/tmp/vcom_a PTY,raw,echo=0,link=/tmp/vcom_b &`
  — ينشئ زوجًا تسلسليًا افتراضيًا؛ شغّل `tests/modbus_slave_sim.rs` لـ 6 محطات.

### جهة Evernight
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

### جهة الخادم
- **الجهاز**: وحدة PLC من طراز S7-1200/1500/300/400
- **المتطلب الأساسي**: TIA Portal ← تفعيل "Permit PUT/GET" + تعطيل "Optimized block access"
- **اختبار بلا عتاد**: `cargo test --features full --test s7comm_integration` (يستخدم snap7-server داخل العملية)

### جهة Evernight
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

### جهة الخادم
- **الجهاز**: وحدة PLC من طراز MELSEC FX/Q/L/iQ-R
- **اختبار بلا عتاد**: `tests/mc_test_server.rs` (خادم MC وهمي داخل العملية)

### جهة Evernight
```rust
use evernight::protocol::mc_protocol::{McProtocolClient, McDevice};

let client = McProtocolClient::new("192.168.1.5", 5000);
client.connect().await?;
let words = client.read_devices(McDevice::D, 0, 10).await?;
println!("D0-D9: {:?}", words);
```

-----------------------------------------------------------------------------

## 4. EtherNet/IP (Rockwell)

### جهة الخادم
- **الجهاز**: Allen-Bradley CompactLogix / ControlLogix
- **اختبار بلا عتاد**: اختبارات وحدة بإطارات مبنية يدويًا (لا محاكٍ حي)

### جهة Evernight
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

### جهة الخادم
- **الجهاز/البرمجية**: أي خادم OPC UA (KEPServerEX، Ignition، CODESYS، إلخ)
- **استضافة ذاتية**: يمكن لـ evernight نفسه العمل كخادم OPC UA:

```rust
use evernight::protocol::opcua_server::OpcUaSensorServer;

let mut server = OpcUaSensorServer::new("opc.tcp://0.0.0.0:4840", 4840)?;
let node = server.add_sensor_variable("temperature", 25.5)?;
// server.run();  // blocks — run in a separate thread
```

### جهة عميل Evernight
```rust
use evernight::protocol::opcua_client::{OpcUaClient, OpcUaEndpoint, OpcUaSecurity};

let endpoint = OpcUaEndpoint::new_anonymous("opc.tcp://192.168.1.50:4840");
let client = OpcUaClient::connect(&endpoint).await?;
let value = client.read_node("ns=2;s=Temperature").await?;
println!("Temperature: {}", value);
```

-----------------------------------------------------------------------------

## 6. SSH

### جهة الخادم
- أي خادم SSH (OpenSSH، Dropbear، إلخ)
- **إدارة المفاتيح**: `evernight vault init ~/.config/evernight/vault "passphrase"`
  ثم أضف بيانات الاعتماد.

### جهة Evernight
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

### جهة الخادم
- **البرمجية**: TigerVNC، x11vnc، RealVNC، إلخ
- **التثبيت**: `apt install tigervnc-standalone-server && vncserver :1`
- **الوصول عبر المتصفح**: يمكن لـ evernight تمثيل VNC إلى WebSocket:

```bash
# Start a VNC-to-WebSocket proxy (noVNC-compatible)
# (programmatically via evernight::vnc::ws::serve_vnc_websocket)
```

### جهة Evernight
```bash
# CLI one-shot — handshake + server info + one frame capture
evernight connect vnc://192.168.1.100:5901
```

-----------------------------------------------------------------------------

## 8. RDP

### جهة الخادم
- **Windows**: RDP أصلي (Settings ← Remote Desktop ← Enable)
- **Linux**: `apt install xrdp`
  - لـ TLS: اضبط `security_layer=tls` في `/etc/xrdp/xrdp.ini`
  - أنشئ شهادة: `openssl req -x509 -newkey rsa:2048 -nodes -keyout key.pem -out cert.pem -days 365 -subj "/CN=localhost"`
  - انسخ إلى `/etc/xrdp/cert.pem` + `/etc/xrdp/key.pem`

### جهة Evernight
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

### أين يقف RDP اليوم
- ✅ النقل: ترقية X.224 + TLS (مُتحقَّق منها مقابل xrdp حقيقي)
- ✅ MCS: Connect-Initial/Response + Attach-User (مُتحقَّق)
- ✅ الصور النقطية: فك ترميز غير مضغوط + Interleaved RLE ← RGBA
- ✅ الإدخال: أكواد مسح لوحة المفاتيح + أحداث الفأرة
- ✅ القنوات: CLIPRDR + RDPDR + RDPSND + DVC
- ✅ NLA: NTLMv2 + CredSSP (يحتاج Kerberos إلى KDC)
- ◐ الجلسة: تحتاج Channel-Join ← تبادل القدرات ← حلقة لوحة الإطارات المستمرة

-----------------------------------------------------------------------------

## 9. Kubernetes

### جهة الخادم
- أي مجموعة k8s (minikube، kind، EKS، GKE، إلخ)
- المصادقة: `~/.kube/config` أو حساب خدمة داخل المجموعة

### جهة Evernight
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

### جهة الخادم
- `apt install libvirt-daemon-system libvirt-dev`
- ابدأ libvirtd: `systemctl start libvirtd`

### جهة Evernight
```rust
use evernight::cloud::libvirt_client::LibvirtClient;

let client = LibvirtClient::open_read_only("qemu:///system")?;
let domains = client.list_domains()?;
for d in &domains {
    println!("{}: {:?}", d.name, d.state);
}
```

-----------------------------------------------------------------------------

## سؤال العميل: هل يجب أن تبني عارضًا؟

### المشكلة

يفك evernight ترميز صور RDP النقطية إلى مخازن RGBA وإطارات VNC إلى بكسلات، لكن **لا يوجد مكان لعرضها**. بدون عارض:

- لا يمكنك التحقق بصريًا من أن فك ترميز الصور النقطية صحيح (يمكنك فقط التحقق من أنه لا ينهار)
- لا يمكنك تجربة الكود داخليًا (dogfooding) — من المفترض أن يكون evernight "مدير اتصالات شاملًا بمستوى XPipe"، وXPipe يعرض أسطح المكتب البعيدة
- الاختبار اليدوي يتطلب عارضًا خارجيًا (mstsc.exe / xfreerdp / vinagre)

### التوصية: نعم — ابنِ عارضًا مدمجًا دنيا

ثلاثة مستويات من الجهد، من الأسهل إلى الأكثر فائدة:

#### Tier 1: لقطة شاشة بلا واجهة (أقل جهدًا، أعلى قيمة اختبار)

```text
evernight connect rdp://host --screenshot out.png
```

يلتقط إطارًا واحدًا بعد إعداد الجلسة ويكتبه إلى PNG. لا حاجة لواجهة رسومية.
يستخدم `bitmap::decode_to_rgba` الموجود + مُرمِّز PNG بسيط (أو PPM، الذي لا يحتاج أي تبعيات). يمنحك هذا:

- **انحدار بصري آلي**: قارن لقطات الشاشة عبر الالتزامات
- **صحة البروتوكول**: يمكنك رؤية ما إذا كان فك ترميز صور RDP النقطية صحيحًا
- **ملائم لـ CI**: لا يتطلب خادم عرض

الجهد المقدَّر: ~100 سطر (ترميز PNG + حلقة التقاط لمرة واحدة).

#### Tier 2: نافذة egui (جهد متوسط، اختبار يدوي كامل)

```text
evernight connect rdp://host --gui
```

يفتح نافذة [egui](https://github.com/emilk/egui) تعرض لوحة إطارات RDP الحية. يُعاد إرسال إدخال لوحة المفاتيح/الفأرة عبر مرمِّز الإدخال الموجود. يمنحك هذا:

- **حلقة مغلقة كاملة**: اكتب ← شاهد المخرجات ← تحقق من التفاعل
- **لا تبعيات خارجية**: egui بـ Rust خالص، متعدد المنصات
- **ملف تنفيذي واحد**: لا حاجة لتطبيق عارض منفصل

الجهد المقدَّر: ~300 سطر (رفع نسيج egui + حلقة أحداث الإدخال).
كرة egui المسماة `eframe` شائعة بالفعل في المنظومة.

#### Tier 3: واجهة أمامية للويب عبر API الموجود (أكبر جهد، الإنتاج)

يملك evernight بالفعل `api-serve --transport ws` (JSON-RPC عبر WebSocket).
تتصل واجهة أمامية للويب (shittim-chest / Tauri) بهذا الـ API وتقوم بـ:

- عرض لوحة الإطارات على `<canvas>`
- إرسال أحداث الإدخال عبر JSON-RPC
- هذا هو مسار الإنتاج — Tier 1+2 للتطوير/الاختبار

هذا عمل واجهة أمامية (Vue/React/Tauri)، وليس كود مكتبة evernight.

### أي مستوى تبني؟

**ابدأ بـ Tier 1 (لقطة شاشة بلا واجهة)** — فهو أعلى عائد على الاستثمار للاختبار
ويستغرق ~1 ساعة. إنه يسد الفجوة الأكثر حرجًا: يمكنك أخيرًا رؤية ما إذا كان
خط أنابيب صور RDP النقطية ينتج بكسلات صحيحة.

ثم أضف Tier 2 (egui) عندما تحتاج إلى اختبار تفاعلي — مثل التحقق من
إدخال لوحة المفاتيح، الحافظة، إعادة توجيه الأقراص.

Tier 3 هو الواجهة الأمامية للإنتاج، تُبنى عندما تكون واجهة الويب جاهزة.

-----------------------------------------------------------------------------

## البدء السريع: تحقق من إعدادك

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
