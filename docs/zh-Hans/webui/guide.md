# Web UI —— 从第一句话开始的旅程

两个界面，一条动线：**arona** 是无界面的控制平面（模型、钥匙、账本、记忆）；**shittim-chest** 是你实际面对的工作台（聊天、面板、看世界）。下面每一屏都是 chest 的视图——chest 经由 arona 的 RPC 接口与它交谈；arona 本身不出 UI。页面只是入口，机制才是主角。

![Chest 后台控制台](https://raw.githubusercontent.com/celestia-island/docs.celestia.world/master/res/screenshots/arona-dashboard.png)

## 模型：从来源到被调用

一个模型从"存在"到"能被聊天用上"，要走过四个阶段：**来源**（Providers 目录——只有元数据，不做推理）→ **注册**（`ollama` 或 OpenAI 兼容的 `external` 后端，重启不丢）→ **部署**（Agents 页把模型 ID 交给某个 `arona-agent` 节点；模型名留空就自动挑最闲的节点）→ **路由**（Models 页；按最少在途请求做负载均衡，会话带亲和性）。external 后端是 fail-closed 的：首次探测成功之前一律拒绝路由。每一步的确切 API 见 [arona 文档](https://arona.docs.celestia.world)。

## 身份与计量

![Chest API 密钥](https://raw.githubusercontent.com/celestia-island/docs.celestia.world/master/res/screenshots/arona-apikeys.png)

![Chest 计费](https://raw.githubusercontent.com/celestia-island/docs.celestia.world/master/res/screenshots/arona-billing.png)

**API keys** 是你的身份——网关用 Bearer 令牌鉴权 `/v1/*`，`curl` 与 chest 都凭它进门。**Usage** 是每把钥匙的逐次调用流水：token、模型、后端、成本。**Billing** 档位设定配额（USD / token / 限流）；撞上配额是硬拒，不是降速。

## 聊天与记忆

![Chest 聊天](https://raw.githubusercontent.com/celestia-island/docs.celestia.world/master/res/screenshots/arona-playground.png)

每一轮聊天都会过记忆服务——每轮上的徽章会告诉你走没走。`Memory on` 表示路由前注入了相关的长期记忆；`Memory offline` 表示记忆服务不可达（这是诚实信号，不是 bug）；`disabled` 表示没找到相关内容。完成的轮次会被提取成 episode 并持久化，所以记忆熬得过重启——写回条目也可以在 Memory 页直接删除。

## 面板与工控

![Chest agent](https://raw.githubusercontent.com/celestia-island/docs.celestia.world/master/res/screenshots/arona-agents.png)

一个提示词创建一块面板；引擎生成布局，并把它持久化进 scepter 的 workspace 存储。编辑是结构化的——数据源绑定、组件清单、连接状态——不是黑盒。Topology 与 Holographic 是同一批设备的两种看法；Reports 在历史之上加了语义搜索。工业写入要先过策略校验和**人工审批**，然后才有任何动作：这是闭环的终点，也是最重的一步。

![Chest 登录](https://raw.githubusercontent.com/celestia-island/docs.celestia.world/master/res/screenshots/arona-login.png)

## 更深入的地方

- arona 平台的完整参考 —— [arona 文档](https://arona.docs.celestia.world)
- chest 工作台与它的面板 —— [shittim-chest 文档](https://shittim-chest.docs.celestia.world)
- Agent、workspace 与工控写门 —— [entelecheia 文档](https://entelecheia.docs.celestia.world)
