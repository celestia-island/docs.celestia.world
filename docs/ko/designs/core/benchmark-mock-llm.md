# 벤치마크 & Mock LLM 서버 설계

> 핵심 명제: **어떤 모델 + Entelecheia 도구 시스템이 얼마나 많은 작업을 완수할 수 있는가?**
>
> "약/강" 분류를 미리 가정하지 않는다. 환경 변수에 어떤 provider의 key가 전달되었든, 해당 모델의 코딩 패키지(coding plan) 구성을 생성해 테스트한다. 단 하나의 key도 없으면 → 곧바로 에러를 내고 종료한다.

## 0. 핵심 발견: 기존 Provider 레지스트리 재사용

Entelecheia는 이미 완전한 env-var 기반 provider 발견 시스템을 갖추고 있다:

- `provider-registry` 저장소: 926개의 TOML 파일로 OpenAI / Anthropic / DeepSeek / GLM / Qwen / Kimi / MiniMax 등 모든 주요 provider를 커버
- `derive_config_from_env()`: 모든 entrypoint TOML을 순회하며, `env_var`가 설정된 provider를 자동으로 활성화
- `ModelTier`(Deep / Normal / Basic) 3단계 + fallback chain
- `_shared_llm_provider::ProviderRegistry`: 전역 등록, 5종 프로토콜(OpenAI Chat / Responses / Anthropic v1/v2 / Gemini)

**provider 레지스트리를 새로 만들 필요가 없다** —— benchmark runner가 `_shared_config` + `_shared_llm_provider`를 직접 재사용한다.

## 1. 코딩 패키지(Coding Plan) 개념

각 사용 가능 모델에 대해 benchmark profile을 자동 생성한다:

| 필드 | 출처 | 설명 |
|------|------|------|
| provider_id | entrypoint TOML | 예: `deepseek` / `zhipu_glm` |
| model_id | entrypoint defaults | 예: `deepseek-coder` / `glm-4-plus` |
| tier | ModelTier::Deep | 코딩 작업은 Deep tier 사용 |
| base_url | entrypoint api.base_url | 실제 원격 API |
| api_key | 환경 변수(entrypoint api.env_var) | 런타임에 읽음 |
| protocol | entrypoint api.protocol | GenProtocol 열거값 |
| context_window | model card | `models/<provider>/<model>.toml`에서 읽음 |
| max_output_tokens | model card | 동일 |
| supports_function_calling | model card | 도구 호출 방식 결정 |

Profile은 런타임에 env vars로부터 동적으로 구성되며, 설정 파일로 미리 저장하지 않는다.

## 2. 아키텍처

```text
┌─────────────────────────────────────────────────────────┐
│                    Benchmark Runner                      │
│  (데이터셋 인스턴스를 순회하며 결과 수집, JSONL 출력)     │
└──────────────┬──────────────────────┬───────────────────┘
               │                      │
       ┌───────▼────────┐    ┌────────▼────────┐
       │  Task Adapter   │    │  Result Collector│
       │ (SWE-bench /    │    │  (git diff →     │
       │  Aider / etc.)  │    │   JSONL output)  │
       └───────┬────────┘    └────────▲─────────┘
               │                      │
       ┌───────▼──────────────────────┴─────────┐
       │        Entelecheia Agent Runtime        │
       │  (SkoPeo 오케스트레이션 → HubRis 계획 → 스킬 체인)    │
       │                                         │
       │  ┌─────────┐  ┌─────────┐  ┌────────┐  │
       │  │ Tool    │  │ Skill   │  │ Soul   │  │
       │  │ Layer   │  │ Chain   │  │ Layer  │  │
       │  │(MCP)    │  │ Router  │  │(Identity)│ │
       │  └────┬────┘  └─────────┘  └────────┘  │
       └───────┼─────────────────────────────────┘
               │
       ┌───────▼─────────────────────────────────┐
       │          LLM Backend Switch              │
       │                                         │
       │  ┌─────────────┐    ┌─────────────────┐ │
       │  │ Mock Server  │    │ Real API Proxy  │ │
       │  │(record/replay)│   │(OpenAI/etc.)    │ │
       │  └─────────────┘    └─────────────────┘ │
       └─────────────────────────────────────────┘
               │
       ┌───────▼─────────┐
       │  Docker Sandbox  │
       │ (작업 인스턴스 환경)│
       │ - 코드 저장소      │
       │ - 툴체인          │
       │ - 테스트 스위트     │
       └─────────────────┘
```

## 3. Mock LLM 서버

### 3.1 Record/Replay 프로토콜

Mock 서버는 OpenAI Chat Completions API(`/v1/chat/completions`)와 호환되며, 두 가지 작업 모드를 지원한다:

**녹화 모드(최초 실제 모델 실행 시)**:
```text
Client → Mock Server → Real API → Mock Server (응답 녹화) → Client
```

**재생 모드(CI/오프라인 시)**:
```text
Client → Mock Server (요청 매칭 → 녹화된 응답 반환) → Client
```

### 3.2 요청 매칭 전략

요청은 다음 필드들의 해시로 매칭된다:
- `model`(모델명)
- `messages`의 콘텐츠 해시(정규화 후)
- `tools`의 구조 해시(있는 경우)
- `temperature`, `max_tokens` 등의 파라미터

**Strict 모드**(CI 기본 활성화): 매칭되지 않은 요청은 즉시 에러를 내며, real API로 fallback하지 않는다. fixture의 완전성을 보장한다.

**Lenient 모드**(개발용): 매칭되지 않으면 real API로 fallback하며 녹화한다.

### 3.3 Fixture 저장

```text
tests/fixtures/llm/
├── swe-bench-verified/
│   ├── gpt-4o/
│   │   ├── <request_hash>.json      # 녹화된 응답
│   │   └── index.toml                # 요청 요약 인덱스
│   ├── claude-sonnet/
│   └── llama-8b/
└── aider-polyglot/
    └── ...
```

### 3.4 구현 선택지

| 방안 | 장점 | 단점 |
|------|------|------|
| **AIMock**(CopilotKit) | 성숙함, streaming/tool-calls/MCP 지원, Docker 이미지 | 외부 의존성 |
| **자체 경량 서버** | 완전한 제어, 외부 의존성 제로 | streaming/엣지 케이스를 직접 처리해야 함 |
| **VCR.py / wiremock** | 언어 생태계가 성숙함 | LLM 전용이 아니라서 어댑팅 필요 |

**권장**: 먼저 자체 경량 서버(axum/actix 라우터 하나, 매칭 + JSON 반환)로 시작하고, streaming이 필요해지면 AIMock으로 이전한다.

## 4. SWE-bench 어댑터

### 4.1 작업 실행 흐름

```text
for instance in dataset:
    1. SWE-bench Docker 이미지를 풀한다 (base + env + instance 3계층)
    2. 컨테이너를 시작하고 코드 저장소를 마운트한다
    3. 이슈 텍스트를 작업 설명으로 주입한다
    4. Entelecheia Agent Runtime을 시작한다 (컨테이너 내 bash/파일시스템에 연결)
    5. 완료되거나 타임아웃될 때까지 에이전트가 실행된다 (step cap: 50, wall-clock: 15min)
    6. 컨테이너 내에서 git diff를 실행해 patch를 추출한다
    7. JSONL 출력: {instance_id, model_name_or_path, model_patch}
    8. 컨테이너를 파괴한다
```

### 4.2 Agent Runtime 주입

Entelecheia가 SWE-bench 컨테이너 내에서 실행될 때 필요한 것:
- 파일 조작 도구 → 컨테이너 내 파일시스템으로 매핑
- 명령 실행 도구 → 컨테이너 내 bash로 매핑
- 검색 도구 → `rg`/`grep`(컨테이너 내 사전 설치)
- 해당 작업과 무관한 에이전트(PoleMos/산업 프로토콜 등)는 **비활성화**하여 컨텍스트 노이즈를 줄임

### 4.3 채점

SWE-bench 네이티브 harness를 그대로 사용한다:
```bash
python -m swebench.harness.run_evaluation \
    --dataset_name princeton-nlp/SWE-bench_Verified \
    --predictions_path entelecheia_predictions.jsonl \
    --max_workers 8 --run_id entelecheia-eval
```

출력: 각 인스턴스의 resolved/unresolved, resolution rate을 집계한다.

## 5. 실험 매트릭스

### 5.1 핵심 비교

데이터셋(SWE-bench Verified)을 고정하고 두 차원을 변화시킨다:

|  | Baseline (mini-SWE-agent) | Entelecheia |
|--|---------------------------|-------------|
| **GPT-4o** | A₁ | B₁ |
| **Claude Sonnet** | A₂ | B₂ |
| **Llama 3.1 8B** | A₃ | B₃ |
| **Qwen 2.5 7B** | A₄ | B₄ |

- Bᵢ/Aᵢ = 모델 i의 증폭 계수
- 행 간 비교: 약한 모델(Llama/Qwen)의 AF가 강한 모델(GPT-4o)보다 높은가?

### 5.2 절제 실험(Ablation)

| 구성 | 목적 |
|------|------|
| 완전한 Entelecheia(12 agent + 모든 스킬) | 풀스펙 기준선 |
| HubRis + KaLos + SkeMma만(계획+파일+실행) | 다중 에이전트 오케스트레이션의 증분 측정 |
| KaLos + bash만(단일 에이전트 + 파일 도구) | baseline에 가까움, 스킬 체인의 증분 측정 |
| soul identity 없음(신원/은유 prompt 제거) | persona prompt의 효과 측정 |

## 6. 구현 로드맵

### Phase 1: Mock LLM 서버(1-2일)
- [ ] OpenAI 호환 record/replay 서버 구현
- [ ] 요청 해시 매칭 + strict/lenient 모드
- [ ] Fixture 저장 구조
- [ ] `ENTELECHEIA_LLM_BASE_URL` 환경 변수로 전환

### Phase 2: SWE-bench 어댑터(2-3일)
- [ ] JSONL 작업 로더
- [ ] Docker 컨테이너 오케스트레이션(SWE-bench 이미지 재사용)
- [ ] 컨테이너에 Agent Runtime 주입
- [ ] Patch 추출 + JSONL 출력
- [ ] 네이티브 harness 채점 연동

### Phase 3: 최초 평가(1일)
- [ ] GPT-4o로 SWE-bench Lite(300문제)의 baseline + entelecheia 실행
- [ ] fixture 녹화(후속 CI용)
- [ ] AF를 계산해 첫 비교 보고서 작성

### Phase 4: 다중 모델 횡단 비교(2-3일)
- [ ] Claude / Llama / Qwen 연동
- [ ] 전체 실험 매트릭스 실행
- [ ] 절제 실험
- [ ] 최종 보고서 작성

## 7. Entelecheia 기존 아키텍처와의 통합 지점

| 컴포넌트 | 통합 방식 |
|------|---------|
| `ApoRia::llm_chat` | base_url을 mock 또는 real API로 전환 |
| `SkoPeo` 오케스트레이션 | 새 `benchmark` 실행 모드 추가, 대화형 확인을 건너뜀 |
| `HubRis` 계획 | benchmark 작업 설명을 입력으로 받음 |
| `NeiKos` 컨테이너 | SWE-bench Docker 컨테이너 수명주기 관리 |
| `KaLos` 파일 | 컨테이너 내 파일시스템으로 매핑 |
| `OreXis` 보안 | benchmark 모드에서 보안 정책을 완화(임의 코드 실행 허용) |

## 8. 주의사항

- **비용 제어**: SWE-bench Verified 전체 500문제 × 4 모델 × 2 구성 = 4000회 실행. 평균 50스텝/문제, 스텝당 ~2K tokens로 추정하면 약 400M tokens. `--max_cost` 상한을 설정해야 한다.
- **컨테이너 자원**: 각 SWE-bench 인스턴스는 독립된 Docker 컨테이너가 필요하며, ≥120GB 디스크, ≥32GB RAM을 권장한다.
- **결정성**: Mock 모드는 CI 재현성을 보장한다; Real 모드는 `temperature=0` 고정 + 요청 해시 기록으로 드리프트를 감지한다.
- **오염 검출**: SWE-bench는 기억 누출 문제가 존재하며(arXiv:2506.12286), 자체 합성 작업 일부를 holdout으로 보존할 것을 권장한다.
