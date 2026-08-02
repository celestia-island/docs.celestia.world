# 闭环

产品是闭环，而不是任何一个单独项目：

> 发现 → 安装 → 认证 → 部署模型 → 聊天与智能体 → 工业控制 → 验证支撑

每一环由特定的项目群负责。任何一环断裂，平台就不算完成。

## 逐环分解

| # | 环节 | 发生什么 | 项目 |
| --- | --- | --- | --- |
| 1 | **发现** | 潜在用户找到生态、理解其哲学并选择入口 | [docs.celestia.world](https://docs.celestia.world)（本站）、[celestia-island.github.io](https://celestia-island.github.io)、[e.celestia.world](https://e.celestia.world) |
| 2 | **安装** | 用户得到可运行的系统：管理面板、桌面/Web 外壳、被监督的服务 | [arona](https://github.com/celestia-island/arona)（云 API 管理面板）、[shittim-chest](https://github.com/celestia-island/shittim-chest)（聊天桌面/WebUI）、[malkuth](https://github.com/celestia-island/malkuth)（服务监督） |
| 3 | **认证** | 零信任身份：注册（邀请制）、限流登录、API 密钥、RBAC | [kirino](https://github.com/celestia-island/kirino)（认证原语与 RBAC 引擎） |
| 4 | **部署模型** | 选择模型运行时、部署到节点、绑定聊天后端、计量用量 | [arona](https://github.com/celestia-island/arona)（面板与后端）、[entelecheia](https://github.com/celestia-island/entelecheia)（scepter 运行时）、[plana](https://github.com/celestia-island/plana)（计量与定价） |
| 5 | **聊天与智能体** | 与模型对话、多智能体协作、会话持久化、记忆管理 | [shittim-chest](https://github.com/celestia-island/shittim-chest)（UI 与聊天）、[entelecheia](https://github.com/celestia-island/entelecheia)（智能体编排）、[noa](https://github.com/celestia-island/noa)（AI 原生版本控制） |
| 6 | **工业控制** | 远程操作与协议桥接：Modbus、S7comm、OPC UA；遥测与写阀门 | [evernight](https://github.com/celestia-island/evernight)（协议网关）、[aoba](https://github.com/celestia-island/aoba)（Modbus 与数据源 CLI） |
| 7 | **验证与支撑** | 真机集成测试、监督与自愈、用量记录、反馈通道 | [celestia-integration](https://github.com/celestia-island/celestia-integration)、[malkuth](https://github.com/celestia-island/malkuth)、[plana](https://github.com/celestia-island/plana)（用量记录） |

## 闭环如何运转

- **每一步都可测试。** 每个环节在 [celestia-integration](https://github.com/celestia-island/celestia-integration) 中有对应的验收测试；直到整个闭环在真实节点上通过，发布才算绿。
- **每一步都可观测。** 监督、健康端点与用量记录让每个环节的状态可见，而非假设。
- **绝不静默降级。** 环节降级时（例如记忆离线、后端不可达），API 响应与 UI 必须明说。失败天生要响亮。
- **安全不是环节。** 写阀门、策略校验与人工确认织入第 5、6 环，而不是最后补上。见[安全原则](./safety.md)。

## 深入阅读

- [为什么有 celestia-island](./why.md) —— 定义闭环的问题。
- [分层架构](./layered-architecture.md) —— 部件如何保持秩序。
- [项目地图](../ecosystem/projects.md) —— 全量仓库清单。
- [快速开始](../getting-started/quickstart.md) —— 30 分钟走完闭环。
