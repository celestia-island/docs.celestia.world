# プロジェクトマップ

celestia-island のプラットフォームリポジトリと製品の完全な一覧を、レイヤ
別にまとめています。リンク付きの名前は、今日そのまま読める公開
リポジトリです。リンクのない名前は、プラットフォームに同梱される製品で、
ソースはまだ公開されていないものです。ドキュメントサイトを持つと
記されたリポジトリは独自の *how* ドキュメントを持ち、それ以外は
リポジトリ内で文書化されており、閲覧にはそのリポジトリへのアクセスが必要です。

## レイヤ 0 — 認証

| プロジェクト | 役割 | ドキュメント |
| --- | --- | --- |
| [kirino](https://github.com/celestia-island/kirino) | ゼロトラスト認証と認可: セッション、パーミッション、レート制限 | [kirino.docs.celestia.world](https://kirino.docs.celestia.world) |

## レイヤ 1 — プラットフォーム

| プロジェクト | 役割 | ドキュメント |
| --- | --- | --- |
| [plana](https://github.com/celestia-island/plana) | 共有プロトコル型、トランスポート、計測、そしてすべてのサービスが利用する基盤 | リポジトリ内 |
| [provider-registry](https://github.com/celestia-island/provider-registry) | 製品間で共有されるモデルとプロバイダのカタログ | リポジトリ内 |

## レイヤ 2 — UI

| プロジェクト | 役割 | ドキュメント |
| --- | --- | --- |
| [hikari](https://github.com/celestia-island/hikari) | すべての webUI が共有する UI コンポーネントライブラリ | リポジトリ内 |

## レイヤ 3 — サービス

| プロジェクト | 役割 | ドキュメント |
| --- | --- | --- |
| arona | モデルゲートウェイとデプロイパネル: キー、バックエンド、ルーティング、利用量 | [Arona](../platforms/arona.md) |
| shittim-chest | チャット、パネル、統合 —— ワークベンチのサーフェス | [Shittim Chest](../platforms/chest.md) |
| entelecheia | エージェントプラットフォーム: エージェント、長期メモリ、セマンティック検索、産業統合 | [Entelecheia](../platforms/entelecheia.md) |
| evernight | 産業プロトコルブローカー: フィールドプロトコル、アラーム、録画、エッジ推論 | [Evernight](../platforms/evernight.md) |
| [malkuth](https://github.com/celestia-island/malkuth) | サービス監視: ローリングアップデート、ヘルスプローブ、リバースプロキシ、クラッシュ復旧 | [malkuth.docs.celestia.world](https://malkuth.docs.celestia.world) |
| [lagrange](https://github.com/celestia-island/lagrange) | 本サイトとすべてのプロジェクトドキュメントサイトを支えるドキュメントエンジン | [lagrange.docs.celestia.world](https://lagrange.docs.celestia.world) |
| celestia-erp | ビジネスバックオフィス: 組織、課金、請求書 | — |
| electrode_recon | 電極ミクロ構造の計算エンジン —— エンジンファブリック上の最初の外部インスタンス | — |

## ツールとライブラリ

| プロジェクト | 役割 | ドキュメント |
| --- | --- | --- |
| [noa](https://github.com/celestia-island/noa) | エージェントネイティブな分散バージョン管理（分離されたワークスペース付き） | [リポジトリ](https://github.com/celestia-island/noa) |
| [seia](https://github.com/celestia-island/seia) | マルチエンジンのウェブ検索 | [seia.docs.celestia.world](https://seia.docs.celestia.world) |
| [aoba](https://github.com/celestia-island/aoba) | マルチプロトコルのデバッグとシミュレーション用 CLI（Modbus RTU など） | [aoba.docs.celestia.world](https://aoba.docs.celestia.world) |
| [ichika](https://github.com/celestia-island/ichika) | メッセージパイプ上のスレッドプールパイプライン | リポジトリ内 |
| [yuuka](https://github.com/celestia-island/yuuka) | 入れ子構造の合成と JSON マージ/パッチのためのマクロ | リポジトリ内 |
| [kou](https://github.com/celestia-island/kou) | 仮想ターミナルエンジン: PTY、VT100/ANSI、インライングラフィックス | リポジトリ内 |
| [hifumi](https://github.com/celestia-island/hifumi) | バージョン間でデータを移行するためのシリアライゼーション | リポジトリ内 |
| [lacrymira](https://github.com/celestia-island/lacrymira) | 1 つのコマンドサーフェスの背後にある SQL と KV の型付きデータアクセス | リポジトリ内 |
| [himari](https://github.com/celestia-island/himari) | 次元を持つ数式の中間表現 | リポジトリ内 |
| [kotama](https://github.com/celestia-island/kotama) | リバースエンジニアリングツールキット: 解析、逆コンパイル、クロスリファレンス | リポジトリ内 |
| [ayane](https://github.com/celestia-island/ayane) | メールサービス: コントロールプレーン、ウェブメール、保護 | リポジトリ内 |
| [aris](https://github.com/celestia-island/aris) | servo 由来の純 Rust ブラウザエンジン。ライブラリとして埋め込み可能 | リポジトリ内 |
| [shirabe](https://github.com/celestia-island/shirabe) | ヘッドレスなブラウザ自動化とデバッグ | リポジトリ内 |
| [tairitsu](https://github.com/celestia-island/tairitsu) | WASM Component Model 上のフルスタックフレームワーク | リポジトリ内 |
| [akivili](https://github.com/celestia-island/akivili) | エージェント拡張のためのプラグインホスト兼 SDK | リポジトリ内 |
| [celestia-plugin](https://github.com/celestia-island/celestia-plugin) | Python プラグイン兼エンジン SDK | リポジトリ内 |
| [shun](https://github.com/celestia-island/shun) | インストーラ、フラッシャ、ポータブルモードのペイロード配信 | リポジトリ内 |
| [ratatui-markdown](https://github.com/celestia-island/ratatui-markdown) | ターミナル UI 内での Markdown レンダリング | リポジトリ内 |
| arcaea | ペルソナプロトコルライブラリ | — |
| scriptum | エージェントプラットフォーム向けのターミナルインターフェース | — |
| official-plugins | ファーストパーティのプラグインパッケージ | — |

## エッジとハードウェア

| プロジェクト | 役割 | ドキュメント |
| --- | --- | --- |
| [kei](https://github.com/celestia-island/kei) | ARM64 と RISC-V のエッジゲートウェイ向け Rust カーネル | リポジトリ内 |
| [hare](https://github.com/celestia-island/hare) | 組み込み産業ノード向けの `no_std` ブリッジライブラリ | リポジトリ内 |
| evernight-appliance | アプライアンス配布: 起動ファームウェア、フラッシャ、ドライバ契約 | — |

## インフラストラクチャとツーリング

| プロジェクト | 役割 | ドキュメント |
| --- | --- | --- |
| [celestia-devtools](https://github.com/celestia-island/celestia-devtools) | 共有開発ツールチェーン: ビルドレシピ、リンティング、リリースゲート | リポジトリ内 |
| [cherino](https://github.com/celestia-island/cherino) | エージェント実行のためのサンドボックス化されたコンテナ抽象 | リポジトリ内 |
| [celestia-artifacts](https://github.com/celestia-island/celestia-artifacts) | リリース用バイナリとイメージ成果物の公開ホスティング | リポジトリ内 |
| celestia-integration | ループ全体を対象としたクロスリポジトリ統合テスト | — |
| fuuka | セルフホストの CI 実行プレーン | — |
| [sysl](https://github.com/celestia-island/sysl) | このコードの大半が使う Synthetic Source License | リポジトリ内 |

## ウェブプレゼンス

| プロパティ | 役割 | ドキュメント |
| --- | --- | --- |
| [celestia-island.github.io](https://celestia-island.github.io) | 組織の存在 | リポジトリ内 |
| [docs.celestia.world](https://docs.celestia.world) | 本サイト —— 哲学、マップ、始め方 | リポジトリ内 |
| [e.celestia.world](https://e.celestia.world) | 公開ランディングページ | リポジトリ内 |
| [dev.celestia.world](https://dev.celestia.world) | パネルと開発者ダッシュボード（ベータ期間中は招待制） | リポジトリ内 |
| [celestia.ac.cn](https://celestia.ac.cn) | 会社とエンタープライズサービスサイト | リポジトリ内 |

## さらに詳しく

- [レイヤ化アーキテクチャ](../philosophy/layered-architecture.md) —— これらのレイヤが存在する理由。
- [クローズドループ](../philosophy/closed-loop.md) —— プロジェクトがループに沿ってどう協調するか。
- [サイトと所有](./sites.md) —— 誰が何を文書化し、どこにあるか。
