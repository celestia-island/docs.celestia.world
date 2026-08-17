# 다운로드

무엇을 설치할지는 폐쇄 루프에서 여러분의 위치에 따라 달라집니다. 내부 베타
동안 대부분의 참여자는 데스크톱 앱만 있으면 됩니다; 나머지는 모두 관리자가
호스팅하거나 선택 사항입니다.

## 데스크톱 앱 (shittim-chest)

shittim-chest 데스크톱 앱은 모든 `v*` 태그에서
[GitHub Releases](https://github.com/celestia-island/shittim-chest/releases)로
게시됩니다. 인스톨러는 **서명되어 있지 않습니다** — 첫 실행 때 OS 보안 경고가
나타날 것으로 예상하세요. 첫 베타 태그가 푸시되기 전까지는 이 페이지가 비어
있습니다.

| 플랫폼 | 에셋 |
| --- | --- |
| Linux | `.AppImage` 또는 `.deb` |
| Windows 10+ | `.exe` (NSIS) 또는 `.msi` |
| macOS | 아직 게시되지 않음 |

릴리스 빌드는 Linux와 Windows만 다룹니다; macOS는 릴리스 파이프라인에
포함되지 않습니다. 첫 릴리스 전까지(또는 설치를 원하지 않는다면)
shittim-chest [웹UI](https://shittim-chest.docs.celestia.world)를 사용하세요.

## 관리 패널 (arona)

Arona는 서버에서 호스팅됩니다 — 로컬에 설치할 것이 없습니다. 관리자가
제공하는 패널 URL(공개 배포에서는 `https://arona.celestia.world`, 내부에서는
`http://<host>:8420`)을 열고 초대장으로 로그인하세요.

## 에이전트 런타임 (entelecheia/scepter, 선택 사항)

에이전트를 직접 실행하는 고급 사용자를 위해, entelecheia의 README는 plana
저장소의 통합 인스톨러를 규정합니다
([Linux/macOS](https://github.com/celestia-island/plana/blob/master/scripts/install/celestia-install.sh),
[Windows](https://github.com/celestia-island/plana/blob/master/scripts/install/celestia-install.ps1)):

```bash
git clone https://github.com/celestia-island/plana.git
# arona/ 옆에 entelecheia, evernight, scriptum, shittim-chest도 함께 클론하세요
cd arona/scripts/install
bash celestia-install.sh --source-root ../../..
```

Windows 동등 명령(WSL2): `.\celestia-install.ps1 -SourceRoot ..\..\..`

entelecheia 자체를 소스에서 빌드하려면: `just bootstrap`가 워크스페이스를
설치하고, 이어서 `just dev`가 TUI를 실행합니다. 사전 요구 사항은 Rust 1.85+,
Docker, 그리고 `just` 태스크 러너입니다.

## 더 알아보기

- [빠른 시작](./quickstart.md) — 루프를 통과하는 30분 경로.
- [클로즈드 베타 가이드](./beta-guide.md) — 베타가 다루는 범위와 버그 신고 방법.
- [프로젝트 지도](../ecosystem/projects.md) — 전체 프로젝트 목록.
