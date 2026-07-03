# リフレクションアーキテクチャ：スキルチェーンにおける継続的な自己疑念

> **状態**：設計仕様。実装進行中。
> 2026-06-27 執筆。

## 問題

現在のスキルチェーンパイプラインは**単一のフォワードパス**で実行される：スキルが出力を生成し、オーケストレータが構造的正しさを確認し（`report()` を呼んだか？ `cargo check` を実行したか？）、次のスキルへ進む。システムが次のように問うフェーズは存在しない：

1. *このステップの推論は妥当だったか？*（意味的リフレクション）
1. *今起きたことを踏まえ、方向転換すべきか？*（適応的リフレクション）
1. *次回のために何を記憶すべきか？*（教訓の堆積）

既存の仕組み —— verify ナッジ、手術後ロールバック、YOLO 日次監査 —— はすべて**反応的かつ二値**である：推論の失敗ではなく技術的失敗を検出する。スキルは構文的に正しくコンパイルの通るコードを生成しつつ、間違った問題を解いてしまうことがあり、現在のパイプラインでは人間が最終出力をレビューするまで誰もそれを捕捉できない。

## 設計原則

1. **リフレクションはパイプラインのフェーズであり、事後的なフックではない。** 出力の検証とレポート送出のあいだに独自のスロットを持ち、他のすべてのフェーズと同等の構造的ウェイトを与えられる。

1. **3 段階、3 つのコスト。** すべてのステップが深い哲学的批判に値するわけではない。システムは、今起きたことに基づいて適切なリフレクション深度を自動的に選択しなければならない。

1. **OreXis がリフレクションエージェントである。** その既存の設計 —— 問いを立てるタイタン、不確実性をオペレータに突きつける存在 —— はリフレクションの役割に完全に合致する。新しいエージェントは不要である。

1. **教訓は前方へ流れなければならない。** 未来の振る舞いを変えないリフレクションは単なる日記である。教訓ストアはコンテキスト準備へフィードバックされなければならず、それにより次のチェーンが直前のチェーンの失敗から恩恵を受ける。

1. **自己トリガのリフレクションは一級のツールである。** どのエージェントも、オーケストレータのスケジュールを待つだけでなく、自身の IEPL スクリプト内からリフレクションサイクルを要求できなければならない。

## 3 段階リフレクションシステム

```text
┌──────────────────────────────────────────────────────────────────┐
│                    SKILL CHAIN PIPELINE                          │
│                                                                  │
│  ┌──────┐   ┌──────┐   ┌──────┐   ┌──────┐   ┌──────────────┐  │
│  │ A:   │   │ D:   │   │ E:   │   │ F:   │   │ REFLECTION   │  │
│  │Guard │──▶│Build │──▶│Invoke│──▶│Valid │──▶│ (NEW)        │  │
│  │Check │   │Prompt│   │Skill │   │Report│   │              │  │
│  └──────┘   └──────┘   └──────┘   └──────┘   └──────┬───────┘  │
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

### Tier 0：ヒューリスティックリフレクション（ゼロコスト、常時有効）

**内容**：スキル出力と実行トレースに対するルールベースの検査。

**タイミング**：すべてのスキル、例外なし。

**方法**：純粋な Rust ロジックで、LLM 呼び出しなし。既存の `validate_report_capture()` を拡張し、以下のヒューリスティックを追加する：

- 出力長の健全性（短すぎる／疑わしいほど長い）
- ツール呼び出しパターンの異常（スキルの想定ドメイン外のツールを呼んだ）
- 実行時間の外れ値（スキルが過去の平均の 10 倍かかった）
- ツール呼び出し内のエラー率（50% 超のツール呼び出しが失敗）
- 出力内の循環参照検出

**コスト**：ほぼゼロ（CPU マイクロ秒単位）。

**評定**：`Accept`（合格）または `NeedsTier1`（意味的分析へエスカレート）を出力できる。

### Tier 1：意味的リフレクション（LLM 1 回呼び出し、判断ポイントで）

**内容**：LLM ベースの評価 ——「この出力はスキルの宣言された目標を達成しているか？ 推論チェーンは内部的に一貫しているか？」

**タイミング**：以下でトリガされる：

- Tier 0 のエスカレーション（`NeedsTier1`）
- スキル定義で `requires_reflection` と明示されたスキル
- チェーンの判断ポイントにあるスキル（`task_decompose`、`plan_execute`、`workplan_generate` の後）
- チェーン内でそのスキルが初出（新規性トリガ）
- 任意のエージェントによる `orexis::request_reflection` ツール経由の自己トリガ

**方法**：リフレクション専用のスキルプロンプトで OreXis エージェントを起動する。プロンプトには以下を含む：

- スキルの宣言された目標
- スキルの出力
- 実行トレースの要約（行われたツール呼び出しとその結果）
- チェーンのコンテキスト（前に何があったか、後に何が続くか）

**コスト**：LLM 1 回呼び出し（出力 ~500〜2000 トークン）。

**評定**：`Accept`、`Adjust`（修正案を伴う）、`Backtrack`（前のスキルに戻り別のアプローチで再試行）、または `NeedsTier2`（深い批判へエスカレート）。

### Tier 2：ディープクリティーク（OreXis による哲学的レビュー、チェーン境界で）

**内容**：OreXis によるチェーン全体の検証 ——「全体としてのアプローチは正しかったか？ どの前提が間違っていたか？ 何を学ぶべきか？」

**タイミング**：以下でトリガされる：

- Tier 1 のエスカレーション（`NeedsTier2`）
- チェーン完了（成功・失敗を問わず）—— ポストチェーンハックとして実行
- オペレータ設定の周期（例：N チェーンごと）
- YOLO Strategic 段階

**方法**：`deep_critique` スキルを持つ OreXis エージェント。以下をレビューする：

- 完全なチェーントレース（全スキル、全出力、全ツール呼び出し）
- 当初の目標と達成された結果の対比
- 教訓ストアからの過去の教訓（パターンマッチング用）

**コスト**：LLM 1〜2 回呼び出し（出力 ~1000〜5000 トークン）。

**評定**：以下を含む `DeepCritiqueReport` を生成する：

- 根因分析（チェーンが失敗した場合）
- 前提の監査（どの前提が有効で、どれが無効だったか）
- 教訓候補（教訓ストアに書き込まれる）
- 信頼度評価

## データモデル

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

### Lesson Store

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

## 統合ポイント

### 1. パイプラインへの挿入（pipeline.rs）

Phase F（`post_execution_cleanup`）と Phase G（`dispatch_report_and_check_termination`）のあいだに、以下を挿入する：

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

### 2. コンテキスト準備（教訓の注入）

Phase D（`build_prompts`）で、システムプロンプトを組み立てる前に、コンテキストに関連する教訓を教訓ストアに問い合わせる：

```rust
let relevant_lessons = lesson_store
    .find_similar(&s.current_skill_context, TOP_K_LESSONS)
    .await;

let lesson_section = format_lessons_for_prompt(&relevant_lessons);
// Inject into system prompt after skill description
```

### 3. 自己トリガのリフレクション（IEPL ツール）

`orexis::request_reflection` を IEPL 名前空間に公開する。任意のエージェントは自身の TypeScript コード内でこれを呼び出せる：

```typescript
import { request_reflection } from 'orexis';

const review = await request_reflection({
  reason: "I'm about to execute a potentially destructive operation",
  context: { operation: "file_delete", path: "/etc/..." },
  urgency: "high",
});
```

これは OreXis のリフレクションサイクルを同期的に起動し、リフレクションが完了するまで呼び出し元エージェントをブロックする。

### 4. ポストチェーン・ディープクリティークフック

`surgery_hooks` 名前空間に新しいパイプラインフックを登録する：

```text
pipeline.reflection.post_chain  (priority 30, after PostSurgeryRollback)
```

このフックはチェーン成功後に Tier 2 のディープクリティークを実行し、将来のチェーンに役立つ教訓を生成する。

## 教訓のライフサイクル

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

教訓は生きた成果物である：

- **強化**：適用が成功した結果と相関するとき
- **調整**：新たな証拠に基づき教訓の文章を洗練させる必要があるとき
- **廃止**：一貫して役に立たない、あるいは無関係になったとき

## コスト管理

| Tier | トークンコスト | 頻度 | 1 日のトークン予算 |
| --- | --- | --- | --- |
| Heuristic | 0 | 全スキル | 0 |
| Semantic | ~2K トークン | 判断ポイント（スキルの ~30%） | ~20K トークン／チェーン |
| Deep | ~5K トークン | チェーンごと + エスカレーション | ~5K〜10K トークン／チェーン |

総オーバーヘッド：チェーンあたり約 10〜15% の追加トークン消費で、トークンを品質と引き換える。環境変数で設定可能。

## 設定

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

## 既存システムとの関係

| 既存システム | 関係 |
| --- | --- |
| `validate_report_capture()` | Tier 0 に多数のヒューリスティックの一つとして吸収される |
| Verify ナッジ | Tier 1 へエスカレート可能な Tier 0 ヒューリスティックとなる |
| `PostSurgeryRollback` | そのまま維持。リフレクションはその前に実行され、置き換えない |
| YOLO 日次監査 | リフレクションが補完する。監査はコンプライアンスを、リフレクションは推論を検査する |
| `RetroReview` | 目標レベルのレビューについて Tier 2 ディープクリティークに吸収される |
| `quality_score` / `lesson` フィールド | 教訓ストアに接続され、ついに読み手を持つ |
| `context_preparation` | 関連する教訓を注入するよう拡張される |
| `agent-consensus` | 合意は事実を、リフレクションは推論を検証する。相補的である |
| `memory-and-self.md` | 教訓ストアは「自己のための記憶の堆積」の運用上の実装である |

## 命名

リフレクションシステムの内部コンポーネントは、既存のギリシャ哲学的な命名規約に従う：

- **OreXis**（ὄρεξις、「欲望／渇望」）—— すでに問いを立てるエージェントである。

その欲望は、物事が単に*為された*かではなく*正しい*かを知ることである。

- **Lesson** —— `TaskState` の既存の `quality_score`／`lesson` フィールド名と一貫する。

- **`ReflectionResult`** —— 機能的命名であり、`ReportCaptureDecision` や他のパイプライン型に合致する。
