# 下載

要安裝什麼，取決於你在閉環中的位置。內部封閉測試期間，多數參與者只需要桌面應用程式；其餘一切由你的管理員託管，或屬於可選。

## 桌面應用程式（shittim-chest）

shittim-chest 桌面應用程式從每個 `v*` tag 發布到 [GitHub Releases](https://github.com/celestia-island/shittim-chest/releases)。安裝包**未簽署** —— 首次啟動時請預期作業系統的安全警告。第一個 beta tag 推出之前，該頁面保持空白。

| 平台 | 資產 |
| --- | --- |
| Linux | `.AppImage` 或 `.deb` |
| Windows 10+ | `.exe`（NSIS）或 `.msi` |
| macOS | 尚未發布 |

發布構建僅涵蓋 Linux 與 Windows；macOS 不在發布管線之內。在首次發布之前（或如果你偏好不安裝），請使用 shittim-chest 的 [webUI](https://shittim-chest.docs.celestia.world)。

## 管理控制台（arona）

Arona 由伺服器託管 —— 本機沒有任何要安裝的東西。開啟管理員提供的控制台網址（公開部署為 `https://arona.celestia.world`，內網為 `http://<主機>:8420`），並以你的邀請登入。

## 智能體執行環境（entelecheia/scepter，可選）

對於自行執行智能體的進階使用者，entelecheia 的 README 指定使用來自 plana 倉庫的統一安裝器（[Linux/macOS](https://github.com/celestia-island/plana/blob/master/scripts/install/celestia-install.sh)、[Windows](https://github.com/celestia-island/plana/blob/master/scripts/install/celestia-install.ps1)）：

```bash
git clone https://github.com/celestia-island/plana.git
# Also clone entelecheia, evernight, scriptum, shittim-chest alongside arona/
cd arona/scripts/install
bash celestia-install.sh --source-root ../../..
```

Windows 對應命令（WSL2）：`.\celestia-install.ps1 -SourceRoot ..\..\..`

要從原始碼構建 entelecheia 本體：`just bootstrap` 安裝工作區，然後 `just dev` 啟動 TUI。先決條件是 Rust 1.85+、Docker 與 `just` 任務執行器。

## 深入閱讀

- [快速開始](./quickstart.md) —— 30 分鐘走完閉環。
- [封閉測試指南](./beta-guide.md) —— 封閉測試涵蓋範圍與如何回報缺陷。
- [專案地圖](../ecosystem/projects.md) —— 全量專案清單。
