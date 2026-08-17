# التنزيلات

ما تثبّته يعتمد على موقعك في الحلقة المغلقة. خلال النسخة التجريبية الداخلية
يحتاج معظم المشاركين إلى تطبيق سطح المكتب فقط؛ وكل ما عداه يستضيفه مسؤولك
أو يكون اختياريًا.

## تطبيق سطح المكتب (shittim-chest)

يُنشر تطبيق سطح المكتب shittim-chest في
[GitHub Releases](https://github.com/celestia-island/shittim-chest/releases)
من كل وسم `v*`. المثبّتات **غير موقّعة** — فتوقّع تحذيرًا أمنيًا من نظام
التشغيل عند أول تشغيل. وتبقى الصفحة فارغة حتى يُدفع أول وسم تجريبي.

| المنصة | الحزمة |
| --- | --- |
| Linux | `.AppImage` أو `.deb` |
| Windows 10+ | `.exe` (NSIS) أو `.msi` |
| macOS | لم يُنشر بعد |

تغطي بنيات الإصدار Linux وWindows فقط؛ وmacOS ليس جزءًا من خط أنابيب
الإصدار. حتى صدور أول إصدار (أو إن فضّلت عدم التثبيت)، استخدم
[webUI](https://shittim-chest.docs.celestia.world) الخاص بـ shittim-chest.

## لوحة الإدارة (arona)

Arona مستضاف على الخادم — فلا شيء لتثبيته محليًا. افتح عنوان اللوحة الذي
يزوّدك به مسؤولك (`https://arona.celestia.world` في تثبيت عام، أو
`http://<host>:8420` داخليًا) وسجّل الدخول بدعوتك.

## بيئة تشغيل الوكلاء (entelecheia/scepter، اختياري)

للمستخدمين المتقدمين الذين يشغّلون الوكلاء بأنفسهم، يحدّد README الخاص بـ
entelecheia المثبّت الموحّد من مستودع plana
([Linux/macOS](https://github.com/celestia-island/plana/blob/master/scripts/install/celestia-install.sh)،
[Windows](https://github.com/celestia-island/plana/blob/master/scripts/install/celestia-install.ps1)):

```bash
git clone https://github.com/celestia-island/plana.git
# Also clone entelecheia, evernight, scriptum, shittim-chest alongside arona/
cd arona/scripts/install
bash celestia-install.sh --source-root ../../..
```

ما يعادله في Windows (WSL2): `.\celestia-install.ps1 -SourceRoot ..\..\..`

لبناء entelecheia نفسه من المصدر: يثبّت `just bootstrap` مساحة العمل، ثم
يطلق `just dev` واجهة TUI. المتطلبات المسبقة هي Rust 1.85+ وDocker
ومشغّل المهام `just`.

## لمزيد من التفاصيل

- [البدء السريع](./quickstart.md) — مسار الثلاثين دقيقة عبر الحلقة.
- [دليل النسخة التجريبية المغلقة](./beta-guide.md) — ما تغطيه النسخة التجريبية وكيف تُبلغ عن الأخطاء.
- [خريطة المشاريع](../ecosystem/projects.md) — القائمة الكاملة للمشاريع.
