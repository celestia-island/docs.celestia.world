# Web UI —— 从第一句话开始的旅程

一个账户、一把密钥、一段对话。本页走产品走过的同一条路——模型变得可用，密钥为它鉴权，一轮对话带着记忆运行，而一块面板把它变成你能操作的东西。

![控制台](https://raw.githubusercontent.com/celestia-island/docs.celestia.world/master/res/screenshots/arona-dashboard.png)

## 模型：从来源到被调用

一个模型从"存在"到"可聊天"，要走过四个阶段：**来源**（提供商目录——只有元数据，不做推理）→ **注册**（一个后端，可以是本地运行时或任意 OpenAI 兼容服务；它熬得过重启）→ **部署**（模型 ID 被交给某个节点，节点下载它并启动运行时）→ **路由**（最少在途请求的负载均衡，带会话亲和）。尚未通过首次健康探测的后端会被拒绝，而不是被尝试。

## 身份与计量

![API 密钥](https://raw.githubusercontent.com/celestia-island/docs.celestia.world/master/res/screenshots/arona-apikeys.png)

![用量与账单](https://raw.githubusercontent.com/celestia-island/docs.celestia.world/master/res/screenshots/arona-billing.png)

**API 密钥**是你的身份——网关用 Bearer 令牌鉴权，`curl` 与工作台都凭它进门。**用量**是按密钥、逐次调用的流水：token、模型、后端、成本。**计费**档位设定配额；撞上配额是硬拒，不是降速。

## 聊天与记忆

![聊天](https://raw.githubusercontent.com/celestia-island/docs.celestia.world/master/res/screenshots/arona-playground.png)

每一轮都经过记忆服务——每轮上的徽章会告诉你走没走。`Memory on` 表示路由前注入了相关的长期记忆；`Memory offline` 表示记忆服务不可达（这是诚实信号，不是 bug）；`disabled` 表示没找到相关内容。完成的轮次会被提取并持久化，所以记忆熬得过重启——写回条目也可以直接在 Memory 页删除。

## 面板与工业控制

![智能体](https://raw.githubusercontent.com/celestia-island/docs.celestia.world/master/res/screenshots/arona-agents.png)

一条提示词创建一块面板；引擎生成布局，并把它持久化进工作区。编辑是结构化的——数据源绑定、组件清单、连接状态——不是黑盒。Topology 与 Holographic 是同一批设备的两种看法；Reports 在历史之上加了语义搜索。工业写入要先过策略校验和**人工审批**，然后才有任何动作：这是闭环的终点，也是最重的一步。

![登录](https://raw.githubusercontent.com/celestia-island/docs.celestia.world/master/res/screenshots/arona-login.png)

## 深入阅读

- [Arona](../platforms/arona.md) —— 网关与部署面板。
- [Shittim Chest](../platforms/chest.md) —— 工作台与它的面板。
- [Entelecheia](../platforms/entelecheia.md) —— 智能体、工作区与工业写阀门。
