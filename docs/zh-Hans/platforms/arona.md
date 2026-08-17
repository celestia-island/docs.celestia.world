# Arona — 模型网关、长期记忆与集群

Arona 是平台控制平面：模型网关、自部署运行时管理与 Web 控制台。它要解决的问题是——把模型从"下载到某台机器"变成"全平台可用、可计量、有记忆"。本文按功能模块展开：模型路由、长期记忆与多节点集群。

## 架构一览

```text
shittim-chest / 任意 OpenAI 兼容客户端
        │  /v1/chat/completions（Bearer API key）
        ▼
   Arona 网关（node-2:8420）
   ├─ Router：别名 → 后端间最少计数负载均衡
   ├─ 记忆网关：召回注入 → 聊天 → 写回（episode）
   └─ Agent 控制面（/ws/agent）──► GPU 节点上的 arona-agent
        │
        ▼
   后端：ollama · external（OpenAI 兼容）· agent 部署的引擎
```

所有管理流量（面板、agent、记忆）走 WebSocket + JSON-RPC 2.0；唯一的 REST 面是 OpenAI 兼容的 `/v1/*` 端点。

## 1. 模型

### 注册后端

后端注册为 `ollama` 或 `external`（任意 OpenAI 兼容服务——vLLM、TGI、LMDeploy、TileRT 的 router 等）：

```bash
POST /api/admin/backends        # Bearer ADMIN_TOKEN
  {"type": "ollama", "name": "node3-ollama", "url": "http://host:11434"}
  {"type": "external", "name": "my-vllm", "url": "http://host:8000",
   "api_key": "...", "models": ["qwen2.5-72b"]}
```

已注册的后端在重启后保留（`backend_configs` 表），并持续接受健康探测：external 后端在首次 `/v1/models` 探测成功前为 fail-closed（拒绝路由），其模型列表也会动态刷新。

### 在节点上自部署模型

`arona-agent` 二进制运行在 GPU 机器上并回连面板。从面板 **Agents** 页下发部署（或调用 `agents.deploy`，`agent_id` 留空时自动选最空闲节点）。agent 下载模型（HuggingFace 或 Ollama 源）、拉起引擎（llama.cpp / vLLM / Ollama）、上报引擎端点——面板自动把它注册为可路由的 `agent-{model}` 后端，停止时自动注销。

引擎绑定地址：需要对外服务的节点设置 `ARONA_AGENT_BIND_ADDR=0.0.0.0`。注意：引擎端口无鉴权——仅在可信网络部署。

### 会话亲和

会话固定路由到同一后端（会话亲和），便于复用运行时 KV cache。被固定的后端失活时自动回退并重新固定。

## 2. 长期记忆

Arona 是**记忆网关**：它不做模型训练——而是围绕你现有的模型编排记忆服务（entelecheia 的 PhiLia agent）。

### 启用

```bash
ARONA_MEMORY_URL=ws://<scepter-host>:8424/ws
ARONA_MEMORY_TOKEN=<scepter 连接 token>
ARONA_MEMORY_WRITEBACK=1        # 默认开启；0 关闭写回
```

### 每次聊天的流程

1. **召回** —— 最后一条用户消息被嵌入并查询记忆服务；相关记忆以 `## Relevant Long-Term Memories` system 段注入（幂等）。
2. **聊天** —— 组装后的上下文路由到模型。
3. **写回** —— 完成的对话轮次被启发式提取（`User: … / Assistant: …`，零 LLM 调用）作为 episode 存入记忆图（pgvector 持久化，重启不丢）。
4. **状态** —— 每个响应报告 `memory: enabled | disabled | offline`；REST 面额外带 `X-Arona-Memory` 头。失败从不阻断聊天；`offline` 表示记忆服务不可达，且始终在 UI 可见。

按调用覆盖：`chat.send` 可传 `memory: true|false`。

### 管理

仪表盘**记忆**页显示召回/写回/删除活动，并可删除已存节点。会话在服务端持久化：`chat.send` 传 `conversation_id`，由服务端装配历史而非客户端。

## 3. 运维

- **认证**：首个用户成为 admin 后注册自动锁定（`ARONA_REGISTRATION_OPEN=1` 可重新开放）。管理端点要求 `ARONA_ADMIN_TOKEN`，缺失时 fail-closed。
- **计量**：按 API key 记录用量与成本（`usage.list`、带配额与限流的计费档位）。
- **健康**：`/api/health` 与 `/v1/health` 报告版本与构建哈希。

## 环境变量参考

| 变量 | 用途 |
|---|---|
| `DATABASE_URL` | Postgres（必需） |
| `JWT_SECRET` | Token 签名（非 mock 模式必需） |
| `ARONA_HOST` / `ARONA_PORT` | 绑定地址（默认 `0.0.0.0:8420`） |
| `ARONA_ADMIN_TOKEN` | `/api/admin/*` 的 Bearer token |
| `ARONA_REGISTRATION_OPEN` | 重新开放自助注册 |
| `ARONA_MEMORY_URL` / `ARONA_MEMORY_TOKEN` / `ARONA_MEMORY_WRITEBACK` | 记忆网关 |
| `ARONA_AGENT_NAME` / `ARONA_PANEL_URL` / `ARONA_AGENT_BIND_ADDR` | Agent 节点 |
