# هندسة التأمل: الشك الذاتي المستمر في سلسلة المهارات

> **الحالة**: مواصفة تصميم. التنفيذ قيد التقدم.
> كُتب في 2026-06-27.

## المشكلة

ينفذ خط أنابيب سلسلة المهارات الحالي في **تمريرة أمامية واحدة**: تنتج المهارة
مخرجًا، يفحص المنسق الصحة البنيوية (هل استدعت `report()`؟ هل شغّلت `cargo check`؟)،
ثم تنتقل إلى المهارة التالية. لا توجد مرحلة يسأل فيها النظام:

1. *هل كان استدلال هذه الخطوة سليمًا؟* (التأمل الدلالي)
1. *بالنظر لما حدث للتو، هل يجب أن نغيّر الاتجاه؟* (التأمل التكيّفي)
1. *ما الذي يجب أن نتذكره للمرة القادمة؟* (ترسيب الدروس)

الآليات الموجودة — تنبيهات التحقق، التراجع بعد الجراحة، تدقيقات YOLO اليومية —
جميعها **تفاعلية وثنائية**: تكتشف الإخفاقات التقنية وليس إخفاقات الاستدلال. يمكن
لمهارة أن تنتج كودًا صحيحًا نحويًا، يُجمَّع، يحل المشكلة الخاطئة، ولا شيء في خط
الأنابيب الحالي سيلتقط ذلك حتى يراجع إنسان المخرج النهائي.

## مبادئ التصميم

1. **التأمل مرحلة في خط الأنابيب وليس ربطًا لاحقًا.** يحصل على فترته

الخاصة بين التحقق من المخرج وإرسال التقرير — نفس

الوزن البنيوي ككل مرحلة أخرى.

1. **ثلاث طبقات، ثلاث تكاليف.** ليست كل خطوة تستحق نقدًا

فلسفيًا عميقًا. يجب على النظام اختيار عمق التأمل

المناسب تلقائيًا بناءً على ما حدث للتو.

1. **OreXis هو وكيل التأمل.** تصميمه الموجود — عملاق

التساؤل، الذي يدفع عدم اليقين إلى المشغّل — يطابق تمامًا

دور التأمل. لا حاجة لوكيل جديد.

1. **يجب أن تتدفق الدروس للأمام.** التأمل الذي لا يغيّر السلوك

المستقبلي هو مجرد مذكرات. يجب أن تغذي خزان الدروس

العودة إلى تحضير السياق بحيث تستفيد السلسلة التالية

من أخطاء السلسلة الأخيرة.

1. **التأمل ذاتي التفعيل أداة من الدرجة الأولى.** يجب أن يتمكن أي وكيل من

طلب دورة تأمل من داخل نص IEPL الخاص به، وليس فقط انتظار

المنسق لجدولة واحدة.

## نظام التأمل ثلاثي الطبقات

```text
┌──────────────────────────────────────────────────────────────────┐
│                    SKILL CHAIN PIPELINE                          │
│                                                                  │
│  ┌──────┐   ┌──────┐   ┌──────┐   ┌──────┐   ┌──────────────┐  │
│  │ A:   │   │ D:   │   │ E:   │   │ F:   │   │ REFLECTION   │  │
│  │Guard │──▶│Build │──▶│Invoke│──▶│Valid │──▶│ (NEW)        │  │
│  │Check │   │Prompt│   │Skill │   │Report│   │              │  │
│  └──────┘   └──────┘   └──────┘   └──────┘   └────┬───────┘  │
│                                                  │            │
│                                    ┌─────────────┼─────────┐ │
│                                    ▼             ▼         ▼ │
│                              ┌──────────┐ ┌─────────┐ ┌──────┐│
│                              │Tier 0:   │ │Tier 1:  │ │Tier 2││
│                              │Heuristic │ │Semantic │ │Deep  ││
│                              │(free)    │ │(1 LLM)  │ │(OreXis││
│                              └──────────┘ └─────────┘ │critiq││
│                                    │         │       │ue)   ││
│                                    ▼         ▼       └──┬───┘│
│                              ┌──────────────────────────────┐│
│                              │  ReflectionVerdict           ││
│                              │  Accept / Adjust / Backtrack ││
│                              │  / Abort                     ││
│                              └──────────────┬───────────────┘│
│                                             ▼                 │
│  ┌──────┐   ┌──────┐                   ┌──────────┐          │
│  │ G:   │   │ H:   │ ◀──────────────── │ Lesson   │          │
│  │Disp  │   │Stack │                   │ Store    │          │
│  │Report│   │Resolv│                   │ (write)  │          │
│  └──────┘   └──────┘                   └──────────┘          │
└──────────────────────────────────────────────────────────────────┘
```

### الطبقة 0: التأمل الاستدلالي (صفر تكلفة، يعمل دائمًا)

**ماذا**: فحوصات قائمة على القواعد على مخرج المهارة وأثر التنفيذ.

**متى**: كل مهارة، بلا استثناءات.

**كيف**: منطق Rust نقي، لا استدعاء LLM. نسخة موسعة من `validate_report_capture()`
الموجودة مع استدلالات إضافية:

- سلامة طول المخرج (قصير جدًا / طويل بشكل مريب)
- شذوذ نمط استدعاء الأدوات (استدعى أدوات خارج نطاق المهارة المتوقع)
- القيم المتطرفة لوقت التنفيذ (استغرقت المهارة 10 أضعاف متوسطها التاريخي)
- معدل الخطأ ضمن استدعاءات الأدوات (أكثر من 50% من استدعاءات الأدوات فشلت)
- كشف المراجع الدائرية في المخرج

**التكلفة**: قريبة من الصفر (ميكروثوانٍ من CPU).

**الحكم**: يمكن أن يصدر `Accept` (نجاح) أو `NeedsTier1` (تصعيد دلالي).

### الطبقة 1: التأمل الدلالي (1 استدعاء LLM، عند نقاط القرار)

**ماذا**: تقييم قائم على LLM: "هل يحقق هذا المخرج الهدف المصرّح به للمهارة؟ هل سلسلة
الاستدلال متسقة داخليًا؟"

**متى**: يُحرَّض بواسطة:

- تصعيد الطبقة 0 (`NeedsTier1`)
- مهارات موسومة صراحةً كـ `requires_reflection` في تعريف المهارة
- مهارات عند نقاط قرار السلسلة (بعد `task_decompose`، `plan_execute`،

`workplan_generate`)

- أول ظهور لمهارة في سلسلة (محفّز الجِدّة)
- تفعيل ذاتي من أي وكيل عبر أداة `orexis::request_reflection`

**كيف**: وكيل OreXis مستدعى بتوجيه مهارة خاص بالتأمل. يتضمن التوجيه:

- الهدف المصرّح به للمهارة
- مخرج المهارة
- ملخص أثر التنفيذ (استدعاءات الأدوات المُجراة، نتائجها)
- سياق السلسلة (ما سبق، ما يأتي بعد)

**التكلفة**: 1 استدعاء LLM (~500-2000 رمز مخرج).

**الحكم**: `Accept`، `Adjust` (مع تعديل مقترح)، `Backtrack`
(العودة للمهارة السابقة وإعادة المحاولة بمنهج مختلف)، أو `NeedsTier2`
(تصعيد للنقد العميق).

### الطبقة 2: النقد العميق (مراجعة OreXis الفلسفية، عند حدود السلسلة)

**ماذا**: فحص بقيادة OreXis للسلسلة كاملة: "هل كان المنهج الكلي
صحيحًا؟ أي الافتراضات كانت خاطئة؟ ما الذي يجب أن نتعلمه؟"

**متى**: يُحرَّض بواسطة:

- تصعيد الطبقة 1 (`NeedsTier2`)
- إكمال السلسلة (نجاح أو فشل) — يعمل كربط بعد السلسلة
- دورية مُكوَّنة من قبل المشغّل (مثل كل N سلسلة)
- طبقة YOLO الاستراتيجية

**كيف**: وكيل OreXis مع مهارة `deep_critique`. يراجع:

- أثر السلسلة الكامل (كل المهارات، كل المخرجات، كل استدعاءات الأدوات)
- الهدف الأصلي مقابل النتيجة المُنجزة
- الدروس التاريخية من خزان الدروس (لمطابقة الأنماط)

**التكلفة**: 1-2 استدعاء LLM (~1000-5000 رمز مخرج).

**الحكم**: ينتج `DeepCritiqueReport` يحتوي:

- تحليل السبب الجذري (إذا فشلت السلسلة)
- تدقيق الافتراضات (أي الافتراضات كانت صحيحة، أيها لم تكن)
- مرشحون للدروس (لُتكتب في خزان الدروس)
- تقييم الثقة

## نموذج البيانات

### ReflectionResult

```rust
pub struct ReflectionResult {
    pub tier: ReflectionTier,
    pub verdict: ReflectionVerdict,
    pub confidence: f32,
    pub reasoning: String,
    pub lessons: Vec<LessonCandidate>,
    pub suggested_adjustment: Option<String>,
    pub created_at: DateTime<Utc>,
}

pub enum ReflectionTier {
    Heuristic,
    Semantic,
    Deep,
}

pub enum ReflectionVerdict {
    Accept,
    Adjust { modification: String },
    Backtrack { to_skill: String, reason: String },
    Abort { reason: String },
}
```

### خزان الدروس

```rust
pub struct Lesson {
    pub id: Uuid,
    pub context_signature: String,      // semantic hash of the situation
    pub context_embedding: Vec<f32>,    // for similarity matching (pgvector)
    pub lesson_text: String,
    pub severity: LessonSeverity,
    pub source_chain_id: Uuid,
    pub source_skill: String,
    pub created_at: DateTime<Utc>,
    pub times_applied: u32,
    pub effectiveness_score: f32,       // updated when lesson is applied
    pub deprecated: bool,
}

pub enum LessonSeverity {
    Info,
    Warning,
    Critical,
}
```

### ReflectionTrigger

```rust
pub enum ReflectionTrigger {
    Always,                              // Tier 0 for every skill
    SkillFlagged(String),                // skill has requires_reflection
    DecisionPoint,                       // task_decompose, plan_execute, etc.
    NovelSkill,                          // first occurrence in chain
    Escalation(ReflectionTier),          // lower tier escalated
    SelfRequested { by_agent: String },  // orexis::request_reflection
    PostChain,                           // after chain completes
    Periodic { interval_secs: u64 },     // YOLO-style periodic
}
```

## نقاط التكامل

### 1. إدراج خط الأنابيب (pipeline.rs)

بين المرحلة F (`post_execution_cleanup`) و المرحلة G
(`dispatch_report_and_check_termination`)، أدرج:

```rust
// NEW: Reflection phase
let reflection_result = Self::reflect_on_output(
    st, &s, &setup, &invoke_result, &cleanup,
).await;

match reflection_result.verdict {
    ReflectionVerdict::Accept => { /* proceed to Phase G */ },
    ReflectionVerdict::Adjust { modification } => {
        // Inject modification into next skill's context
        s.pending_adjustment = Some(modification);
    },
    ReflectionVerdict::Backtrack { to_skill, reason } => {
        // Roll back chain state to the specified skill
        s.current_skill = to_skill;
        s.executed_skills.remove(&to_skill);
        // Continue loop from the earlier skill
    },
    ReflectionVerdict::Abort { reason } => {
        break 'chain false;
    },
}
```

### 2. تحضير السياق (حقن الدروس)

في المرحلة D (`build_prompts`)، قبل تجميع توجيه النظام، استعلم خزان
الدروس عن دروس ذات صلة سياقيًا:

```rust
let relevant_lessons = lesson_store
    .find_similar(&s.current_skill_context, TOP_K_LESSONS)
    .await;

let lesson_section = format_lessons_for_prompt(&relevant_lessons);
// Inject into system prompt after skill description
```

### 3. التأمل ذاتي التفعيل (أداة IEPL)

اعرض `orexis::request_reflection` على نطاق أسماء IEPL. يمكن لأي وكيل استدعاء
هذا ضمن كود TypeScript الخاص به:

```typescript
import { request_reflection } from 'orexis';

const review = await request_reflection({
  reason: "I'm about to execute a potentially destructive operation",
  context: { operation: "file_delete", path: "/etc/..." },
  urgency: "high",
});
```

يُطلق هذا دورة تأمل OreXis بشكل متزامن، محجوبًا الوكيل
المستدعي حتى يكتمل التأمل.

### 4. ربط النقد العميق بعد السلسلة

سجّل ربط خط أنابيب جديد في نطاق أسماء `surgery_hooks`:

```text
pipeline.reflection.post_chain  (priority 30, after PostSurgeryRollback)
```

يشغل هذا الربط نقد الطبقة 2 العميق بعد سلسلة ناجحة، مُنتجًا
دروسًا تفيد السلاسل المستقبلية.

## دورة حياة الدرس

```text
┌─────────────┐     ┌──────────────┐     ┌───────────────┐
│  Created    │────▶│  Applied     │────▶│  Evaluated    │
│  (Tier 2)   │     │  (injected   │     │  (did it help?│
│             │     │   into next  │     │   track score)│
│             │     │   chain)     │     │               │
└─────────────┘     └──────────────┘     └───────┬───────┘
                                                 │
                                    ┌────────────┼────────────┐
                                    ▼            ▼            ▼
                              ┌──────────┐ ┌──────────┐ ┌──────────┐
                              │Reinforced│ │Adjusted  │ │Deprecated│
                              │(score ↑) │ │(text     │ │(score ↓, │
                              │          │ │ updated) │ │ removed) │
                              └──────────┘ └──────────┘ └──────────┘
```

الدروس قطع أثرية حية:

- **مُعزَّزة** عندما يرتبط تطبيقها بنتائج ناجحة
- **مُعدَّلة** عندما يحتاج نص الدرس للتحسين بناءً على أدلة جديدة
- **مُهمَلة** عندما تفشل باستمرار في المساعدة أو تصبح غير ذات صلة

## إدارة التكلفة

| الطبقة | تكلفة الرموز | التكرار | ميزانية الرموز اليومية |
| --- | --- | --- | --- |
| استدلالي | 0 | كل مهارة | 0 |
| دلالي | ~2K رمز | نقاط القرار (~30% من المهارات) | ~20K رمز/سلسلة |
| عميق | ~5K رمز | لكل سلسلة + تصعيدات | ~5K-10K رمز/سلسلة |

إجمالي العبء: حوالي 10-15% استهلاك رموز إضافي لكل سلسلة،
مقايضة الرموز بالجودة. قابل للتهيئة عبر متغيرات البيئة.

## التكوين

```env
# Reflection system configuration
REFLECTION_ENABLED=true
REFLECTION_TIER0_ENABLED=true                    # always-on heuristics
REFLECTION_TIER1_ENABLED=true                    # semantic reflection
REFLECTION_TIER2_ENABLED=true                    # deep critique
REFLECTION_TIER1_SKILL_THRESHOLD=0.3             # % of skills that get Tier 1
REFLECTION_POST_CHAIN_ENABLED=true               # deep critique after chain
REFLECTION_LESSON_TOP_K=5                        # max lessons injected per skill
REFLECTION_LESSON_MIN_EFFECTIVENESS=0.3          # don't inject useless lessons
REFLECTION_BACKTRACK_MAX=2                       # max backtracks per chain
```

## العلاقة بالأنظمة الموجودة

| النظام الموجود | العلاقة |
| --- | --- |
| `validate_report_capture()` | مُستوعَب في الطبقة 0 كاستدلال واحد بين عدة |
| تنبيه التحقق | يصبح استدلال طبقة 0 يمكنه التصعيد إلى الطبقة 1 |
| `PostSurgeryRollback` | يبقى كما هو؛ التأمل يعمل قبله، لا يستبدله |
| تدقيقات YOLO اليومية | مكمّل بالتأمل؛ التدقيقات تفحص الامتثال، التأمل يفحص الاستدلال |
| `RetroReview` | مُستوعَب في نقد الطبقة 2 العميق للمراجعة على مستوى الهدف |
| حقول `quality_score` / `lesson` | مربوطة بخزان الدروس؛ أخيرًا لديها قارئ |
| `context_preparation` | ممدود لحقن الدروس ذات الصلة |
| `agent-consensus` | الإجماع يتحقق من الحقائق؛ التأمل يتحقق من الاستدلال. مكمّل |
| `memory-and-self.md` | خزان الدروس هو التنفيذ التشغيلي لـ "ترسيب الذاكرة للذات" |

## التسمية

تتبع المكونات الداخلية لنظام التأمل اصطلاح التسمية الفلسفي اليوناني
الموجود:

- **OreXis** (ὄρεξις، "الرغبة/الشوق") — بالفعل وكيل التساؤل.

رغبته في معرفة ما إذا كانت الأمور *صحيحة*، وليست فقط *منجزة*.

- **Lesson** — متسق مع أسماء حقول `quality_score` / `lesson`

الموجودة في `TaskState`.

- **`ReflectionResult`** — تسمية وظيفية، مطابقة لـ `ReportCaptureDecision`

وأنواع خط الأنابيب الأخرى.
