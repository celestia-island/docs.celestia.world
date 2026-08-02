# 계층형 아키텍처

생태계는 엄격하게 계층화되어 있기 때문에 관리 가능한 상태를 유지합니다.
의존성은 한 방향만 가리킵니다: **하류 서비스는 상류 기능을 소비하고, 일반
기능은 절대 다시 구현되지 않습니다.**

## 네 개의 계층

| 계층 | 프로젝트 | 제공하는 것 |
| --- | --- | --- |
| **계층 0 — 인증** | [kirino](https://github.com/celestia-island/kirino) | 제로 트러스트 프리미티브: JWT 서명 및 갱신, Argon2id 비밀번호 해싱, 로그인 비율 제한, RBAC 엔진, 초대 저장소, 세션 |
| **계층 1 — 플랫폼** | [plana](https://github.com/celestia-island/plana) | 공유 기능: JSON-RPC 2.0 타입 및 라우팅, 서비스 DTO, 네트워크 감지, SSE 세션, 회로 차단기, LLM 계량 및 가격 책정 |
| **계층 2 — UI** | [hikari](https://github.com/celestia-island/hikari) | 모든 웹UI가 공유하는 UI 컴포넌트 라이브러리 (Vue/TS + Rust) |
| **계층 3 — 서비스** | [arona](https://github.com/celestia-island/arona), [shittim-chest](https://github.com/celestia-island/shittim-chest), [entelecheia](https://github.com/celestia-island/entelecheia), [evernight](https://github.com/celestia-island/evernight), [malkuth](https://github.com/celestia-island/malkuth), [lagrange](https://github.com/celestia-island/lagrange) | 비즈니스 로직만 포함합니다. 계층 0–2를 소비하고 각 제품을 실제로 만드는 동작을 추가합니다 |

## 원칙

1. **절대 두 번 구현하지 않기.** 코드를 작성하기 전에 물어보세요: kirino에
   있나요? plana에 있나요? hikari에 있나요? 예: JSON-RPC 타입은 plana에서,
   JWT는 kirino에서, 로그인 비율 제한은 kirino에서, 회로 차단기는 plana에서,
   헬스 DTO는 plana에서, 가격 책정은 plana에서 가져옵니다.
2. **일반 기능은 상류로.** 두 개 이상의 서비스가 재사용할 기능은 kirino,
   plana 또는 hikari에 먼저 구축된 후 소비됩니다.
3. **역방향 의존성 없음.** 서비스는 kirino/plana/hikari에 의존합니다;
   plana는 kirino에 의존할 수 있습니다; kirino는 plana나 hikari에 절대
   의존하지 않습니다.
4. **소비하기 전에 상류를 확장하세요.** 상류에 필요한 기능이 없으면 상류를
   확장한 다음 소비합니다. 새 기능이 서비스에서 프로토타이핑된 후 나중에
   다시 구현되는 일은 없습니다.
5. **저장소 간 의존성은 git 참조입니다.** 모든 저장소는 로컬 경로
   의존성이 아니라 `master` 브랜치(또는 고정된 버전)에 대한 git 참조를 통해
   상류를 소비합니다. 모든 저장소는 모든 머신에서 동일하게 빌드됩니다.

## 왜 중요한가

- **하나의 수정이 전파됩니다.** kirino의 보안 수정은 의존성 업그레이드만으로
  모든 서비스에 도달하며, 재구현을 뒤지는 일이 없습니다.
- **리뷰는 위험에 비례합니다.** 계층 3 변경은 제품 로직이고, 계층 0 변경은
  인프라입니다 — 리뷰 기준도 이를 반영합니다.
- **지도가 읽기 쉽게 유지됩니다.** 새 엔지니어는 이 페이지를 읽고 어떤
  기능이 어디에 있는지 알 수 있습니다. [프로젝트 지도](../ecosystem/projects.md)는
  전체 목록입니다.

## 더 알아보기

- [왜 celestia-island인가](./why.md) — 계층화 뒤의 문제.
- [안전 원칙](./safety.md) — 계층 위에 놓이는 원칙.
- [프로젝트 지도](../ecosystem/projects.md) — 계층별 모든 저장소.
