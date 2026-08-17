# Shittim Chest — 聊天、面板与多渠道集成

Shittim Chest 是用户面：聊天、面板与多渠道集成——把模型与 agent 的能力变成你每天用得到的东西。它从 Arona 取模型与记忆，从 entelecheia 的 scepter 取 agent、面板与工业工作流。本文按功能模块展开：聊天、面板、渠道、搜索与认证。

## 架构一览

```text
你
 │  桌面应用 · Web UI · 12+ IM 渠道（discord/slack/matrix/lark/…）
 ▼
Shittim Chest core（node-2:8425）
 ├─ 聊天：会话持久化于 Postgres，SSE/WS 流式
 ├─ 面板：数据表格 / 媒体管线 / 3D 孪生（面板引擎）
 ├─ 媒体管线：LLM 视觉评审、文生图、3D 生成（stub）
 ├─ 渠道桥：IM ↔ core 双向（webhook + WS）
 └─ RPC 桥 → scepter（agent、语义搜索、知识库）
        │
        ▼
Arona（模型、记忆）· scepter（agent、面板、搜索）
```

## 1. 聊天

- 会话与消息持久化于 Postgres（`conversations` / `messages` 表），历史由服务端完整装配。
- SSE 流式 + chunk 回放；桌面壳显示 scepter agent 的思考块与工具调用。
- `chat.send` 支持 conversation id、模型覆盖与记忆开关（语义见 [Arona 指南](./arona.md) 的记忆网关章节）。

## 2. 面板

面板由单一提示词创建：引擎生成布局与组件，持久化到 scepter 的 workspace 存储（`.amphoreus/workspace.toml` + `.noa/views/*.view.toml`）。编辑是结构化而非黑盒：原始数据源绑定、组件清单与连接状态全部可见，附带行级深度编辑弹窗与默认折叠的自然语言微调框。

三种面板：

- **数据表格** — 带类型字段的表视图，排序/筛选/分组，写入走 `table.*` 编辑类型，真校验 + 回滚。
- **媒体管线** — Dify 风格节点图（LLM 节点、文生图、HTTP、知识检索、条件分支）；管线服务端执行、流式进度，可被 agent 当作工具调用。
- **3D 孪生** — 带世界坐标的设备模型树、场景配置与相机书签。

## 3. 多渠道集成

渠道桥把 core 连接到 IM 平台（Discord、Slack、Matrix、Lark 等）。入站消息成为聊天轮次；出站回复经同一渠道流回。每个渠道的 OAuth 应用需审核通过才可用于生产。

## 4. 语义搜索与知识

- `search.semantic` 桥接 scepter 的向量检索（ApoRia workspace 索引 + PhiLia 长期记忆融合为单一排序列表）。
- 知识库（建库 / 加文档 / 订阅）持久化于 Postgres，同一 RPC 面可检索。
- agent 报告自动索引，历史报告可被语义检索。

## 5. 认证

认证委托式：scepter 信任 chest 网关提供的调用者用户 id（`X-User-Id` / `user_id`），chest 从 Arona 或邀请流程取得。RBAC 角色（admin / operator / viewer / agent）门控面板与 workspace 的写操作。

## 环境变量参考（节选）

| 变量 | 用途 |
|---|---|
| `DATABASE_URL` | Postgres（必需） |
| `ENTELECHEIA_SCEPTER_URL` / `WS_URL` | Agent 引擎 RPC/WS 端点 |
| `LLM_DEFAULT_PROVIDER_ENDPOINT` / `_API_KEY` / `_MODELS` | 聊天模型提供方（通常是 Arona） |
| `BIGMODEL_API_KEY*` | 媒体管线（GLM 视觉 / CogView 文生图） |
| `CHANNEL_*` | 各 IM 平台渠道凭据 |
