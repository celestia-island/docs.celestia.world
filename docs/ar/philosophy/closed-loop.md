# الحلقة المغلقة

المنتج هو الحلقة، لا أي مشروع منفرد:

> اكتشف ← ثبّت ← وثّق الهوية ← انشر نموذجًا ← تحدث وشغّل الوكلاء ←
> تحكم في المعدات الصناعية ← تحقق وادعم

كل شريحة يملكها مجموعة محددة من المشاريع. إذا انكسرت شريحة، فلم تكتمل المنصة.

## شريحة بشريحة

| # | الشريحة | ما يحدث | المشاريع |
| --- | --- | --- | --- |
| 1 | **الاكتشاف** | يجد مستخدم محتمل المنظومة، ويفهم فلسفتها، ويختار نقطة دخول | [docs.celestia.world](https://docs.celestia.world) (هذا الموقع)، [celestia-island.github.io](https://celestia-island.github.io)، [e.celestia.world](https://e.celestia.world) |
| 2 | **التثبيت** | يحصل المستخدم على نظام يعمل: لوحة إدارة، صدفة سطح مكتب/ويب، خدمات مراقَبة | [arona](https://github.com/celestia-island/arona) (لوحة إدارة API السحابية)، [shittim-chest](https://github.com/celestia-island/shittim-chest) (محادثة سطح المكتب/الويب)، [malkuth](https://github.com/celestia-island/malkuth) (الإشراف على الخدمات) |
| 3 | **المصادقة** | هوية الثقة الصفرية: تسجيل (مقيد بالدعوات)، تسجيل دخول مع تقييد المعدل، مفاتيح API، RBAC | [kirino](https://github.com/celestia-island/kirino) (بدائيات المصادقة ومحرك RBAC) |
| 4 | **نشر نموذج** | اختر بيئة تشغيل نموذج، وانشرها على عقدة، واربطها بخلفية محادثة، وقِس الاستخدام | [arona](https://github.com/celestia-island/arona) (اللوحة والخلفيات)، [entelecheia](https://github.com/celestia-island/entelecheia) (بيئة تشغيل scepter)، [plana](https://github.com/celestia-island/plana) (القياس والتسعير) |
| 5 | **المحادثة والوكلاء** | تحدث إلى النماذج، وشغّل تعاونًا متعدد الوكلاء، واحفظ المحادثات، وأدر الذاكرة | [shittim-chest](https://github.com/celestia-island/shittim-chest) (الواجهة والمحادثة)، [entelecheia](https://github.com/celestia-island/entelecheia) (تنسيق الوكلاء)، [noa](https://github.com/celestia-island/noa) (تحكم بالإصدارات أصيل للذكاء الاصطناعي) |
| 6 | **التحكم الصناعي** | العمليات عن بعد ووساطة البروتوكولات: Modbus وS7comm وOPC UA؛ القياسات عن بعد وبوابات الكتابة | [evernight](https://github.com/celestia-island/evernight) (وسيط البروتوكولات)، [aoba](https://github.com/celestia-island/aoba) (واجهة Modbus ومصادر البيانات CLI) |
| 7 | **التحقق والدعم** | اختبارات تكامل على أجهزة حقيقية، إشراف وشفاء ذاتي، سجلات استخدام، قنوات ملاحظات | [celestia-integration](https://github.com/celestia-island/celestia-integration)، [malkuth](https://github.com/celestia-island/malkuth)، [plana](https://github.com/celestia-island/plana) (سجلات الاستخدام) |

## كيف تتصرف الحلقة

- **كل خطوة قابلة للاختبار.** لكل شريحة اختبار قبول محدد في
  [celestia-integration](https://github.com/celestia-island/celestia-integration)؛
  ولا يكون الإصدار أخضر حتى تمر الحلقة كلها على عقد حقيقية.
- **كل خطوة قابلة للمراقبة.** الإشراف، ونقاط نهاية الصحة، وسجلات الاستخدام
  تجعل حالة كل شريحة مرئية بدلًا من افتراضها.
- **لا تدهور صامت.** عندما تتدهور شريحة (مثلًا الذاكرة غير متصلة أو خلفية
  يتعذر الوصول إليها)، يقول استجابة API والواجهة ذلك صراحة. الأعطال صاخبة
  بالتصميم.
- **السلامة ليست شريحة.** بوابات الكتابة، والتحقق من السياسات، والتأكيد
  البشري منسوجة في الشريحتين 5 و6، لا ملصوقة في النهاية.
  راجع [مبادئ السلامة](./safety.md).

## لمزيد من التفاصيل

- [لماذا celestia-island](./why.md) — المشكلة التي تحدد الحلقة.
- [البنية الطبقية](./layered-architecture.md) — كيف تبقى القطع مرتبة.
- [خريطة المشاريع](../ecosystem/projects.md) — الجرد الكامل للمستودعات.
- [البدء السريع](../getting-started/quickstart.md) — سِر عبر الحلقة في 30 دقيقة.
