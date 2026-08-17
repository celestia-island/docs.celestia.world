# Web UI — الرحلة تبدأ من جملتك الأولى

سطحان وتدفق واحد: **arona** هو مستوى التحكم بلا واجهة (النماذج، والمفاتيح،
ودفتر الاستخدام، والذاكرة)؛ أما **shittim-chest** فهو منصة العمل التي تنظر
إليها فعلًا (المحادثة، واللوحات، ورؤية العالم). كل شاشة أدناه هي واجهة من
chest — يتخاطب chest مع arona عبر واجهة RPC الخاصة به؛ أما arona نفسه فلا
يقدّم أي واجهة استخدام.

![وحدة تحكم chest الخلفية](https://raw.githubusercontent.com/celestia-island/docs.celestia.world/master/res/screenshots/arona-dashboard.png)

## النماذج: من المصدر إلى الاستدعاء

ينتقل النموذج من «موجود» إلى «جاهز للمحادثة» في أربع مراحل: **المصدر**
(كتالوج المزوّدين — بيانات وصفية لا استدلال) ← **التسجيل** (خلفية `ollama`
أو `external` متوافقة مع OpenAI، تبقى محفوظة عبر إعادة التشغيل) ← **النشر**
(صفحة الوكلاء تسلّم معرّف النموذج إلى عقدة `arona-agent`؛ واسم نموذج فارغ
يختار تلقائيًا العقدة الأقل انشغالًا) ← **التوجيه** (صفحة النماذج؛ موازنة
حمل «الأقل قيد التنفيذ» مع ترابط الجلسة). تعمل الخلفيات الخارجية بمبدأ
الفشل المغلق إلى أن ينجح أول فحص. توجد واجهة API الدقيقة لكل خطوة في
[وثائق arona](https://arona.docs.celestia.world).

## الهوية والقياس

![مفاتيح API في chest](https://raw.githubusercontent.com/celestia-island/docs.celestia.world/master/res/screenshots/arona-apikeys.png)

![فوترة chest](https://raw.githubusercontent.com/celestia-island/docs.celestia.world/master/res/screenshots/arona-billing.png)

**مفاتيح API** هي هويتك — تُصادق البوابة طلبات `/v1/*` برموز Bearer،
وكل من `curl` وchest يقدّم واحدة عند الباب. **الاستخدام** دفتر قيد لكل
استدعاء ولكل مفتاح: الرموز، والنموذج، والخلفية، والتكلفة. تحدّد مستويات
**الفوترة** الحصص (دولار أمريكي / رموز / حدود معدل)؛ وبلوغ أحدها رفض
قاطع لا إبطاء.

## المحادثة والذاكرة

![محادثة chest](https://raw.githubusercontent.com/celestia-island/docs.celestia.world/master/res/screenshots/arona-playground.png)

يمرّ كل دور من المحادثة عبر خدمة الذاكرة — وتخبرك الشارة على كل دور
بحدوث ذلك من عدمه. `Memory on` تعني أنه أُدخلت ذكريات طويلة الأمد ذات
صلة قبل التوجيه؛ و`Memory offline` تعني أنه يتعذر الوصول إلى خدمة
الذاكرة (إشارة صدق لا خلل برمجي)؛ و`disabled` تعني أنه لم يُعثر على شيء
ذي صلة. تُستخرج الأدوار المكتملة في هيئة حلقات وتُحفظ، فتبقى الذاكرة قائمة
بعد إعادة التشغيل — ويمكن حذف مدخلات الكتابة الراجعة مباشرةً من صفحة الذاكرة.

## اللوحات والتحكم الصناعي

![وكلاء chest](https://raw.githubusercontent.com/celestia-island/docs.celestia.world/master/res/screenshots/arona-agents.png)

موجّه واحد ينشئ لوحة؛ يولّد المحرك التخطيط ويحفظه في تخزين مساحة عمل
scepter. والتحرير بنيوي — ارتباطات مصادر البيانات، وقوائم المكوّنات، وحالات
الاتصال — وليس صندوقًا أسود. الطوبولوجيا والهولوغرام منظوران للأسطول
نفسه؛ ويضيف قسم التقارير بحثًا دلاليًا في السجل. تمرّ عمليات الكتابة
الصناعية بالتحقق من السياسات و**الموافقة البشرية** قبل أن يتحرك أي شيء:
نهاية الحلقة المغلقة، وأثقل خطواتها.

![صفحة ولوج chest](https://raw.githubusercontent.com/celestia-island/docs.celestia.world/master/res/screenshots/arona-login.png)

## للاستزادة

- المرجع الكامل لمنصة arona — [وثائق arona](https://arona.docs.celestia.world)
- منصة العمل chest ولوحاتها — [وثائق shittim-chest](https://shittim-chest.docs.celestia.world)
- الوكلاء ومساحات العمل وبوابة الكتابة الصناعية — [وثائق entelecheia](https://entelecheia.docs.celestia.world)
