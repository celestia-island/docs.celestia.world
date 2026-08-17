# Shittim Chest —— 聊天、面板與整合

Shittim Chest 是面向使用者的那一面：聊天、面板與多通道整合 —— 把模型與智能體能力變成你每天在用的東西的那一層。它從 Arona 取得模型與記憶，從 entelecheia 的 scepter 取得智能體、面板與工業工作流。本指南按能力組織：聊天、面板、通道、搜尋與認證。

## 架構一覽

```text
你
 │  桌面應用程式 · Web UI · 12+ IM 通道（discord/slack/matrix/lark/…）
 ▼
Shittim Chest 核心（node-2:8425）
 ├─ 聊天：對話持久化於 Postgres，SSE/WS 串流
 ├─ 面板：資料網格 / 媒體管線 / 3D 孿生（面板引擎）
 ├─ 媒體管線：LLM 視覺審查、圖像生成、3D 生成（stub）
 ├─ 通道橋：雙向 IM ↔ 核心（webhooks + WS）
 └─ RPC 橋 → scepter（智能體、語意搜尋、知識庫）
         │
         ▼
Arona（模型、記憶）· scepter（智能體、面板、搜尋）
```

## 1. 聊天

- 對話與訊息持久化於 Postgres（`conversations` / `messages` 表）。完整歷史在伺服端組裝。
- 透過 SSE 串流並附區塊重播；桌面外殼顯示來自 scepter 智能體的思考區塊與工具呼叫。
- `chat.send` 支援對話 ID、模型覆寫與記憶旗標（記憶閘道語意見 [Arona 指南](./arona.md)）。

## 2. 面板

面板從單一段提示詞建立：引擎生成版面配置與小工具，然後把它們持久化到 scepter 的工作區儲存（`.amphoreus/workspace.toml` + `.noa/views/*.view.toml`）。編輯是結構性的，而非黑盒子：原始的資料來源綁定、小工具清單與連線狀態皆可見，並備有逐列深度編輯對話框與收合式的自然語言微調框。

三種面板：

- **資料網格** —— 帶型別欄位的表格視圖，支援排序/篩選/分組；寫入經由 `table.*` 編輯種類，附帶真實的校驗與回滾。
- **媒體管線** —— Dify 風格的節點圖（LLM 節點、圖像生成、HTTP、知識檢索、分支）；管線在伺服端執行、附串流進度，並可被智能體當作工具呼叫。
- **3D 孿生** —— 帶世界座標的設備模型樹、場景配置與相機書籤。

## 3. 多通道整合

通道橋把核心連接到 IM 平台（Discord、Slack、Matrix、Lark、…）。入站訊息化為對話輪；出站回應沿同一通道串流返回。每個通道都需要該平台的 OAuth 應用程式取得生產使用的核准。

## 4. 語意搜尋與知識

- `search.semantic` 橋接到 scepter 的向量搜尋（ApoRia 工作區索引 + PhiLia 長期記憶，融合為單一排序清單）。
- 知識庫（建立 / 加入文件 / 訂閱）持久化於 Postgres，並可透過同一 RPC 面搜尋。
- 智能體報告會自動索引，因此過去的報告可用語意檢索。

## 5. 認證

認證是委派的：scepter 信任由 chest 閘道提供的呼叫者使用者 ID（`X-User-Id` / `user_id`），而 chest 從 Arona 或邀請流程取得該 ID。RBAC 角色（admin / operator / viewer / agent）把守面板與工作區上的寫入操作。

## 環境變數參考（節選）

| 變數 | 用途 |
|---|---|
| `DATABASE_URL` | Postgres（必填） |
| `ENTELECHEIA_SCEPTER_URL` / `WS_URL` | 智能體引擎 RPC/WS 端點 |
| `LLM_DEFAULT_PROVIDER_ENDPOINT` / `_API_KEY` / `_MODELS` | 對話模型提供者（通常是 Arona） |
| `BIGMODEL_API_KEY*` | 媒體管線（GLM 視覺 / CogView 圖像生成） |
| `CHANNEL_*` | 各 IM 平台的通道憑證 |
