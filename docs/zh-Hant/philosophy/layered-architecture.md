# 分層架構

生態之所以可控，是因為它被嚴格分層。依賴只朝一個方向：**下游服務消費上游能力；通用能力絕不重複實作。**

## 四層結構

| 層 | 專案 | 提供什麼 |
| --- | --- | --- |
| **第 0 層 — 認證** | [kirino](https://github.com/celestia-island/kirino) | 零信任身分：認證、工作階段、權限 |
| **第 1 層 — 平台** | [plana](https://github.com/celestia-island/plana) | 共享協定型別、傳輸，以及每個服務都需要的設施 |
| **第 2 層 — UI** | [hikari](https://github.com/celestia-island/hikari) | 全體 WebUI 共享的元件庫 |
| **第 3 層 — 服務** | arona、shittim-chest、entelecheia、evernight、[malkuth](https://github.com/celestia-island/malkuth)、[lagrange](https://github.com/celestia-island/lagrange) | 僅業務邏輯。消費第 0–2 層，加上讓每個產品成真的行為 |

## 教義

1. **絕不實作第二遍。** 寫程式碼前先問：kirino 有嗎？plana 有嗎？hikari 有嗎？服務裡重寫上游能力是缺陷，不是功能。
2. **通用能力放上游。** 會被兩個以上服務複用的功能，先建進 kirino、plana 或 hikari，再被消費。
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
