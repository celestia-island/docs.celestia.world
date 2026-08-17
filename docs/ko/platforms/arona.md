# Arona — 모델 게이트웨이, 메모리 및 클러스터

Arona는 플랫폼의 컨트롤 플레인입니다: 모델 게이트웨이, 자체 배포 런타임
매니저, 웹 대시보드. 이것이 풀려는 문제는 "어떤 머신에 내려받은 모델"을
플랫폼 전체가 라우팅하고, 계량하고, 기억할 수 있는 것으로 바꾸는 일입니다.
이 가이드는 기능별로 구성되어 있습니다: 모델 라우팅, 장기 메모리, 그리고
다중 노드 클러스터.

## 한눈에 보는 아키텍처

```text
shittim-chest / 모든 OpenAI 클라이언트
        │  /v1/chat/completions (Bearer API key)
        ▼
   Arona 게이트웨이 (node-2:8420)
   ├─ 라우터: 별칭 → 백엔드 전체에 걸친 최소 카운트 로드 밸런싱
   ├─ 메모리 게이트웨이: 리콜 주입 → 채팅 → 라이트백 (에피소드)
   └─ 에이전트 컨트롤 플레인 (/ws/agent) ──► GPU 노드의 arona-agent
        │
        ▼
   백엔드: ollama · 외부 (OpenAI 호환) · 에이전트 배포 엔진
```

모든 관리 트래픽(대시보드, 에이전트, 메모리)은 JSON-RPC 2.0 메시지를 실은
WebSocket으로 실행됩니다; 유일한 REST 표면은 OpenAI 호환 `/v1/*`
엔드포인트입니다.

## 1. 모델

### 백엔드 등록

백엔드는 `ollama` 또는 `external`(vLLM, TGI, LMDeploy, TileRT의 라우터 등
모든 OpenAI 호환 서버)로 등록됩니다:

```bash
POST /api/admin/backends        # Bearer ADMIN_TOKEN
  {"type": "ollama", "name": "node3-ollama", "url": "http://host:11434"}
  {"type": "external", "name": "my-vllm", "url": "http://host:8000",
   "api_key": "...", "models": ["qwen2.5-72b"]}
```

등록된 백엔드는 재시작 후에도 유지되며(`backend_configs` 테이블) 지속적으로
헬스 프로브됩니다: 외부 백엔드는 첫 `/v1/models` 프로브가 성공할 때까지
실패 폐쇄(fail-closed) 상태이며, 모델 목록은 동적으로 갱신됩니다.

### 노드에 모델 자체 배포하기

`arona-agent` 바이너리는 GPU 머신에서 실행되어 패널로 역방향 연결됩니다.
대시보드 **Agents** 페이지에서(또는 `agent_id`를 비워 가장 덜 부하가 걸린
노드를 자동 선택하는 `agents.deploy`로) 모델을 배포하세요. 에이전트는
모델을 내려받고(HuggingFace 또는 Ollama 레지스트리), 엔진(llama.cpp /
vLLM / Ollama)을 시작하고, 엔진 엔드포인트를 보고합니다 — 패널은 이를
라우팅 가능한 `agent-{model}` 백엔드로 자동 등록하고 중지 시 제거합니다.

엔진 바인드 주소: 패널에 트래픽을 제공해야 하는 노드에서는
`ARONA_AGENT_BIND_ADDR=0.0.0.0`을 설정하세요. 참고: 엔진 포트는 인증되지
않습니다 — 신뢰할 수 있는 네트워크에서만 배포하세요.

### 대화 어피니티

대화는 하나의 백엔드에 고정됩니다(세션 어피니티), 이로써 런타임 KV 캐시를
재사용할 수 있습니다. 고정된 백엔드가 비정상이 되면 라우터는 폴백한 뒤 다시
고정합니다.

## 2. 장기 메모리

Arona는 **메모리 게이트웨이**입니다: 모델을 학습하지 않습니다 — 기존
모델 주변에 메모리 서비스(entelecheia의 PhiLia 에이전트)를 오케스트레이션할
뿐입니다.

### 활성화

```bash
ARONA_MEMORY_URL=ws://<scepter-host>:8424/ws
ARONA_MEMORY_TOKEN=<scepter 연결 토큰>
ARONA_MEMORY_WRITEBACK=1        # 기본 켜짐; 0이면 라이트백 비활성화
```

### 채팅마다 일어나는 일

1. **리콜** — 마지막 사용자 메시지가 임베딩되어 메모리 서비스에 조회되고,
   관련 메모리가 `## Relevant Long-Term Memories` 시스템 섹션으로
   주입됩니다(멱등).
2. **채팅** — 조립된 컨텍스트가 모델로 라우팅됩니다.
3. **라이트백** — 완료된 턴이 휴리스틱으로 추출되어(`User: … /
   Assistant: …`, LLM 호출 없이) 메모리 그래프에 에피소드로 저장됩니다
   (pgvector 기반, 재시작 후에도 유지).
4. **상태** — 모든 응답은 `memory: enabled | disabled | offline`을
   보고합니다; REST 표면은 `X-Arona-Memory` 헤더를 추가합니다. 실패가
   채팅을 막는 일은 결코 없습니다; `offline`은 메모리 서비스에 도달할 수
   없다는 뜻이며 항상 UI에 표시됩니다.

호출별 재정의: `chat.send`는 `memory: true|false`를 받습니다.

### 관리

대시보드 **Memory** 페이지는 리콜/라이트백/삭제 활동을 보여주고 저장된
노드를 삭제할 수 있게 합니다. 세션은 서버 쪽에 유지됩니다: `chat.send`에
`conversation_id`를 전달하면 클라이언트가 아니라 서버가 이력을 조립합니다.

## 3. 운영

- **인증**: 첫 관리자 부트스트랩 이후 등록이 잠깁니다
  (`ARONA_REGISTRATION_OPEN=1`로 다시 열립니다). 관리 엔드포인트는
  `ARONA_ADMIN_TOKEN`을 요구합니다; 이 토큰이 없으면 실패
  폐쇄(fail-closed)됩니다.
- **계량**: 사용량과 비용이 API key별로 기록됩니다(`usage.list`, 쿼터와
  비율 제한이 있는 빌링 티어).
- **헬스**: `/api/health`와 `/v1/health`가 버전과 빌드 해시를 보고합니다.

## 환경 변수 참조

| 변수 | 용도 |
|---|---|
| `DATABASE_URL` | Postgres (필수) |
| `JWT_SECRET` | 토큰 서명 (모의 모드 밖에서는 필수) |
| `ARONA_HOST` / `ARONA_PORT` | 바인드 주소 (기본 `0.0.0.0:8420`) |
| `ARONA_ADMIN_TOKEN` | `/api/admin/*`용 Bearer 토큰 |
| `ARONA_REGISTRATION_OPEN` | 셀프 등록 다시 열기 |
| `ARONA_MEMORY_URL` / `ARONA_MEMORY_TOKEN` / `ARONA_MEMORY_WRITEBACK` | 메모리 게이트웨이 |
| `ARONA_AGENT_NAME` / `ARONA_PANEL_URL` / `ARONA_AGENT_BIND_ADDR` | 에이전트 노드 |
