# Entelecheia —— 智能體平台與記憶

Entelecheia 是智能體平台：編排專精智能體（「靈魂」）的 scepter 執行環境、維護長期記憶（PhiLia）、提供語意搜尋，並承載工業整合層。Arona 與 Chest 的諸多能力背後，站著的正是這個平台。本指南按能力組織：智能體、記憶、搜尋、知識與連接。

## 架構一覽

```text
用戶端：Arona（閘道）· Shittim Chest（聊天/面板）· TUI/CLI
        │  WebSocket 上的 JSON-RPC 2.0（token 或 API 金鑰）
        ▼
   scepter 執行環境（node-3:8424）
   ├─ 智能體管理器：L1 靈魂（PhiLia、Skopeo、Hubris、Kalos、…）
   ├─ 技能鏈：LLM + 工具呼叫的管線，附 RAG 預取
   ├─ PhiLia：長期記憶（向量 + 圖，pgvector 支撐）
   ├─ ApoRia：知識庫 + 工作區索引（語意搜尋）
   ├─ OreXis：工具執行上的原則/安全閘門
   └─ 反思：教訓儲存重新注入提示詞
```

## 1. 智能體（靈魂）

每個靈魂是一個專精智能體，有自己的身分文件、工具（MCP 風格）與技能。技能鏈把 LLM 呼叫與工具執行組合起來；每次呼叫之前，會預取相關的長期記憶與知識庫內容並注入系統提示詞。

安全：工具執行通過 OreXis 原則閘門，工業寫入需要顯式的核准流程。

## 2. 長期記憶（PhiLia）

PhiLia 是 Arona 記憶閘道背後的記憶服務：

- **儲存** —— 情節、實體與工件作為節點存入記憶圖，嵌入並鏡射到 pgvector（`philia_chunks`）。
- **查詢** —— 語意檢索結合向量相似度、圖遍歷與新近度衰減（14 天半衰期）。
- **固化** —— 週期性合併把相關節點連結起來。
- **線路面** —— 一級方法 `Sync.MemoryStoreRequest` / `MemoryQueryRequest` / `MemoryDeleteRequest`（RBAC：SystemWrite / SystemRead），以及通用的 `Mcp.CallTool` 路由。

嵌入：透過 `OLLAMA_HOST` + `OLLAMA_EMBED_MODEL`（例如 `nomic-embed-text`）或遠端 API 設定，並可回退到本機 ONNX 模型。

## 3. 語意搜尋

`Sync.SearchRequest` 把兩個儲存融合為單一排序清單：

- **ApoRia** —— 工作區索引、智能體報告與知識庫文件（向量 + 關鍵字混合，RRF）。
- **PhiLia** —— 長期記憶（`philia_memory` 來源）。

## 4. 知識庫

建立知識庫、加入文件並訂閱 rag 訂閱 —— 全部持久化於 Postgres。文件被嵌入 ApoRia 儲存，並可透過同一搜尋面檢索。

## 5. 反思

學到的教訓存入教訓儲存（pgvector），並重新注入未來的提示詞 —— 這是 PhiLia 之外的第二套輕量持久記憶。

## 6. 連接用戶端

- WebSocket `ws://<host>:8424/ws` —— 在升級時以 `?token=<connection token>`（或 Bearer）認證；然後 `Sync.ConnectHandshake`。
- HTTP JSON-RPC `POST /api/rpc?token=…` 供請求/回應之用。
- 連線權杖：scepter 節點上的 `~/.config/entelecheia/scepter.token`。

## 環境變數參考（節選）

| 變數 | 用途 |
|---|---|
| `SERVER_BIND_ADDRESS` | 綁定位址（預設 127.0.0.1；遠端用戶端設 0.0.0.0:8424） |
| `DATABASE_URL` | Postgres（config.toml 或環境變數） |
| `OLLAMA_HOST` / `OLLAMA_EMBED_MODEL` | 嵌入後端 |
| `JWT_SECRET` | 持久認證權杖（未設定時每工作階段隨機） |
| `connection_token` | Scepter 連線權杖檔案 |
