# Entelecheia — Agent 平台与记忆

Entelecheia 是 agent 平台：scepter 运行时编排专门化 agent（"souls"）、维护长期记忆（PhiLia）、提供语义搜索，并承载工业集成层。Arona 与 Chest 的能力背后都是它。本文按功能模块展开：agents、记忆、搜索、知识库与连接。

## 架构一览

```text
客户端：Arona（网关）· Shittim Chest（聊天/面板）· TUI/CLI
        │  WebSocket 上的 JSON-RPC 2.0（token 或 API key）
        ▼
   scepter 运行时（node-3:8424）
   ├─ Agent manager：L1 souls（PhiLia、Skopeo、Hubris、Kalos、…）
   ├─ Skill chains：LLM + 工具调用的管线，带 RAG 预取
   ├─ PhiLia：长期记忆（向量 + 图，pgvector 持久化）
   ├─ ApoRia：知识库 + workspace 索引（语义搜索）
   ├─ OreXis：工具执行的策略/安全门
   └─ Reflection：教训库重新注入提示词
```

## 1. Agents（souls）

每个 soul 是带独立身份文档、工具（MCP 风格）与技能的专门化 agent。Skill chains 把 LLM 调用与工具执行组合成管线；每次调用前，相关长期记忆与知识库内容被预取并注入 system prompt。

安全：工具执行经过 OreXis 策略门；工业写入需要显式审批流。

## 2. 长期记忆（PhiLia）

PhiLia 是 Arona 记忆网关背后的记忆服务：

- **存储** — episode、entity 与 artifact 作为节点存入记忆图，嵌入后镜像到 pgvector（`philia_chunks`）。
- **查询** — 语义检索组合向量相似度、图遍历与时间衰减（14 天半衰期）。
- **整合** — 周期性 consolidate 把相关节点链接合并。
- **线协议面** — 一等方法 `Sync.MemoryStoreRequest` / `MemoryQueryRequest` / `MemoryDeleteRequest`（RBAC：SystemWrite / SystemRead），另有通用 `Mcp.CallTool` 路由。

嵌入：`OLLAMA_HOST` + `OLLAMA_EMBED_MODEL`（如 `nomic-embed-text`）或远程 API，回退本地 ONNX 模型。

## 3. 语义搜索

`Sync.SearchRequest` 融合两个库为单一排序列表：

- **ApoRia** — workspace 索引、agent 报告与知识库文档（向量 + 关键词 hybrid，RRF 融合）。
- **PhiLia** — 长期记忆（`philia_memory` source）。

## 4. 知识库

创建知识库、添加文档、订阅 rag subscription——全部 Postgres 持久化。文档嵌入 ApoRia 库，同一搜索面可检索。

## 5. Reflection

经验教训存入教训库（pgvector）并在后续提示词中重新注入——与 PhiLia 并行的第二套轻量持久记忆。

## 6. 连接客户端

- WebSocket `ws://<host>:8424/ws` — upgrade 时 `?token=<connection token>`（或 Bearer）鉴权；随后 `Sync.ConnectHandshake`。
- HTTP JSON-RPC `POST /api/rpc?token=…` 用于请求/响应。
- 连接 token：scepter 节点上的 `~/.config/entelecheia/scepter.token`。

## 环境变量参考（节选）

| 变量 | 用途 |
|---|---|
| `SERVER_BIND_ADDRESS` | 绑定地址（默认 127.0.0.1；远程客户端需 0.0.0.0:8424） |
| `DATABASE_URL` | Postgres（config.toml 或 env） |
| `OLLAMA_HOST` / `OLLAMA_EMBED_MODEL` | 嵌入后端 |
| `JWT_SECRET` | 持久化认证 token（未设置时每次会话随机） |
| `connection_token` | scepter 连接 token 文件 |
