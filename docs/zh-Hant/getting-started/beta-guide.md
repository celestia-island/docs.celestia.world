# 封閉測試指南

**內部封閉測試**涵蓋從帳戶註冊到工業控制的完整產品閉環。參與僅限受邀。

## 封閉測試涵蓋什麼

1. **註冊帳戶並建立 API 金鑰**於 [Arona](https://github.com/celestia-island/arona) 雲 API 管理控制台。封閉測試期間控制台僅內網可存取（部署主機 `arona:8420`）。
2. **部署模型**並透過控制台綁定聊天後端。
3. **聊天與執行智能體**於 [shittim-chest](https://github.com/celestia-island/shittim-chest) 桌面應用程式；智能體編排由 entelecheia 的 **scepter** 執行環境提供。
4. **工業控制**：遠端操作與協定橋接透過 [evernight](https://github.com/celestia-island/evernight) 執行。

## 取得存取權

- 存取是**邀請制**。公開自助註冊預設關閉。
- 邀請由維護者簽發，綁定單一帳戶。
- 存取問題請透過[貢獻指南](../meta/CONTRIBUTING.md)中的管道聯絡。

## 回報缺陷

在 GitHub 回報問題，一 bug 一 issue，使用 issue 範本：

| 產品 | 倉庫 |
| --- | --- |
| 聊天桌面/Web — shittim-chest | [celestia-island/shittim-chest](https://github.com/celestia-island/shittim-chest/issues) |
| 智能體編排 — entelecheia/scepter | [celestia-island/entelecheia](https://github.com/celestia-island/entelecheia/issues) |
| 工業控制 — evernight | [celestia-island/evernight](https://github.com/celestia-island/evernight/issues) |
| 管理控制台與平台 — arona/plana | [celestia-island/arona](https://github.com/celestia-island/arona/issues) |

務必包含：環境資訊（作業系統、產品版本）、重現步驟、預期與實際行為、相關日誌。

## 已知限制

- Arona 控制台封閉測試期間**僅內網**，不對外暴露。
- 註冊預設關閉；開放註冊尚未就緒。
- WebRTC 設備中繼與即時 SCADA 遙測需要執行中的 scepter 實例；缺失時 UI 回退到模擬展示資料。
- 行動應用程式與 IDE 外掛不在封閉測試範圍。
- 部分語言的文件為部分翻譯。

## 深入閱讀

- [快速開始](./quickstart.md) —— 30 分鐘走完閉環。
- [為什麼有 celestia-island](../philosophy/why.md) —— 封閉測試背後的哲學。
