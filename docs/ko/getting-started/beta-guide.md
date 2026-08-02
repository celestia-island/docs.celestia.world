# 클로즈드 베타 가이드

**내부 클로즈드 베타**는 계정 등록부터 산업 제어까지 제품 루프 전체를
다룹니다. 참여는 초대 전용입니다.

## 베타가 다루는 범위

1. [Arona](https://github.com/celestia-island/arona) 클라우드 API 관리 패널에서
   **계정을 등록하고 API key를 생성**합니다. 베타 기간 동안 패널은 내부
   전용입니다 (배포 호스트의 `arona:8420`).
2. 패널을 통해 **모델을 배포**하고 채팅 백엔드에 바인딩합니다.
3. [shittim-chest](https://github.com/celestia-island/shittim-chest) 데스크톱
   앱에서 **채팅하고 에이전트를 실행**합니다; 에이전트 오케스트레이션은
   entelecheia의 **scepter** 런타임이 제공합니다.
4. **산업 제어**: 원격 운영과 프로토콜 브로커링은
   [evernight](https://github.com/celestia-island/evernight)를 통해
   실행됩니다.

## 접근 권한 얻기

- 접근은 **초대 기반**입니다. 공개 자체 등록은 기본적으로 닫혀 있습니다.
- 초대는 유지보수자가 발급하며 단일 계정에 바인딩됩니다.
- 접근 관련 문의는 [기여하기](../meta/CONTRIBUTING.md)에 나열된 채널을 통해
  연락하세요.

## 버그 보고

이슈 템플릿을 사용하여 버그당 하나의 이슈로 GitHub에 보고하세요:

| 제품 | 저장소 |
| --- | --- |
| 채팅 데스크톱/웹 — shittim-chest | [celestia-island/shittim-chest](https://github.com/celestia-island/shittim-chest/issues) |
| 에이전트 오케스트레이션 — entelecheia/scepter | [celestia-island/entelecheia](https://github.com/celestia-island/entelecheia/issues) |
| 산업 제어 — evernight | [celestia-island/evernight](https://github.com/celestia-island/evernight/issues) |
| 관리 패널 및 플랫폼 — arona/plana | [celestia-island/arona](https://github.com/celestia-island/arona/issues) |

항상 다음을 포함하세요: 환경 정보 (OS, 제품 버전), 재현 단계, 예상 동작과
실제 동작, 관련 로그.

## 알려진 제한 사항

- Arona 패널은 **내부 전용**이며 베타 기간 동안 공개적으로 노출되지
  않습니다.
- 등록은 기본적으로 닫혀 있습니다; 공개 등록은 아직 제공되지 않습니다.
- WebRTC 디바이스 릴레이와 실시간 SCADA 텔레메트리는 실행 중인 scepter
  인스턴스가 필요합니다; 없으면 UI는 시뮬레이션된 데모 데이터로
  폴백합니다.
- 모바일 앱과 IDE 플러그인은 이 베타에 포함되지 않습니다.
- 일부 문서 언어는 부분 번역입니다.

## 더 알아보기

- [빠른 시작](./quickstart.md) — 루프를 통한 30분 경로.
- [왜 celestia-island인가](../philosophy/why.md) — 베타 뒤의 철학.
