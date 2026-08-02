# 分层架构

生态之所以可控，是因为它被严格分层。依赖只朝一个方向：**下游服务消费上游能力；通用能力绝不重复实现。**

## 四层结构

| 层 | 项目 | 提供什么 |
| --- | --- | --- |
| **第 0 层 — 认证** | [kirino](https://github.com/celestia-island/kirino) | 零信任原语：JWT 签发与刷新、Argon2id 密码哈希、登录限流、RBAC 引擎、邀请存储、会话 |
| **第 1 层 — 平台** | [plana](https://github.com/celestia-island/plana) | 共享设施：JSON-RPC 2.0 类型与路由、服务 DTO、网络探测、SSE 会话、熔断器、LLM 计量与定价 |
| **第 2 层 — UI** | [hikari](https://github.com/celestia-island/hikari) | 全体 WebUI 共享的 UI 组件库（Vue/TS + Rust） |
| **第 3 层 — 服务** | [arona](https://github.com/celestia-island/arona)、[shittim-chest](https://github.com/celestia-island/shittim-chest)、[entelecheia](https://github.com/celestia-island/entelecheia)、[evernight](https://github.com/celestia-island/evernight)、[malkuth](https://github.com/celestia-island/malkuth)、[lagrange](https://github.com/celestia-island/lagrange) | 仅业务逻辑。消费第 0–2 层，加上让每个产品成真的行为 |

## 教义

1. **绝不实现第二遍。** 写代码前先问：kirino 有吗？plana 有吗？hikari 有吗？例如：JSON-RPC 类型来自 plana，JWT 来自 kirino，登录限流来自 kirino，熔断器来自 plana，health DTO 来自 plana，定价来自 plana。
2. **通用能力放上游。** 会被两个及以上服务复用的特性，先建进 kirino / plana / hikari，再被消费。
3. **禁止反向依赖。** 服务依赖 kirino/plana/hikari；plana 可依赖 kirino；kirino 永不依赖 plana 或 hikari。
4. **先扩展上游，再消费。** 上游缺能力就扩展上游，然后再消费。新能力绝不在服务里先做一版、之后再重写。
5. **跨仓依赖一律 git reference。** 所有仓库通过 git reference 消费上游（`master` 分支或钉版），禁止本地 path 依赖。每个仓库在任何机器上构建结果一致。

## 为什么重要

- **一次修复，处处生效。** kirino 的安全修复随着依赖升级到达每个服务，而不是在复制品里挨个排查。
- **评审与风险成比例。** 第 3 层改动是产品逻辑；第 0 层改动是基础设施——评审门槛因此不同。
- **地图保持可读。** 新工程师读这一页，就知道任何能力住在哪里。[项目地图](../ecosystem/projects.md)是全量清单。

## 深入阅读

- [为什么有 celestia-island](./why.md) —— 分层背后的问题。
- [安全原则](./safety.md) —— 坐落在各层之上的教义。
- [项目地图](../ecosystem/projects.md) —— 按层排列的全部仓库。
