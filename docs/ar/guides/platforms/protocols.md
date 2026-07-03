# تكامل البروتوكولات الصناعية — Evernight

Evernight هو **وسيط القدرات الأجهزة الإلزامي** لمنظومة celestia-island. لا يستورد أي كرة upstream حزمة `aoba` / `rust7` / إلخ مباشرةً — كل الإدخال/الإخراج المادي يمر عبر وحدات بروتوكول evernight.

## مستويات البروتوكولات

ليست جميع البروتوكولات متساوية. يصنّفها Evernight في ثلاثة مستويات:

| المستوى | ما هي | مدمج؟ | في صورة aris؟ | أمثلة |
|------|------|-----------|----------------|----------|
| **Tier 1** | معايير مفتوحة — متاحة دائمًا | ✅ نعم | ✅ نعم | OPC UA، Modbus TCP/RTU، CAN، EtherCAT |
| **Tier 2** | خاصة بالبائع — كرات رسمية، اختيارية | ميزة اختيارية | ❌ لا | S7comm، MC Protocol، EtherNet/IP |
| **Tier 3** | إضافات طرف ثالث — تُحمَّل وقت التشغيل | ❌ عملية خارجية | ❌ لا | أي شيء تكتبه |

### لماذا التقسيم إلى مستويات؟

**Tier 1 (المعايير المفتوحة)** هي المسار الأساسي. تأتي وحدات PLC الحديثة من كل بائع رئيسي (Siemens S7-1500، Mitsubishi iQ-R، Rockwell ControlLogix 5580) مزوَّدة بخوادم OPC UA مدمجة. إذا كان جهاز ما يتحدث OPC UA، فاستخدمها — لا حاجة لكود خاص بالبائع.

**Tier 2 (خاصة بالبائع)** تغطي القاعدة المثبَّتة القديمة. ملايين وحدات PLC في الميدان (S7-300/1200، MELSEC Q، Allen-Bradley القديمة) لا تملك OPC UA وتتحدث بروتوكولها المملوك فقط. هذه البروتوكولات:

- منفذة كـ **كرات مستقلة** (غير مضمَّنة في نواة evernight)
- تُجمَّع فقط عند تفعيل ميزة Cargo
- **غير مُضمَّنة** في صورة نظام تشغيل بوابة aris افتراضيًا
- تعمل كل كرة كـ **تنفيذ مرجعي** لمؤلفي إضافات Tier 3

**Tier 3 (إضافات طرف ثالث)** تتيح لأي شخص إضافة دعم بروتوكول دون المساس بالكود المصدري لـ evernight. الإضافة هي عملية خارجية تتحدث JSON-RPC (باستخدام أنواع [arona](https://github.com/celestia-island/arona)) عبر WebSocket أو مقبس نطاق Unix. يُصرِّح تكوين TOML للبوابة بمكان كل إضافة.

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

## Tier 1: المعايير المفتوحة

### Modbus (RTU عبر تسلسلي / TCP)

Modbus هو حصان العمل في الاتصالات الصناعية. وهو معيار مفتوح (IEC 61158) مدعوم من كل وحدة PLC ومستشعر ومشغّل تقريبًا في السوق.

**مُجمَّع دائمًا.** لا حاجة لأعلام الميزات.

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

OPC UA (IEC 62541) هو معيار الاتصال الصناعي الشامل. وحدات PLC الحديثة من Siemens وMitsubishi وRockwell وغيرها تتضمن خوادم OPC UA مدمجة. إذا كان الجهاز يدعم OPC UA، فهذا هو المسار المفضل — لا حاجة لبروتوكول خاص بالبائع.

```toml
[dependencies]
evernight = { version = "0.1", features = ["opcua"] }
```

### CAN 2.0B / EtherCAT

معايير مفتوحة لاتصال الناقل الميداني (خلايا الوقود، المشغّلات الت伺فية، التحكم بالحركة). تُفعَّل عبر ميزتَي `can` و`ethercat`.

-----------------------------------------------------------------------------

## Tier 2: البروتوكولات الخاصة بالبائع

كل بروتوكول Tier 2 هو **كرة مستقلة** تنفذ السمتَين `ProtocolBackend` و`ProtocolProbe`. وهي اختيارية — فعّل ميزة Cargo لتجميعها، أو اتركها لتُبقي الملف التنفيذي صغيرًا.

> **كرات Tier 2 غير مُضمَّنة في صورة نظام تشغيل بوابة aris افتراضيًا.**
> تأتي الصورة بـ Tier 1 فقط. إذا كنت تحتاج بروتوكولًا خاصًا بالبائع
> على البوابة، فإمّا:
> 1. ابنِ صورة aris مخصصة مع تفعيل الميزة، أو
> 2. شغّل البروتوكول كإضافة Tier 3 (انظر أدناه).

### S7comm (Siemens S7-1200/1500/300/400)

```toml
[dependencies]
evernight = { version = "0.1", features = ["s7comm"] }
```

S7comm هو البروتوكول الأصلي لـ Siemens عبر ISO-on-TCP (المنفذ 102). هذا **أعلى بروتوكولات البائع أولوية** — فشركة Siemens تملك أكبر قاعدة مثبَّتة في الأسواق المستهدفة (طاقة الهيدروجين، الكيماويات، الصيدلة).

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

**التحقق:** مُتحقَّق منه مقابل تنفيذ Snap7 C المرجعي (معيار صناعي مفتوح المصدر عمره 15 عامًا). اختبار تفاضلي على مستوى البايت يؤكد الامتثال لصيغة السلك. 19 اختبار تكامل تمر في CI.

### MC Protocol (Mitsubishi MELSEC)

```toml
[dependencies]
evernight = { version = "0.1", features = ["mc"] }
```

MC Protocol (إطار 3E الثنائي) يغطي سلسلة Mitsubishi MELSEC Q/L/iQ-R. **الأقل أولوية** بين بروتوكولات البائعين — منظومة Mitsubishi مغلقة المصدر بدون تنفيذ خادم مرجعي. مع ذلك، وحدات PLC الحديثة من Mitsubishi (iQ-R، iQ-F) تملك OPC UA مدمجًا، لذا **OPC UA هو المسار المفضل لأجهزة Mitsubishi**.

**التحقق:** مرجعية متقاطعة مقابل ستة مصادر مستقلة (دليل Mitsubishi الرسمي، مشغّل Beijer Electronics، وثائق Neuron، محاكي Sym3، عميل pymcprotocol، لقطات إطار مُختبَرة ميدانيًا).

### EtherNet/IP (Rockwell/Allen-Bradley)

```toml
[dependencies]
evernight = { version = "0.1", features = ["enip"] }
```

EtherNet/IP + CIP يغطي وحدات PLC من Rockwell Automation / Allen-Bradley، بشكل أساسي في السوق الأمريكية الشمالية.

-----------------------------------------------------------------------------

## Tier 3: بروتوكول الإضافات — JSON-RPC عبر WebSocket / IPC

يتيح Tier 3 لأي شخص إضافة دعم بروتوكول إلى evernight دون تعديل الكود المصدري لـ evernight. الإضافة هي عملية خارجية تقوم بـ:

1. الاستماع على WebSocket (`ws://host:port`) أو مقبس نطاق Unix (`ipc:///path`)
2. التحدث JSON-RPC 2.0 باستخدام أنواع [arona](https://github.com/celestia-island/arona)
3. تنفيذ نفس واجهة `connect` / `read` / `write` / `ping` كالواجهات الخلفية المدمجة

### التصريح بالإضافات في TOML للبوابة

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

عند بدء التشغيل، يقرأ evernight هذا الملف، ويُنشئ `RemotePluginBackend` لكل إدخال، ويسجّله في `ProtocolRegistry`. من تلك النقطة، تشارك الإضافة في الكشف التلقائي وإدخال/إخراج البيانات تمامًا كواجهة خلفية مدمجة.

### واجهة JSON-RPC (أنواع arona)

يجب أن تستجيب الإضافة لطرق JSON-RPC هذه (المعرَّفة في arona):

| الطريقة | المعاملات | تُعيد |
|--------|-----------|---------|
| `protocol.connect` | `{ transport: TransportInfo }` | `{ connected: bool }` |
| `protocol.read` | `{ address: DataAddress }` | `{ raw: [u8], latency_us: u64 }` |
| `protocol.write` | `{ address: DataAddress, data: [u8] }` | `{ confirmed: bool }` |
| `protocol.ping` | `{}` | `{ reachable: bool }` |
| `protocol.probe` | `{ transport: TransportInfo }` | `{ protocol: string, confidence: float }` |

انظر [كرة arona](https://github.com/celestia-island/arona) لتعريفات الأنواع الكاملة وروابط TypeScript.

### كتابة إضافة Tier 3

تعمل كرة Tier 2 (مثل `evernight-s7comm`) كـ **تنفيذ مرجعي**. يمكن لمؤلفي الإضافات دراسة مصدرها لفهم عقد السمة `ProtocolBackend`، ثم تنفيذ نفس المنطق بأي لغة (Python، Go، C، Node.js) خلف خادم JSON-RPC.

مثال إضافة Python دنيا:

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

## البنية

كل بروتوكول — بصرف النظر عن المستوى — ينفذ نفس السمتين:

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

## أولوية الكشف التلقائي

عند استكشاف جهاز غير معروف، تعمل مجسات Tier 1 للمعايير المفتوحة أولًا:

| الأولوية | البروتوكول | المنفذ |
|----------|----------|------|
| 10 | OPC UA | 4840 |
| 20 | Modbus TCP | 502 |
| 30 | EtherCAT | — |
| 40 | CAN | — |
| 50 | S7comm (Tier 2) | 102 |
| 60 | MC Protocol (Tier 2) | 5000 |
| 70 | EtherNet/IP (Tier 2) | 44818 |
| 100+ | إضافات Tier 3 | متغير |

تحصل المعايير المفتوحة على أرقام الأولوية الأدنى (تُستكشَف أولًا) لأنه إذا كان جهاز ما يتحدث OPC UA، فهذا هو المسار الذي تريده — بصرف النظر عن البائع.

## مرجع أوامر CLI

| الأمر | الوصف |
|---------|-------------|
| `evernight probe <host> [--ports 502,102,...]` | استكشاف مضيف للبروتوكولات (جميع المستويات) |
| `evernight sensor-poll [--manifest X.toml]` | استطلاع المستشعرات، إصدار الإنذارات |
| `evernight api-serve --transport ws` | بدء خادم API بخدمة JSON-RPC |

## أنواع بيانات حقول S7

| النوع | الحجم | صيغة الإزاحة | التفكيك |
|------|------|---------------|--------|
| `BOOL` | 1 bit | `8.0` (byte 8, bit 0) | اختبار البت |
| `BYTE` | 1 byte | `8` | `u8` |
| `WORD` | 2 bytes | `8` | `u16::from_be_bytes` |
| `INT` | 2 bytes | `8` | `i16::from_be_bytes` |
| `DWORD` | 4 bytes | `8` | `u32::from_be_bytes` |
| `DINT` | 4 bytes | `8` | `i32::from_be_bytes` |
| `REAL` | 4 bytes | `0` | `f32::from_be_bytes` |
| `STRING` | var | `20` | ASCII مسبوق بطول |

> يرمز الجزء الكسري من `offset` إلى **فهرس البت** لحقول BOOL.

## توجيه الإنذارات

تتدفق قراءات المستشعرات عبر خط أنابيب إنذار مشترك. يحصل كل بروتوكول على فضاء أسماء مواضيع خاص به:

| البروتوكول | موضوع المُحفِّز | معرّف المصدر |
|----------|---------------|-----------|
| Modbus | `modbus.{station}.{field}.{level}` | `evernight.modbus.{station}` |
| S7comm | `s7comm.{station}.{field}.{level}` | `evernight.s7comm.{station}` |
| OPC UA | `opcua.{node}.{field}.{level}` | `evernight.opcua.{node}` |

تتبع مستويات الإنذار معيار ISA-18.2: `ll` / `l` / `h` / `hh` / `roc`.
