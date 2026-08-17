# 核心基礎架構 —— 認證、RPC 與基礎

你使用的每個平台都建立在同一套基礎之上。這一頁讀一遍，各平台指南便能豁然貫通：kirino（零信任認證與 RBAC）、plana（協定型別、JSON-RPC 傳輸、計量、同步引擎）與 hikari（UI 元件庫）。

## 認證與授權（kirino）

- **身分**：Argon2id 密碼雜湊；JWT 存取/刷新權杖（`TokenManager`、`kirino-session`）；登入限流與帳戶鎖定。
- **RBAC**：由 `GrantResolver` 解析的階層式權限（agent.*、system.*、knowledge.*、…）；角色捆綁權限（admin 全見，viewer 唯讀）。指派持久化於 Postgres。
- **委派**：scepter 信任由 chest 閘道提供的呼叫者使用者 ID（`X-User-Id` / `user_id`），且僅將其用於工作區隔離 —— 認證層永遠在上游。
- **管理面**：面板管理端點需要專屬的 `ARONA_ADMIN_TOKEN`，缺少時一律 fail-closed。

## 協定與 RPC（plana）

- 所有平台流量都是 **JSON-RPC 2.0 over WebSocket**（以及透過 HTTP POST `/api/rpc` 的請求/回應）。方法命名為 `<Domain>.<Action>` —— 例如 `Sync.MemoryQueryRequest`、`Cli.Search`、`Mcp.CallTool`。
- 線路型別位於 plana（`plana-state-sync` / `plana-types`）：協定的單一事實來源；下游倉庫釘住已發布的 tag。
- 通知（無 `id`）推送串流區塊與面板更新等事件；請求帶有 `id`，並在回應中原樣回顯。
- 同步引擎（`plana-sync`）是伺服端權威的狀態樹：用戶端宣告視埠，伺服器廣播差異並定期發送完整快照。

## 計量與定價（plana）

用量按 API 金鑰計量，並依一份規範表定價（`plana-llm-provider` 計量）：prompt/completion token 數、成本估算與配額強制執行在所有服務間共享。

## UI 元件（hikari）

Vue 元件庫（`@celestia-island/hikari`）提供每個 WebUI 都在使用的按鈕、徽章、表格、模態框與確認對話框；平台頁面以 plana 的 UI 外殼組合它們。共享元件必須上游化到這裡，而不是在各倉庫重複實作。

## 依賴規則

- 第 0 層：kirino（認證）→ 第 1 層：plana（協定/基礎）→ 第 2 層：hikari（UI）→ 第 3 層：服務（arona、chest、entelecheia、evernight）。
- 服務僅實作業務邏輯；共享能力來自上游。跨倉依賴使用 git reference 或釘版 tag —— 絕不使用本機 path 依賴。
