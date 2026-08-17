# Web UI — 첫 문장에서 시작하는 여정

두 개의 표면, 하나의 흐름입니다: **arona**는 헤드리스 제어 평면이고(모델,
키, 원장, 메모리), **shittim-chest**는 실제로 눈앞에 두고 바라보는
작업대입니다(채팅, 패널, 세계를 보는 일). 아래의 모든 화면은 chest 뷰입니다 —
chest는 자신의 RPC 표면을 통해 arona와 대화하고, arona 자체는 UI를
제공하지 않습니다.

![Chest 백엔드 콘솔](https://raw.githubusercontent.com/celestia-island/docs.celestia.world/master/res/screenshots/arona-dashboard.png)

## 모델: 소스에서 호출까지

모델은 "존재함"에서 "채팅 가능"까지 네 단계를 거칩니다: **소스**
(Providers 카탈로그 — 메타데이터이지 추론이 아님) → **등록**(`ollama`
또는 OpenAI 호환 `external` 백엔드, 재시작을 거쳐도 유지) → **배포**(Agents
페이지가 모델 ID를 `arona-agent` 노드에 넘깁니다; 모델 이름을 비워 두면
가장 한가한 노드가 자동으로 선택됩니다) → **라우팅**(Models 페이지; 세션
친화성을 갖춘 최소 진행 중(in-flight) 부하 분산). 외부 백엔드는 첫 프로브가
성공할 때까지 실패 폐쇄(fail-closed) 상태입니다. 각 단계의 정확한 API는
[arona 문서](https://arona.docs.celestia.world)에 있습니다.

## 신원과 계량

![Chest API 키](https://raw.githubusercontent.com/celestia-island/docs.celestia.world/master/res/screenshots/arona-apikeys.png)

![Chest 빌링](https://raw.githubusercontent.com/celestia-island/docs.celestia.world/master/res/screenshots/arona-billing.png)

**API 키**가 곧 신원입니다 — 게이트웨이는 Bearer 토큰으로 `/v1/*`을
인증하며, `curl`과 chest 모두 입구에서 토큰을 제시합니다. **사용량**은 키별
호출 단위 장부입니다: 토큰, 모델, 백엔드, 비용. **빌링** 티어는 할당량
(USD / 토큰 / 속도 제한)을 정합니다; 하나에 닿으면 감속이 아니라 완전한
거부입니다.

## 채팅과 메모리

![Chest 채팅](https://raw.githubusercontent.com/celestia-island/docs.celestia.world/master/res/screenshots/arona-playground.png)

모든 채팅 턴은 메모리 서비스를 통과합니다 — 각 턴의 배지가 그 여부를
알려줍니다. `Memory on`은 라우팅 전에 관련 장기 메모리가 주입되었다는
뜻이고, `Memory offline`은 메모리 서비스에 도달할 수 없다는 뜻입니다(버그가
아니라 정직성 신호입니다); `disabled`는 관련 항목을 찾지 못했다는 뜻입니다.
완료된 턴은 에피소드로 추출되어 영속화되므로 메모리는 재시작을 견딥니다 —
되돌려 쓰기(write-back) 항목은 Memory 페이지에서 직접 삭제할 수 있습니다.

## 패널과 산업 제어

![Chest 에이전트](https://raw.githubusercontent.com/celestia-island/docs.celestia.world/master/res/screenshots/arona-agents.png)

하나의 프롬프트가 패널을 만듭니다; 엔진이 레이아웃을 생성해 scepter의
워크스페이스 저장소에 영속화합니다. 편집은 구조적입니다 — 데이터 소스
바인딩, 컴포넌트 목록, 연결 상태 — 블랙 박스가 아닙니다. Topology와
Holographic은 같은 플릿을 보는 두 가지 뷰이고, Reports는 이력에 대한 의미
기반 검색을 더합니다. 산업 쓰기는 그 무엇이 움직이기 전에 정책 검증과
**사람의 승인**을 통과합니다: 폐쇄 루프의 끝이자 가장 무거운 단계입니다.

![Chest 로그인](https://raw.githubusercontent.com/celestia-island/docs.celestia.world/master/res/screenshots/arona-login.png)

## 더 깊이 들어가기

- arona 플랫폼 전체 참조 — [arona 문서](https://arona.docs.celestia.world)
- chest 작업대와 그 패널 — [shittim-chest 문서](https://shittim-chest.docs.celestia.world)
- 에이전트, 워크스페이스, 산업 쓰기 게이트 — [entelecheia 문서](https://entelecheia.docs.celestia.world)
