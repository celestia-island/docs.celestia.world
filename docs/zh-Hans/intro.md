# 欢迎来到 celestia-island

**celestia-island** 是一组面向工业 AI 控制的项目群：多智能体协作、远程操作与安全关键自动化。本站承载它的 *为什么* —— 整体哲学、生态地图与入口；*怎么做* 则由链接指向的各项目独立文档站承担。

## 回答三个问题

| 问题 | 位置 | 内容 |
| --- | --- | --- |
| **为什么存在？** | [哲学](./philosophy/why.md) | 要解决的问题、闭环、安全教义与长期愿景 |
| **里面有什么？** | [生态](./ecosystem/projects.md) | 每个项目、它在闭环中的角色及其文档位置 |
| **怎么开始？** | [快速开始](./getting-started/quickstart.md) | 从注册到聊天智能体与工业控制的 30 分钟路径 |

## 一段话总结

celestia-island 为 AI 驱动的工业控制构建从发现到验证的**闭环**：发现 → 安装 → 认证 → 部署模型 → 聊天与智能体 → 工业控制 → 验证支撑。闭环由严格分层的部件拼装而成：认证原语（[kirino](https://github.com/celestia-island/kirino)）、平台设施（[plana](https://github.com/celestia-island/plana)）、UI 组件（[hikari](https://github.com/celestia-island/hikari)），以及只实现业务逻辑的服务层（[arona](https://github.com/celestia-island/arona)、[shittim-chest](https://github.com/celestia-island/shittim-chest)、[entelecheia](https://github.com/celestia-island/entelecheia)、[evernight](https://github.com/celestia-island/evernight)）。任何能力都不实现第二遍：通用能力在上游构建一次，由全部下游服务消费。

这一切源于一个简单的观察：月球上信号往返需要 2.6 秒，火星上需要 6 到 44 分钟。那里的机器人等不了地球上的人——它们必须本地自主。我们今天为工业控制构建的决策层、世界模型与安全门，正是未来自主所需的同一形态。

## 一切都在哪里

- **项目文档** —— `<name>.docs.celestia.world`，由各仓库自身构建。完整清单见[站点分工](./ecosystem/sites.md)。
- **组织存在** —— [celestia-island on GitHub](https://github.com/celestia-island)。
- **产品入口（内测期间 WIP）** —— [arona](https://arona.celestia.world)（云 API 管理）、[dev](https://dev.celestia.world)（开发者门户）；内测期间实际面板运行于内部 `arona:8420`。

使用右下角语言切换器切换本站语言。内容以英文为准；各语种遵循同一结构。
