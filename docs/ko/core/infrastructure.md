# 핵심 인프라 — 인증, RPC 및 기반

여러분이 사용하는 모든 플랫폼은 동일한 기반 위에 놓입니다. 이 문서를 한 번만
읽으면 플랫폼 가이드들이 제자리에 끼워집니다: kirino(제로 트러스트 인증 및
RBAC), plana(프로토콜 타입, JSON-RPC 전송, 계량, 동기화 엔진) 그리고
hikari(UI 컴포넌트 라이브러리)입니다.

## 인증 및 권한 부여 (kirino)

- **신원**: Argon2id 비밀번호 해싱; JWT 액세스/리프레시 토큰
  (`TokenManager`, `kirino-session`); 로그인 비율 제한 및 계정 잠금.
- **RBAC**: `GrantResolver`가 해석하는 계층적 권한(agent.*, system.*,
  knowledge.*, …); 역할은 권한을 묶습니다(admin은 전체를 보고, viewer는
  읽기 전용). 할당은 Postgres에 유지됩니다.
- **위임**: scepter는 chest 게이트웨이가 전달하는 호출자 사용자 ID
  (`X-User-Id` / `user_id`)를 신뢰하며 이를 워크스페이스 격리에만
  사용합니다 — 인증하는 계층은 항상 상류에 있습니다.
- **관리 화면**: 패널 관리 엔드포인트는 전용 `ARONA_ADMIN_TOKEN`을
  요구하며, 이 토큰이 없으면 실패 폐쇄(fail closed)됩니다.

## 프로토콜 및 RPC (plana)

- 모든 플랫폼 트래픽은 **WebSocket을 통한 JSON-RPC 2.0**입니다(그리고
  HTTP POST `/api/rpc`를 통한 요청/응답). 메서드는 `<Domain>.<Action>`
  형태로 이름이 지정됩니다 — 예: `Sync.MemoryQueryRequest`, `Cli.Search`,
  `Mcp.CallTool`.
- 와이어 타입은 plana에 있습니다(`plana-state-sync` / `plana-types`):
  프로토콜의 단일 진실 공급원이며, 하류 저장소는 릴리스된 태그를
  고정합니다.
- 알림(`id` 없음)은 스트리밍 청크나 패널 업데이트 같은 이벤트를
  푸시합니다; 요청은 `id`를 가지며 응답에서 그 `id`가 그대로 돌아옵니다.
- 동기화 엔진(`plana-sync`)은 서버가 권위를 가지는 상태 트리입니다:
  클라이언트는 뷰포트를 선언하고, 서버는 주기적인 전체 스냅샷과 함께
  diff를 브로드캐스트합니다.

## 계량 및 가격 책정 (plana)

사용량은 API key별로 계량되고 정규 테이블(`plana-llm-provider` 계량)에서
가격이 책정됩니다: 프롬프트/컴플리션 토큰, 비용 추정, 쿼터 강제가 모든
서비스에서 공유됩니다.

## UI 컴포넌트 (hikari)

Vue 컴포넌트 라이브러리(`@celestia-island/hikari`)는 모든 웹UI가 사용하는
버튼, 배지, 테이블, 모달, 확인 대화상자를 제공합니다; 플랫폼 페이지는 이를
plana UI 셸과 조합합니다. 공유 컴포넌트는 저장소마다 다시 구현하는 것이
아니라 반드시 여기 상류로 올려야 합니다.

## 의존성 규칙

- 계층 0: kirino(인증) → 계층 1: plana(프로토콜/기반) → 계층 2:
  hikari(UI) → 계층 3: 서비스(arona, chest, entelecheia, evernight).
- 서비스는 비즈니스 로직만 구현합니다; 공유 기능은 상류에서 옵니다.
  저장소 간 의존성은 git 참조 또는 고정된 태그를 사용합니다 — 로컬 경로
  의존성은 절대 쓰지 않습니다.
