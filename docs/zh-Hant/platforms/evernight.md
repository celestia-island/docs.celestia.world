# Evernight —— 工業協定代理器

Evernight 是工業邊緣：一個會講各種現場協定（Modbus、S7comm、MC Protocol、EtherNet/IP、EtherCAT、CAN、OPC UA、MQTT、…）的跨平台代理器（broker），輪詢感測器、評估警報，並把事件推入 celestia-island 堆疊。它同時管理節點上的模型伺服器（ollama / whisper / vLLM）以供邊緣推論。

## 架構一覽

```text
現場：PLC / MCU / 感測器（Modbus、S7comm、MC、EtherCAT、CAN、OPC UA、…）
        ▼
   evernight（邊緣節點）
   ├─ 協定轉接器：輪詢 → 解碼 → 帶型別的讀值
   ├─ 警報引擎：閾值規則 → 觸發事件
   ├─ 時間序列：帶雙時間戳的緩衝讀值
   ├─ 錄製/重播：環形緩衝 → 分段儲存 → 重播注入
   ├─ 模型伺服器管理器：部署 ollama/whisper/vLLM（GPU 優先）
   └─ 北向：Unix-socket JSON-RPC 觸發 → entelecheia
         │
         ▼
   scepter（智能體、工業工作流、寫入核准）
```

## 1. 現場協定

轉接器把每個協定的原生讀/寫轉換為帶型別的讀值與命令。寫入路徑設有閘門：工業寫入需要平台中的原則驗證與人工核准（OreXis + 核准流程）。

## 2. 感測與警報

- 每個站點的輪詢迴圈，週期可配置；故障以健康事件浮現。
- 警報引擎對讀值評估閾值規則，並向北向觸發槽發出按主題路由的事件。

## 3. 時間與錄製

讀值攜帶雙時間戳（供顯示/稽查的壁鐘時間、供排序/融合的單調時間）。錄製/重播管線維護環形緩衝、持久化分段，並可將重播資料注回觸發管線 —— 這是世界狀態層與學習層共享的前提。

## 4. 邊緣模型服務

`model_server` 管理節點上的模型執行環境：在容器上部署模型（ollama、whisper.cpp、vLLM），GPU 優先、CPU 回退 —— 這是永不依賴線上 LLM 的反應式邊緣推論構建塊。

## 5. 北向整合

事件經由 Unix-socket JSON-RPC 觸發槽（按主題路由）流入 entelecheia 的 scepter；設備↔雲閘道註冊節點身分與遙測。一切實體的東西都經由 evernight 路由。

## 環境變數參考（節選）

| 變數 | 用途 |
|---|---|
| `EVERNIGHT_SOCK` | 對 scepter 的觸發/遙測 Unix socket |
| `EVERNIGHT_*` | 各協定的連線配置 |
| 容器/GPU 環境變數 | 模型伺服器部署（ollama/vLLM 執行環境） |
