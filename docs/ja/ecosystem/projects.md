# プロジェクトマップ

celestia-island リポジトリの完全な一覧をレイヤ別にまとめています。
ドキュメントサイトを持つリポジトリは `<name>.docs.celestia.world` に
独自の *how* ドキュメントを置いています。それ以外はリポジトリ内で
文書化されています。

## レイヤ 0 — 認証

| プロジェクト | 役割 | ドキュメント |
| --- | --- | --- |
| [kirino](https://github.com/celestia-island/kirino) | ゼロトラスト認証と RBAC: JWT セッション、Argon2id ハッシュ、ログインレート制限、権限エンジン | [kirino.docs.celestia.world](https://kirino.docs.celestia.world) |

## レイヤ 1 — プラットフォーム

| プロジェクト | 役割 | ドキュメント |
| --- | --- | --- |
| [plana](https://github.com/celestia-island/plana) | 共有型、JSON-RPC クライアントとサーバー、SSE セッション、サーキットブレーカー、LLM 計測と価格設定、管理 UI シェル | リポジトリ内 |
| [provider-registry](https://github.com/celestia-island/provider-registry) | モデルとプロバイダのレジストリ（エントリーポイント TOML 形式） | リポジトリ内 |

## レイヤ 2 — UI

| プロジェクト | 役割 | ドキュメント |
| --- | --- | --- |
| [hikari](https://github.com/celestia-island/hikari) | すべての WebUI が共有する UI コンポーネントライブラリ（Vue/TS + Rust） | リポジトリ内 |

## レイヤ 3 — サービス

| プロジェクト | 役割 | ドキュメント |
| --- | --- | --- |
| [arona](https://github.com/celestia-island/arona) | クラウド API 管理パネル: アカウント、API キー、モデルデプロイ、バックエンド、利用記録 | リポジトリ内 |
| [shittim-chest](https://github.com/celestia-island/shittim-chest) | チャットデスクトップ/WebUI とシェル | [shittim-chest.docs.celestia.world](https://shittim-chest.docs.celestia.world) |
| [entelecheia](https://github.com/celestia-island/entelecheia) | マルチエージェントコラボレーションプラットフォーム: exec のみのマイクロカーネル、scepter オーケストレーションサーバー、IEPL 実行パイプライン | [entelecheia.docs.celestia.world](https://entelecheia.docs.celestia.world) |
| [evernight](https://github.com/celestia-island/evernight) | 産業プロトコルブローカー: Modbus、S7comm、OPC UA。遠隔運用、テレメトリ、書き込みゲート | [evernight.docs.celestia.world](https://evernight.docs.celestia.world) |
| [malkuth](https://github.com/celestia-island/malkuth) | サービス監視ツールキット: ローリングアップデート、ヘルスプローブ、リバースプロキシ、クラッシュループ復旧 | [malkuth.docs.celestia.world](https://malkuth.docs.celestia.world) |
| [lagrange](https://github.com/celestia-island/lagrange) | 本サイトとすべてのプロジェクトドキュメントサイトを支える Markdown ドキュメントエンジン | [lagrange.docs.celestia.world](https://lagrange.docs.celestia.world) |

## ツールとライブラリ

| プロジェクト | 役割 | ドキュメント |
| --- | --- | --- |
| [noa](https://github.com/celestia-island/noa) | AI ネイティブ分散バージョン管理: エージェントごとのワークスペース分離、JSONL 追記ログ、スナップショット履歴 | [noa.docs.celestia.world](https://noa.docs.celestia.world) |
| [seia](https://github.com/celestia-island/seia) | マルチエンジンウェブ検索ライブラリと CLI | [seia.docs.celestia.world](https://seia.docs.celestia.world) |
| [ichika](https://github.com/celestia-island/ichika) | スレッドプールパイプラインマクロ（flume ベースのメッセージパイプ） | [ichika.docs.celestia.world](https://ichika.docs.celestia.world) |
| [yuuka](https://github.com/celestia-island/yuuka) | シンプルなマクロから複雑な入れ子構造を生成する proc マクロ | [yuuka.docs.celestia.world](https://yuuka.docs.celestia.world) |
| [aoba](https://github.com/celestia-island/aoba) | Modbus とデータソース CLI | [aoba.docs.celestia.world](https://aoba.docs.celestia.world) |
| [kou](https://github.com/celestia-island/kou) | スタンドアロンの仮想ターミナルエンジン: PTY 管理、VT100/ANSI | リポジトリ内 |
| [hifumi](https://github.com/celestia-island/hifumi) | バージョン間でデータを移行するためのシリアライゼーションライブラリ | リポジトリ内 |
| [aris](https://github.com/celestia-island/aris) | servo 由来のブラウザエンジン。ライブラリとして埋め込み可能（デジタルツイン用 WebGL） | リポジトリ内 |
| [shirabe](https://github.com/celestia-island/shirabe) | 軽量な Rust ネイティブのブラウザ自動化・デバッグライブラリ | リポジトリ内 |
| [tairitsu](https://github.com/celestia-island/tairitsu) | WASM Component Model を活用したフルスタックフレームワーク | リポジトリ内 |
| [ratatui-markdown](https://github.com/celestia-island/ratatui-markdown) | ratatui TUI 向け Markdown レンダリング | リポジトリ内 |
| [arcaea](https://github.com/celestia-island/arcaea) | celestia ペルソナプロトコルの Rust ライブラリ | リポジトリ内 |
| [scriptum](https://github.com/celestia-island/scriptum) | entelecheia 向けターミナルインターフェース（TUI）: scepter サーバーと対話する「ダムディスプレイ」 | リポジトリ内 |

## エッジとハードウェア

| プロジェクト | 役割 | ドキュメント |
| --- | --- | --- |
| [kei](https://github.com/celestia-island/kei) | ARM64/RISC-V エッジデバイス向け Rust OS カーネル。長期的展望のための決定論的リアルタイムコア | リポジトリ内 |

## インフラストラクチャとツーリング

| プロジェクト | 役割 | ドキュメント |
| --- | --- | --- |
| [celestia-devtools](https://github.com/celestia-island/celestia-devtools) | 共有開発ツールチェーン: justfile レシピ、パッチ登録、リンティング | リポジトリ内 |
| [celestia-integration](https://github.com/celestia-island/celestia-integration) | ループ全体を対象とした実ハードウェア統合テストスイート | リポジトリ内 |
| [sysl](https://github.com/celestia-island/sysl) | Synthetic Source License（SySL）: AI 生成コード向けに設計されたライセンス | リポジトリ内 |

## ウェブプレゼンス

| プロパティ | 役割 | ドキュメント |
| --- | --- | --- |
| [celestia-island.github.io](https://celestia-island.github.io) | 組織の存在 | リポジトリ内 |
| [docs.celestia.world](https://docs.celestia.world) | 本サイト —— 哲学、マップ、始め方 | リポジトリ内 |
| [e.celestia.world](https://e.celestia.world) | 公開ランディングページ | リポジトリ内 |
| [dev.celestia.world](https://dev.celestia.world) | 開発者ポータル | リポジトリ内 |
| [arona.celestia.world](https://arona.celestia.world) | クラウド API 管理パネル（製品） | — |

## さらに詳しく

- [レイヤ化アーキテクチャ](../philosophy/layered-architecture.md) —— これらのレイヤが存在する理由。
- [クローズドループ](../philosophy/closed-loop.md) —— プロジェクトがループに沿ってどう協調するか。
- [サイトと所有](./sites.md) —— 誰が何を文書化し、どこにあるか。
