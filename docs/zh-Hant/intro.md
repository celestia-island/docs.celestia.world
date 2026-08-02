# 歡迎來到 celestia-island

**celestia-island** 是一組面向工業 AI 控制的專案群：多智能體協作、遠端操作與安全關鍵自動化。本站承載它的 *為什麼* —— 整體哲學、生態地圖與入口；*怎麼做* 則由連結指向的各專案獨立文件站承擔。

## 回答三個問題

| 問題 | 位置 | 內容 |
| --- | --- | --- |
| **為什麼存在？** | [哲學](./philosophy/why.md) | 要解決的問題、閉環、安全教義與長期願景 |
| **裡面有什麼？** | [生態](./ecosystem/projects.md) | 每個專案、它在閉環中的角色及其文件位置 |
| **怎麼開始？** | [快速開始](./getting-started/quickstart.md) | 從註冊到聊天智能體與工業控制的 30 分鐘路徑 |

## 一段話總結

celestia-island 為 AI 驅動的工業控制構建從發現到驗證的**閉環**：發現 → 安裝 → 認證 → 部署模型 → 聊天與智能體 → 工業控制 → 驗證支撐。閉環由嚴格分層的元件拼裝而成：認證原語（[kirino](https://github.com/celestia-island/kirino)）、平台設施（[plana](https://github.com/celestia-island/plana)）、UI 元件（[hikari](https://github.com/celestia-island/hikari)），以及只實作業務邏輯的服務層（[arona](https://github.com/celestia-island/arona)、[shittim-chest](https://github.com/celestia-island/shittim-chest)、[entelecheia](https://github.com/celestia-island/entelecheia)、[evernight](https://github.com/celestia-island/evernight)）。任何能力都不實作第二遍：通用能力在上游構建一次，由全部下游服務消費。

這一切源於一個簡單的觀察：月球上訊號往返需要 2.6 秒，火星上需要 6 到 44 分鐘。那裡的機器人等不了地球上的人——它們必須本機自主。我們今天為工業控制構建的決策層、世界模型與安全門，正是未來自主所需的同一形態。

## 一切都在哪裡

- **專案文件** —— `<name>.docs.celestia.world`，由各倉庫自身構建。完整清單見[站點分工](./ecosystem/sites.md)。
- **組織存在** —— [celestia-island on GitHub](https://github.com/celestia-island)。
- **產品入口（內測期間 WIP）** —— [arona](https://arona.celestia.world)（雲 API 管理）、[dev](https://dev.celestia.world)（開發者入口）；內測期間實際控制台運行於內部 `arona:8420`。

使用右下角語言切換器切換本站語言。內容以英文為準；各語種遵循同一結構。
