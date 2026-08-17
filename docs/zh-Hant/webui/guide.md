# Web UI —— 從第一句話開始的旅程

兩個介面、一條流程：**arona** 是無頭的控制平面（模型、金鑰、帳本、記憶）；
**shittim-chest** 則是你眼前的工作台（對話、面板、看見世界）。以下每個畫面
都是 chest 的視圖 —— chest 經由其 RPC 介面與 arona 交談；arona 本身不附帶
任何 UI。

![chest 後端控制台](https://raw.githubusercontent.com/celestia-island/docs.celestia.world/master/res/screenshots/arona-dashboard.png)

## 模型：從來源到呼叫

一個模型從「存在」走到「可供對話」，要經過四個階段：**來源**（Providers
型錄 —— 是元資料，不是推論）→ **註冊**（`ollama` 或 OpenAI 相容的
`external` 後端，重啟後仍留存）→ **部署**（Agents 頁把模型 ID 交給某個
`arona-agent` 節點；模型名稱留空就自動挑最閒的節點）→ **路由**（Models 頁；
以在途請求最少為準的負載平衡，並具工作階段親和性）。external 後端在首次
探測成功前一律 fail-closed。每一步的確切 API 詳見
[arona 文件](https://arona.docs.celestia.world)。

## 身分與計量

![chest API 金鑰](https://raw.githubusercontent.com/celestia-island/docs.celestia.world/master/res/screenshots/arona-apikeys.png)

![chest 帳務](https://raw.githubusercontent.com/celestia-island/docs.celestia.world/master/res/screenshots/arona-billing.png)

**API keys** 就是你的身分 —— 閘道以 Bearer token 驗證 `/v1/*`，`curl` 與
chest 都得在門口出示同一把。**Usage** 是每把金鑰的逐次呼叫帳本：token 數、
模型、後端、成本。**Billing** 按等級設定配額（USD / token / 速率限制）；
觸頂便是硬性拒絕，而不是放慢速度。

## 對話與記憶

![chest 對話](https://raw.githubusercontent.com/celestia-island/docs.celestia.world/master/res/screenshots/arona-playground.png)

每一輪對話都會經過記憶服務 —— 每輪上的徽章會告訴你它是否真的經過。
`Memory on` 表示路由前已注入相關的長期記憶；`Memory offline` 表示記憶服務
連不上（誠實訊號，不是 bug）；`disabled` 表示沒有找到相關內容。完成的
對話輪會被萃取成情節並持久化，因此記憶能在重啟後留存 —— 而回寫條目可以
直接在 Memory 頁面刪除。

## 面板與工業控制

![chest 智能體](https://raw.githubusercontent.com/celestia-island/docs.celestia.world/master/res/screenshots/arona-agents.png)

一段提示詞就能生出一塊面板；引擎生成版面配置，並把它持久化進 scepter 的
工作區儲存。編輯是結構性的 —— 資料來源綁定、元件清單、連線狀態 —— 不是
黑盒子。Topology 與 Holographic 是同一機群的兩種視圖；Reports 再為歷史
加上語意搜尋。工業寫入必須先通過原則驗證與**人工核准**，一切才會動作：
這是閉環的終點，也是最沉重的一步。

![chest 登入](https://raw.githubusercontent.com/celestia-island/docs.celestia.world/master/res/screenshots/arona-login.png)

## 更深入的去處

- arona 平台的完整參考 —— [arona 文件](https://arona.docs.celestia.world)
- chest 工作台與其面板 —— [shittim-chest 文件](https://shittim-chest.docs.celestia.world)
- 智能體、工作區與工業寫入閘門 —— [entelecheia 文件](https://entelecheia.docs.celestia.world)
