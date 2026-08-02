# خريطة المشاريع

الجرد الكامل لمستودعات celestia-island، مجمعة حسب الطبقة. المستودعات الموسومة
بموقع توثيق تحمل وثائق *كيف* الخاصة بها على `<name>.docs.celestia.world`؛ وكل
ما عداها موثق في مستودعها.

## الطبقة 0 — المصادقة

| المشروع | الدور | التوثيق |
| --- | --- | --- |
| [kirino](https://github.com/celestia-island/kirino) | مصادقة الثقة الصفرية وRBAC: جلسات JWT، تجزئة Argon2id، تقييد معدل تسجيل الدخول، محرك الأذونات | [kirino.docs.celestia.world](https://kirino.docs.celestia.world) |

## الطبقة 1 — المنصة

| المشروع | الدور | التوثيق |
| --- | --- | --- |
| [plana](https://github.com/celestia-island/plana) | أنواع مشتركة، عميل وخادم JSON-RPC، جلسات SSE، قواطع دائرة، قياس LLM وتسعيره، صدفة لوحة الإدارة | المستودع |
| [provider-registry](https://github.com/celestia-island/provider-registry) | سجل النماذج والمزودين (تنسيق TOML لنقطة الدخول) | المستودع |

## الطبقة 2 — الواجهة

| المشروع | الدور | التوثيق |
| --- | --- | --- |
| [hikari](https://github.com/celestia-island/hikari) | مكتبة مكونات واجهة (Vue/TS + Rust) تشترك فيها كل واجهات الويب | المستودع |

## الطبقة 3 — الخدمات

| المشروع | الدور | التوثيق |
| --- | --- | --- |
| [arona](https://github.com/celestia-island/arona) | لوحة إدارة API السحابية: الحسابات، مفاتيح API، نشر النماذج، الخلفيات، سجلات الاستخدام | المستودع |
| [shittim-chest](https://github.com/celestia-island/shittim-chest) | محادثة سطح المكتب/الويب والصدفة | [shittim-chest.docs.celestia.world](https://shittim-chest.docs.celestia.world) |
| [entelecheia](https://github.com/celestia-island/entelecheia) | منصة التعاون متعدد الوكلاء: نواة دقيقة exec-only، خادم تنسيق scepter، خط تنفيذ IEPL | [entelecheia.docs.celestia.world](https://entelecheia.docs.celestia.world) |
| [evernight](https://github.com/celestia-island/evernight) | وسيط البروتوكولات الصناعية: Modbus وS7comm وOPC UA؛ العمليات عن بعد، القياسات عن بعد، بوابات الكتابة | [evernight.docs.celestia.world](https://evernight.docs.celestia.world) |
| [malkuth](https://github.com/celestia-island/malkuth) | مجموعة أدوات الإشراف على الخدمات: تحديثات متدحرجة، فحوصات صحة، وكيل عكسي، استرداد من حلقات الانهيار | [malkuth.docs.celestia.world](https://malkuth.docs.celestia.world) |
| [lagrange](https://github.com/celestia-island/lagrange) | محرك توثيق Markdown الذي يشغل هذا الموقع وكل مواقع توثيق المشاريع | [lagrange.docs.celestia.world](https://lagrange.docs.celestia.world) |

## الأدوات والمكتبات

| المشروع | الدور | التوثيق |
| --- | --- | --- |
| [noa](https://github.com/celestia-island/noa) | تحكم بالإصدارات موزع أصيل للذكاء الاصطناعي: عزل مساحات عمل لكل وكيل، سجلات JSONL ملحقة فقط، تاريخ لقطات | [noa.docs.celestia.world](https://noa.docs.celestia.world) |
| [seia](https://github.com/celestia-island/seia) | مكتبة بحث ويب متعددة المحركات وCLI | [seia.docs.celestia.world](https://seia.docs.celestia.world) |
| [ichika](https://github.com/celestia-island/ichika) | ماكروات خطوط أنابيب بمجمع خيوط (أنابيب رسائل مبنية على flume) | [ichika.docs.celestia.world](https://ichika.docs.celestia.world) |
| [yuuka](https://github.com/celestia-island/yuuka) | ماكرو إجرائي لتوليد هياكل متداخلة معقدة من ماكرو بسيط | [yuuka.docs.celestia.world](https://yuuka.docs.celestia.world) |
| [aoba](https://github.com/celestia-island/aoba) | واجهة سطر أوامر Modbus ومصادر البيانات | [aoba.docs.celestia.world](https://aoba.docs.celestia.world) |
| [kou](https://github.com/celestia-island/kou) | محرك محطة افتراضية مستقل: إدارة PTY، VT100/ANSI | المستودع |
| [hifumi](https://github.com/celestia-island/hifumi) | مكتبة تسلسل لترحيل البيانات بين الإصدارات | المستودع |
| [aris](https://github.com/celestia-island/aris) | محرك متصفح مشتق من servo، قابل للتضمين كمكتبة (WebGL للتوائم الرقمية) | المستودع |
| [shirabe](https://github.com/celestia-island/shirabe) | مكتبة أتمتة وتصحيح متصفح خفيفة أصلية في Rust | المستودع |
| [tairitsu](https://github.com/celestia-island/tairitsu) | إطار عمل كامل الحزمة يعمل بنموذج مكونات WASM | المستودع |
| [ratatui-markdown](https://github.com/celestia-island/ratatui-markdown) | عرض Markdown لواجهات ratatui الطرفية | المستودع |
| [arcaea](https://github.com/celestia-island/arcaea) | مكتبة Rust لبروتوكول شخصية celestia | المستودع |
| [scriptum](https://github.com/celestia-island/scriptum) | واجهة طرفية (TUI) لـ entelecheia: «شاشة غبية» تتحدث إلى خادم scepter | المستودع |

## الحافة والعتاد

| المشروع | الدور | التوثيق |
| --- | --- | --- |
| [kei](https://github.com/celestia-island/kei) | نواة نظام Rust لأجهزة ARM64/RISC-V الطرفية؛ نواة زمن حقيقي حتمية للأفق الطويل | المستودع |

## البنية التحتية والأدوات

| المشروع | الدور | التوثيق |
| --- | --- | --- |
| [celestia-devtools](https://github.com/celestia-island/celestia-devtools) | سلسلة أدوات تطوير مشتركة: وصفات justfile، تسجيل التصحيحات، فحص الأكواد | المستودع |
| [celestia-integration](https://github.com/celestia-island/celestia-integration) | مجموعات اختبار تكامل على عتاد حقيقي للحلقة الكاملة | المستودع |
| [sysl](https://github.com/celestia-island/sysl) | ترخيص المصدر التركيبي (SySL): ترخيص مصمم للكود المولد بالذكاء الاصطناعي | المستودع |

## الحضور على الويب

| الموقع | الدور | التوثيق |
| --- | --- | --- |
| [celestia-island.github.io](https://celestia-island.github.io) | حضور المنظمة | المستودع |
| [docs.celestia.world](https://docs.celestia.world) | هذا الموقع — الفلسفة، الخريطة، البدء | المستودع |
| [e.celestia.world](https://e.celestia.world) | صفحة الهبوط العامة | المستودع |
| [dev.celestia.world](https://dev.celestia.world) | بوابة المطورين | المستودع |
| [arona.celestia.world](https://arona.celestia.world) | لوحة إدارة API السحابية (منتج) | — |

## لمزيد من التفاصيل

- [البنية الطبقية](../philosophy/layered-architecture.md) — لماذا توجد هذه الطبقات.
- [الحلقة المغلقة](../philosophy/closed-loop.md) — كيف تتعاون المشاريع على طول الحلقة.
- [المواقع والمسؤوليات](./sites.md) — من يوثق ماذا، وأين.
