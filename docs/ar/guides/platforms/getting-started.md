# البدء — Evernight

Evernight (长夜月) مكتبة تحكم عن بُعد متعددة المنصات وبرنامج خفي (daemon) مكتوب بلغة Rust. يدمج التقاط الشاشة، وبث WebRTC، وصدفة SSH البعيدة، والوصول إلى الطرفية البعيدة، ونقل الملفات، وقياس عن بُعد للأجهزة، ودعم البروتوكولات الصناعية (استكشاف Modbus وS7comm وOPC-UA)، واختراق NAT في كرة Rust واحدة قابلة لإعادة الاستخدام وملف CLI تنفيذي مستقل.

## المتطلبات الأساسية

- Rust 1.85 أو أحدث (إصدار 2024)
- مُصرّف C لمنصتك (MSVC على Windows، GCC/Clang على Linux/macOS)
- لقياس الأجهزة عن بُعد: `nvidia-smi` (لـ NVIDIA GPU)، `libudev` على Linux
- للبروتوكولات الصناعية: منفذ تسلسلي (`/dev/ttyUSB*`) أو وصول شبكي إلى PLC

## البناء

```bash
git clone https://github.com/celestia-island/evernight.git
cd evernight
cargo build --release
```

يقع الملف التنفيذي الرئيسي في `target/release/evernight`.

## البدء السريع

تستخدم CLI أوامر فرعية. شغّل `evernight --help` لرؤيتها جميعًا.

### SSH — تشغيل أمر بعيد

```bash
evernight exec --host 192.168.1.100 --user root --key ~/.ssh/id_ed25519 \
  --command "uname -a"
```

### SSH — عمليات الملفات

```bash
# Upload a local file to a remote host
evernight file cp ./config.yaml root@192.168.1.100:/etc/app/config.yaml

# Download a remote file
evernight file get root@192.168.1.100:/var/log/syslog ./syslog

# List a remote directory
evernight file ls root@192.168.1.100:/etc/
```

### SSH — وكيل SOCKS5

```bash
# Start a local SOCKS5 proxy (port 1080) tunneled through an SSH jump host
evernight proxy 1080 --host 192.168.1.100 --user root --key ~/.ssh/id_ed25519
```

### قياس عن بُعد للأجهزة

```bash
evernight hw
```

### استكشاف البروتوكولات الشبكية

```bash
# Probe common industrial ports on a host
evernight probe 192.168.1.20 --ports 502,102,4840,22
```

### استطلاع المستشعرات الصناعية

```bash
# Poll sensors from a hardware manifest and emit alarms to entelecheia
evernight sensor-poll --manifest corridor.toml \
  --entelecheia-socket /run/entelecheia/hardware-events.sock
```

### كشف نوع NAT

```bash
evernight nat
```

### خادم API (JSON-RPC عبر WebSocket)

```bash
evernight api-serve --transport ws --host 0.0.0.0 --port 50000
```

## أعلام الميزات

Evernight مُقَيَّد بالميزات (feature-gated) حتى تُجمّع ما تحتاجه فقط:

```toml
[dependencies]
# Minimal: SSH + hardware telemetry
evernight = { version = "0.1", features = ["remote-ssh", "hardware"] }

# Industrial: Modbus + S7comm + manifest support
evernight = { version = "0.1", features = ["serial", "s7comm", "manifest"] }

# Everything (default)
evernight = { version = "0.1", features = ["full"] }
```

| الميزة | تُفعّل |
|---------|---------|
| `remote-ssh` | تنفيذ SSH، نقل الملفات، الطرفية، تمرير المنافذ، وكيل SOCKS5 |
| `remote-vnc` | عميل VNC (RFB) |
| `remote-rdp` | هيكل نقل RDP (TPKT/COTP/MCS) |
| `serial` | المنفذ التسلسلي + Modbus RTU (عبر aoba) |
| `s7comm` | عميل S7comm + تنزيل الكتل/الوميض (عبر rust7 + snap7-client) |
| `protocol` | استكشاف البروتوكولات + تجريد السمة ProtocolBackend |
| `sensor` | حلقة استطلاع المستشعرات، تقييم الإنذارات، تخزين السلاسل الزمنية |
| `manifest` | مخطط ملف بيان الأجهزة TOML/JSON + محوّلات وقت التشغيل |
| `container` | إدارة حاويات Docker / Podman |
| `hardware` | قياس عن بُعد للمعالج/كرت الشاشة/الذاكرة/التخزين |
| `screen` | التقاط الشاشة + ترميز JPEG/VP9 |
| `webrtc` | بث الشاشة عبر WebRTC |
| `tunnel` | تمرير منافذ TCP + اختراق NAT |
| `api` | خادم API بخدمة JSON-RPC 2.0 (ws/wss/ipc) |

## الميزات الرئيسية

- **التقاط الشاشة** — تعداد الشاشات، التقاط إطارات RGBA خام
- **بث WebRTC** — JPEG عبر DataChannel أو مسار فيديو VP9؛ دعم ICE/STUN
- **صدفة SSH البعيدة** — تنفيذ الأوامر، نقل الملفات، فتح الطرفيات عبر `russh`
- **نقل الملفات** — رفع/تنزيل مع استدعاءات تقدّم عبر SSH
- **قياس عن بُعد للأجهزة** — المعالج، كرت الشاشة، الذاكرة، التخزين، أجهزة PCI
- **البروتوكولات الصناعية** — Modbus RTU/TCP، S7comm (Siemens)، استكشاف OPC-UA
- **استطلاع المستشعرات** — حلقة استطلاع إقرارية مدفوعة بملف بيان مع توجيه إنذارات ISA-18.2
- **نفقي TCP** — تمرير المنافذ المحلي/البعيد + تمرير ديناميكي SOCKS5
- **اكتشاف NAT** — كشف نوع NAT قائم على STUN
- **خادم API** — JSON-RPC 2.0 عبر WebSocket / IPC للواجهات الأمامية للويب

## الخطوات التالية

- اقرأ **[دليل تكامل البروتوكولات الصناعية](./protocols.md)** لاستخدام Modbus/S7comm
- انظر `evernight <command> --help` لخيارات كل أمر
- تحقق من `cargo doc --open` لمرجع API الكامل
- شغّل اختبارات التكامل للتحقق من إعدادك (لا حاجة لأجهزة):
```bash
  cargo test --features full --test s7comm_integration    # S7comm vs snap7-server
  cargo test --features full --test serial_integration    # Modbus vs virtual serial
```
