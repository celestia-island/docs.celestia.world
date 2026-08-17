# Entelecheia — 에이전트 플랫폼 및 메모리

Entelecheia는 에이전트 플랫폼입니다: 특화 에이전트("소울")를 오케스트레이션하고
장기 메모리(PhiLia)를 유지하며 시맨틱 검색을 제공하고 산업 통합 계층을 호스팅하는
scepter 런타임입니다. Arona와 Chest의 기능 뒤에는 이 플랫폼이 서 있습니다.
이 가이드는 기능별로 구성되어 있습니다: 에이전트, 메모리, 검색, 지식, 연결.

## 한눈에 보는 아키텍처

```text
클라이언트: Arona (게이트웨이) · Shittim Chest (채팅/패널) · TUI/CLI
        │  WebSocket을 통한 JSON-RPC 2.0 (토큰 또는 API key)
        ▼
   scepter 런타임 (node-3:8424)
   ├─ 에이전트 매니저: L1 소울 (PhiLia, Skopeo, Hubris, Kalos, …)
   ├─ 스킬 체인: RAG 프리페치가 붙은 LLM + 도구 호출 파이프라인
   ├─ PhiLia: 장기 메모리 (벡터 + 그래프, pgvector 기반)
   ├─ ApoRia: 지식 베이스 + 워크스페이스 인덱스 (시맨틱 검색)
   ├─ OreXis: 도구 실행에 대한 정책 / 안전 게이트
   └─ 성찰: 프롬프트에 재주입되는 레슨 저장소
```

## 1. 에이전트 (소울)

각 소울은 자체 신원 문서, 도구(MCP 스타일), 스킬을 가진 특화 에이전트입니다.
스킬 체인은 LLM 호출과 도구 실행을 조합합니다; 각 호출 전에 관련 장기 메모리와
지식 베이스 콘텐츠가 프리페치되어 시스템 프롬프트에 주입됩니다.

안전: 도구 실행은 OreXis 정책 게이트를 거치며, 산업 쓰기는 명시적인 승인
플로우를 요구합니다.

## 2. 장기 메모리 (PhiLia)

PhiLia는 Arona의 메모리 게이트웨이 뒤에 있는 메모리 서비스입니다:

- **저장** — 에피소드, 엔티티, 아티팩트가 메모리 그래프의 노드로 저장되어
  임베딩되고 pgvector(`philia_chunks`)로 미러링됩니다.
- **조회** — 시맨틱 검색이 벡터 유사도, 그래프 순회, 최신성 감쇠(14일
  반감기)를 결합합니다.
- **통합** — 주기적인 병합이 관련 노드들을 연결합니다.
- **와이어 표면** — 일급 메서드 `Sync.MemoryStoreRequest` /
  `MemoryQueryRequest` / `MemoryDeleteRequest`(RBAC: SystemWrite /
  SystemRead)가 일반 `Mcp.CallTool` 라우트와 함께 제공됩니다.

임베딩: `OLLAMA_HOST` + `OLLAMA_EMBED_MODEL`(예: `nomic-embed-text`) 또는
원격 API로 구성되며, 로컬 ONNX 모델로 폴백합니다.

## 3. 시맨틱 검색

`Sync.SearchRequest`는 두 저장소를 하나의 랭킹 목록으로 융합합니다:

- **ApoRia** — 워크스페이스 인덱스, 에이전트 보고서, 지식 베이스 문서(RRF를
  사용한 하이브리드 벡터 + 키워드).
- **PhiLia** — 장기 메모리(`philia_memory` 소스).

## 4. 지식 베이스

지식 베이스를 만들고, 문서를 추가하고, RAG 구독을 신청하세요 — 모두
Postgres에 유지됩니다. 문서는 ApoRia 저장소에 임베딩되어 같은 검색 표면을
통해 검색 가능합니다.

## 5. 성찰

얻은 교훈은 레슨 저장소(pgvector)에 저장되어 이후 프롬프트에 재주입됩니다 —
PhiLia 옆의 두 번째, 가벼운 영구 메모리입니다.

## 6. 클라이언트 연결

- WebSocket `ws://<host>:8424/ws` — 업그레이드 시
  `?token=<연결 토큰>`(또는 Bearer)으로 인증하세요; 이어서
  `Sync.ConnectHandshake`.
- 요청/응답 용도의 HTTP JSON-RPC `POST /api/rpc?token=…`.
- 연결 토큰: scepter 노드의 `~/.config/entelecheia/scepter.token`.

## 환경 변수 참조 (일부)

| 변수 | 용도 |
|---|---|
| `SERVER_BIND_ADDRESS` | 바인드 주소 (기본 127.0.0.1; 원격 클라이언트를 위해 0.0.0.0:8424 설정) |
| `DATABASE_URL` | Postgres (config.toml 또는 환경변수) |
| `OLLAMA_HOST` / `OLLAMA_EMBED_MODEL` | 임베딩 백엔드 |
| `JWT_SECRET` | 영구 인증 토큰 (미설정 시 세션마다 무작위) |
| `connection_token` | scepter 연결 토큰 파일 |
