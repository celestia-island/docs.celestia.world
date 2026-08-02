# 프로젝트 지도

celestia-island 저장소의 전체 목록으로, 계층별로 정리되어 있습니다. 문서
사이트가 표시된 저장소는 `<name>.docs.celestia.world`에서 자체 *방법* 문서를
제공합니다; 나머지는 저장소 안에서 문서화됩니다.

## 계층 0 — 인증

| 프로젝트 | 역할 | 문서 |
| --- | --- | --- |
| [kirino](https://github.com/celestia-island/kirino) | 제로 트러스트 인증 및 RBAC: JWT 세션, Argon2id 해싱, 로그인 비율 제한, 권한 엔진 | [kirino.docs.celestia.world](https://kirino.docs.celestia.world) |

## 계층 1 — 플랫폼

| 프로젝트 | 역할 | 문서 |
| --- | --- | --- |
| [plana](https://github.com/celestia-island/plana) | 공유 타입, JSON-RPC 클라이언트 및 서버, SSE 세션, 회로 차단기, LLM 계량 및 가격 책정, 관리 UI 셸 | 저장소 |
| [provider-registry](https://github.com/celestia-island/provider-registry) | 모델 및 공급자 레지스트리 (entrypoint TOML 형식) | 저장소 |

## 계층 2 — UI

| 프로젝트 | 역할 | 문서 |
| --- | --- | --- |
| [hikari](https://github.com/celestia-island/hikari) | 모든 웹UI가 공유하는 UI 컴포넌트 라이브러리 (Vue/TS + Rust) | 저장소 |

## 계층 3 — 서비스

| 프로젝트 | 역할 | 문서 |
| --- | --- | --- |
| [arona](https://github.com/celestia-island/arona) | 클라우드 API 관리 패널: 계정, API key, 모델 배포, 백엔드, 사용 기록 | 저장소 |
| [shittim-chest](https://github.com/celestia-island/shittim-chest) | 채팅 데스크톱/웹UI 및 셸 | [shittim-chest.docs.celestia.world](https://shittim-chest.docs.celestia.world) |
| [entelecheia](https://github.com/celestia-island/entelecheia) | 다중 에이전트 협업 플랫폼: exec 전용 마이크로커널, scepter 오케스트레이션 서버, IEPL 실행 파이프라인 | [entelecheia.docs.celestia.world](https://entelecheia.docs.celestia.world) |
| [evernight](https://github.com/celestia-island/evernight) | 산업 프로토콜 브로커: Modbus, S7comm, OPC UA; 원격 운영, 텔레메트리, 쓰기 게이트 | [evernight.docs.celestia.world](https://evernight.docs.celestia.world) |
| [malkuth](https://github.com/celestia-island/malkuth) | 서비스 감독 도구 키트: 롤링 업데이트, 헬스 프로브, 리버스 프록시, 크래시 루프 복구 | [malkuth.docs.celestia.world](https://malkuth.docs.celestia.world) |
| [lagrange](https://github.com/celestia-island/lagrange) | 이 사이트와 모든 프로젝트 문서 사이트를 구동하는 마크다운 문서 엔진 | [lagrange.docs.celestia.world](https://lagrange.docs.celestia.world) |

## 도구 및 라이브러리

| 프로젝트 | 역할 | 문서 |
| --- | --- | --- |
| [noa](https://github.com/celestia-island/noa) | AI 네이티브 분산 버전 관리: 에이전트별 작업 공간 격리, JSONL 추가 전용 로그, 스냅샷 히스토리 | [noa.docs.celestia.world](https://noa.docs.celestia.world) |
| [seia](https://github.com/celestia-island/seia) | 다중 엔진 웹 검색 라이브러리 및 CLI | [seia.docs.celestia.world](https://seia.docs.celestia.world) |
| [ichika](https://github.com/celestia-island/ichika) | 스레드 풀 파이프라인 매크로 (flume 기반 메시지 파이프) | [ichika.docs.celestia.world](https://ichika.docs.celestia.world) |
| [yuuka](https://github.com/celestia-island/yuuka) | 단순 매크로에서 복잡한 중첩 구조를 생성하는 절차 매크로 | [yuuka.docs.celestia.world](https://yuuka.docs.celestia.world) |
| [aoba](https://github.com/celestia-island/aoba) | Modbus 및 데이터 소스 CLI | [aoba.docs.celestia.world](https://aoba.docs.celestia.world) |
| [kou](https://github.com/celestia-island/kou) | 독립형 가상 터미널 엔진: PTY 관리, VT100/ANSI | 저장소 |
| [hifumi](https://github.com/celestia-island/hifumi) | 버전 간 데이터 마이그레이션용 직렬화 라이브러리 | 저장소 |
| [aris](https://github.com/celestia-island/aris) | servo에서 파생된 브라우저 엔진, 라이브러리로 임베드 가능 (디지털 트윈용 WebGL) | 저장소 |
| [shirabe](https://github.com/celestia-island/shirabe) | 가벼운 Rust 네이티브 브라우저 자동화 및 디버그 라이브러리 | 저장소 |
| [tairitsu](https://github.com/celestia-island/tairitsu) | WASM 컴포넌트 모델 기반 풀스택 프레임워크 | 저장소 |
| [ratatui-markdown](https://github.com/celestia-island/ratatui-markdown) | ratatui TUI용 마크다운 렌더링 | 저장소 |
| [arcaea](https://github.com/celestia-island/arcaea) | celestia persona 프로토콜용 Rust 라이브러리 | 저장소 |
| [scriptum](https://github.com/celestia-island/scriptum) | entelecheia용 터미널 인터페이스 (TUI): scepter 서버와 대화하는 "단순 디스플레이" | 저장소 |

## 엣지 및 하드웨어

| 프로젝트 | 역할 | 문서 |
| --- | --- | --- |
| [kei](https://github.com/celestia-island/kei) | ARM64/RISC-V 엣지 디바이스용 Rust OS 커널; 장기 지평을 위한 결정적 실시간 코어 | 저장소 |

## 인프라 및 도구

| 프로젝트 | 역할 | 문서 |
| --- | --- | --- |
| [celestia-devtools](https://github.com/celestia-island/celestia-devtools) | 공유 개발 도구 체인: justfile 레시피, 패치 등록, 린팅 | 저장소 |
| [celestia-integration](https://github.com/celestia-island/celestia-integration) | 전체 루프에 대한 실제 하드웨어 통합 테스트 스위트 | 저장소 |
| [sysl](https://github.com/celestia-island/sysl) | Synthetic Source License (SySL): AI 생성 코드를 위해 설계된 라이선스 | 저장소 |

## 웹 프레즌스

| 속성 | 역할 | 문서 |
| --- | --- | --- |
| [celestia-island.github.io](https://celestia-island.github.io) | 조직 프레즌스 | 저장소 |
| [docs.celestia.world](https://docs.celestia.world) | 이 사이트 — 철학, 지도, 시작하기 | 저장소 |
| [e.celestia.world](https://e.celestia.world) | 공개 랜딩 페이지 | 저장소 |
| [dev.celestia.world](https://dev.celestia.world) | 개발자 포털 | 저장소 |
| [arona.celestia.world](https://arona.celestia.world) | 클라우드 API 관리 패널 (제품) | — |

## 더 알아보기

- [계층형 아키텍처](../philosophy/layered-architecture.md) — 이 계층들이 존재하는 이유.
- [폐쇄 루프](../philosophy/closed-loop.md) — 루프를 따라 프로젝트가 협력하는 방식.
- [사이트 및 소유권](./sites.md) — 누가 무엇을 문서화하고 어디에 있는지.
