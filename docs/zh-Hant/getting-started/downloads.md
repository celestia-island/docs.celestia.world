# 下載

要安裝什麼，取決於你在閉環中的位置。內部封測期間多數參與者只需要桌面應用程式；其餘一切由你的管理員託管，或屬於可選。

## 桌面應用程式（shittim-chest）

shittim-chest 桌面應用程式從每個 `v*` tag 發布。安裝包**未簽署**——首次啟動時請預期作業系統的安全警告。第一個 beta tag 推出之前，下載頁面保持空白。

| 平台 | 資產 |
| --- | --- |
| Linux | `.AppImage` 或 `.deb` |
| Windows 10+ | `.exe`（NSIS）或 `.msi` |
| macOS | 尚未發布 |

發布構建僅涵蓋 Linux 與 Windows；macOS 不在發布管線之內。在首次發布之前（或如果你偏好不安裝），請使用 shittim-chest 的 [webUI](https://dev.celestia.world)。

## 管理面板（arona）

Arona 由伺服器託管——本機沒有任何要安裝的東西。開啟管理員提供的面板網址，並以你的邀請登入。

## 智能體執行環境（可選）

自行執行智能體平台的使用者，請遵循 entelecheia 與 plana 倉庫所記載的統一安裝器。一切都從生態自身的倉庫構建，因此先決條件是 Rust 工具鏈、Docker 與 `just` 任務執行器。

## 深入閱讀

- [快速開始](./quickstart.md) —— 30 分鐘走完閉環。
- [封閉測試指南](./beta-guide.md) —— 封測涵蓋範圍與如何回報缺陷。
- [專案地圖](../ecosystem/projects.md) —— 全量專案清單。
