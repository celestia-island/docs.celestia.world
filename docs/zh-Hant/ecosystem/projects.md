# 專案地圖

celestia-island 倉庫全量清單，按層分組。帶文件站的倉庫在 `<name>.docs.celestia.world` 維護自己的 *怎麼做* 文件；其餘在倉庫內文件化。

## 第 0 層 — 認證

| 專案 | 角色 | 文件 |
| --- | --- | --- |
| [kirino](https://github.com/celestia-island/kirino) | 零信任認證與 RBAC：JWT 工作階段、Argon2id 雜湊、登入限流、權限引擎 | [kirino.docs.celestia.world](https://kirino.docs.celestia.world) |

## 第 1 層 — 平台

| 專案 | 角色 | 文件 |
| --- | --- | --- |
| [plana](https://github.com/celestia-island/plana) | 共享型別、JSON-RPC 用戶端與伺服端、SSE 工作階段、斷路器、LLM 計量與定價、管理 UI 外殼 | 倉庫內 |
| [provider-registry](https://github.com/celestia-island/provider-registry) | 模型與提供者註冊表（entrypoint TOML 格式） | 倉庫內 |

## 第 2 層 — UI

| 專案 | 角色 | 文件 |
| --- | --- | --- |
| [hikari](https://github.com/celestia-island/hikari) | 全部 WebUI 共享的 UI 元件庫（Vue/TS + Rust） | 倉庫內 |

## 第 3 層 — 服務

| 專案 | 角色 | 文件 |
| --- | --- | --- |
| [arona](https://github.com/celestia-island/arona) | 雲 API 管理控制台：帳戶、API 金鑰、模型部署、後端、用量紀錄 | 倉庫內 |
| [shittim-chest](https://github.com/celestia-island/shittim-chest) | 聊天桌面/WebUI 與外殼 | [shittim-chest.docs.celestia.world](https://shittim-chest.docs.celestia.world) |
| [entelecheia](https://github.com/celestia-island/entelecheia) | 多智能體協作平台：exec-only 微核心、scepter 編排伺服器、IEPL 執行管線 | [entelecheia.docs.celestia.world](https://entelecheia.docs.celestia.world) |
| [evernight](https://github.com/celestia-island/evernight) | 工業協定閘道：Modbus、S7comm、OPC UA；遠端操作、遙測、寫入閥門 | [evernight.docs.celestia.world](https://evernight.docs.celestia.world) |
| [malkuth](https://github.com/celestia-island/malkuth) | 服務監督工具包：滾動更新、健康探針、反向代理、崩潰迴圈恢復 | [malkuth.docs.celestia.world](https://malkuth.docs.celestia.world) |
| [lagrange](https://github.com/celestia-island/lagrange) | 支撐本站與所有專案文件站的 Markdown 文件引擎 | [lagrange.docs.celestia.world](https://lagrange.docs.celestia.world) |

## 工具與函式庫

| 專案 | 角色 | 文件 |
| --- | --- | --- |
| [noa](https://github.com/celestia-island/noa) | AI 原生分散式版本控制：每智能體工作區隔離、JSONL 追加日誌、快照歷史 | [noa.docs.celestia.world](https://noa.docs.celestia.world) |
| [seia](https://github.com/celestia-island/seia) | 多引擎網路搜尋函式庫與 CLI | [seia.docs.celestia.world](https://seia.docs.celestia.world) |
| [ichika](https://github.com/celestia-island/ichika) | 執行緒池管線巨集（基於 flume 訊息管線） | [ichika.docs.celestia.world](https://ichika.docs.celestia.world) |
| [yuuka](https://github.com/celestia-island/yuuka) | 用簡單巨集生成複雜巢狀結構的 proc-macro | [yuuka.docs.celestia.world](https://yuuka.docs.celestia.world) |
| [aoba](https://github.com/celestia-island/aoba) | Modbus 與資料源 CLI | [aoba.docs.celestia.world](https://aoba.docs.celestia.world) |
| [kou](https://github.com/celestia-island/kou) | 獨立虛擬終端機引擎：PTY 管理、VT100/ANSI | 倉庫內 |
| [hifumi](https://github.com/celestia-island/hifumi) | 資料跨版本遷移的序列化函式庫 | 倉庫內 |
| [aris](https://github.com/celestia-island/aris) | 源自 servo 的瀏覽器引擎，可作函式庫嵌入（數位孿生的 WebGL） | 倉庫內 |
| [shirabe](https://github.com/celestia-island/shirabe) | 輕量 Rust 原生瀏覽器自動化與除錯函式庫 | 倉庫內 |
| [tairitsu](https://github.com/celestia-island/tairitsu) | 基於 WASM Component Model 的全端框架 | 倉庫內 |
| [ratatui-markdown](https://github.com/celestia-island/ratatui-markdown) | 面向 ratatui TUI 的 Markdown 渲染 | 倉庫內 |
| [arcaea](https://github.com/celestia-island/arcaea) | celestia persona 協定的 Rust 函式庫 | 倉庫內 |
| [scriptum](https://github.com/celestia-island/scriptum) | entelecheia 的終端介面（TUI）：與 scepter 伺服器對話的「啞顯示」 | 倉庫內 |

## 邊緣與硬體

| 專案 | 角色 | 文件 |
| --- | --- | --- |
| [kei](https://github.com/celestia-island/kei) | ARM64/RISC-V 邊緣設備的 Rust 核心；長期地平線的確定性即時核心 | 倉庫內 |

## 基礎設施與工具鏈

| 專案 | 角色 | 文件 |
| --- | --- | --- |
| [celestia-devtools](https://github.com/celestia-island/celestia-devtools) | 共享開發工具鏈：justfile 配方、補丁註冊、lint | 倉庫內 |
| [celestia-integration](https://github.com/celestia-island/celestia-integration) | 全閉環實機整合測試套件 | 倉庫內 |
| [sysl](https://github.com/celestia-island/sysl) | Synthetic Source License（SySL）：為 AI 生成程式碼設計的授權條款 | 倉庫內 |

## 站點

| 資產 | 角色 | 文件 |
| --- | --- | --- |
| [celestia-island.github.io](https://celestia-island.github.io) | 組織存在 | 倉庫內 |
| [docs.celestia.world](https://docs.celestia.world) | 本站 —— 哲學、地圖、快速開始 | 倉庫內 |
| [e.celestia.world](https://e.celestia.world) | 公開落地頁 | 倉庫內 |
| [dev.celestia.world](https://dev.celestia.world) | 開發者入口 | 倉庫內 |
| [arona.celestia.world](https://arona.celestia.world) | 雲 API 管理控制台（產品） | — |

## 深入閱讀

- [分層架構](../philosophy/layered-architecture.md) —— 這些層為何存在。
- [閉環](../philosophy/closed-loop.md) —— 專案如何沿閉環協作。
- [站點分工](./sites.md) —— 誰負責什麼文件、在哪裡。
