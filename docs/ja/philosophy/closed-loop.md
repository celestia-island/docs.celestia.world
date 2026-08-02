# クローズドループ

製品とはループであり、特定のプロジェクトではありません:

> 発見 → インストール → 認証 → モデルデプロイ → チャットとエージェント
> 実行 → 産業機器の制御 → 検証とサポート

各区間は特定のプロジェクト群が担当します。区間のどこかが壊れていれば、
プラットフォームは完成していません。

## 区間ごとの解説

| # | 区間 | 何が起きるか | プロジェクト |
| --- | --- | --- | --- |
| 1 | **発見** | 潜在ユーザーがエコシステムを見つけ、その哲学を理解し、エントリーポイントを選ぶ | [docs.celestia.world](https://docs.celestia.world)（本サイト）、[celestia-island.github.io](https://celestia-island.github.io)、[e.celestia.world](https://e.celestia.world) |
| 2 | **インストール** | 動作するシステムを手に入れる: 管理パネル、デスクトップ/ウェブシェル、監視下のサービス | [arona](https://github.com/celestia-island/arona)（クラウド API 管理パネル）、[shittim-chest](https://github.com/celestia-island/shittim-chest)（チャットデスクトップ/WebUI）、[malkuth](https://github.com/celestia-island/malkuth)（サービス監視） |
| 3 | **認証** | ゼロトラスト ID: 登録（招待制）、レート制限付きログイン、API キー、RBAC | [kirino](https://github.com/celestia-island/kirino)（認証プリミティブと RBAC エンジン） |
| 4 | **モデルデプロイ** | モデルランタイムを選び、ノードにデプロイし、チャットバックエンドにバインドし、利用量を計測する | [arona](https://github.com/celestia-island/arona)（パネル + バックエンド）、[entelecheia](https://github.com/celestia-island/entelecheia)（scepter ランタイム）、[plana](https://github.com/celestia-island/plana)（計測と価格設定） |
| 5 | **チャットとエージェント** | モデルと対話し、マルチエージェントコラボレーションを実行し、会話を保持し、メモリを管理する | [shittim-chest](https://github.com/celestia-island/shittim-chest)（UI とチャット）、[entelecheia](https://github.com/celestia-island/entelecheia)（エージェントオーケストレーション）、[noa](https://github.com/celestia-island/noa)（AI ネイティブバージョン管理） |
| 6 | **産業制御** | 遠隔運用とプロトコルブローカリング: Modbus、S7comm、OPC UA。テレメトリと書き込みゲート | [evernight](https://github.com/celestia-island/evernight)（プロトコルブローカー）、[aoba](https://github.com/celestia-island/aoba)（Modbus とデータソース CLI） |
| 7 | **検証とサポート** | 実ハードウェアでの統合テスト、監視と自己修復、利用記録、フィードバックチャネル | [celestia-integration](https://github.com/celestia-island/celestia-integration)、[malkuth](https://github.com/celestia-island/malkuth)、[plana](https://github.com/celestia-island/plana)（利用記録） |

## ループの振る舞い

- **すべてのステップがテスト可能。** 各区間には
  [celestia-integration](https://github.com/celestia-island/celestia-integration)
  に定義された受け入れテストがあります。ループ全体が実ノードで成功する
  まで、リリースはグリーンになりません。
- **すべてのステップが観測可能。** 監視、ヘルスエンドポイント、利用記録
  により、各区間の状態は想定ではなく可視化されます。
- **静かな劣化はしない。** 区間が劣化したとき（メモリがオフライン、
  バックエンドに到達不能など）、API レスポンスと UI はそれを明示します。
  失敗は設計上、明確に知らされます。
- **安全性は区間ではない。** 書き込みゲート、ポリシー検証、人間の確認は
  区間 5 と 6 に織り込まれており、最後に付け足されるものではありませ
  ん。[安全の原則](./safety.md) を参照してください。

## さらに詳しく

- [なぜ celestia-island なのか](./why.md) —— ループを定義する問題。
- [レイヤ化アーキテクチャ](./layered-architecture.md) —— 部品の順序がどのように保たれるか。
- [プロジェクトマップ](../ecosystem/projects.md) —— リポジトリの完全な一覧。
- [クイックスタート](../getting-started/quickstart.md) —— 30 分でループを歩く。
