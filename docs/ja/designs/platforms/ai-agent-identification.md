# AI エージェント識別とコミットの Co-author 戦略

## 概要

`evernight` は celestia-island の co-author 戦略に 2 つの形で参加する：

1. **コミットホストとして**：AI エージェントが evernight を通じてコミットをオーケストレーションするとき（ホスト A 上の agent → evernight の SSH／exec → ホスト B → `git commit`）、ホスト側の `commit-msg` フック（`noa` がインストール）がローカルで発火し、コミットに来歴メタデータを刻印する。
2. **中継 provider として**：evernight がモデルトラフィックを中継するとき、提供プラットフォームとして author email に現れ、トランスポートホップを監査可能にする。

本書は evernight の役割を規定する。権威ある仕組みは `noa` の設計文書で定義されており、本書は evernight 固有の統合を扱う。

## Provider アイデンティティモデル

author email は `celestia.world` の信頼名前空間を使用する：

```text
Display Name <provider-<or-platform-id@celestia.world>>
```

evernight がモデルを中継するとき、provider id はその中継を反映する：

```text
GLM 5 <evernight.<celestia.world@celestia.world>>   # GLM 5 を evernight 経由でリレー
```

ファーストパーティの provider は自身のドメインを維持し（`anthropic.com`、`deepseek.com`、`zhipuai.cn`、……）、サードパーティの中継も同様に維持する（`opencode.ai`、`jdcloud.com`、`openrouter.ai`、……）。これにより「どのモデルを、誰を経由して」使ったかの連鎖がすべてのコミットで可視化される。

## Co-author トレーラー

- トレーラーキー：`Co-authored-by`（git 認識済み）。
- モデルごとに 1 つ、使用順に並べる。
- YOLO クルーズコントロール下で完全に実行されたチェーンは、追加で以下を得る：
  `Co-authored-by: Entelecheia <demiurge@celestia.world>`。

## 組み込みトークン使用量

co-author トレーラーの後に追加される（空行で区切る）：

```text
Co-authored-by: Claude Opus 4.8 (↑ 12.5k ↓ 8.3k ●45.2k) <anthropic.<com@celestia.world>>
Co-authored-by: Deepseek V4 Pro (↑ 5.1k ↓ 3.2k) <deepseek.<com@celestia.world>>
```

- `Upload` = 入力トークン、`Download` = 出力トークン。
- `Cache` は、キャッシュされた入力トークンが報告され、かつ > 0 のときのみ現れる。
- カウントは千単位（`k`）、小数第 1 位、末尾のゼロは切り詰める。

## evernight の統合ポイント

### ホスト側フック

`evernight` の `Command.Exec` JSON-RPC（entelecheia の surgery パイプラインと `KaLos:auto_fix` ループが使用）経由のコミットはシステムの `git` を起動するため、`noa hook install` がインストールした `.git/hooks/commit-msg` フックがそのまま適用される。フックがインストールされたホスト上で行われるコミットについて、evernight 側のコード変更は不要である。

### 中継 provider のアイデンティティ

evernight が LLM トラフィックをプロキシするとき（例：モデル呼び出しをリモートホストのローカル推論へルーティング）、co-author リゾルバに中継エンドポイントを伝えることで、provider id を `evernight.celestia.world` にできる。これは `noa co-author resolve` が読む `aporia.toml` と同じ provider リストで設定される。

## 完全なコミットメッセージ例

```text
perf(screen): cache X11 connection to avoid per-frame reconnect

X11CaptureBackend previously called x11rb::connect on every capture_frame.
Cache the connection in a Mutex<Option<..>>, reusing it across frames.

Co-authored-by: Entelecheia <demiurge@celestia.world>
Co-authored-by: Deepseek V4 Pro (↑ 18.2k ↓ 2.1k) <deepseek.<com@celestia.world>>
```

## セキュリティ上の考慮事項

- co-author トレーラーは自己申告の来歴であり、暗号論的な証明ではない。
- リゾルバは安全に劣化する：`noa` の欠落やパースエラーの場合は空のブロックとなり、コミットは改変されずに進む。
- provider 識別子はローカルの `aporia.toml` に由来し、設定された provider を反映する。

## Provider 識別子リファレンス（初期レジストリ）

| provider id | ブランド | エンドポイントの目安 |
| --- | --- | --- |
| `zhipuai.cn` | GLM | `open.bigmodel.cn` |
| `deepseek.com` | Deepseek | `api.deepseek.com` |
| `anthropic.com` | Claude | `api.anthropic.com` |
| `openai.com` | GPT / OpenAI | `api.openai.com` |
| `evernight.celestia.world` | （中継） | evernight プロキシ |
| `opencode.ai` | （中継） | `opencode.ai` |
| `jdcloud.com` | （中継） | `jdcloud.com` |
