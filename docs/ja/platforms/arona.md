# Arona — モデルゲートウェイ、メモリ、クラスタ

Arona はプラットフォームのコントロールプレーンです: モデルゲートウェイ、
セルフデプロイのランタイムマネージャ、Web ダッシュボード。解決する問題は、
「どこかのマシンにダウンロードされたモデル」を、プラットフォーム全体が
ルーティングし、計測し、記憶できるものに変えることです。このガイドは
機能別に構成されています: モデルルーティング、長期メモリ、マルチノード
クラスタ。

## アーキテクチャの概観

```text
shittim-chest / 任意の OpenAI クライアント
        │  /v1/chat/completions (Bearer API キー)
        ▼
   Arona ゲートウェイ (node-2:8420)
   ├─ ルータ: エイリアス → バックエンド横断の least-count ロードバランシング
   ├─ メモリゲートウェイ: リコール注入 → チャット → 書き戻し (エピソード)
   └─ エージェントコントロールプレーン (/ws/agent) ──► GPU ノード上の arona-agent
        │
        ▼
   バックエンド: ollama · 外部 (OpenAI 互換) · エージェントデプロイのエンジン
```

すべての管理トラフィック（ダッシュボード、エージェント、メモリ）は
JSON-RPC 2.0 メッセージで WebSocket 上を流れます。唯一の REST サーフェスは
OpenAI 互換の `/v1/*` エンドポイントです。

## 1. モデル

### バックエンドを登録する

バックエンドは `ollama` または `external`（任意の OpenAI 互換サーバー ——
vLLM、TGI、LMDeploy、TileRT のルータ、…）として登録します:

```bash
POST /api/admin/backends        # Bearer ADMIN_TOKEN
  {"type": "ollama", "name": "node3-ollama", "url": "http://host:11434"}
  {"type": "external", "name": "my-vllm", "url": "http://host:8000",
   "api_key": "...", "models": ["qwen2.5-72b"]}
```

登録されたバックエンドは再起動を越えて保持され（`backend_configs` テーブル）、
継続的にヘルスプローブされます。外部バックエンドは最初の `/v1/models`
プローブが成功するまでフェイルクローズドであり、モデルリストは動的に
更新されます。

### ノードにモデルをセルフデプロイする

`arona-agent` バイナリは GPU マシン上で動作し、パネルへ接続し戻ります。
ダッシュボードの **Agents** ページからモデルをデプロイします（または
`agents.deploy` の `agent_id` を空にして、最も負荷の低いノードを自動
ターゲットにします）。エージェントはモデルをダウンロードし（HuggingFace
または Ollama レジストリ）、エンジン（llama.cpp / vLLM / Ollama）を起動し、
エンジンのエンドポイントを報告します —— パネルはそれをルーティング可能な
`agent-{model}` バックエンドとして自動登録し、停止時に削除します。

エンジンのバインドアドレス: パネルへトラフィックを供給する必要がある
ノードでは `ARONA_AGENT_BIND_ADDR=0.0.0.0` を設定します。注意: エンジンの
ポートは認証なしです —— 信頼できるネットワークでのみデプロイしてください。

### 会話アフィニティ

会話は 1 つのバックエンドに固定され（セッションアフィニティ）、ランタイム
の KV キャッシュを再利用できます。固定先のバックエンドが不健全になると、
ルータはフォールバックして再固定します。

## 2. 長期メモリ

Arona は**メモリゲートウェイ**です: モデルを訓練するのではなく、既存の
モデルの周りでメモリサービス（entelecheia の PhiLia エージェント）を
オーケストレーションします。

### 有効化する

```bash
ARONA_MEMORY_URL=ws://<scepter-host>:8424/ws
ARONA_MEMORY_TOKEN=<scepter connection token>
ARONA_MEMORY_WRITEBACK=1        # デフォルトでオン。0 で書き戻しを無効化
```

### チャットごとに何が起きるか

1. **リコール** —— 最後のユーザーメッセージが埋め込まれ、メモリサービスへ
   照会されます。関連するメモリは `## Relevant Long-Term Memories`
   システムセクションとして注入されます（冪等）。
2. **チャット** —— 組み立てられたコンテキストがモデルへルーティング
   されます。
3. **書き戻し** —— 完了したターンがヒューリスティックに抽出され
   （`User: … / Assistant: …`、LLM 呼び出しゼロ）、メモリグラフへ
   エピソードとして保存されます（pgvector バック、再起動を越えて存続）。
4. **状態** —— すべてのレスポンスが `memory: enabled | disabled | offline`
   を報告し、REST サーフェスは `X-Arona-Memory` ヘッダーを追加します。
   失敗がチャットをブロックすることはありません。`offline` はメモリ
   サービスに到達できないことを意味し、UI で常に可視です。

呼び出しごとのオーバーライド: `chat.send` は `memory: true|false` を
受け付けます。

### 管理する

ダッシュボードの **Memory** ページはリコール/書き戻し/削除のアクティビティ
を表示し、保存されたノードを削除できます。セッションはサーバー側で永続化
されます: `chat.send` に `conversation_id` を渡すと、クライアントではなく
サーバーが履歴を組み立てます。

## 3. 運用

- **認証**: 登録は最初の管理者ブートストラップ後にロックされます
  （`ARONA_REGISTRATION_OPEN=1` で再開）。管理エンドポイントは
  `ARONA_ADMIN_TOKEN` を要求し、それがなければフェイルクローズドします。
- **計測**: 利用量とコストは API キーごとに記録されます（`usage.list`、
  クォータとレート制限付きの課金ティア）。
- **ヘルス**: `/api/health` と `/v1/health` がバージョンとビルドハッシュを
  報告します。

## 環境変数リファレンス

| 変数 | 用途 |
|---|---|
| `DATABASE_URL` | Postgres（必須） |
| `JWT_SECRET` | トークン署名（モックモード外では必須） |
| `ARONA_HOST` / `ARONA_PORT` | バインドアドレス（デフォルト `0.0.0.0:8420`） |
| `ARONA_ADMIN_TOKEN` | `/api/admin/*` 用の Bearer トークン |
| `ARONA_REGISTRATION_OPEN` | 自己登録を再開する |
| `ARONA_MEMORY_URL` / `ARONA_MEMORY_TOKEN` / `ARONA_MEMORY_WRITEBACK` | メモリゲートウェイ |
| `ARONA_AGENT_NAME` / `ARONA_PANEL_URL` / `ARONA_AGENT_BIND_ADDR` | エージェントノード |
