# 快速開始

約 30 分鐘走完[閉環](../philosophy/closed-loop.md)。具體網址取決於你的部署；面板網址與邀請請諮詢管理員。

## 1. 取得帳戶

註冊是邀請制：部署的首個使用者成為管理員，此後自助註冊上鎖。向維護者索取邀請，然後在面板註冊（公開部署為 `https://dev.celestia.world`，或你的管理員提供的面板網址）。

## 2. 建立 API 金鑰

在面板為你的帳戶建立 API 金鑰。這把金鑰是你接下來一切操作的身分——模型管理、聊天後端與智能體操作。

## 3. 部署模型

在面板中選擇模型執行環境，部署到節點，並綁定聊天後端。面板展示健康與用量；計量與定價由平台層處理。每個步驟做什麼，見 [Arona](../platforms/arona.md)。

## 4. 聊天與執行智能體

開啟 [shittim-chest](https://dev.celestia.world)（桌面應用程式或 WebUI），以 API 金鑰連接並開始對話。多智能體工作由智能體平台在同一介面背後編排；智能體日誌與工具呼叫在 UI 中可見。見 [Shittim Chest](../platforms/chest.md) 與 [Entelecheia](../platforms/entelecheia.md)。

## 5. 控制工業設備

[evernight](../platforms/evernight.md) 執行後，接入協定橋（Modbus、S7comm、OPC UA）、訂閱遙測，並在策略校驗與人工確認之後發起寫入。內部封測期間此環節執行於模擬或實驗室設備；安全鏈在兩種情況下完全相同。

## 6. 驗證

查看監督狀態（[malkuth](https://github.com/celestia-island/malkuth) 管理的服務）、檢查用量紀錄，並按[封測指南](./beta-guide.md)的管道回報問題。若有斷裂，說明閉環尚未完成——告訴我們斷在哪裡。

## 出了故障怎麼辦？

- **服務掛了** —— 監督應已重啟它；查看服務狀態頁或日誌。
- **面板打不開** —— 確認主機/連接埠正確。
- **記憶或召回不可用** —— API 回應與 UI 會顯式標註；沒有它聊天仍可運作。

## 深入閱讀

- [封閉測試指南](./beta-guide.md) —— 封測涵蓋範圍與如何回報缺陷。
- [閉環](../philosophy/closed-loop.md) —— 這些步驟背後的哲學。
