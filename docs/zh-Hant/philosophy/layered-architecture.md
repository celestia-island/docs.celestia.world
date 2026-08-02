# 分層架構

生態之所以可控，是因為它被嚴格分層。依賴只朝一個方向：**下游服務消費上游能力；通用能力絕不重複實作。**

## 四層結構

| 層 | 專案 | 提供什麼 |
| --- | --- | --- |
| **第 0 層 — 認證** | [kirino](https://github.com/celestia-island/kirino) | 零信任原語：JWT 簽發與刷新、Argon2id 密碼雜湊、登入限流、RBAC 引擎、邀請儲存、工作階段 |
| **第 1 層 — 平台** | [plana](https://github.com/celestia-island/plana) | 共享設施：JSON-RPC 2.0 型別與路由、服務 DTO、網路探測、SSE 工作階段、斷路器、LLM 計量與定價 |
| **第 2 層 — UI** | [hikari](https://github.com/celestia-island/hikari) | 全體 WebUI 共享的 UI 元件庫（Vue/TS + Rust） |
| **第 3 層 — 服務** | [arona](https://github.com/celestia-island/arona)、[shittim-chest](https://github.com/celestia-island/shittim-chest)、[entelecheia](https://github.com/celestia-island/entelecheia)、[evernight](https://github.com/celestia-island/evernight)、[malkuth](https://github.com/celestia-island/malkuth)、[lagrange](https://github.com/celestia-island/lagrange) | 僅業務邏輯。消費第 0–2 層，加上讓每個產品成真的行為 |

## 教義

1. **絕不實作第二遍。** 寫程式碼前先問：kirino 有嗎？plana 有嗎？hikari 有嗎？例如：JSON-RPC 型別來自 plana，JWT 來自 kirino，登入限流來自 kirino，斷路器來自 plana，health DTO 來自 plana，定價來自 plana。
2. **通用能力放上游。** 會被兩個以上服務複用的功能，先建進 kirino / plana / hikari，再被消費。
3. **禁止反向依賴。** 服務依賴 kirino/plana/hikari；plana 可依賴 kirino；kirino 永不依賴 plana 或 hikari。
4. **先擴展上游，再消費。** 上游缺能力就擴展上游，然後再消費。新能力絕不在服務裡先做一版、之後再重寫。
5. **跨倉依賴一律 git reference。** 所有倉庫透過 git reference 消費上游（`master` 分支或釘版），禁止本機 path 依賴。每個倉庫在任何機器上構建結果一致。

## 為什麼重要

- **一次修復，處處生效。** kirino 的安全修復隨著依賴升級到達每個服務，而不是在複製品裡逐個排查。
- **審查與風險成比例。** 第 3 層改動是產品邏輯；第 0 層改動是基礎設施——審查門檻因此不同。
- **地圖保持可讀。** 新工程師讀這一頁，就知道任何能力住在哪裡。[專案地圖](../ecosystem/projects.md)是全量清單。

## 深入閱讀

- [為什麼有 celestia-island](./why.md) —— 分層背後的問題。
- [安全原則](./safety.md) —— 坐落在各層之上的教義。
- [專案地圖](../ecosystem/projects.md) —— 按層排列的全部倉庫。
