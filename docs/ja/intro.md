# celestia-island へようこそ

**celestia-island** は産業用 AI 制御のためのプロジェクト群です。マルチ
エージェントコラボレーション、遠隔運用、そして安全性重視の自動化を
実現します。このサイトはその *why* —— 哲学、エコシステムマップ、
そしてエントリーポイントをまとめたものです。*how* は、ここから
リンクされる各プロジェクトのドキュメントサイトにあります。

## 3 つの問いに答える

| 問い | どこ | 見つかるもの |
| --- | --- | --- |
| **なぜこれが存在するのか？** | [哲学](./philosophy/why.md) | 解決しようとしている問題、クローズドループ、安全のドクトリン、長期的な展望 |
| **中身は何か？** | [エコシステム](./ecosystem/projects.md) | すべてのプロジェクト、ループ内での役割、ドキュメントの置き場所 |
| **どう始めるか？** | [始め方](./getting-started/quickstart.md) | アカウント作成から動作するチャットエージェントと産業制御まで 30 分でたどる道筋 |

## 1 段落の要約

celestia-island は、AI による産業制御のために**発見から検証までの
クローズドループ**を構築します。発見 → インストール → 認証 → モデル
デプロイ → チャットとエージェント実行 → 産業機器の制御 → すべての
検証。このループは小さく厳密にレイヤ化された部品から組み立てられます。
認証プリミティブ（[kirino](https://github.com/celestia-island/kirino)）、
プラットフォーム基盤（[plana](https://github.com/celestia-island/plana)）、
UI コンポーネント（[hikari](https://github.com/celestia-island/hikari)）、
そしてビジネスロジックのみを実装するサービス群
（[arona](https://github.com/celestia-island/arona)、
[shittim-chest](https://github.com/celestia-island/shittim-chest)、
[entelecheia](https://github.com/celestia-island/entelecheia)、
[evernight](https://github.com/celestia-island/evernight)）です。
何かが二重実装されることは決してありません。汎用機能は上流で一度
構築され、下流のすべてのサービスがそれを利用します。

その理由は単純な観察にあります。月までの往復には 2.6 秒、火星まで
は 6〜44 分かかります。そこにあるロボットは地球の人間を待つことが
できません —— 現地で自律的に動作しなければならないのです。私たちが
今日産業制御のために構築している意思決定層、世界モデル、安全ゲートは、
将来の自律性が必要とするものと同じ形なのです。

## すべての配置場所

- **プロジェクト別ドキュメント** —— `<name>.docs.celestia.world`。
  各リポジトリから構築されます。完全な一覧は
  [サイトと所有](./ecosystem/sites.md) を参照してください。
- **組織の存在** —— [GitHub 上の celestia-island](https://github.com/celestia-island)。
- **プロダクトパネル（ベータ期間中は WIP）** —— [arona](https://arona.celestia.world)
  （クラウド API 管理パネル）、[dev](https://dev.celestia.world)
  （開発者ポータル）。ベータ期間中、ライブパネルは内部の `arona:8420`
  で実行されます。

右下の言語切り替えを使って、このサイトを別の言語で読むことができます。
コンテンツは英語で執筆され、翻訳は同じ構造に従います。
