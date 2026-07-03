# اصطلاحات تسجيل CLI

## نظرة عامة

يتبع مخرجات سجل غلاف CLI في shittim-chest اصطلاحات متسقة مع entelecheia، باستخدام نظام `tracing` البيئي، مُخرجة إلى stderr بصيغة مدمجة قابلة للقراءة البشرية.

## اختيار الإطار

| المكوّن | الاختيار | السبب |
| --- | --- | --- |
| إطار التسجيل | `tracing` | معيار نظام Rust البيئي، متسق مع entelecheia |
| المشترك | طبقة fmt في `tracing-subscriber` | مخرجات مدمجة، لا حاجة لتحليل JSON |
| صيغة الوقت | `ShortTimer` (HH:MM:SS) | ملائم للطرفية، متسق مع CLI في entelecheia |
| هدف الإخراج | stderr | مفصول عن stdout، لا يتداخل مع الأنابيب |

## كود التهيئة

```rust
use chrono::Local;
use tracing_subscriber::fmt::time::FormatTime;

struct ShortTimer;

impl FormatTime for ShortTimer {
    fn format_time(&self, w: &mut tracing_subscriber::fmt::format::Writer<'_>) -> std::fmt::Result {
        let now = Local::now();
        write!(w, "{} ", now.format("%H:%M:%S"))
    }
}

// التهيئة
tracing_subscriber::fmt()
    .with_env_filter(EnvFilter::new(&args.log_level))
    .with_target(false)          // إخفاء مسارات الوحدات
    .with_timer(ShortTimer)      // صيغة HH:MM:SS
    .compact()                   // الوضع المدمج
    .with_writer(std::io::stderr) // الإخراج إلى stderr
    .init();
```

## مقارنة الصيغة

| الوضع | مثال الإخراج | حالة الاستخدام |
| --- | --- | --- |
| CLI (الحالي) | `14:23:05  INFO creating network shittim-chest...` | التطوير، العمليات |
| الخادم (مستقبلًا) | `{"timestamp":"...","level":"INFO","message":"..."}` | جمع سجلات الإنتاج |

## معامل --log-level

يقبل CLI معامل `--log-level` / `-l` (افتراضي `info`):

```text
shittim-chest --log-level debug dev
shittim-chest -l trace status
```

المستويات المدعومة: `trace`، `debug`، `info`، `warn`، `error`.

## اصطلاحات استخدام مستوى السجل

| المستوى | الغرض | سيناريوهات CLI النموذجية |
| --- | --- | --- |
| `info` | العمليات المهمة | إنشاء/بدء/إيقاف الحاوية، بدء/إكمال التهجير |
| `warn` | مشاكل محتملة | إعادة محاولات التهجير، الحاوية موجودة لكن في حالة غير طبيعية |
| `error` | الأخطاء | تعطل الحاوية، فشل التهجير، فشل إنشاء الشبكة |
| `debug` | معلومات تصحيح | (غير مستخدم حاليًا، محجوز للمستقبل) |
| `trace` | تدفق مفصل | (غير مستخدم حاليًا، محجوز للمستقبل) |

## مبادئ التصميم

1. **لا يبتلع CLI الأخطاء**: تنتشر جميع الأخطاء لأعلى عبر `anyhow::Result`؛ تطبع `main()` سلسلة الأخطاء تلقائيًا.
1. **لكل بداية عملية سجل**: `creating network...`، `running migrations...`، `building shittim_chest...` — يعرف المستخدم ما يفعله CLI.
1. **لكل إكمال عملية تأكيد**: `shittim-chest started on 0.0.0.0:80`، `all services started`.
1. **العمليات الناجحة بصمت لا تُسجَّل**: `ensure_network` لا يطبع إذا كانت الشبكة موجودة بالفعل، لتجنب الضجيج.
1. **تُجلب سجلات الحاوية عبر Docker API**: لا يكتب CLI نفسه سجلات أعمال، فقط سجلات عمليات التنسيق.

## المواءمة مع entelecheia

| الميزة | CLI في entelecheia | CLI في shittim-chest | متوافق |
| --- | --- | --- | --- |
| الإطار | `tracing` | `tracing` | ✅ |
| صيغة الوقت | `ShortTimer` (HH:MM:SS) | `ShortTimer` (HH:MM:SS) | ✅ |
| هدف الإخراج | stderr | stderr | ✅ |
| الوضع المدمج | `.compact()` | `.compact()` | ✅ |
| إخفاء الهدف | `.with_target(false)` | `.with_target(false)` | ✅ |
| --log-level | مدعوم | مدعوم | ✅ |

مخرجات سجل CLI في كلا المشروعين متطابقة بصريًا، مما يسهل على المطورين التبديل بين المشروعين.
