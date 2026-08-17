# 核心基础设施 — 认证、RPC 与地基

你用的每个平台都站在同一片地基上。把这篇读一遍，平台指南里的零件就都
对上了：kirino（零信任认证与 RBAC）、plana（协议类型、JSON-RPC 传输、计量、
同步引擎）、hikari（UI 组件库）。

## 认证与授权（kirino）

- **身份**：Argon2id 密码哈希；JWT 访问/刷新 token（`TokenManager`、
  `kirino-session`）；登录限流与账户锁定。
- **RBAC**：层级权限（agent.*、system.*、knowledge.* 等）由 `GrantResolver`
  解析；角色捆绑权限（admin 全量、viewer 只读）。分配持久化于 Postgres。
- **委托**：scepter 信任 chest 网关提供的调用者用户 id（`X-User-Id` /
  `user_id`），仅用于 workspace 隔离——认证层总是在上游。
- **管理面**：面板管理端点要求专用 `ARONA_ADMIN_TOKEN`，缺失时 fail-closed。

## 协议与 RPC（plana）

- 所有平台流量是 **WebSocket 上的 JSON-RPC 2.0**（以及 HTTP POST
  `/api/rpc` 的请求/响应）。方法名为 `<Domain>.<Action>`——如
  `Sync.MemoryQueryRequest`、`Cli.Search`、`Mcp.CallTool`。
- 线协议类型在 plana（`plana-state-sync` / `plana-types`）：协议单一事实源；
  下游仓库钉发布的 tag。
- 通知（无 `id`）推送流式块与面板更新等事件；请求带 `id`，响应回显。
- 同步引擎（`plana-sync`）是服务端权威状态树：客户端声明视口，服务端广播
  diff 并周期性全量快照。

## 计量与定价（plana）

按 API key 计量用量，从统一定价表（`plana-llm-provider` metering）计价：
prompt/completion token、成本估算与配额强制跨服务共享。

## UI 组件（hikari）

Vue 组件库（`@celestia-island/hikari`）提供每个 webui 使用的按钮、徽章、
表格、弹窗与确认对话框；平台页面用 plana UI shell 组合它们。共享组件必须
上提到这里，而不是每仓重新实现。

## 依赖规则

- 第 0 层：kirino（认证）→ 第 1 层：plana（协议/地基）→ 第 2 层：hikari（UI）→ 第 3 层：服务（arona、chest、entelecheia、evernight）。
- 服务只实现业务逻辑；通用能力来自上游。跨仓依赖用 git reference 或钉版 tag——绝不用本地 path 依赖。
