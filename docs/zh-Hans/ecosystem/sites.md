# 站点分工

本生态的文档遵循一条规则：**中心站解释为什么与在哪里；每个项目站解释怎么做。** 这让中心站保持精小，项目站保持权威。

## 谁拥有什么

| 站点 | 拥有 | 内容 |
| --- | --- | --- |
| [docs.celestia.world](https://docs.celestia.world) | 生态 | 哲学、生态地图、快速开始、治理（许可证、CLA、行为准则、安全、贡献指南） |
| `<name>.docs.celestia.world` | 每个项目 | 指南、架构、设计、参考——由项目自身仓库构建 |
| [celestia-island.github.io](https://celestia-island.github.io) | 组织 | 存在、链接、品牌资产 |
| [e.celestia.world](https://e.celestia.world) | 公众面孔 | 落地页、定价、博客、行动号召 |
| [dev.celestia.world](https://dev.celestia.world) | 开发者 | 开发者门户与状态 |

## 唯一规则：不重复

- 中心站**绝不复制**项目文档。主题属于项目（协议如何工作、服务如何配置），中心站就链接过去，而不是转述。
- 项目站**可以链回**中心站获取哲学与跨项目上下文。
- 当一个项目足以自行维护文档时，中心站将其覆盖范围缩减为地图条目加链接。

## 站点如何构建

每个文档站（含本站）都用 [lagrange](https://github.com/celestia-island/lagrange) 从项目仓库中的 Markdown 构建，带共享语言切换器。内容以英文撰写；翻译遵循同一结构，部分翻译会明确标注。

## 深入阅读

- [项目地图](./projects.md) —— 存在哪些站点、服务于哪些项目。
- [贡献指南](../meta/CONTRIBUTING.md) —— 如何为文档做贡献。
