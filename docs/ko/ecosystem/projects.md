# 프로젝트 지도

celestia-island 플랫폼의 저장소와 제품 전체 목록을 계층별로 정리했습니다.
링크가 있는 이름은 오늘 바로 읽을 수 있는 공개 저장소입니다; 링크가 없는
이름은 플랫폼과 함께 배포되지만 아직 소스가 공개되지 않은 제품입니다. 문서
사이트가 표시된 저장소는 자체 *방법* 문서를 제공합니다; 나머지는 저장소
안에서 문서화되며, 열람하려면 해당 저장소에 대한 접근 권한이 필요합니다.

## 계층 0 — 인증

| 프로젝트 | 역할 | 문서 |
| --- | --- | --- |
| [kirino](https://github.com/celestia-island/kirino) | 제로 트러스트 인증 및 권한 부여: 세션, 권한, 비율 제한 | [kirino.docs.celestia.world](https://kirino.docs.celestia.world) |

## 계층 1 — 플랫폼

| 프로젝트 | 역할 | 문서 |
| --- | --- | --- |
| [plana](https://github.com/celestia-island/plana) | 공유 프로토콜 타입, 전송, 계량, 그리고 모든 서비스가 소비하는 기반 기능 | 저장소 |
| [provider-registry](https://github.com/celestia-island/provider-registry) | 제품 전반이 공유하는 모델 및 제공자 카탈로그 | 저장소 |

## 계층 2 — UI

| 프로젝트 | 역할 | 문서 |
| --- | --- | --- |
| [hikari](https://github.com/celestia-island/hikari) | 모든 웹UI가 공유하는 UI 컴포넌트 라이브러리 | 저장소 |

## 계층 3 — 서비스

| 프로젝트 | 역할 | 문서 |
| --- | --- | --- |
| arona | 모델 게이트웨이 및 배포 패널: 키, 백엔드, 라우팅, 사용량 | [Arona](../platforms/arona.md) |
| shittim-chest | 채팅, 패널 및 연동 — 워크벤치 표면 | [Shittim Chest](../platforms/chest.md) |
| entelecheia | 에이전트 플랫폼: 에이전트, 장기 메모리, 시맨틱 검색, 산업 연동 | [Entelecheia](../platforms/entelecheia.md) |
| evernight | 산업 프로토콜 브로커: 필드 프로토콜, 알람, 기록, 엣지 추론 | [Evernight](../platforms/evernight.md) |
| [malkuth](https://github.com/celestia-island/malkuth) | 서비스 감독: 롤링 업데이트, 헬스 프로브, 리버스 프록시, 크래시 복구 | [malkuth.docs.celestia.world](https://malkuth.docs.celestia.world) |
| [lagrange](https://github.com/celestia-island/lagrange) | 이 사이트와 모든 프로젝트 문서 사이트의 기반이 되는 문서 엔진 | [lagrange.docs.celestia.world](https://lagrange.docs.celestia.world) |
| celestia-erp | 비즈니스 백오피스: 조직, 과금, 인보이스 | — |
| electrode_recon | 전극 미세구조 연산 엔진 — 엔진 패브릭 위의 첫 외부 인스턴스 | — |

## 도구 및 라이브러리

| 프로젝트 | 역할 | 문서 |
| --- | --- | --- |
| [noa](https://github.com/celestia-island/noa) | 격리된 워크스페이스를 갖춘 에이전트 네이티브 분산 버전 관리 | [저장소](https://github.com/celestia-island/noa) |
| [seia](https://github.com/celestia-island/seia) | 다중 엔진 웹 검색 | [seia.docs.celestia.world](https://seia.docs.celestia.world) |
| [aoba](https://github.com/celestia-island/aoba) | 다중 프로토콜 디버깅 및 시뮬레이션 CLI (Modbus RTU 등) | [aoba.docs.celestia.world](https://aoba.docs.celestia.world) |
| [ichika](https://github.com/celestia-island/ichika) | 메시지 파이프 위의 스레드 풀 파이프라인 | 저장소 |
| [yuuka](https://github.com/celestia-island/yuuka) | 조합된 중첩 구조와 JSON 병합/패치를 위한 매크로 | 저장소 |
| [kou](https://github.com/celestia-island/kou) | 가상 터미널 엔진: PTY, VT100/ANSI, 인라인 그래픽 | 저장소 |
| [hifumi](https://github.com/celestia-island/hifumi) | 버전 간 데이터 마이그레이션을 위한 직렬화 | 저장소 |
| [lacrymira](https://github.com/celestia-island/lacrymira) | 하나의 명령 표면 뒤에 숨긴 SQL 및 KV용 타입 지정 데이터 접근 | 저장소 |
| [himari](https://github.com/celestia-island/himari) | 차원을 갖는 수식 중간 표현 | 저장소 |
| [kotama](https://github.com/celestia-island/kotama) | 리버스 엔지니어링 툴킷: 분해, 디컴파일, 교차 참조 | 저장소 |
| [ayane](https://github.com/celestia-island/ayane) | 메일 서비스: 제어 평면, 웹메일, 보호 | 저장소 |
| [aris](https://github.com/celestia-island/aris) | servo에서 파생되어 라이브러리로 임베드 가능한 순수 Rust 브라우저 엔진 | 저장소 |
| [shirabe](https://github.com/celestia-island/shirabe) | 헤드리스 브라우저 자동화 및 디버깅 | 저장소 |
| [tairitsu](https://github.com/celestia-island/tairitsu) | WASM 컴포넌트 모델 위의 풀스택 프레임워크 | 저장소 |
| [akivili](https://github.com/celestia-island/akivili) | 에이전트 확장을 위한 플러그인 호스트 및 SDK | 저장소 |
| [celestia-plugin](https://github.com/celestia-island/celestia-plugin) | Python 플러그인 및 엔진 SDK | 저장소 |
| [shun](https://github.com/celestia-island/shun) | 설치 프로그램, 플래셔, 포터블 모드 페이로드 전달 | 저장소 |
| arcaea | 페르소나 프로토콜 라이브러리 | — |
| scriptum | 에이전트 플랫폼용 터미널 인터페이스 | — |
| official-plugins | 퍼스트 파티 플러그인 패키지 | — |

## 엣지 및 하드웨어

| 프로젝트 | 역할 | 문서 |
| --- | --- | --- |
| [kei](https://github.com/celestia-island/kei) | ARM64 및 RISC-V 엣지 게이트웨이용 Rust 커널 | 저장소 |
| [hare](https://github.com/celestia-island/hare) | 임베디드 산업 노드용 `no_std` 브리지 라이브러리 | 저장소 |
| evernight-appliance | 어플라이언스 배포판: 부트 펌웨어, 플래셔, 드라이버 계약 | — |

## 인프라 및 툴링

| 프로젝트 | 역할 | 문서 |
| --- | --- | --- |
| [celestia-devtools](https://github.com/celestia-island/celestia-devtools) | 공유 개발 툴체인: 빌드 레시피, 린팅, 릴리스 게이트 | 저장소 |
| [cherino](https://github.com/celestia-island/cherino) | 에이전트 실행을 위한 샌드박스 컨테이너 추상화 | 저장소 |
| [celestia-artifacts](https://github.com/celestia-island/celestia-artifacts) | 릴리스용 공개 바이너리 및 이미지 아티팩트 호스팅 | 저장소 |
| celestia-integration | 루프 전체를 위한 저장소 간 통합 테스트 | — |
| fuuka | 자체 호스팅 CI 실행 평면 | — |
| [sysl](https://github.com/celestia-island/sysl) | 이 코드 대부분이 사용하는 Synthetic Source License | 저장소 |

## 웹 프레즌스

| 속성 | 역할 | 문서 |
| --- | --- | --- |
| [celestia-island.github.io](https://celestia-island.github.io) | 조직 프레즌스 | 저장소 |
| [docs.celestia.world](https://docs.celestia.world) | 이 사이트 — 철학, 지도, 시작하기 | 저장소 |
| [e.celestia.world](https://e.celestia.world) | 공개 랜딩 페이지 | 저장소 |
| [dev.celestia.world](https://dev.celestia.world) | 패널 및 개발자 대시보드 (베타 기간 초대제) | 저장소 |
| [celestia.ac.cn](https://celestia.ac.cn) | 회사 및 엔터프라이즈 서비스 사이트 | 저장소 |

## 더 알아보기

- [계층 구조](../philosophy/layered-architecture.md) — 이 계층들이 존재하는 이유.
- [폐쇄 루프](../philosophy/closed-loop.md) — 프로젝트들이 루프 위에서 협력하는 방식.
- [사이트 및 소유권](./sites.md) — 누가 무엇을 어디에 문서화하는지.
