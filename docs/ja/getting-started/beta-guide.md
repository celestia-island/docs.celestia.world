# クローズドベータガイド

**内部クローズドベータ**は、アカウント登録から産業制御までの製品ループ
全体を対象とします。参加は招待制です。

## ベータの対象範囲

1. **アカウントを登録し、API キーを作成** —— [Arona](https://github.com/celestia-island/arona)
   クラウド API 管理パネルで行います。パネルはベータ期間中、内部のみ
   です（デプロイメントホストの `arona:8420`）。
2. **モデルをデプロイ** し、パネルからチャットバックエンドにバインド
   します。
3. **チャットとエージェント実行** ——
   [shittim-chest](https://github.com/celestia-island/shittim-chest)
   デスクトップアプリから。エージェントオーケストレーションは
   entelecheia の **scepter** ランタイムが提供します。
4. **産業制御** —— 遠隔運用とプロトコルブローカリングは
   [evernight](https://github.com/celestia-island/evernight) を通じて
   実行されます。

## アクセスの取得

- アクセスは**招待ベース**です。公開の自己登録はデフォルトで閉じられて
  います。
- 招待状はメンテナーが発行し、単一のアカウントに紐づきます。
- アクセスに関する質問は、[コントリビュート](../meta/CONTRIBUTING.md)
  に記載されているチャネルで問い合わせてください。

## バグの報告

問題は GitHub に、バグごとに 1 件、issue テンプレートを使って報告して
ください:

| 製品 | リポジトリ |
| --- | --- |
| チャットデスクトップ/ウェブ — shittim-chest | [celestia-island/shittim-chest](https://github.com/celestia-island/shittim-chest/issues) |
| エージェントオーケストレーション — entelecheia/scepter | [celestia-island/entelecheia](https://github.com/celestia-island/entelecheia/issues) |
| 産業制御 — evernight | [celestia-island/evernight](https://github.com/celestia-island/evernight/issues) |
| 管理パネルとプラットフォーム — arona/plana | [celestia-island/arona](https://github.com/celestia-island/arona/issues) |

必ず含めること: 環境情報（OS、製品バージョン）、再現手順、期待する
動作と実際の動作、関連するログ。

## 既知の制限

- Arona パネルは**内部のみ**で、ベータ期間中は公開されません。
- 登録はデフォルトで閉じられており、オープン登録はまだありません。
- WebRTC デバイスリレーとライブ SCADA テレメトリには、動作中の scepter
  インスタンスが必要です。ない場合、UI はシミュレートされたデモデータ
  にフォールバックします。
- モバイルアプリと IDE プラグインはこのベータの対象外です。
- 一部の言語のドキュメントは部分的な翻訳です。

## さらに詳しく

- [クイックスタート](./quickstart.md) —— ループを 30 分で歩く道筋。
- [なぜ celestia-island なのか](../philosophy/why.md) —— ベータの背後にある哲学。
