# سجلات قرارات الهندسة المعمارية (ADR)

يسجل هذا الدليل القرارات المعمارية الرئيسية المُتخذة خلال تطوير Evernight. كل ADR يشرح **ما** قُرر، **لماذا** قُرر، و**ما** التنازلات التي اعتُبرت.

تتبع ADRs [قالب ADR لـ Michael Nygard](https://cognitect.com/blog/2011/11/15/documenting-architecture-decisions). هي غير قابلة للتغيير بمجرد نشرها — القرارات المُستبدَلة تُوسم وفقًا لذلك.

## الفهرس

| # | العنوان | الحالة |
|---|-------|--------|
| screen-capture | [هندسة التقاط الشاشة](../adr/screen-capture.md) | مقبول |
| feature-flags | [هندسة أعلام الميزات](../adr/feature-flags.md) | مقبول |
| ssh-backend | [خلفية SSH — russh مع اتصال مشترك](../adr/ssh-backend.md) | مقبول |
| async-runtime | [زمن تشغيل غير متزامن — tokio](../adr/async-runtime.md) | مقبول |
| error-handling | [معالجة الأخطاء — thiserror مع Result خاص بالكرات](../adr/error-handling.md) | مقبول |
| module-decoupling | [فصل الوحدات وملكية الأنواع](../adr/module-decoupling.md) | مقبول |
| signaling-transport | [نقل الإشارات — مقبس Unix مزدوج / TCP](../adr/signaling-transport.md) | مقبول |
| backend-traits | [تجريدات سمات TerminalBackend / ViewportBackend / FileBackend](../adr/backend-traits.md) | مقبول |
| ssh-connection-pool | [تجمع اتصالات SSH](../adr/ssh-connection-pool.md) | مقبول |
| vnc-rfb-client | [عميل بروتوكول VNC (RFB)](../adr/vnc-rfb-client.md) | مقبول |
| ssh-config-parser | [محلل تكوين SSH](../adr/ssh-config-parser.md) | مقبول |
| connection-entry-uri | [مخطط URI لإدخال الاتصال](../adr/connection-entry-uri.md) | مقبول |
| serial-port-aoba | [اتصال المنفذ التسلسلي عبر aoba](../adr/serial-port-aoba.md) | مقبول |
| container-runtime | [عميل زمن تشغيل الحاويات (Docker/Podman)](../adr/container-runtime.md) | مقبول |

## أدلة اللغة

| الرمز | اللغة |
|------|----------|
| `en/` | الإنجليزية (قانونية) |
| `zhs/` | الصينية المبسطة |
| `zht/` | الصينية التقليدية |
| `ja/` | اليابانية |
| `ko/` | الكورية |
| `fr/` | الفرنسية |
| `es/` | الإسبانية |
| `ru/` | الروسية |
