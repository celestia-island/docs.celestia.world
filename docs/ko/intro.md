# celestia-island 문서에 오신 것을 환영합니다

**celestia-island**는 산업용 AI 제어를 위한 프로젝트 모음입니다: 다중 에이전트
협업, 원격 운영, 안전 필수(safety-critical) 자동화가 포함됩니다. 이 사이트는
그 *이유* — 철학, 생태계 지도, 진입점 — 를 담고 있습니다. *방법* 은 각
프로젝트별 문서 사이트에 있으며 여기에서 연결됩니다.

## 세 가지 질문에 대한 답변

| 질문 | 위치 | 찾을 수 있는 내용 |
| --- | --- | --- |
| **왜 존재하나요?** | [철학](./philosophy/why.md) | 우리가 해결하려는 문제, 폐쇄 루프, 안전 원칙, 장기적 지평 |
| **무엇이 있나요?** | [생태계](./ecosystem/projects.md) | 모든 프로젝트, 루프 안에서의 역할, 문서가 있는 곳 |
| **어떻게 시작하나요?** | [시작하기](./getting-started/quickstart.md) | 계정부터 동작하는 채팅 에이전트와 산업 제어까지 30분 경로 |

## 한 문단 요약

celestia-island는 AI 기반 산업 제어를 위한 **폐쇄 루프**를 발견에서 검증까지
구축합니다: 발견 → 설치 → 인증 → 모델 배포 → 채팅 및 에이전트 실행 → 산업
장비 제어 → 모든 것 검증. 루프는 작고 엄격하게 계층화된 조각들로
조립됩니다: 인증 프리미티브([kirino](https://github.com/celestia-island/kirino)),
플랫폼 기반 시설([plana](https://github.com/celestia-island/plana)), UI
컴포넌트([hikari](https://github.com/celestia-island/hikari)), 그리고
비즈니스 로직만 구현하는 서비스들([arona](https://github.com/celestia-island/arona),
[shittim-chest](https://github.com/celestia-island/shittim-chest),
[entelecheia](https://github.com/celestia-island/entelecheia),
[evernight](https://github.com/celestia-island/evernight))로 구성됩니다.
어떤 것도 두 번 구현되지 않습니다: 일반 기능은 상류에서 한 번 구축되고,
모든 서비스가 하류에서 이를 소비합니다.

이 모든 것의 이유는 단순한 관찰에서 비롯됩니다: 달에서는 왕복 통신이 2.6초,
화성에서는 6분에서 44분이 걸립니다. 그곳의 로봇은 지구의 인간을 기다릴 수
없습니다 — 로컬에서 자율적으로 동작해야 합니다. 우리가 오늘 산업 제어를 위해
구축하는 의사결정 계층, 세계 모델, 안전 게이트는 내일의 자율성이 필요로 할
것과 같은 형태입니다.

## 모든 것이 있는 곳

- **프로젝트별 문서** — 각 저장소에서 빌드된 `<name>.docs.celestia.world`.
  전체 목록은 [사이트 및 소유권](./ecosystem/sites.md)에서 확인하세요.
- **조직 프레즌스** — [celestia-island GitHub 조직](https://github.com/celestia-island).
- **제품 패널(베타 기간 중 WIP)** — [arona](https://arona.celestia.world)
  (클라우드 API 관리), [dev](https://dev.celestia.world) (개발자 포털);
  베타가 끝날 때까지 실시간 패널은 내부 `arona:8420`에서 실행됩니다.

언어 전환기(오른쪽 하단)를 사용하여 이 사이트를 다른 언어로 읽을 수
있습니다. 콘텐츠는 영어로 작성되며, 번역은 동일한 구조를 따릅니다.
