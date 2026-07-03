# 反思架构：技能链中的持续自我怀疑

> **状态**：设计规范。实现进行中。
> 写于 2026-06-27。

## 问题

当前的技能链流水线以**单次前向传递**执行：一个技能
产生输出，编排器检查结构正确性（它是否调用了
`report()`？是否运行了 `cargo check`？），然后推进到下一个技能。系统
没有任何阶段会提出这样的问题：

1. *这一步的推理是否合理？*（语义反思）
1. *基于刚发生的情况，我们是否应该改变方向？*（自适应反思）
1. *我们应该为下次记住什么？*（经验沉淀）

现有的机制——verify 提醒、术后回滚、YOLO 每日审计——
全部都是**反应式且二元的**：它们检测的是技术故障，而非推理
故障。一个技能可以产生语法正确、可编译的代码，却解决了
错误的问题，而当前流水线中没有任何东西能捕捉到这一点，直到
人类审查最终输出。

## 设计原则

1. **反思是一个流水线阶段，而不是事后补充的钩子。**它拥有自己的

槽位，位于输出验证与报告分发之间——与其他
每个阶段具有相同的结构权重。

1. **三个等级，三种成本。**并非每个步骤都值得深入的哲学

批判。系统必须基于刚刚发生的情况，自动选择
合适的反思深度。

1. **OreXis 是反思 agent。**其现有设计——那个不断追问的

泰坦、那个向操作者抛出不确定性的存在——完美契合
反思这一角色。无需新增 agent。

1. **经验必须向前流动。**不能改变未来行为的反思

只是一本日记。经验库必须回馈到上下文
准备阶段，使下一条链能从上一条链的错误中受益。

1. **自我触发的反思是一等公民工具。**任何 agent 都应能

在自己的 IEPL 脚本内部请求一次反思周期，而不仅仅是等待
编排器来调度。

## 三级反思系统

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

### Tier 0：启发式反思（零成本，始终开启）

**是什么**：对技能输出与执行轨迹进行基于规则的检查。

**何时**：每个技能，无例外。

**怎么做**：纯 Rust 逻辑，无 LLM 调用。在现有
`validate_report_capture()` 的基础上扩展，加入额外的启发式规则：

- 输出长度合理性（过短 / 可疑地过长）
- 工具调用模式异常（调用了技能预期领域之外的工具）
- 执行时间离群值（技能耗时是其历史平均值的 10 倍以上）
- 工具调用内部的错误率（超过 50% 的工具调用失败）
- 输出中的循环引用检测

**成本**：接近零（微秒级 CPU）。

**裁定**：可发出 `Accept`（通过）或 `NeedsTier1`（升级到语义层）。

### Tier 1：语义反思（1 次 LLM 调用，位于决策点）

**是什么**：基于 LLM 的评估：“这个输出是否达成了技能所声明的
目标？推理链是否内部自洽？”

**何时**：由以下情况触发：

- Tier 0 升级（`NeedsTier1`）
- 在技能定义中被显式标记为 `requires_reflection` 的技能
- 处于链决策点的技能（在 `task_decompose`、`plan_execute`、

`workplan_generate` 之后）

- 某技能在链中的首次出现（新颖性触发）
- 任意 agent 通过 `orexis::request_reflection` 工具自我触发

**怎么做**：调用 OreXis agent，注入一段反思专用的技能提示。该提示
包含：

- 技能声明的目标
- 技能的输出
- 执行轨迹摘要（做了哪些工具调用、各自的结果）
- 链上下文（之前是什么、之后是什么）

**成本**：1 次 LLM 调用（约 500-2000 输出 token）。

**裁定**：`Accept`、`Adjust`（附带建议的修改）、`Backtrack`
（回到上一个技能并以不同方式重试），或 `NeedsTier2`
（升级到深度批判）。

### Tier 2：深度批判（OreXis 哲学审查，位于链边界）

**是什么**：由 OreXis 驱动的对整条链的检视：“整体
方法是否正确？哪些假设是错的？我们应当学到什么？”

**何时**：由以下情况触发：

- Tier 1 升级（`NeedsTier2`）
- 链完成（无论成功还是失败）——作为链后钩子运行
- 操作者配置的周期性（例如每 N 条链一次）
- YOLO Strategic 等级

**怎么做**：调用带 `deep_critique` 技能的 OreXis agent。审查：

- 完整的链轨迹（所有技能、所有输出、所有工具调用）
- 原始目标 vs. 实际达成的结果
- 来自经验库的历史经验（用于模式匹配）

**成本**：1-2 次 LLM 调用（约 1000-5000 输出 token）。

**裁定**：生成一份 `DeepCritiqueReport`，包含：

- 根因分析（若链失败）
- 假设审计（哪些假设成立、哪些不成立）
- 候选经验（将被写入经验库）
- 置信度评估

## 数据模型

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

### 经验库（Lesson Store）

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

## 集成点

### 1. 流水线插入（pipeline.rs）

在 Phase F（`post_execution_cleanup`）与 Phase G
（`dispatch_report_and_check_termination`）之间，插入：

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

### 2. 上下文准备（经验注入）

在 Phase D（`build_prompts`）中，组装系统提示之前，向经验库
查询与上下文相关的经验：

```rust
let relevant_lessons = lesson_store
    .find_similar(&s.current_skill_context, TOP_K_LESSONS)
    .await;

let lesson_section = format_lessons_for_prompt(&relevant_lessons);
// Inject into system prompt after skill description
```

### 3. 自我触发的反思（IEPL 工具）

将 `orexis::request_reflection` 暴露到 IEPL 命名空间。任何 agent 都可以
在其 TypeScript 代码中调用它：

```typescript
import { request_reflection } from 'orexis';

const review = await request_reflection({
  reason: "I'm about to execute a potentially destructive operation",
  context: { operation: "file_delete", path: "/etc/..." },
  urgency: "high",
});
```

这会同步地启动一次 OreXis 反思周期，阻塞调用方
agent 直到反思完成。

### 4. 链后深度批判钩子

在 `surgery_hooks` 命名空间中注册一个新的流水线钩子：

```text
pipeline.reflection.post_chain  (priority 30, after PostSurgeryRollback)
```

该钩子在链成功完成后运行 Tier 2 深度批判，产生
能够惠及未来链的经验。

## 经验生命周期

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

经验是动态演进的产物：

- 当应用某经验与成功结果相关联时，被**强化**
- 当经验文本需要根据新证据精炼时，被**调整**
- 当某经验持续无法提供帮助或变得不再相关时，被**废弃**

## 成本管理

| 等级 | Token 成本 | 频率 | 每日 Token 预算 |
| --- | --- | --- | --- |
| Heuristic | 0 | 每个技能 | 0 |
| Semantic | 约 2K token | 决策点（约 30% 的技能） | 每条链约 20K token |
| Deep | 约 5K token | 每条链 + 升级时 | 每条链约 5K-10K token |

总开销：每条链增加约 10-15% 的额外 token 消耗，
以 token 换取质量。可通过环境变量配置。

## 配置

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

## 与现有系统的关系

| 现有系统 | 关系 |
| --- | --- |
| `validate_report_capture()` | 被 Tier 0 吸收，成为众多启发式规则之一 |
| Verify 提醒 | 成为一条可升级到 Tier 1 的 Tier 0 启发式规则 |
| `PostSurgeryRollback` | 保持原样；反思在它之前运行，而非取代它 |
| YOLO 每日审计 | 与反思互补；审计检查合规性，反思检查推理 |
| `RetroReview` | 被 Tier 2 深度批判吸收，用于目标层面的审查 |
| `quality_score` / `lesson` 字段 | 与经验库相连；终于有了读取方 |
| `context_preparation` | 扩展以注入相关经验 |
| `agent-consensus` | 共识验证事实，反思验证推理。二者互补 |
| `memory-and-self.md` | 经验库是“为自我而进行的记忆沉淀”的运营化实现 |

## 命名

反思系统的内部组件遵循现有的希腊
哲学命名约定：

- **OreXis**（ὄρεξις，“欲望/渴求”）——即那个不断追问的 agent。

它的渴望是知道事物是否*正确*，而不仅仅是*已完成*。

- **Lesson**（经验）——与 `TaskState` 中现有的

`quality_score` / `lesson` 字段命名保持一致。

- **`ReflectionResult`**——功能性命名，与 `ReportCaptureDecision`

及其他流水线类型相匹配。
