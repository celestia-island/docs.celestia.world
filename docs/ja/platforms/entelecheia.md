# Entelecheia — エージェントプラットフォームとメモリ

Entelecheia はエージェントプラットフォームです: 特化エージェント
（「ソウル」）をオーケストレーションし、長期メモリ（PhiLia）を維持し、
セマンティック検索を提供し、産業統合レイヤをホストする scepter ランタイム。
Arona と Chest の能力の背後にこのプラットフォームが立っています。この
ガイドは機能別に構成されています: エージェント、メモリ、検索、ナレッジ、
接続。

## アーキテクチャの概観

```text
クライアント: Arona (ゲートウェイ) · Shittim Chest (チャット/パネル) · TUI/CLI
        │  WebSocket 上の JSON-RPC 2.0 (トークンまたは API キー)
        ▼
   scepter ランタイム (node-3:8424)
   ├─ エージェントマネージャ: L1 ソウル (PhiLia, Skopeo, Hubris, Kalos, …)
   ├─ スキルチェーン: RAG プリフェッチ付きの LLM + ツール呼び出しのパイプライン
   ├─ PhiLia: 長期メモリ (ベクトル + グラフ、pgvector バック)
   ├─ ApoRia: ナレッジベース + ワークスペースインデックス (セマンティック検索)
   ├─ OreXis: ツール実行へのポリシー/安全ゲート
   └─ リフレクション: レッスンストアをプロンプトへ再注入
```

## 1. エージェント（ソウル）

各ソウルは、独自のアイデンティティドキュメント、ツール（MCP スタイル）、
スキルを持つ特化エージェントです。スキルチェーンは LLM 呼び出しとツール
実行を組み合わせます。各呼び出しの前に、関連する長期メモリとナレッジ
ベースの内容がプリフェッチされ、システムプロンプトへ注入されます。

安全面: ツール実行は OreXis のポリシーゲートを通り、産業への書き込みには
明示的な承認フローが必要です。

## 2. 長期メモリ（PhiLia）

PhiLia は Arona のメモリゲートウェイの背後にあるメモリサービスです:

- **保存** —— エピソード、エンティティ、アーティファクトはメモリグラフの
  ノードとして保存され、埋み込まれ、pgvector（`philia_chunks`）へ
  ミラーされます。
- **照会** —— セマンティック検索はベクトル類似度、グラフ走査、新しさの
  減衰（半減期 14 日）を組み合わせます。
- **統合** —— 定期的なマージが関連ノードをリンクします。
- **ワイヤサーフェス** —— 第一級メソッド `Sync.MemoryStoreRequest` /
  `MemoryQueryRequest` / `MemoryDeleteRequest`（RBAC: SystemWrite /
  SystemRead）が汎用 `Mcp.CallTool` ルートと並びます。

埋め込み: `OLLAMA_HOST` + `OLLAMA_EMBED_MODEL`（例: `nomic-embed-text`）で
設定するか、リモート API を使うか、ローカルの ONNX モデルへフォールバック
します。

## 3. セマンティック検索

`Sync.SearchRequest` は 2 つのストアを 1 つのランキングリストへ融合します:

- **ApoRia** —— ワークスペースインデックス、エージェントレポート、
  ナレッジベースドキュメント（RRF 付きのベクトル + キーワードハイブリッド）。
- **PhiLia** —— 長期メモリ（`philia_memory` ソース）。

## 4. ナレッジベース

ナレッジベースを作成し、ドキュメントを追加し、rag サブスクリプションを
購読します —— すべて Postgres に永続化されます。ドキュメントは ApoRia
ストアへ埋め込まれ、同じ検索サーフェスから取得できます。

## 5. リフレクション

得られた教訓はレッスンストア（pgvector）に保存され、将来のプロンプトへ
再注入されます —— PhiLia と並ぶ、2 番目の軽量な永続メモリです。

## 6. クライアントの接続

- WebSocket `ws://<host>:8424/ws` —— アップグレード時に
  `?token=<connection token>`（または Bearer）で認証します。その後
  `Sync.ConnectHandshake`。
- HTTP JSON-RPC `POST /api/rpc?token=…` はリクエスト/レスポンス用途です。
- 接続トークン: scepter ノード上の
  `~/.config/entelecheia/scepter.token`。

## 環境変数リファレンス（抜粋）

| 変数 | 用途 |
|---|---|
| `SERVER_BIND_ADDRESS` | バインドアドレス（デフォルト 127.0.0.1。リモートクライアントには 0.0.0.0:8424 を設定） |
| `DATABASE_URL` | Postgres（config.toml または環境変数） |
| `OLLAMA_HOST` / `OLLAMA_EMBED_MODEL` | 埋め込みバックエンド |
| `JWT_SECRET` | 永続認証トークン（未設定ならセッションごとにランダム） |
| `connection_token` | Scepter 接続トークンファイル |
