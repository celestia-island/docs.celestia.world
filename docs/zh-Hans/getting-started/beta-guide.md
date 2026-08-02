# 内测指南

**内部封闭内测**覆盖从账户注册到工业控制的完整产品闭环。参与仅限受邀。

## 内测覆盖什么

1. **注册账户并创建 API 密钥**于 [Arona](https://github.com/celestia-island/arona) 云 API 管理面板。内测期间面板仅内网可访问（部署主机 `arona:8420`）。
2. **部署模型**并通过面板绑定聊天后端。
3. **聊天与运行智能体**于 [shittim-chest](https://github.com/celestia-island/shittim-chest) 桌面应用；智能体编排由 entelecheia 的 **scepter** 运行时提供。
4. **工业控制**：远程操作与协议桥接通过 [evernight](https://github.com/celestia-island/evernight) 运行。

## 获取访问

- 访问是**邀请制**。公开自助注册默认关闭。
- 邀请由维护者签发，绑定单一账户。
- 访问问题请通过[贡献指南](../meta/CONTRIBUTING.md)中的渠道联系。

## 上报缺陷

在 GitHub 上报问题，一 bug 一 issue，使用 issue 模板：

| 产品 | 仓库 |
| --- | --- |
| 聊天桌面/Web — shittim-chest | [celestia-island/shittim-chest](https://github.com/celestia-island/shittim-chest/issues) |
| 智能体编排 — entelecheia/scepter | [celestia-island/entelecheia](https://github.com/celestia-island/entelecheia/issues) |
| 工业控制 — evernight | [celestia-island/evernight](https://github.com/celestia-island/evernight/issues) |
| 管理面板与平台 — arona/plana | [celestia-island/arona](https://github.com/celestia-island/arona/issues) |

务必包含：环境信息（操作系统、产品版本）、复现步骤、期望与实际行为、相关日志。

## 已知限制

- Arona 面板内测期间**仅内网**，不对外暴露。
- 注册默认关闭；开放注册尚未就绪。
- WebRTC 设备中继与实时 SCADA 遥测需要运行中的 scepter 实例；缺失时 UI 回退到模拟演示数据。
- 移动应用与 IDE 插件不在内测范围。
- 部分语言的文档为部分翻译。

## 深入阅读

- [快速开始](./quickstart.md) —— 30 分钟走完闭环。
- [为什么有 celestia-island](../philosophy/why.md) —— 内测背后的哲学。
