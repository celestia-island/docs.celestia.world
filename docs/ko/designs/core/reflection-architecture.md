# 리플렉션 아키텍처: 스킬 체인에서의 지속적 자기 회의

> **상태**: 설계 명세. 구현 진행 중.
> 2026-06-27 작성.

## 문제

현재 스킬 체인 파이프라인은 **단일 순방향 패스(forward pass)**로 실행된다: 스킬이 출력을 생성하고, 오케스트레이터가 구조적 정합성을 검사한 뒤(`report()`를 호출했는가? `cargo check`를 실행했는가?), 다음 스킬로 넘어간다. 시스템이 다음과 같이 묻는 단계는 없다:

1. *이 스텝의 추론은 타당했는가?* (의미론적 리플렉션)
1. *방금 일어난 일을 고려할 때, 방향을 바꿔야 하는가?* (적응적 리플렉션)
1. *다음을 위해 무엇을 기억해야 하는가?* (교훈의 침전)

기존 메커니즘들 —— verify 넛지, 수술 후 롤백, YOLO 일일 감사 —— 은 모두 **반응적이고 이진적**이다: 기술적 실패는 감지하지만 추론 실패는 감지하지 못한다. 스킬은 문법적으로 올바르고 컴파일되지만 잘못된 문제를 해결하는 코드를 생성할 수 있으며, 현재 파이프라인에서는 인간이 최종 출력을 검토하기 전까지 이를 잡아낼 수 없다.

## 설계 원칙

1. **리플렉션은 파이프라인의 한 단계이며, 사후 처리용 훅이 아니다.** 출력 검증과 리포트 전달 사이에 자기 몫의 슬롯을 갖는다 —— 다른 모든 단계와 동일한 구조적 비중을 둔다.

1. **세 개의 티어, 세 개의 비용.** 모든 스텝이 깊은 철학적 비평을 받을 자격이 있는 것은 아니다. 시스템은 방금 일어난 일에 기반해 적절한 리플렉션 깊이를 자동으로 선택해야 한다.

1. **OreXis가 리플렉션 에이전트다.** 기존 설계 —— 질문을 던지는 Titan, 불확실성을 운영자에게 밀어 올리는 존재 —— 은 리플렉션 역할에 완벽히 부합한다. 새 에이전트는 필요 없다.

1. **교훈은 앞으로 흘러가야 한다.** 미래 행동을 바꾸지 못하는 리플렉션은 그저 일기일 뿐이다. 교훈 저장소는 컨텍스트 준비 단계로 피드백되어, 다음 체인이 이전 체인의 실수로부터 혜택을 받도록 해야 한다.

1. **자기 트리거된 리플렉션은 일급 도구다.** 모든 에이전트는 오케스트레이터가 하나를 예약해 주길 기다리기만 하는 것이 아니라, 자신의 IEPL 스크립트 내부에서 리플렉션 주기를 요청할 수 있어야 한다.

## 3단계 리플렉션 시스템

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

### Tier 0: 휴리스틱 리플렉션 (비용 제로, 항상 활성)

**무엇을**: 스킬 출력과 실행 트레이스에 대한 규칙 기반 검사.

**언제**: 모든 스킬, 예외 없이.

**어떻게**: 순수 Rust 로직, LLM 호출 없음. 기존 `validate_report_capture()`의 확장된 버전으로 추가 휴리스틱을 포함한다:

- 출력 길이의 건전성(너무 짧거나 / 의심스러울 만큼 김)
- 도구 호출 패턴 이상(스킬의 예상 도메인 밖의 도구를 호출)
- 실행 시간 이상치(스킬이 역사적 평균보다 10배 오래 걸림)
- 도구 호출 내 오류율(도구 호출의 50% 이상이 실패)
- 출력 내 순환 참조 탐지

**비용**: 거의 제로(CPU 마이크로초 단위).

**판정**: `Accept`(통과) 또는 `NeedsTier1`(의미론적 단계로 에스컬레이션)을 낼 수 있다.

### Tier 1: 의미론적 리플렉션 (LLM 호출 1회, 의사결정 지점에서)

**무엇을**: LLM 기반 평가 —— "이 출력이 스킬이 서술한 목표를 달성하는가? 추론 사슬이 내적으로 일관적인가?"

**언제**: 다음에 의해 트리거된다:

- Tier 0 에스컬레이션(`NeedsTier1`)
- 스킬 정의에서 `requires_reflection`으로 명시 표시된 스킬
- 체인 의사결정 지점의 스킬(`task_decompose`, `plan_execute`, `workplan_generate` 이후)

- 체인 내 스킬의 첫 출현(신규성 트리거)
- `orexis::request_reflection` 도구를 통한 임의 에이전트의 자가 트리거

**어떻게**: 리플렉션 전용 스킬 프롬프트로 OreXis 에이전트를 호출한다. 프롬프트는 다음을 포함한다:

- 스킬이 서술한 목표
- 스킬의 출력
- 실행 트레이스 요약(수행된 도구 호출, 그 결과)
- 체인 컨텍스트(이전에 무엇이 있었는지, 이후에 무엇이 오는지)

**비용**: LLM 호출 1회(~500-2000 출력 토큰).

**판정**: `Accept`, `Adjust`(수정 제안 포함), `Backtrack`(이전 스킬로 돌아가 다른 접근으로 재시도), 또는 `NeedsTier2`(심층 비평으로 에스컬레이션).

### Tier 2: 심층 비평 (OreXis 철학적 검토, 체인 경계에서)

**무엇을**: 전체 체인에 대한 OreXis 주도의 검토 —— "전반적 접근이 올바른가? 어떤 가정이 틀렸는가? 무엇을 배워야 하는가?"

**언제**: 다음에 의해 트리거된다:

- Tier 1 에스컬레이션(`NeedsTier2`)
- 체인 완료(성공 또는 실패) —— 사후 체인 훅으로 실행
- 운영자 구성 주기성(예: N체인마다)
- YOLO Strategic 티어

**어떻게**: `deep_critique` 스킬을 가진 OreXis 에이전트. 다음을 검토한다:

- 전체 체인 트레이스(모든 스킬, 모든 출력, 모든 도구 호출)
- 원래 목표 대 달성 결과
- 교훈 저장소의 역사적 교훈(패턴 매칭용)

**비용**: LLM 호출 1-2회(~1000-5000 출력 토큰).

**판정**: 다음을 포함하는 `DeepCritiqueReport`를 생성한다:

- 근본 원인 분석(체인이 실패한 경우)
- 가정 감사(어떤 가정이 타당했고, 어떤 것이 그렇지 않았는지)
- 교훈 후보(교훈 저장소에 기록될)
- 신뢰도 평가

## 데이터 모델

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

### 교훈 저장소 (Lesson Store)

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

## 통합 지점

### 1. 파이프라인 삽입 (pipeline.rs)

Phase F(`post_execution_cleanup`)와 Phase G(`dispatch_report_and_check_termination`) 사이에 다음을 삽입한다:

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

### 2. 컨텍스트 준비 (교훈 주입)

Phase D(`build_prompts`)에서, 시스템 프롬프트를 조립하기 전에 교훈 저장소에서 컨텍스트적으로 관련된 교훈을 조회한다:

```rust
let relevant_lessons = lesson_store
    .find_similar(&s.current_skill_context, TOP_K_LESSONS)
    .await;

let lesson_section = format_lessons_for_prompt(&relevant_lessons);
// Inject into system prompt after skill description
```

### 3. 자가 트리거된 리플렉션 (IEPL 도구)

`orexis::request_reflection`을 IEPL 네임스페이스에 노출한다. 모든 에이전트는 자신의 TypeScript 코드 내에서 이를 호출할 수 있다:

```typescript
import { request_reflection } from 'orexis';

const review = await request_reflection({
  reason: "I'm about to execute a potentially destructive operation",
  context: { operation: "file_delete", path: "/etc/..." },
  urgency: "high",
});
```

이는 동기적으로 OreXis 리플렉션 주기를 생성하며, 호출한 에이전트는 리플렉션이 완료될 때까지 블록된다.

### 4. 사후 체인 심층 비평 훅

`surgery_hooks` 네임스페이스에 새 파이프라인 훅을 등록한다:

```text
pipeline.reflection.post_chain  (priority 30, after PostSurgeryRollback)
```

이 훅은 체인 성공 이후 Tier 2 심층 비평을 실행하여, 향후 체인에 도움이 될 교훈을 생성한다.

## 교훈 생명주기

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

교훈은 살아 있는 산물이다:

- **강화(Reinforced)**: 적용이 성공적 결과와 상관관계가 있을 때
- **조정(Adjusted)**: 새 증거에 기반해 교훈 텍스트의 다듬음이 필요할 때
- **폐기(Deprecated)**: 지속적으로 도움이 되지 않거나 관련성을 잃었을 때

## 비용 관리

| 티어 | 토큰 비용 | 빈도 | 일일 토큰 예산 |
| --- | --- | --- | --- |
| Heuristic | 0 | 모든 스킬 | 0 |
| Semantic | ~2K 토큰 | 의사결정 지점(스킬의 약 30%) | ~20K 토큰/체인 |
| Deep | ~5K 토큰 | 체인당 + 에스컬레이션 | ~5K-10K 토큰/체인 |

총 오버헤드: 체인당 약 10-15%의 추가 토큰 소비로, 토큰을 품질과 교환한다. 환경 변수로 설정 가능하다.

## 설정

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

## 기존 시스템과의 관계

| 기존 시스템 | 관계 |
| --- | --- |
| `validate_report_capture()` | Tier 0의 여러 휴리스틱 중 하나로 흡수됨 |
| Verify 넛지 | Tier 1로 에스컬레이션 가능한 Tier 0 휴리스틱이 됨 |
| `PostSurgeryRollback` | 있는 그대로 유지; 리플렉션이 그것을 대체하지 않고 그 이전에 실행됨 |
| YOLO 일일 감사 | 리플렉션으로 보완됨; 감사는 준수를, 리플렉션은 추론을 검사함 |
| `RetroReview` | 목표 수준의 검토를 위해 Tier 2 심층 비평에 흡수됨 |
| `quality_score` / `lesson` 필드 | 교훈 저장소에 연결됨; 마침내 읽기 측이 생김 |
| `context_preparation` | 관련 교훈을 주입하도록 확장됨 |
| `agent-consensus` | 합의(consensus)는 사실을, 리플렉션은 추론을 검증한다. 상호 보완적 |
| `memory-and-self.md` | 교훈 저장소는 "자기를 위한 기억 침전"의 운영적 구현이다 |

## 명명

리플렉션 시스템의 내부 컴포넌트는 기존 그리스 철학 명명 관행을 따른다:

- **OreXis**(ὄρεξις, "갈망/동경") —— 이미 질문을 던지는 에이전트다.

그것의 욕망은 사물이 단지 *끝났는지*가 아니라 *올바른지*를 아는 것이다.

- **Lesson** —— `TaskState`의 기존 `quality_score` / `lesson` 필드명과 일치한다.

- **`ReflectionResult`** —— 기능적 명명으로, `ReportCaptureDecision` 및 다른 파이프라인 타입과 일치한다.
