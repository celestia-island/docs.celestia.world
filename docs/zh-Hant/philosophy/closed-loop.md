# 閉環

產品是閉環，而不是任何一個單獨專案：

> 發現 → 安裝 → 認證 → 部署模型 → 聊天與智能體 → 工業控制 → 驗證支撐

每一環由特定的專案群負責。任何一環斷裂，平台就不算完成。

## 逐環分解

| # | 環節 | 發生什麼 | 專案 |
| --- | --- | --- | --- |
| 1 | **發現** | 潛在使用者找到生態、理解其哲學並選擇入口 | [docs.celestia.world](https://docs.celestia.world)（本站）、[celestia-island.github.io](https://celestia-island.github.io)、[e.celestia.world](https://e.celestia.world) |
| 2 | **安裝** | 使用者得到可運行的系統：管理控制台、桌面/Web 外殼、被監督的服務 | [arona](https://github.com/celestia-island/arona)（雲 API 管理控制台）、[shittim-chest](https://github.com/celestia-island/shittim-chest)（聊天桌面/WebUI）、[malkuth](https://github.com/celestia-island/malkuth)（服務監督） |
| 3 | **認證** | 零信任身分：註冊（邀請制）、限流登入、API 金鑰、RBAC | [kirino](https://github.com/celestia-island/kirino)（認證原語與 RBAC 引擎） |
| 4 | **部署模型** | 選擇模型執行環境、部署到節點、綁定聊天後端、計量用量 | [arona](https://github.com/celestia-island/arona)（控制台與後端）、[entelecheia](https://github.com/celestia-island/entelecheia)（scepter 執行環境）、[plana](https://github.com/celestia-island/plana)（計量與定價） |
| 5 | **聊天與智能體** | 與模型對話、多智能體協作、對話持久化、記憶管理 | [shittim-chest](https://github.com/celestia-island/shittim-chest)（UI 與聊天）、[entelecheia](https://github.com/celestia-island/entelecheia)（智能體編排）、[noa](https://github.com/celestia-island/noa)（AI 原生版本控制） |
| 6 | **工業控制** | 遠端操作與協定橋接：Modbus、S7comm、OPC UA；遙測與寫入閥門 | [evernight](https://github.com/celestia-island/evernight)（協定閘道）、[aoba](https://github.com/celestia-island/aoba)（Modbus 與資料源 CLI） |
| 7 | **驗證與支撐** | 實機整合測試、監督與自癒、用量紀錄、回饋管道 | [celestia-integration](https://github.com/celestia-island/celestia-integration)、[malkuth](https://github.com/celestia-island/malkuth)、[plana](https://github.com/celestia-island/plana)（用量紀錄） |

## 閉環如何運轉

- **每一步都可測試。** 每個環節在 [celestia-integration](https://github.com/celestia-island/celestia-integration) 中有對應的驗收測試；直到整個閉環在真實節點上通過，發布才算綠。
- **每一步都可觀測。** 監督、健康端點與用量紀錄讓每個環節的狀態可見，而非假設。
- **絕不靜默降級。** 環節降級時（例如記憶離線、後端不可達），API 回應與 UI 必須明說。失敗天生要響亮。
- **安全不是環節。** 寫入閥門、策略校驗與人工確認織入第 5、6 環，而不是最後才補上。見[安全原則](./safety.md)。

## 深入閱讀

- [為什麼有 celestia-island](./why.md) —— 定義閉環的問題。
- [分層架構](./layered-architecture.md) —— 元件如何保持秩序。
- [專案地圖](../ecosystem/projects.md) —— 全量倉庫清單。
- [快速開始](../getting-started/quickstart.md) —— 30 分鐘走完閉環。
