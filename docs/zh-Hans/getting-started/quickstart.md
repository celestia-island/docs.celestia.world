# 快速开始

约 30 分钟走完[闭环](../philosophy/closed-loop.md)。确切地址取决于你的部署；面板 URL 与邀请请向你的管理员索取。

## 1. 获取账户

注册是邀请制：部署的首个用户成为管理员，此后自助注册上锁。联系维护者获取邀请，然后通过面板注册（公网部署为 `https://dev.celestia.world`，或使用你管理员的面板 URL）。

## 2. 创建 API 密钥

在面板中为你的账户创建 API 密钥。这把密钥就是你在下面一切操作中的身份——模型管理、聊天后端与智能体操作。

## 3. 部署模型

在面板中选择模型运行时，部署到节点，并绑定聊天后端。面板展示健康与用量；计量与定价由平台层处理。每一步具体做什么见 [Arona](../platforms/arona.md)。

## 4. 聊天与智能体

打开 [shittim-chest](https://dev.celestia.world)（桌面应用或 WebUI），用 API 密钥连接并开始对话。多智能体场景下，智能体平台在同一界面背后编排；智能体日志与工具调用在 UI 中可见。见 [Shittim Chest](../platforms/chest.md) 与 [Entelecheia](../platforms/entelecheia.md)。

## 5. 控制工业设备

在 [evernight](../platforms/evernight.md) 运行后，接入协议桥（Modbus、S7comm、OPC UA），订阅遥测，并在策略校验与人工确认之后发起写操作。内测期间此环节运行于模拟或实验室设备；安全链在两种情况下完全相同。

## 6. 验证

查看监督状态（[malkuth](https://github.com/celestia-island/malkuth)管理的服务）、检查用量记录，并按[内测指南](./beta-guide.md)中的渠道上报问题。若有断裂，说明闭环尚未完成——告诉我们断在哪里。

## 出了故障怎么办？

- **服务挂了** —— 监督应当已重启它；查看服务状态页或日志。
- **面板打不开** —— 确认你在正确的主机/端口上。
- **记忆或召回不可用** —— API 响应与 UI 会显式标注；没有它聊天仍可工作。

## 深入阅读

- [内测指南](./beta-guide.md) —— 内测覆盖范围与如何上报缺陷。
- [闭环](../philosophy/closed-loop.md) —— 这些步骤背后的哲学。
