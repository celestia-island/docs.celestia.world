# 项目地图

celestia-island 仓库全量清单，按层分组。带文档站的仓库在 `<name>.docs.celestia.world` 维护自己的 *怎么做* 文档；其余在仓库内文档化。

## 第 0 层 — 认证

| 项目 | 角色 | 文档 |
| --- | --- | --- |
| [kirino](https://github.com/celestia-island/kirino) | 零信任认证与 RBAC：JWT 会话、Argon2id 哈希、登录限流、权限引擎 | [kirino.docs.celestia.world](https://kirino.docs.celestia.world) |

## 第 1 层 — 平台

| 项目 | 角色 | 文档 |
| --- | --- | --- |
| [plana](https://github.com/celestia-island/plana) | 共享类型、JSON-RPC 客户端与服务端、SSE 会话、熔断器、LLM 计量与定价、管理 UI 外壳 | 仓库内 |
| [provider-registry](https://github.com/celestia-island/provider-registry) | 模型与提供商注册表（entrypoint TOML 格式） | 仓库内 |

## 第 2 层 — UI

| 项目 | 角色 | 文档 |
| --- | --- | --- |
| [hikari](https://github.com/celestia-island/hikari) | 全部 WebUI 共享的 UI 组件库（Vue/TS + Rust） | 仓库内 |

## 第 3 层 — 服务

| 项目 | 角色 | 文档 |
| --- | --- | --- |
| [arona](https://github.com/celestia-island/arona) | 云 API 管理面板：账户、API 密钥、模型部署、后端、用量记录 | 仓库内 |
| [shittim-chest](https://github.com/celestia-island/shittim-chest) | 聊天桌面/WebUI 与外壳 | [shittim-chest.docs.celestia.world](https://shittim-chest.docs.celestia.world) |
| [entelecheia](https://github.com/celestia-island/entelecheia) | 多智能体协作平台：exec-only 微内核、scepter 编排服务器、IEPL 执行管线 | [entelecheia.docs.celestia.world](https://entelecheia.docs.celestia.world) |
| [evernight](https://github.com/celestia-island/evernight) | 工业协议网关：Modbus、S7comm、OPC UA；远程操作、遥测、写阀门 | [evernight.docs.celestia.world](https://evernight.docs.celestia.world) |
| [malkuth](https://github.com/celestia-island/malkuth) | 服务监督工具包：滚动更新、健康探针、反向代理、崩溃循环恢复 | [malkuth.docs.celestia.world](https://malkuth.docs.celestia.world) |
| [lagrange](https://github.com/celestia-island/lagrange) | 支撑本站与所有项目文档站的 Markdown 文档引擎 | [lagrange.docs.celestia.world](https://lagrange.docs.celestia.world) |

## 工具与库

| 项目 | 角色 | 文档 |
| --- | --- | --- |
| [noa](https://github.com/celestia-island/noa) | AI 原生分布式版本控制：每智能体工作区隔离、JSONL 追加日志、快照历史 | [noa.docs.celestia.world](https://noa.docs.celestia.world) |
| [seia](https://github.com/celestia-island/seia) | 多引擎网络搜索库与 CLI | [seia.docs.celestia.world](https://seia.docs.celestia.world) |
| [ichika](https://github.com/celestia-island/ichika) | 线程池管线宏（基于 flume 消息管道） | [ichika.docs.celestia.world](https://ichika.docs.celestia.world) |
| [yuuka](https://github.com/celestia-island/yuuka) | 用简单宏生成复杂嵌套结构的 proc-macro | [yuuka.docs.celestia.world](https://yuuka.docs.celestia.world) |
| [aoba](https://github.com/celestia-island/aoba) | Modbus 与数据源 CLI | [aoba.docs.celestia.world](https://aoba.docs.celestia.world) |
| [kou](https://github.com/celestia-island/kou) | 独立虚拟终端引擎：PTY 管理、VT100/ANSI | 仓库内 |
| [hifumi](https://github.com/celestia-island/hifumi) | 数据跨版本迁移的序列化库 | 仓库内 |
| [aris](https://github.com/celestia-island/aris) | 源自 servo 的浏览器引擎，可作库嵌入（数字孪生的 WebGL） | 仓库内 |
| [shirabe](https://github.com/celestia-island/shirabe) | 轻量 Rust 原生浏览器自动化与调试库 | 仓库内 |
| [tairitsu](https://github.com/celestia-island/tairitsu) | 基于 WASM Component Model 的全栈框架 | 仓库内 |
| [ratatui-markdown](https://github.com/celestia-island/ratatui-markdown) | 面向 ratatui TUI 的 Markdown 渲染 | 仓库内 |
| [arcaea](https://github.com/celestia-island/arcaea) | celestia persona 协议的 Rust 库 | 仓库内 |
| [scriptum](https://github.com/celestia-island/scriptum) | entelecheia 的终端界面（TUI）：与 scepter 服务器对话的"哑显示" | 仓库内 |

## 边缘与硬件

| 项目 | 角色 | 文档 |
| --- | --- | --- |
| [kei](https://github.com/celestia-island/kei) | ARM64/RISC-V 边缘设备的 Rust 内核；长期地平线的确定性实时核心 | 仓库内 |

## 基础设施与工具链

| 项目 | 角色 | 文档 |
| --- | --- | --- |
| [celestia-devtools](https://github.com/celestia-island/celestia-devtools) | 共享开发工具链：justfile 配方、补丁注册、lint | 仓库内 |
| [celestia-integration](https://github.com/celestia-island/celestia-integration) | 全闭环真机集成测试套件 | 仓库内 |
| [sysl](https://github.com/celestia-island/sysl) | Synthetic Source License（SySL）：为 AI 生成代码设计的许可证 | 仓库内 |

## 站点

| 资产 | 角色 | 文档 |
| --- | --- | --- |
| [celestia-island.github.io](https://celestia-island.github.io) | 组织存在 | 仓库内 |
| [docs.celestia.world](https://docs.celestia.world) | 本站 —— 哲学、地图、快速开始 | 仓库内 |
| [e.celestia.world](https://e.celestia.world) | 公开落地页 | 仓库内 |
| [dev.celestia.world](https://dev.celestia.world) | 开发者门户 | 仓库内 |
| [arona.celestia.world](https://arona.celestia.world) | 云 API 管理面板（产品） | — |

## 深入阅读

- [分层架构](../philosophy/layered-architecture.md) —— 这些层为何存在。
- [闭环](../philosophy/closed-loop.md) —— 项目如何沿闭环协作。
- [站点分工](./sites.md) —— 谁负责什么文档、在哪里。
