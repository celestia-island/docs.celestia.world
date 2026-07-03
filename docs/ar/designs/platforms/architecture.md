# هندسة Evernight

> **evernight** مكتبة وخدمة تحكم بعيد عبر منصات. هو
> وسيط قدرات الأجهزة/البروتوكولات الإلزامي لمنظومة celestia-island —
> لا كرات upstream تتحدث مع الأجهزة المادية مباشرة.

## نظرة سريعة

| القدرة | الوحدة | الميزة |
|---|---|---|
| التقاط الشاشة (X11/DXGI/CoreGraphics) | `screen` | `screen` |
| بث شاشة WebRTC | `stream` | `webrtc` |
| صدفة SSH بعيدة + SFTP | `remote` | `remote-ssh` |
| عميل VNC (RFB) | `vnc` | `remote-vnc` |
| عميل RDP | `rdp` | `remote-rdp` |
| قياس الأجهزة | `hardware` | `hardware` |
| البروتوكولات الصناعية | `protocol` | `protocol` / `s7comm` / `opcua` / `ethercat` |
| تسلسلي / Modbus | `serial`, `sensor` | `serial` |
| نفق TCP + عبور NAT | `tunnel` | `tunnel` / `upnp` |
| كتالوج الاتصالات (URI) | `connection`, `connection_chain` | الأساسية |
| مخزن بيانات اعتماد مشفّر | `vault` | `vault` |
| حاويات / K8s / libvirt | `container`, `vm_manager` | `container` / `k8s` / `libvirt` / `vm` |
| خادم API (JSON-RPC) | `api` | `api` |

## ثلاث سمات خلفية متعددة الأشكال

كل ما سبق مُجرَّد خلف ثلاث سمات غير متعلقة بالنقل:

- `TerminalBackend` — قراءة/كتابة/تغيير حجم للطرفيات النصية (SSH، تسلسلي، Docker)
- `ViewportBackend` — عرض/إدخال لسطح المكتب الرسومي (VNC، RDP، الشاشة المحلية)
- `FileBackend` — قائمة/الحصول/الوضع/حذف لعمليات الملفات (SFTP، صدفة، نظام الملفات المحلي)

إضافة نقل هو إضافة — المستهلكون لا يتغيرون.

## طبقة البروتوكول

الإدخال/الإخراج الصناعي بوساطة سمتين:

- `ProtocolBackend` — اتصال / قراءة / كتابة / ping
- `ProtocolProbe` — كشف تلقائي لبروتوكول نقطة نهاية مجهولة

```
ProtocolRegistry::auto_detect(transport)  →  ProtocolProbeResult
```

الخلفيات: Modbus (aoba)، S7comm (rust7 + snap7-client)، MC Protocol، EtherCAT
(ethercrab)، EtherNet/IP + CIP، OPC UA (كرات opcua، عميل + خادم)، CAN
(SocketCAN).

### شبكة S7 الذاتية (التزويد التلقائي)

أشر evernight إلى IP مكشوف ويتشبك ذاتيًا:

```rust
use evernight::protocol::auto_provision;
let profile = auto_provision("192.168.1.10").await?;
```

خط أنابيب الفحص ← اتصال ← فحص-DB ← فحص-بنية يعيد
`S7DeviceProfile` دون إدخال رموز يدوي. راجع
[دليل إعداد TIA Portal](../../guides/platforms/tia-portal-setup.md) لتحضير
PLC لمرة واحدة.

## نموذج الاتصال

الاتصالات مُنمَّطة بـ URI ومُدارة بالكتالوج:

```
ssh://user@host:22          s7://10.0.0.5?rack=0&slot=1
vnc://host:5900             opcua://10.0.0.5:4840
serial:///dev/ttyUSB0?baud=9600
```

يحل `connection_chain` هدفًا إلى سلسلة قفزات مرتبة (ProxyJump مُعمَّم)
للنفق.

## أعلام الميزات

`full` (افتراضي) يفعّل كل شيء. كل قدرة قابلة للبوابة بشكل مستقل
لبناءات بحد أدنى من الاعتماديات — مثلًا `--features s7comm,serial` يشحن فقط
مجموعة البروتوكولات الصناعية الفرعية.
