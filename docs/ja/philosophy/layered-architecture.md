# レイヤ化アーキテクチャ

このエコシステムが管理可能なのは、厳密にレイヤ化されているからです。
依存関係は一方向のみを指します。**下流のサービスは上流の機能を利用し、
汎用機能は決して再実装されません。**

## 4 つのレイヤ

| レイヤ | プロジェクト | 提供するもの |
| --- | --- | --- |
| **レイヤ 0 — 認証** | [kirino](https://github.com/celestia-island/kirino) | ゼロトラストプリミティブ: JWT 署名とリフレッシュ、Argon2id パスワードハッシュ、ログインレート制限、RBAC エンジン、招待ストア、セッション |
| **レイヤ 1 — プラットフォーム** | [plana](https://github.com/celestia-island/plana) | 共有基盤: JSON-RPC 2.0 型とルーティング、サービス DTO、ネットワーク検出、SSE セッション、サーキットブレーカー、LLM 計測と価格設定 |
| **レイヤ 2 — UI** | [hikari](https://github.com/celestia-island/hikari) | すべての WebUI が共有する UI コンポーネントライブラリ（Vue/TS + Rust） |
| **レイヤ 3 — サービス** | [arona](https://github.com/celestia-island/arona)、[shittim-chest](https://github.com/celestia-island/shittim-chest)、[entelecheia](https://github.com/celestia-island/entelecheia)、[evernight](https://github.com/celestia-island/evernight)、[malkuth](https://github.com/celestia-island/malkuth)、[lagrange](https://github.com/celestia-island/lagrange) | ビジネスロジックのみ。レイヤ 0〜2 を利用し、各製品を実物にする振る舞いを追加する |

## ドクトリン

1. **決して二重実装しない。** コードを書く前に問うこと: kirino にあるか？
   plana にあるか？ hikari にあるか？ 例: JSON-RPC 型は plana、JWT は
   kirino、ログインレート制限は kirino、サーキットブレーカーは plana、
   ヘルス DTO は plana、価格設定は plana から来ます。
2. **汎用機能は上流へ。** 2 つ以上のサービスが再利用する機能は、まず
   kirino、plana、または hikari に構築してから利用します。
3. **逆方向の依存はしない。** サービスは kirino/plana/hikari に依存し、
   plana は kirino に依存してもよい。kirino は決して plana や hikari に
   依存しません。
4. **利用する前に上流を拡張する。** 上流に必要な機能がない場合は、上流
   を拡張してから利用します。新しい機能がサービス内で試作され、後で再
   実装されることはありません。
5. **クロスリポジトリ依存は git 参照。** すべてのリポジトリは `master`
   ブランチへの git 参照（または固定バージョン）で上流を利用し、ローカル
   パス依存は使いません。すべてのリポジトリはどのマシンでも同じように
   ビルドされます。

## なぜ重要か

- **1 つの修正が波及する。** kirino のセキュリティ修正は、再実装を探し
  回るのではなく、依存のバンプですべてのサービスに届きます。
- **レビューはリスクに比例する。** レイヤ 3 の変更はプロダクトロジック、
  レイヤ 0 の変更はインフラストラクチャ —— レビューの基準はそれを反映
  します。
- **マップは読みやすいまま。** 新しいエンジニアはこのページを読めば、
  どの機能がどこにあるか分かります。[プロジェクトマップ](../ecosystem/projects.md)
  が完全な一覧です。

## さらに詳しく

- [なぜ celestia-island なのか](./why.md) —— レイヤ化の背後にある問題。
- [安全の原則](./safety.md) —— レイヤの上に載るドクトリン。
- [プロジェクトマップ](../ecosystem/projects.md) —— すべてのリポジトリをレイヤ別に。
