# 下载

要安装什么，取决于你在闭环中的位置。内测期间大多数参与者只需要桌面应用；其余一切由你的管理员托管，或者属于可选项。

## 桌面应用（shittim-chest）

shittim-chest 桌面应用从每个 `v*` tag 发布到 [GitHub Releases](https://github.com/celestia-island/shittim-chest/releases)。安装包**未签名**——首次启动时会出现操作系统安全警告。在第一个 beta tag 推送之前，该页面保持为空。

| 平台 | 产物 |
| --- | --- |
| Linux | `.AppImage` 或 `.deb` |
| Windows 10+ | `.exe`（NSIS）或 `.msi` |
| macOS | 暂未发布 |

Release 构建只覆盖 Linux 与 Windows；macOS 不在发布流水线内。首个 release 之前（或如果你不想安装），请使用 shittim-chest [webUI](https://shittim-chest.docs.celestia.world)。

## 管理面板（arona）

Arona 由服务器托管——本地无需安装任何东西。打开管理员提供的面板 URL（公网部署为 `https://arona.celestia.world`，内网为 `http://<host>:8420`），使用你的邀请登录。

## Agent 运行时（entelecheia/scepter，可选）

对于自己运行 agent 的进阶用户，entelecheia 的 README 给出了 plana 仓库的统一安装器（[Linux/macOS](https://github.com/celestia-island/plana/blob/master/scripts/install/celestia-install.sh)、[Windows](https://github.com/celestia-island/plana/blob/master/scripts/install/celestia-install.ps1)）：

```bash
git clone https://github.com/celestia-island/plana.git
# 同时把 entelecheia、evernight、scriptum、shittim-chest 与 arona/ 并排克隆
cd arona/scripts/install
bash celestia-install.sh --source-root ../../..
```

Windows 等价命令（WSL2）：`.\celestia-install.ps1 -SourceRoot ..\..\..`

要从源码构建 entelecheia 本体：`just bootstrap` 安装工作区，`just dev` 启动 TUI。前置要求是 Rust 1.85+、Docker 与 `just` 任务运行器。

## 深入阅读

- [快速开始](./quickstart.md) —— 30 分钟走完闭环。
- [内测指南](./beta-guide.md) —— 内测覆盖什么、如何上报缺陷。
- [项目地图](../ecosystem/projects.md) —— 完整项目清单。
