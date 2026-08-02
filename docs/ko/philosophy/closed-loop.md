# 폐쇄 루프

제품은 루프이지, 어떤 단일 프로젝트가 아닙니다:

> 발견 → 설치 → 인증 → 모델 배포 → 채팅 및 에이전트 실행 →
> 산업 장비 제어 → 검증 및 지원

각 구간은 특정 프로젝트 집합이 소유합니다. 한 구간이 끊겨 있으면 플랫폼은
완성되지 않은 것입니다.

## 구간별 상세

| # | 구간 | 동작 | 프로젝트 |
| --- | --- | --- | --- |
| 1 | **발견** | 잠재 사용자가 생태계를 발견하고, 철학을 이해하고, 진입점을 선택합니다 | [docs.celestia.world](https://docs.celestia.world) (이 사이트), [celestia-island.github.io](https://celestia-island.github.io), [e.celestia.world](https://e.celestia.world) |
| 2 | **설치** | 사용자가 동작하는 시스템을 얻습니다: 관리 패널, 데스크톱/웹 셸, 감독되는 서비스 | [arona](https://github.com/celestia-island/arona) (클라우드 API 관리 패널), [shittim-chest](https://github.com/celestia-island/shittim-chest) (채팅 데스크톱/웹UI), [malkuth](https://github.com/celestia-island/malkuth) (서비스 감독) |
| 3 | **인증** | 제로 트러스트 신원: 등록(초대 게이트), 비율 제한이 있는 로그인, API key, RBAC | [kirino](https://github.com/celestia-island/kirino) (인증 프리미티브 및 RBAC 엔진) |
| 4 | **모델 배포** | 모델 런타임을 선택하고, 노드에 배포하고, 채팅 백엔드에 바인딩하고, 사용량을 계량합니다 | [arona](https://github.com/celestia-island/arona) (패널 + 백엔드), [entelecheia](https://github.com/celestia-island/entelecheia) (scepter 런타임), [plana](https://github.com/celestia-island/plana) (계량 및 가격 책정) |
| 5 | **채팅 및 에이전트** | 모델과 대화하고, 다중 에이전트 협업을 실행하고, 대화를 유지하고, 메모리를 관리합니다 | [shittim-chest](https://github.com/celestia-island/shittim-chest) (UI 및 채팅), [entelecheia](https://github.com/celestia-island/entelecheia) (에이전트 오케스트레이션), [noa](https://github.com/celestia-island/noa) (AI 네이티브 버전 관리) |
| 6 | **산업 제어** | 원격 운영 및 프로토콜 브로커링: Modbus, S7comm, OPC UA; 텔레메트리 및 쓰기 게이트 | [evernight](https://github.com/celestia-island/evernight) (프로토콜 브로커), [aoba](https://github.com/celestia-island/aoba) (Modbus 및 데이터 소스 CLI) |
| 7 | **검증 및 지원** | 실제 하드웨어에서의 통합 테스트, 감독 및 자가 치유, 사용 기록, 피드백 채널 | [celestia-integration](https://github.com/celestia-island/celestia-integration), [malkuth](https://github.com/celestia-island/malkuth), [plana](https://github.com/celestia-island/plana) (사용 기록) |

## 루프의 동작 방식

- **모든 단계가 테스트 가능합니다.** 각 구간에는
  [celestia-integration](https://github.com/celestia-island/celestia-integration)에
  정의된 승인 테스트가 있습니다; 릴리스는 실제 노드에서 전체 루프가 통과할
  때까지 그린(green)이 아닙니다.
- **모든 단계가 관찰 가능합니다.** 감독, 헬스 엔드포인트, 사용 기록이 각
  구간의 상태를 추측이 아닌 가시적인 것으로 만듭니다.
- **조용한 성능 저하가 없습니다.** 구간이 저하되면(예: 메모리 오프라인 또는
  백엔드 도달 불가), API 응답과 UI가 명시적으로 알립니다. 실패는 설계상
  시끄럽습니다.
- **안전은 구간이 아닙니다.** 쓰기 게이트, 정책 검증, 인간 확인은 구간 5와
  6에 엮여 있으며, 끝에 덧붙여지는 것이 아닙니다. [안전 원칙](./safety.md)을
  참조하세요.

## 더 알아보기

- [왜 celestia-island인가](./why.md) — 루프를 정의하는 문제.
- [계층형 아키텍처](./layered-architecture.md) — 조각들이 질서를 유지하는 방법.
- [프로젝트 지도](../ecosystem/projects.md) — 저장소 전체 목록.
- [빠른 시작](../getting-started/quickstart.md) — 30분 만에 루프를 체험해보세요.
