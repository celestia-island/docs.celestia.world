# 專案地圖

celestia-island 平台倉庫與產品的清單，按層分組。帶連結的名字是今天就能閱讀的公開倉庫；不帶連結的名字是隨平台一同交付、原始碼尚未公開的產品。標有文件站的倉庫在該站維護自己的 *怎麼做* 文件；其餘在倉庫內部文件化，需要該倉庫的存取權限。

## 第 0 層 — 認證

| 專案 | 角色 | 文件 |
| --- | --- | --- |
| [kirino](https://github.com/celestia-island/kirino) | 零信任認證與授權：工作階段、權限、限流 | [kirino.docs.celestia.world](https://kirino.docs.celestia.world) |

## 第 1 層 — 平台

| 專案 | 角色 | 文件 |
| --- | --- | --- |
| [plana](https://github.com/celestia-island/plana) | 共享協定型別、傳輸、計量，以及每個服務都會消費的設施 | 倉庫內 |
| [provider-registry](https://github.com/celestia-island/provider-registry) | 跨產品共享的模型與提供者型錄 | 倉庫內 |

## 第 2 層 — UI

| 專案 | 角色 | 文件 |
| --- | --- | --- |
| [hikari](https://github.com/celestia-island/hikari) | 全體 WebUI 共享的 UI 元件庫 | 倉庫內 |

## 第 3 層 — 服務

| 專案 | 角色 | 文件 |
| --- | --- | --- |
| arona | 模型閘道與部署面板：金鑰、後端、路由、用量 | [Arona](../platforms/arona.md) |
| shittim-chest | 聊天、面板與整合——工作台介面 | [Shittim Chest](../platforms/chest.md) |
| entelecheia | 智能體平台：智能體、長期記憶、語意搜尋、工業整合 | [Entelecheia](../platforms/entelecheia.md) |
| evernight | 工業協定代理器：現場協定、警報、錄製、邊緣推論 | [Evernight](../platforms/evernight.md) |
| [malkuth](https://github.com/celestia-island/malkuth) | 服務監督：滾動更新、健康探針、反向代理、崩潰恢復 | [malkuth.docs.celestia.world](https://malkuth.docs.celestia.world) |
| [lagrange](https://github.com/celestia-island/lagrange) | 支撐本站與所有專案文件站的 Markdown 文件引擎 | [lagrange.docs.celestia.world](https://lagrange.docs.celestia.world) |
| celestia-erp | 業務後台：組織、帳務、發票 | — |
| electrode_recon | 電極微觀結構計算引擎——引擎織布上的第一個外部實例 | — |

## 工具與函式庫

| 專案 | 角色 | 文件 |
| --- | --- | --- |
| [noa](https://github.com/celestia-island/noa) | 智能體原生分散式版本控制，具隔離工作區 | [倉庫](https://github.com/celestia-island/noa) |
| [seia](https://github.com/celestia-island/seia) | 多引擎網路搜尋 | [seia.docs.celestia.world](https://seia.docs.celestia.world) |
| [aoba](https://github.com/celestia-island/aoba) | 多協定除錯與模擬 CLI（Modbus RTU 等） | [aoba.docs.celestia.world](https://aoba.docs.celestia.world) |
| [ichika](https://github.com/celestia-island/ichika) | 建於訊息管線之上的執行緒池管線 | 倉庫內 |
| [yuuka](https://github.com/celestia-island/yuuka) | 組合巢狀結構與 JSON 合併/修補的巨集 | 倉庫內 |
| [kou](https://github.com/celestia-island/kou) | 虛擬終端機引擎：PTY、VT100/ANSI、行內圖形 | 倉庫內 |
| [hifumi](https://github.com/celestia-island/hifumi) | 供資料跨版本遷移的序列化 | 倉庫內 |
| [lacrymira](https://github.com/celestia-island/lacrymira) | 統一命令面之後的 SQL 與 KV 帶型別資料存取 | 倉庫內 |
| [himari](https://github.com/celestia-island/himari) | 帶量綱的公式中介表示 | 倉庫內 |
| [kotama](https://github.com/celestia-island/kotama) | 逆向工程工具包：剖析、反編譯、交叉引用 | 倉庫內 |
| [ayane](https://github.com/celestia-island/ayane) | 郵件服務：控制平面、webmail 與防護 | 倉庫內 |
| [aris](https://github.com/celestia-island/aris) | 源自 servo 的純 Rust 瀏覽器引擎，可作函式庫嵌入 | 倉庫內 |
| [shirabe](https://github.com/celestia-island/shirabe) | 無頭瀏覽器自動化與除錯 | 倉庫內 |
| [tairitsu](https://github.com/celestia-island/tairitsu) | 建於 WASM Component Model 的全端框架 | 倉庫內 |
| [akivili](https://github.com/celestia-island/akivili) | 面向智能體擴充的外掛宿主與 SDK | 倉庫內 |
| [celestia-plugin](https://github.com/celestia-island/celestia-plugin) | Python 外掛與引擎 SDK | 倉庫內 |
| [shun](https://github.com/celestia-island/shun) | 安裝器、燒錄工具與可攜模式的負載交付 | 倉庫內 |
| [ratatui-markdown](https://github.com/celestia-island/ratatui-markdown) | 終端機 UI 內的 Markdown 渲染 | 倉庫內 |
| arcaea | persona 協定函式庫 | — |
| scriptum | 智能體平台的終端介面 | — |
| official-plugins | 第一方外掛套件 | — |

## 邊緣與硬體

| 專案 | 角色 | 文件 |
| --- | --- | --- |
| [kei](https://github.com/celestia-island/kei) | 面向 ARM64 與 RISC-V 邊緣閘道的 Rust 核心 | 倉庫內 |
| [hare](https://github.com/celestia-island/hare) | 面向嵌入式工業節點的 `no_std` 橋接函式庫 | 倉庫內 |
| evernight-appliance | 硬體機分發：開機韌體、燒錄工具、驅動契約 | — |

## 基礎設施與工具鏈

| 專案 | 角色 | 文件 |
| --- | --- | --- |
| [celestia-devtools](https://github.com/celestia-island/celestia-devtools) | 共享開發工具鏈：構建配方、lint、發布閘門 | 倉庫內 |
| [cherino](https://github.com/celestia-island/cherino) | 供智能體執行使用的沙箱化容器抽象 | 倉庫內 |
| [celestia-artifacts](https://github.com/celestia-island/celestia-artifacts) | 發布用的公開二進位檔與映像產物託管 | 倉庫內 |
| celestia-integration | 全閉環的跨倉整合測試 | — |
| fuuka | 自託管 CI 執行平面 | — |
| [sysl](https://github.com/celestia-island/sysl) | 這份程式碼多數採用的 Synthetic Source License | 倉庫內 |

## 站點

| 資產 | 角色 | 文件 |
| --- | --- | --- |
| [celestia-island.github.io](https://celestia-island.github.io) | 組織存在 | 倉庫內 |
| [docs.celestia.world](https://docs.celestia.world) | 本站——哲學、地圖、快速開始 | 倉庫內 |
| [e.celestia.world](https://e.celestia.world) | 公開落地頁 | 倉庫內 |
| [dev.celestia.world](https://dev.celestia.world) | 面板與開發者儀表板（封測期間邀請制） | 倉庫內 |
| [celestia.ac.cn](https://celestia.ac.cn) | 公司與企業服務站 | 倉庫內 |

## 深入閱讀

- [分層架構](../philosophy/layered-architecture.md) —— 這些層為何存在。
- [閉環](../philosophy/closed-loop.md) —— 專案如何沿閉環協作。
- [站點分工](./sites.md) —— 誰負責什麼文件、在哪裡。
