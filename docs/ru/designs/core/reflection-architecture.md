# Архитектура рефлексии: непрерывное самоусомнение в цепочке навыков

> **Статус**: спецификация проектирования. Реализация в процессе.
> Написано 2026-06-27.

## Проблема

Текущий конвейер цепочки навыков выполняется за **один прямой проход (single forward pass)**: навык формирует выходные данные, оркестратор проверяет структурную корректность (вызвал ли он `report()`? выполнил ли `cargo check`?), затем переходит к следующему навыку. Не существует фазы, на которой система задаёт вопросы:

1. *Было ли рассуждение на этом шаге обоснованным?* (семантическая рефлексия)
1. *С учётом произошедшего, стоит ли сменить направление?* (адаптивная рефлексия)
1. *Что нам стоит запомнить на будущее?* (седиментация уроков)

Существующие механизмы — verify-подсказки (verify nudges), откат после surgery, ежедневные аудиты YOLO — все они **реактивны и бинарны**: они обнаруживают технические сбои, а не ошибки рассуждения. Навык может выдать синтаксически корректный, компилируемый код, решающий не ту задачу, и ничего в текущем конвейере этого не поймёт — пока человек не проверит финальный результат.

## Принципы проектирования

1. **Рефлексия — это фаза конвейера, а не запоздалая надстройка (afterthought hook).** Ей отведён собственный слот между валидацией выхода и диспетчеризацией отчёта — с тем же структурным весом, что и у любой другой фазы.

1. **Три уровня, три стоимости.** Не каждый шаг заслуживает глубокого философского разбора. Система должна автоматически выбирать подходящую глубину рефлексии в зависимости от того, что только что произошло.

1. **OreXis — агент рефлексии.** Его существующий дизайн — вопрошающий Титан, тот, кто доводит неопределённость до оператора — идеально ложится на роль рефлексии. Новый агент не нужен.

1. **Уроки должны идти вперёд.** Рефлексия, не меняющая будущее поведение, — это просто дневник. Хранилище уроков должно возвращаться в подготовку контекста, чтобы следующая цепочка извлекала пользу из ошибок предыдущей.

1. **Самозапускаемая (self-triggered) рефлексия — первоклассный инструмент.** Любой агент должен иметь возможность запросить цикл рефлексии из своего IEPL-скрипта, а не только ждать, пока оркестратор его запланирует.

## Трёхуровневая система рефлексии

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

### Уровень 0: Эвристическая рефлексия (нулевая стоимость, всегда включена)

**Что**: проверки на основе правил по выходным данным навыка и трассировке выполнения.

**Когда**: для каждого навыка, без исключений.

**Как**: чистая логика на Rust, без вызова LLM. Расширенная версия существующей `validate_report_capture()` с дополнительными эвристиками:

- Санитарная проверка длины выхода (слишком короткий / подозрительно длинный)
- Аномалии в паттерне вызовов инструментов (вызывались инструменты вне ожидаемой для навыка области)
- Выбросы по времени выполнения (навык занял в 10 раз больше исторического среднего)
- Доля ошибок в вызовах инструментов (более 50% вызовов завершились неудачей)
- Обнаружение циклических ссылок в выходных данных

**Стоимость**: близка к нулю (микросекунды CPU).

**Вердикт**: может выдать `Accept` (принять) или `NeedsTier1` (передать на семантический уровень).

### Уровень 1: Семантическая рефлексия (1 вызов LLM, в точках принятия решений)

**Что**: оценка на основе LLM: «Достигают ли эти выходные данные заявленной цели навыка? Внутренне ли непротиворечива цепочка рассуждений?»

**Когда**: запускается при:

- передаче с уровня 0 (`NeedsTier1`)
- навыках, явно помеченных `requires_reflection` в своём определении
- навыках в точках принятия решений цепочки (после `task_decompose`, `plan_execute`, `workplan_generate`)
- первом появлении навыка в цепочке (триггер новизны)
- самозапуске любым агентом через инструмент `orexis::request_reflection`

**Как**: агент OreXis вызывается со специфичным для рефлексии промптом навыка. Промпт включает:

- Заявленную цель навыка
- Выходные данные навыка
- Сводку трассировки выполнения (сделанные вызовы инструментов, их результаты)
- Контекст цепочки (что было до, что будет после)

**Стоимость**: 1 вызов LLM (~500–2000 выходных токенов).

**Вердикт**: `Accept`, `Adjust` (с предложенной модификацией), `Backtrack` (вернуться к предыдущему навыку и повторить с другим подходом) или `NeedsTier2` (передать на глубокий разбор).

### Уровень 2: Глубокий разбор (философская ревизия OreXis, на границах цепочки)

**Что**: исследование всей цепочки под управлением OreXis: «Был ли общий подход верным? Какие предположения оказались ошибочными? Чему нам стоит научиться?»

**Когда**: запускается при:

- передаче с уровня 1 (`NeedsTier2`)
- завершении цепочки (успешном или нет) — выполняется как post-chain хук
- периодичности, заданной оператором (напр., каждые N цепочек)
- уровне YOLO Strategic

**Как**: агент OreXis с навыком `deep_critique`. Ревизует:

- Полную трассировку цепочки (все навыки, все выходы, все вызовы инструментов)
- Исходную цель против достигнутого результата
- Исторические уроки из хранилища уроков (для сопоставления шаблонов)

**Стоимость**: 1–2 вызова LLM (~1000–5000 выходных токенов).

**Вердикт**: формирует `DeepCritiqueReport`, содержащий:

- Анализ первопричин (если цепочка завершилась неудачей)
- Аудит предположений (какие были верны, какие — нет)
- Кандидаты в уроки (для записи в хранилище уроков)
- Оценку уверенности

## Модель данных

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

### Хранилище уроков

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

## Точки интеграции

### 1. Вставка в конвейер (pipeline.rs)

Между Фазой F (`post_execution_cleanup`) и Фазой G (`dispatch_report_and_check_termination`) вставляется:

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

### 2. Подготовка контекста (инъекция уроков)

В Фазе D (`build_prompts`), перед сборкой системного промпта, из хранилища уроков запрашиваются контекстно-релевантные уроки:

```rust
let relevant_lessons = lesson_store
    .find_similar(&s.current_skill_context, TOP_K_LESSONS)
    .await;

let lesson_section = format_lessons_for_prompt(&relevant_lessons);
// Inject into system prompt after skill description
```

### 3. Самозапускаемая рефлексия (инструмент IEPL)

`orexis::request_reflection` открывается в пространстве имён IEPL. Любой агент может вызвать его в своём TypeScript-коде:

```typescript
import { request_reflection } from 'orexis';

const review = await request_reflection({
  reason: "I'm about to execute a potentially destructive operation",
  context: { operation: "file_delete", path: "/etc/..." },
  urgency: "high",
});
```

Это синхронно запускает цикл рефлексии OreXis, блокируя вызывающий агент до завершения рефлексии.

### 4. Post-chain хук глубокого разбора

В пространстве имён `surgery_hooks` регистрируется новый хук конвейера:

```text
pipeline.reflection.post_chain  (priority 30, after PostSurgeryRollback)
```

Этот хук запускает глубокий разбор Уровня 2 после успешной цепочки, формируя уроки, полезные для будущих цепочек.

## Жизненный цикл урока

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

Уроки — это живые артефакты:

- **Усиливаются (Reinforced)**, когда их применение коррелирует с успешными исходами
- **Корректируются (Adjusted)**, когда текст урока требует уточнения с учётом новых свидетельств
- **Помечаются устаревшими (Deprecated)**, когда последовательно не помогают или становятся неактуальными

## Управление стоимостью

| Уровень | Стоимость в токенах | Частота | Дневной бюджет токенов |
| --- | --- | --- | --- |
| Heuristic | 0 | Каждый навык | 0 |
| Semantic | ~2K токенов | Точки принятия решений (~30% навыков) | ~20K токенов/цепочка |
| Deep | ~5K токенов | На цепочку + передачи | ~5K–10K токенов/цепочка |

Суммарные накладные расходы: примерно 10–15% дополнительного потребления токенов на цепочку — обмен токенов на качество. Настраивается через переменные окружения.

## Конфигурация

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

## Связь с существующими системами

| Существующая система | Связь |
| --- | --- |
| `validate_report_capture()` | Поглощается Уровнём 0 как одна из множества эвристик |
| Verify-подсказка (nudge) | Становится эвристикой Уровня 0, способной передать на Уровень 1 |
| `PostSurgeryRollback` | Остаётся как есть; рефлексия выполняется до него, не заменяя его |
| Ежедневные аудиты YOLO | Дополняются рефлексией; аудиты проверяют соответствие, рефлексия проверяет рассуждения |
| `RetroReview` | Поглощается глубоким разбором Уровня 2 для ревизии на уровне целей |
| Поля `quality_score` / `lesson` | Подключены к хранилищу уроков; наконец-то получают читателя |
| `context_preparation` | Расширена для инъекции релевантных уроков |
| `agent-consensus` | Консенсус валидирует факты; рефлексия валидирует рассуждения. Взаимодополняюще |
| `memory-and-self.md` | Хранилище уроков — операционная реализация «седиментации памяти для себя» |

## Именование

Внутренние компоненты системы рефлексии следуют существующей греческой философской конвенции именования:

- **OreXis** (ὄρεξις, «стремление/влечение») — уже является вопрошающим агентом.

Его желание — узнать, всё ли *верно*, а не просто *сделано*.

- **Lesson (Урок)** — согласуется с существующими именами полей `quality_score` / `lesson` в `TaskState`.

- **`ReflectionResult`** — функциональное имя, согласующееся с `ReportCaptureDecision` и другими типами конвейера.
