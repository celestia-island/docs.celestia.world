# خريطة المشاريع

جرد مستودعات منصة celestia-island ومنتجاتها، مجمَّعًا حسب الطبقة. الاسم الموصول
رابطًا مستودع عام يمكنك قراءته اليوم؛ والاسم غير الموصول رابطًا منتجٌ يُشحن مع
المنصة ولم يصبح مصدره عامًّا بعد. والمستودعات المعلَّمة بموقع توثيق تحمل توثيق
*كيف* الخاص بها؛ وكل ما عداها موثَّق داخل المستودع نفسه.

## الطبقة 0 — المصادقة

| المشروع | الدور | التوثيق |
| --- | --- | --- |
| [kirino](https://github.com/celestia-island/kirino) | مصادقة وتفويض الثقة الصفرية: الجلسات، والأذونات، وتقييد المعدل | [kirino.docs.celestia.world](https://kirino.docs.celestia.world) |

## الطبقة 1 — المنصة

| المشروع | الدور | التوثيق |
| --- | --- | --- |
| [plana](https://github.com/celestia-island/plana) | أنواع البروتوكول المشتركة، والنقل، والقياس، والمرافق التي تستهلكها كل خدمة | المستودع |
| [provider-registry](https://github.com/celestia-island/provider-registry) | كتالوج النماذج والمزوّدين المشترك بين المنتجات | المستودع |

## الطبقة 2 — الواجهة

| المشروع | الدور | التوثيق |
| --- | --- | --- |
| [hikari](https://github.com/celestia-island/hikari) | مكتبة مكونات الواجهة التي تشترك فيها كل واجهات الويب | المستودع |

## الطبقة 3 — الخدمات

| المشروع | الدور | التوثيق |
| --- | --- | --- |
| arona | بوابة النماذج ولوحة النشر: المفاتيح، والخلفيات، والتوجيه، والاستخدام | [Arona](../platforms/arona.md) |
| shittim-chest | المحادثة واللوحات والتكاملات — سطح منصة العمل | [Shittim Chest](../platforms/chest.md) |
| entelecheia | منصة الوكلاء: الوكلاء، والذاكرة طويلة الأمد، والبحث الدلالي، والتكامل الصناعي | [Entelecheia](../platforms/entelecheia.md) |
| evernight | وسيط البروتوكولات الصناعية: بروتوكولات الميدان، والإنذارات، والتسجيل، والاستدلال على الطرفية | [Evernight](../platforms/evernight.md) |
| [malkuth](https://github.com/celestia-island/malkuth) | الإشراف على الخدمات: التحديثات المتدرجة، وفحوص الصحة، والوكيل العكسي، والتعافي من الأعطال | [malkuth.docs.celestia.world](https://malkuth.docs.celestia.world) |
| [lagrange](https://github.com/celestia-island/lagrange) | محرك التوثيق وراء هذا الموقع ووراء موقع توثيق كل مشروع | [lagrange.docs.celestia.world](https://lagrange.docs.celestia.world) |
| celestia-erp | الأنظمة الإدارية الخلفية للأعمال: المؤسسات، والفوترة، والفواتير | — |
| electrode_recon | محرك حسابي لبنية الإلكترود الدقيقة — أول نسخة خارجية على نسيج المحرك | — |

## الأدوات والمكتبات

| المشروع | الدور | التوثيق |
| --- | --- | --- |
| [noa](https://github.com/celestia-island/noa) | تحكم بالإصدارات موزَّع وأصيل للوكلاء مع مساحات عمل معزولة | [المستودع](https://github.com/celestia-island/noa) |
| [seia](https://github.com/celestia-island/seia) | بحث على الويب متعدد المحركات | [seia.docs.celestia.world](https://seia.docs.celestia.world) |
| [aoba](https://github.com/celestia-island/aoba) | واجهة سطرية متعددة البروتوكولات للتنقيح والمحاكاة (Modbus RTU وغيره) | [aoba.docs.celestia.world](https://aoba.docs.celestia.world) |
| [ichika](https://github.com/celestia-island/ichika) | خطوط أنابيب تجمّعات الخيوط فوق أنابيب الرسائل | المستودع |
| [yuuka](https://github.com/celestia-island/yuuka) | ماكروهات للبُنى المتداخلة المركّبة ودمج/ترقيع JSON | المستودع |
| [kou](https://github.com/celestia-island/kou) | محرك طرفية افتراضية: PTY، وVT100/ANSI، ورسوميات داخلية | المستودع |
| [hifumi](https://github.com/celestia-island/hifumi) | تسلسل لترحيل البيانات بين الإصدارات | المستودع |
| [lacrymira](https://github.com/celestia-island/lacrymira) | وصول مُنمَّط إلى البيانات لـ SQL وKV خلف سطح أوامر واحد | المستودع |
| [himari](https://github.com/celestia-island/himari) | تمثيل وسيط للصيغ ذات الأبعاد | المستودع |
| [kotama](https://github.com/celestia-island/kotama) | عدة أدوات الهندسة العكسية: التشريح، وفك الترجمة، والإحالات المتبادلة | المستودع |
| [ayane](https://github.com/celestia-island/ayane) | خدمة بريد: مستوى التحكم، والبريد على الويب، والحماية | المستودع |
| [aris](https://github.com/celestia-island/aris) | محرك متصفح مكتوب بـ Rust خالص مشتق من servo، قابل للتضمين كمكتبة | المستودع |
| [shirabe](https://github.com/celestia-island/shirabe) | أتمتة متصفح بلا واجهة وتنقيحها | المستودع |
| [tairitsu](https://github.com/celestia-island/tairitsu) | حزمة كاملة على نموذج مكوّنات WASM | المستودع |
| [akivili](https://github.com/celestia-island/akivili) | مضيف إضافات وحزمة تطوير لامتدادات الوكلاء | المستودع |
| [celestia-plugin](https://github.com/celestia-island/celestia-plugin) | حزمة تطوير إضافات ومحركات بـ Python | المستودع |
| [shun](https://github.com/celestia-island/shun) | المثبِّتات وأدوات الوميض وتسليم حمولات الوضع المحمول | المستودع |
| [ratatui-markdown](https://github.com/celestia-island/ratatui-markdown) | عرض Markdown داخل واجهات الطرفية | المستودع |
| arcaea | مكتبة بروتوكول الشخصيات | المستودع |
| scriptum | واجهة طرفية لمنصة الوكلاء | — |
| official-plugins | حزم الإضافات التابعة للجهة الأولى | المستودع |

## الطرفية والعتاد

| المشروع | الدور | التوثيق |
| --- | --- | --- |
| [kei](https://github.com/celestia-island/kei) | نواة Rust لبوابات الحوسبة الطرفية على ARM64 وRISC-V | المستودع |
| [hare](https://github.com/celestia-island/hare) | مكتبة جسر `no_std` للعقد الصناعية المدمجة | المستودع |
| evernight-appliance | توزيعة الجهاز: برنامج الإقلاع الثابت، وأداة الوميض، وعقد السائق | — |

## البنية التحتية والأدوات

| المشروع | الدور | التوثيق |
| --- | --- | --- |
| [celestia-devtools](https://github.com/celestia-island/celestia-devtools) | سلسلة التطوير المشتركة: وصفات البناء، والفحص، وبوابات الإصدار | المستودع |
| [cherino](https://github.com/celestia-island/cherino) | تجريد حاويات معزولة لتنفيذ الوكلاء | المستودع |
| [celestia-artifacts](https://github.com/celestia-island/celestia-artifacts) | استضافة عامة للملفات التنفيذية والصور للمشاريع | المستودع |
| celestia-integration | اختبارات تكامل عابرة للمستودعات تشمل الحلقة كلها | — |
| fuuka | مستوى تنفيذ التكامل المستمر المُستضاف ذاتيًا | — |
| [sysl](https://github.com/celestia-island/sysl) | رخصة المصدر التركيبي التي يستخدمها معظم هذا الكود | المستودع |

## الحضور على الويب

| الموقع | الدور | التوثيق |
| --- | --- | --- |
| [celestia-island.github.io](https://celestia-island.github.io) | حضور المنظمة | المستودع |
| [docs.celestia.world](https://docs.celestia.world) | هذا الموقع — الفلسفة، والخريطة، والبدء | المستودع |
| [e.celestia.world](https://e.celestia.world) | صفحة الهبوط العامة | المستودع |
| [dev.celestia.world](https://dev.celestia.world) | اللوحة ولوحة المطوّر (بالدعوة خلال النسخة التجريبية) | المستودع |
| [celestia.ac.cn](https://celestia.ac.cn) | موقع الشركة وخدمات المؤسسات | المستودع |

## لمزيد من التفاصيل

- [البنية الطبقية](../philosophy/layered-architecture.md) — لماذا توجد هذه الطبقات.
- [الحلقة المغلقة](../philosophy/closed-loop.md) — كيف تتعاون المشاريع على امتداد الحلقة.
- [المواقع والمسؤوليات](./sites.md) — من يوثّق ماذا، وأين.
