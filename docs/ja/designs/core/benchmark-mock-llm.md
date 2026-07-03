# Benchmark & Mock LLM サーバー設計

> コア命題：**任意のモデル + Entelecheia ツールシステムで、どれだけ多くのタスクをこなせるか？**
>
> 「弱い／強い」の分類は前提しない。環境変数でどの provider のキーが渡されたかによって、そのモデルのコーディングプラン（coding plan）設定を生成してテストする。キーが一つもなければ → そのままエラーで終了する。

## 0. 重要な発見：既存の Provider レジストリを再利用する

Entelecheia には**すでに**完全な env-var 駆動の provider ディスカバリシステムが存在する：

- `provider-registry` リポジトリ：926 個の TOML ファイル。OpenAI / Anthropic / DeepSeek / GLM / Qwen / Kimi / MiniMax など主要な provider をすべて網羅
- `derive_config_from_env()`：すべての entrypoint TOML を走査し、`env_var` が設定されている provider を自動的に有効化
- `ModelTier`（Deep / Normal / Basic）の 3 段階 + フォールバックチェーン
- `_shared_llm_provider::ProviderRegistry`：グローバル登録、5 種のプロトコル（OpenAI Chat / Responses / Anthropic v1/v2 / Gemini）

**provider レジストリを新設する必要はない** —— benchmark runner は `_shared_config` + `_shared_llm_provider` をそのまま再利用する。

## 1. コーディングプラン（Coding Plan）の概念

利用可能な各モデルに対し、benchmark プロファイルが自動生成される：

| フィールド | 出典 | 説明 |
|------|------|------|
| provider_id | entrypoint TOML | 例：`deepseek` / `zhipu_glm` |
| model_id | entrypoint defaults | 例：`deepseek-coder` / `glm-4-plus` |
| tier | ModelTier::Deep | コーディングタスクには Deep tier を使用 |
| base_url | entrypoint api.base_url | 実際のリモート API |
| api_key | 環境変数（entrypoint api.env_var） | 実行時に読み取る |
| protocol | entrypoint api.protocol | GenProtocol 列挙値 |
| context_window | モデルカード | `models/<provider>/<model>.toml` から読み取り |
| max_output_tokens | モデルカード | 同上 |
| supports_function_calling | モデルカード | ツール呼び出しの方式を決定 |

プロファイルは実行時に環境変数から動的に構築され、設定ファイルとして事前に保存はしない。

## 2. アーキテクチャ

```text
┌─────────────────────────────────────────────────────────┐
│                    Benchmark Runner                      │
│  (遍历数据集实例，收集结果，输出 JSONL)                     │
└──────────────┬──────────────────────┬───────────────────┘
               │                      │
       ┌───────▼────────┐    ┌────────▼────────┐
       │  Task Adapter   │    │  Result Collector│
       │ (SWE-bench /    │    │  (git diff →     │
       │  Aider / etc.)  │    │   JSONL output)  │
       └───────┬────────┘    └────────▲─────────┘
               │                      │
       ┌───────▼──────────────────────┴─────────┐
       │        Entelecheia Agent Runtime        │
       │  (SkoPeo 编排 → HubRis 规划 → 技能链)    │
       │                                         │
       │  ┌─────────┐  ┌─────────┐  ┌────────┐  │
       │  │ Tool    │  │ Skill   │  │ Soul   │  │
       │  │ Layer   │  │ Chain   │  │ Layer  │  │
       │  │(MCP)    │  │ Router  │  │(Identity)│ │
       │  └────┬────┘  └─────────┘  └────────┘  │
       └───────┼─────────────────────────────────┘
               │
       ┌───────▼─────────────────────────────────┐
       │          LLM Backend Switch              │
       │                                         │
       │  ┌─────────────┐    ┌─────────────────┐ │
       │  │ Mock Server  │    │ Real API Proxy  │ │
       │  │(record/replay)│   │(OpenAI/etc.)    │ │
       │  └─────────────┘    └─────────────────┘ │
       └─────────────────────────────────────────┘
               │
       ┌───────▼─────────┐
       │  Docker Sandbox  │
       │ (任务实例环境)    │
       │ - 代码仓库       │
       │ - 工具链         │
       │ - 测试套件       │
       └─────────────────┘
```

## 3. Mock LLM サーバー

### 3.1 Record/Replay プロトコル

Mock サーバーは OpenAI Chat Completions API（`/v1/chat/completions`）互換で、2 つの動作モードをサポートする：

**録画モード（初回に実際のモデルを動かすとき）**：
```text
Client → Mock Server → Real API → Mock Server (レスポンスを録画) → Client
```

**再生モード（CI／オフライン時）**：
```text
Client → Mock Server (リクエストを照合 → 録画済みレスポンスを返す) → Client
```

### 3.2 リクエスト照合戦略

リクエストは以下のフィールドのハッシュにより照合される：
- `model`（モデル名）
- `messages` の内容ハッシュ（正規化後）
- `tools` の構造ハッシュ（存在する場合）
- `temperature`、`max_tokens` などのパラメータ

**Strict モード**（CI ではデフォルトで有効）：未照合のリクエストは即座にエラーとなり、実際の API へフォールバックしない。フィクスチャの完全性を保証する。

**Lenient モード**（開発用）：未照合の場合は実際の API へフォールバックして録画する。

### 3.3 フィクスチャの格納

```text
tests/fixtures/llm/
├── swe-bench-verified/
│   ├── gpt-4o/
│   │   ├── <request_hash>.json      # 録画されたレスポンス
│   │   └── index.toml                # リクエスト要約のインデックス
│   ├── claude-sonnet/
│   └── llama-8b/
└── aider-polyglot/
    └── ...
```

### 3.4 実装の選択肢

| 方策 | 利点 | 欠点 |
|------|------|------|
| **AIMock**（CopilotKit） | 成熟、streaming／tool-calls／MCP 対応、Docker イメージあり | 外部依存 |
| **自前のシンプルなサーバー** | 完全に制御可能、外部依存ゼロ | streaming／エッジケースを自前で処理する必要あり |
| **VCR.py / wiremock** | 言語エコシステムが成熟 | LLM 専用ではない、要適応 |

**推奨**：まず自前のシンプルなサーバー（axum／actix のルータ 1 つで、照合 + JSON 返却）から始め、将来 streaming が必要になれば AIMock へ移行する。

## 4. SWE-bench アダプタ

### 4.1 タスク実行フロー

```text
for instance in dataset:
    1. SWE-bench Docker イメージを取得（base + env + instance の 3 層）
    2. コンテナを起動し、コードリポジトリをマウント
    3. issue テキストをタスク説明として注入
    4. Entelecheia Agent Runtime を起動（コンテナ内の bash／ファイルシステムへ接続）
    5. Agent が完了またはタイムアウトまで実行（step cap: 50、wall-clock: 15min）
    6. コンテナ内で git diff を実行 → パッチを抽出
    7. JSONL を出力: {instance_id, model_name_or_path, model_patch}
    8. コンテナを破棄
```

### 4.2 Agent Runtime の注入

Entelecheia が SWE-bench コンテナ内で実行される際、以下が必要になる：
- ファイル操作ツール → コンテナ内のファイルシステムへマッピング
- コマンド実行ツール → コンテナ内の bash へマッピング
- 検索ツール → `rg`／`grep`（コンテナ内にプレインストール）
- 当該タスクと無関係な agent（PoleMos／産業プロトコルなど）を**無効化**し、コンテキストノイズを低減

### 4.3 採点

SWE-bench ネイティブの harness をそのまま使用する：
```bash
python -m swebench.harness.run_evaluation \
    --dataset_name princeton-nlp/SWE-bench_Verified \
    --predictions_path entelecheia_predictions.jsonl \
    --max_workers 8 --run_id entelecheia-eval
```

出力：各インスタンスの resolved／unresolved、および resolution rate を集計。

## 5. 実験マトリクス

### 5.1 コア比較

データセットを固定（SWE-bench Verified）し、2 つの次元を変化させる：

|  | Baseline (mini-SWE-agent) | Entelecheia |
|--|---------------------------|-------------|
| **GPT-4o** | A₁ | B₁ |
| **Claude Sonnet** | A₂ | B₂ |
| **Llama 3.1 8B** | A₃ | B₃ |
| **Qwen 2.5 7B** | A₄ | B₄ |

- Bᵢ/Aᵢ = モデル i の増幅係数
- 行間比較：弱いモデル（Llama／Qwen）の AF は強いモデル（GPT-4o）より高いか？

### 5.2 アブレーション実験

| 構成 | 目的 |
|------|------|
| 完全な Entelecheia（12 agent + 全 skill） | フル装備のベースライン |
| HubRis + KaLos + SkeMma のみ（計画+ファイル+実行） | マルチ agent オーケストレーションの増分を計測 |
| KaLos + bash のみ（単一 agent + ファイルツール） | baseline に近く、skill chain の増分を計測 |
| soul identity なし（アイデンティティ／メタファーのプロンプトを除去） | persona プロンプトの効果を計測 |

## 6. 実装ロードマップ

### Phase 1：Mock LLM サーバー（1〜2 日）
- [ ] OpenAI 互換の record/replay サーバーを実装
- [ ] リクエストハッシュ照合 + strict／lenient モード
- [ ] フィクスチャの格納構造
- [ ] `ENTELECHEIA_LLM_BASE_URL` 環境変数による切替

### Phase 2：SWE-bench アダプタ（2〜3 日）
- [ ] JSONL タスクローダー
- [ ] Docker コンテナオーケストレーション（SWE-bench イメージを再利用）
- [ ] Agent Runtime をコンテナへ注入
- [ ] パッチ抽出 + JSONL 出力
- [ ] ネイティブ harness の評価を組み込み

### Phase 3：初回評価（1 日）
- [ ] GPT-4o で SWE-bench Lite（300 問）の baseline + entelecheia を実行
- [ ] フィクスチャを録画（以降の CI で使用）
- [ ] AF を計算し、最初の比較レポートを出力

### Phase 4：多モデルの横断比較（2〜3 日）
- [ ] Claude／Llama／Qwen を接続
- [ ] 完全な実験マトリクスを実行
- [ ] アブレーション実験
- [ ] 最終レポートを出力

## 7. Entelecheia の既存アーキテクチャとの統合ポイント

| コンポーネント | 統合方式 |
|------|---------|
| `ApoRia::llm_chat` | base_url を mock または real API へ切替 |
| `SkoPeo` オーケストレーション | `benchmark` 実行モードを追加し、対話型確認をスキップ |
| `HubRis` 計画 | benchmark タスク説明を入力として受け取る |
| `NeiKos` コンテナ | SWE-bench Docker コンテナのライフサイクルを管理 |
| `KaLos` ファイル | コンテナ内のファイルシステムへマッピング |
| `OreXis` セキュリティ | benchmark モードではセキュリティポリシーを緩和（任意のコード実行を許可） |

## 8. 注意事項

- **コスト制御**：SWE-bench Verified 全量 500 問 × 4 モデル × 2 構成 = 4000 回の実行。平均 50 ステップ／問、各ステップ ~2K tokens と見積もると約 400M tokens。`--max_cost` の上限を設定する必要がある。
- **コンテナリソース**：各 SWE-bench インスタンスには独立した Docker コンテナが必要。≥120GB のディスク、≥32GB の RAM を推奨。
- **決定性**：Mock モードは CI の再現性を保証する。Real モードは `temperature=0` を固定 + リクエストハッシュを記録してドリフトを検出する。
- **汚染検出**：SWE-bench には記憶漏洩の問題が存在し（arXiv:2506.12286）、自前で合成したタスクの一部を holdout として取っておくことを推奨する。
