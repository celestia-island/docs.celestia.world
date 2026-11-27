# 项目地图

celestia-island 平台仓库与产品的全量清单，按层分组。带链接的名字是今天就可以阅读的公开仓库；不带链接的名字是随平台一起交付、但源码尚未公开的产品。标注了文档站的仓库维护自己的 *怎么做* 文档；其余的在仓库自身内部文档化，需要该仓库的访问权限。

## 第 0 层 — 认证

| 项目 | 角色 | 文档 |
| --- | --- | --- |
| [kirino](https://github.com/celestia-island/kirino) | 零信任认证与授权：会话、权限、限流 | [kirino.docs.celestia.world](https://kirino.docs.celestia.world) |

## 第 1 层 — 平台

| 项目 | 角色 | 文档 |
| --- | --- | --- |
| [plana](https://github.com/celestia-island/plana) | 共享协议类型、传输、计量，以及每个服务都消费的平台设施 | 仓库内 |
| [provider-registry](https://github.com/celestia-island/provider-registry) | 跨产品共享的模型与提供商目录 | 仓库内 |

## 第 2 层 — UI

| 项目 | 角色 | 文档 |
| --- | --- | --- |
| [hikari](https://github.com/celestia-island/hikari) | 全体 WebUI 共享的 UI 组件库 | 仓库内 |

## 第 3 层 — 服务

| 项目 | 角色 | 文档 |
| --- | --- | --- |
| arona | 模型网关与部署面板：密钥、后端、路由、用量 | [Arona](../platforms/arona.md) |
| shittim-chest | 聊天、面板与集成——工作台界面 | [Shittim Chest](../platforms/chest.md) |
| entelecheia | 智能体平台：智能体、长期记忆、语义搜索、工业集成 | [Entelecheia](../platforms/entelecheia.md) |
| evernight | 工业协议网关：现场协议、告警、录制、边缘推理 | [Evernight](../platforms/evernight.md) |
| [malkuth](https://github.com/celestia-island/malkuth) | 服务监督：滚动更新、健康探针、反向代理、崩溃恢复 | [malkuth.docs.celestia.world](https://malkuth.docs.celestia.world) |
| [lagrange](https://github.com/celestia-island/lagrange) | 支撑本站与所有项目文档站的文档引擎 | [lagrange.docs.celestia.world](https://lagrange.docs.celestia.world) |
| celestia-erp | 业务后台：组织、账单、发票 | — |
| electrode_recon | 电极微观结构计算引擎——引擎底座上的首个外部实例 | — |

## 工具与库

| 项目 | 角色 | 文档 |
| --- | --- | --- |
| [noa](https://github.com/celestia-island/noa) | 智能体原生的分布式版本控制，带隔离工作区 | [仓库](https://github.com/celestia-island/noa) |
| [seia](https://github.com/celestia-island/seia) | 多引擎网络搜索 | [seia.docs.celestia.world](https://seia.docs.celestia.world) |
| [aoba](https://github.com/celestia-island/aoba) | 多协议调试与仿真 CLI（Modbus RTU 等） | [aoba.docs.celestia.world](https://aoba.docs.celestia.world) |
| [ichika](https://github.com/celestia-island/ichika) | 基于消息管道的线程池管线 | 仓库内 |
| [yuuka](https://github.com/celestia-island/yuuka) | 组合式嵌套结构与 JSON merge/patch 的宏 | 仓库内 |
| [kou](https://github.com/celestia-island/kou) | 虚拟终端引擎：PTY、VT100/ANSI、内联图形 | 仓库内 |
| [hifumi](https://github.com/celestia-island/hifumi) | 用于在版本之间迁移数据的序列化 | 仓库内 |
| [lacrymira](https://github.com/celestia-island/lacrymira) | 统一命令面之后的 SQL 与 KV 类型化数据访问 | 仓库内 |
| [himari](https://github.com/celestia-island/himari) | 带量纲的公式中间表示 | 仓库内 |
| [kotama](https://github.com/celestia-island/kotama) | 逆向工程工具箱：剖析、反编译、交叉引用 | 仓库内 |
| [ayane](https://github.com/celestia-island/ayane) | 邮件服务：控制面、Webmail 与防护 | 仓库内 |
| [aris](https://github.com/celestia-island/aris) | 源自 servo 的纯 Rust 浏览器引擎，可作库嵌入 | 仓库内 |
| [shirabe](https://github.com/celestia-island/shirabe) | 无头浏览器自动化与调试 | 仓库内 |
| [tairitsu](https://github.com/celestia-island/tairitsu) | 基于 WASM Component Model 的全栈框架 | 仓库内 |
| [akivili](https://github.com/celestia-island/akivili) | 面向智能体扩展的插件宿主与 SDK | 仓库内 |
| [celestia-plugin](https://github.com/celestia-island/celestia-plugin) | Python 插件与引擎 SDK | 仓库内 |
| [shun](https://github.com/celestia-island/shun) | 安装器、刷写工具与便携模式载荷分发 | 仓库内 |
| arcaea | 人格协议库 | — |
| scriptum | 智能体平台的终端界面 | — |
| official-plugins | 一方的插件包 | — |

## 边缘与硬件

| 项目 | 角色 | 文档 |
| --- | --- | --- |
| [kei](https://github.com/celestia-island/kei) | 面向 ARM64 与 RISC-V 边缘网关的 Rust 内核 | 仓库内 |
| [hare](https://github.com/celestia-island/hare) | 面向嵌入式工业节点的 `no_std` 桥接库 | 仓库内 |
| evernight-appliance | 设备发行版：引导固件、刷写工具、驱动契约 | — |

## 基础设施与工具链

| 项目 | 角色 | 文档 |
| --- | --- | --- |
| [celestia-devtools](https://github.com/celestia-island/celestia-devtools) | 共享开发工具链：构建配方、lint、发布门禁 | 仓库内 |
| [cherino](https://github.com/celestia-island/cherino) | 面向智能体执行的沙箱化容器抽象 | 仓库内 |
| [celestia-artifacts](https://github.com/celestia-island/celestia-artifacts) | 面向发布的公共二进制与镜像产物托管 | 仓库内 |
| celestia-integration | 覆盖整个闭环的跨仓集成测试 | — |
| fuuka | 自托管 CI 执行面 | — |
| [sysl](https://github.com/celestia-island/sysl) | 大部分代码使用的 Synthetic Source License | 仓库内 |

## Web 阵地

| 资产 | 角色 | 文档 |
| --- | --- | --- |
| [celestia-island.github.io](https://celestia-island.github.io) | 组织存在 | 仓库内 |
| [docs.celestia.world](https://docs.celestia.world) | 本站 —— 哲学、地图、快速开始 | 仓库内 |
| [e.celestia.world](https://e.celestia.world) | 公开落地页 | 仓库内 |
| [dev.celestia.world](https://dev.celestia.world) | 面板与开发者仪表盘（内测期间邀请制） | 仓库内 |
| [celestia.ac.cn](https://celestia.ac.cn) | 公司与服务企业站点 | 仓库内 |

## 深入阅读

- [分层架构](../philosophy/layered-architecture.md) —— 这些层为何存在。
- [闭环](../philosophy/closed-loop.md) —— 项目如何沿闭环协作。
- [站点分工](./sites.md) —— 谁负责什么文档、在哪里。
