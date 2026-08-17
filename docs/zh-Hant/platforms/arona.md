# Arona —— 模型閘道、記憶與叢集

Arona 是平台的控制平面：模型閘道、自部署執行環境管理器與 Web 儀表板。它解決的問題，是把「下載到某台機器上的模型」變成整個平台能夠路由、計量並記住的東西。本指南按能力組織：模型路由、長期記憶與多節點叢集。

## 架構一覽

```text
shittim-chest / 任何 OpenAI 相容用戶端
        │  /v1/chat/completions（Bearer API 金鑰）
        ▼
    Arona 閘道（node-2:8420）
    ├─ 路由器：別名 → 跨後端、以在途請求最少為準的負載平衡
    ├─ 記憶閘道：召回注入 → 對話 → 回寫（情節）
    └─ 智能體控制平面（/ws/agent）──► GPU 節點上的 arona-agent
         │
         ▼
    後端：ollama · external（OpenAI 相容）· 智能體部署的引擎
```

所有管理流量（儀表板、智能體、記憶）都走 WebSocket 上的 JSON-RPC 2.0 訊息；唯一的 REST 面是 OpenAI 相容的 `/v1/*` 端點。

## 1. 模型

### 註冊後端

後端註冊為 `ollama` 或 `external`（任何 OpenAI 相容伺服器 —— vLLM、TGI、LMDeploy、TileRT 的路由器、…）：

```bash
POST /api/admin/backends        # Bearer ADMIN_TOKEN
  {"type": "ollama", "name": "node3-ollama", "url": "http://host:11434"}
  {"type": "external", "name": "my-vllm", "url": "http://host:8000",
   "api_key": "...", "models": ["qwen2.5-72b"]}
```

已註冊的後端跨重啟持久化（`backend_configs` 表），並持續接受健康探測：external 後端在首次 `/v1/models` 探測成功之前一律 fail-closed，其模型清單會動態刷新。

### 在節點上自部署模型

`arona-agent` 執行檔運行於 GPU 機器上，並回連到控制台。從儀表板的 **Agents** 頁部署模型（或透過 `agents.deploy` 帶空 `agent_id` 自動瞄準負載最輕的節點）。智能體下載模型（HuggingFace 或 Ollama registry）、啟動引擎（llama.cpp / vLLM / Ollama）並回報引擎端點 —— 控制台自動將其註冊為可路由的 `agent-{model}` 後端，並在停止時移除。

引擎綁定位址：在必須向控制台提供流量的節點上設定 `ARONA_AGENT_BIND_ADDR=0.0.0.0`。注意：引擎連接埠未經認證 —— 僅在受信任的網路上部署。

### 對話親和性

對話被釘選到單一後端（工作階段親和性），使執行期 KV 快取得以複用。若被釘選的後端轉為不健康，路由器會回退並重新釘選。

## 2. 長期記憶

Arona 是**記憶閘道**：它不訓練模型 —— 它圍繞你既有的模型編排一套記憶服務（entelecheia 的 PhiLia 智能體）。

### 啟用

```bash
ARONA_MEMORY_URL=ws://<scepter-host>:8424/ws
ARONA_MEMORY_TOKEN=<scepter connection token>
ARONA_MEMORY_WRITEBACK=1        # default on; 0 disables writeback
```

### 每次對話發生什麼

1. **召回** —— 最後一條使用者訊息被嵌入並向記憶服務查詢；相關記憶以 `## Relevant Long-Term Memories` 系統區塊注入（冪等）。
2. **對話** —— 組裝好的上下文被路由到模型。
3. **回寫** —— 完成的對話輪以啟發式萃取（`User: … / Assistant: …`，零次 LLM 呼叫），並作為情節存入記憶圖（pgvector 支撐，跨重啟留存）。
4. **狀態** —— 每個回應都回報 `memory: enabled | disabled | offline`；REST 面另加 `X-Arona-Memory` 標頭。失敗絕不阻斷對話；`offline` 表示記憶服務不可達，且永遠在 UI 中可見。

逐次覆寫：`chat.send` 接受 `memory: true|false`。

### 管理

儀表板的 **Memory** 頁顯示召回/回寫/刪除活動，並讓你刪除已儲存的節點。工作階段在伺服端持久化：向 `chat.send` 傳入 `conversation_id`，伺服器便代替用戶端組裝歷史。

## 3. 維運

- **認證**：首次管理員 bootstrap 之後註冊上鎖（`ARONA_REGISTRATION_OPEN=1` 重新開放）。管理端點需要 `ARONA_ADMIN_TOKEN`；缺少時一律 fail-closed。
- **計量**：用量與成本按 API 金鑰記錄（`usage.list`、帶配額與速率限制的帳務等級）。
- **健康**：`/api/health` 與 `/v1/health` 回報版本與構建雜湊。

## 環境變數參考

| 變數 | 用途 |
|---|---|
| `DATABASE_URL` | Postgres（必填） |
| `JWT_SECRET` | 權杖簽章（mock 模式之外必填） |
| `ARONA_HOST` / `ARONA_PORT` | 綁定位址（預設 `0.0.0.0:8420`） |
| `ARONA_ADMIN_TOKEN` | `/api/admin/*` 的 Bearer 權杖 |
| `ARONA_REGISTRATION_OPEN` | 重新開放自助註冊 |
| `ARONA_MEMORY_URL` / `ARONA_MEMORY_TOKEN` / `ARONA_MEMORY_WRITEBACK` | 記憶閘道 |
| `ARONA_AGENT_NAME` / `ARONA_PANEL_URL` / `ARONA_AGENT_BIND_ADDR` | 智能體節點 |
