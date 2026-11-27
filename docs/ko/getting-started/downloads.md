# 다운로드

무엇을 설치할지는 폐쇄 루프에서 당신의 위치에 따라 달라집니다. 내부 베타
기간에는 대부분의 참가자에게 데스크톱 앱만 필요하고, 나머지는 관리자가
호스팅하거나 선택 사항입니다.

## 데스크톱 앱 (shittim-chest)

shittim-chest 데스크톱 앱은 모든 `v*` 태그에서 배포됩니다. 설치 프로그램은
**서명되지 않았습니다** — 첫 실행 시 OS 보안 경고가 표시되는 것이
정상입니다. 첫 베타 태그가 푸시되기 전까지 다운로드 페이지는 비어 있습니다.

| 플랫폼 | 산출물 |
| --- | --- |
| Linux | `.AppImage` 또는 `.deb` |
| Windows 10+ | `.exe` (NSIS) 또는 `.msi` |
| macOS | 아직 배포되지 않음 |

릴리스 빌드는 Linux와 Windows만 지원합니다; macOS는 릴리스 파이프라인에
포함되지 않습니다. 첫 릴리스 전까지(또는 설치 없이 쓰고 싶다면)
shittim-chest [웹UI](https://dev.celestia.world)를 이용하세요.

## 관리 패널 (arona)

Arona는 서버에서 호스팅됩니다 — 로컬에 설치할 것은 없습니다. 관리자가
제공하는 패널 URL을 열고 초대장으로 로그인하세요.

## 에이전트 런타임 (선택 사항)

에이전트 플랫폼을 직접 운영하려는 사용자는
[plana](https://github.com/celestia-island/plana/tree/master/scripts/install)의
통합 설치 프로그램을
([Linux/macOS](https://github.com/celestia-island/plana/blob/master/scripts/install/celestia-install.sh),
[Windows](https://github.com/celestia-island/plana/blob/master/scripts/install/celestia-install.ps1))
사용합니다. 모든 것이 생태계 자체 저장소에서 빌드되므로, 사전 요구 사항은
Rust 툴체인, Docker, `just` 작업 실행기입니다.

## 더 알아보기

- [빠른 시작](./quickstart.md) — 루프를 30분에 걷는 길.
- [클로즈드 베타 가이드](./beta-guide.md) — 베타의 범위와 버그 보고 방법.
- [프로젝트 지도](../ecosystem/projects.md) — 전체 프로젝트 목록.
