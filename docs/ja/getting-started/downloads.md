# ダウンロード

何をインストールするかは、クローズドループのどこにいるかで決まります。
内部ベータの間、ほとんどの参加者に必要なのはデスクトップアプリだけです。
それ以外はすべて、管理者がホストするか、オプションです。

## デスクトップアプリ（shittim-chest）

shittim-chest デスクトップアプリは、すべての `v*` タグから
[GitHub Releases](https://github.com/celestia-island/shittim-chest/releases)
へ公開されます。インストーラは**未署名**です —— 初回起動時に OS の
セキュリティ警告が表示されます。最初のベータタグがプッシュされるまで、
ページは空のままです。

| プラットフォーム | アセット |
| --- | --- |
| Linux | `.AppImage` または `.deb` |
| Windows 10+ | `.exe` (NSIS) または `.msi` |
| macOS | 未公開 |

リリースビルドは Linux と Windows のみで、macOS はリリースパイプラインに
含まれません。最初のリリースまで（またはインストールなしを好む場合）は、
shittim-chest の [WebUI](https://shittim-chest.docs.celestia.world) を
使ってください。

## 管理パネル（arona）

Arona はサーバーホストです —— ローカルにインストールするものはありませ
ん。管理者が提供するパネル URL（公開デプロイメントでは
`https://arona.celestia.world`、内部では `http://<host>:8420`）を開き、
招待状でサインインしてください。

## エージェントランタイム（entelecheia/scepter、オプション）

自分でエージェントを運用する上級ユーザー向けに、entelecheia の README は
plana リポジトリの統合インストーラ
（[Linux/macOS](https://github.com/celestia-island/plana/blob/master/scripts/install/celestia-install.sh)、
[Windows](https://github.com/celestia-island/plana/blob/master/scripts/install/celestia-install.ps1)）
を定めています:

```bash
git clone https://github.com/celestia-island/plana.git
# arona/ と並べて entelecheia、evernight、scriptum、shittim-chest もクローン
cd arona/scripts/install
bash celestia-install.sh --source-root ../../..
```

Windows 版（WSL2）: `.\celestia-install.ps1 -SourceRoot ..\..\..`

entelecheia 本体をソースからビルドするには: `just bootstrap` がワーク
スペースをインストールし、続いて `just dev` が TUI を起動します。前提
条件は Rust 1.85+、Docker、`just` タスクランナーです。

## さらに詳しく

- [クイックスタート](./quickstart.md) —— 30 分でループを歩く道順。
- [クローズドベータガイド](./beta-guide.md) —— ベータの対象範囲とバグ報告方法。
- [プロジェクトマップ](../ecosystem/projects.md) —— すべてのプロジェクトの一覧。
