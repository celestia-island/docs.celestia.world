# Web UI 指南

平台自带两个 Web 界面：**Arona**（管理面板——模型、密钥、用量、计费、记忆）
与 **Shittim Chest**（工作界面——聊天、面板、可视化与深度管理后台）。本指南
介绍每个界面的功能。

## Arona — 管理面板

打开 `http://<host>:8420`。登录或注册（注册在首个 admin 后锁定；
`ARONA_REGISTRATION_OPEN=1` 可重新开放）。

### Dashboard 总览
概览页：请求量、在线 GPU 节点、已部署模型与近期用量一览。

### Models 模型
模型目录。列出网关可路由的一切——HuggingFace registry 快速开始集与你注册的
后端——并显示每个模型由哪个后端服务。

### Agents 节点
GPU 节点管理。每行是一个 `arona-agent` 节点：状态（心跳判定在线）、主机、
GPU 摘要与已加载模型。**Deploy/Stop** 按钮经 agent 控制面下发命令；模型字段
留空时自动选最空闲节点。

### Providers 提供商
提供商目录（registry 条目 + 你的自定义提供商）。这是模型来源的元数据；
实际路由后端经 admin API 管理。

### API Keys 密钥
按用户创建/吊销 API key（可选项目作用域）。密钥是 `curl` 与 chest 对接
网关时的身份。

### Usage 用量
按密钥的用量记录：prompt/completion token、模型、后端、成本。

### Billing 计费
计费档位（free/pro/enterprise 种子）带月度 USD 配额与 token 配额，以及
每档限流。

### Memory 记忆
记忆网关状态页：召回/写回是否启用，以及活动日志（召回/写回/删除事件）。
从写回条目可删除已存节点。

### Playground 试验场
对任意已路由模型的聊天试验台。选模型、用或建会话、开聊——记忆徽章显示每轮
记忆状态（`Memory on` / `Memory offline`）。

### Settings 设置
账户设置（资料、凭据）。

## Shittim Chest — 工作界面

打开 `http://<host>:8425`。UI 分三块：聊天、面板、管理后台（`/backend#…`）。

### 聊天
聊天产品：会话服务端持久化、流式响应、消息流中可见 agent 工具调用与思考块。

### 面板
提示词创建的工作区渲染为面板——数据表格、媒体管线与 3D 孪生。每个面板的
原始数据源绑定与组件清单可编辑（结构化编辑视图），非黑盒。

### 可视化
- **Topology 拓扑** — 设备/网络拓扑视图，带设备详情。
- **Holographic 全息** — 3D 孪生视图（带世界坐标的设备模型）。
- **Demiurge** — agent 总览与单 agent 详情（状态、技能、工具）。
- **Reports 报告** — agent 报告存档，支持语义搜索。

### 管理后台（`/backend`）
按域分组：

- **资源** — Workspaces、Devices、Stations、Groups、Manifests、Device
  Models（带深度编辑弹窗）、Resource Quotas。
- **Agents** — 节点列表 + 详情（工具、MCP、技能、容器）、Layer-2 agents、
  MCP Tools、Skills。
- **访问** — Invitations、RBAC（角色/权限/分配）、OAuth providers、
  Webhooks。
- **集成** — Channels（IM 平台 + webhooks）、Bridge Network、语音服务。
- **运维** — Alarms、Token Usage、System。
- **偏好** — UI 偏好与面板默认。

## 常见流程

- **首次登录**：chest 管理 → Settings/Setup → 连接提供商（通常是 Arona）
  并填入 API key → 开聊。
- **试一个模型**：Arona Playground → 选模型 → 开聊；然后把同一模型通过
  提供商配置交给 chest。
- **给人开权限**：chest 管理 → Invitations → 发邀请；在 RBAC 里分配角色。
