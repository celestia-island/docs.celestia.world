# Web UI — 最初の一文から始まる旅

二つの画面、一つの流れです。**arona** はヘッドレスのコントロールプレーン
（モデル、キー、台帳、メモリ）であり、**shittim-chest** はあなたが実際に
眺めるワークベンチ（チャット、パネル、世界を見ること）です。以下の画面は
すべて chest のビューです —— chest は arona の RPC サーフェス越しに
対話し、arona 自身は UI を持ちません。

![chest バックエンドコンソール](https://raw.githubusercontent.com/celestia-island/docs.celestia.world/master/res/screenshots/arona-dashboard.png)

## モデル：ソースから呼び出しまで

モデルは「存在する」から「チャットできる」まで、四つの段階を旅します：
**ソース**（Providers カタログ —— メタデータであって推論ではない）→
**登録**（`ollama` または OpenAI 互換の `external` バックエンド。再起動を
越えて保持される）→ **デプロイ**（Agents ページがモデル ID を
`arona-agent` ノードへ渡す。モデル名が空なら最も空いたノードが自動的に
選ばれる）→ **ルーティング**（Models ページ。セッションアフィニティ付きの
least-in-flight ロードバランシング）。外部バックエンドは最初のプローブが
成功するまでフェイルクローズドです。各段階の正確な API は
[arona ドキュメント](https://arona.docs.celestia.world) にあります。

## アイデンティティと従量課金

![chest API キー](https://raw.githubusercontent.com/celestia-island/docs.celestia.world/master/res/screenshots/arona-apikeys.png)

![chest 課金](https://raw.githubusercontent.com/celestia-island/docs.celestia.world/master/res/screenshots/arona-billing.png)

**API キー**はあなたのアイデンティティです —— ゲートウェイは Bearer
トークンで `/v1/*` を認証し、`curl` も chest も入り口でそれを提示します。
**Usage** はキーごと・呼び出しごとの台帳です：トークン数、モデル、
バックエンド、コスト。**Billing** のティアはクォータ（USD / トークン /
レート制限）を定めます。上限に達したときに返ってくるのは、緩やかな減速
ではなく明確な拒絶です。

## チャットとメモリ

![chest チャット](https://raw.githubusercontent.com/celestia-island/docs.celestia.world/master/res/screenshots/arona-playground.png)

すべてのチャットターンはメモリサービスを通ります —— 各ターンのバッジが、
実際に通ったかどうかを告げています。`Memory on` は、ルーティングの前に
関連する長期メモリが注入されたことを、`Memory offline` はメモリサービスに
到達できないことを（バグではなく正直さのシグナル）、`disabled` は関連する
ものが見つからなかったことを意味します。完了したターンはエピソードとして
抽出され永続化されるため、メモリは再起動を越えて存続します ——
書き戻されたエントリは Memory ページから直接削除できます。

## パネルと産業制御

![chest エージェント](https://raw.githubusercontent.com/celestia-island/docs.celestia.world/master/res/screenshots/arona-agents.png)

一つのプロンプトがパネルを生みます。エンジンがレイアウトを生成し、
scepter のワークスペースストレージへ永続化します。編集は構造的です ——
データソースのバインディング、コンポーネント一覧、接続状態。
ブラックボックスではありません。Topology と Holographic は同じフリートを
映す二つのビューであり、Reports が履歴へのセマンティック検索を加えます。
産業への書き込みは、何かが動く前にポリシー検証と**人間の承認**を通ります：
クローズドループの終点、そして最も重い一歩です。

![chest ログイン](https://raw.githubusercontent.com/celestia-island/docs.celestia.world/master/res/screenshots/arona-login.png)

## さらに詳しく

- arona プラットフォームの完全なリファレンス —— [arona ドキュメント](https://arona.docs.celestia.world)
- chest のワークベンチとそのパネル —— [shittim-chest ドキュメント](https://shittim-chest.docs.celestia.world)
- エージェント、ワークスペース、産業書き込みゲート —— [entelecheia ドキュメント](https://entelecheia.docs.celestia.world)
