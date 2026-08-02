# 站點分工

本生態的文件遵循一條規則：**中心站解釋為什麼與在哪裡；每個專案站解釋怎麼做。** 這讓中心站保持精小，專案站保持權威。

## 誰擁有什麼

| 站點 | 擁有 | 內容 |
| --- | --- | --- |
| [docs.celestia.world](https://docs.celestia.world) | 生態 | 哲學、生態地圖、快速開始、治理（授權條款、CLA、行為準則、安全、貢獻指南） |
| `<name>.docs.celestia.world` | 每個專案 | 指南、架構、設計、參考——由專案自身倉庫構建 |
| [celestia-island.github.io](https://celestia-island.github.io) | 組織 | 存在、連結、品牌資產 |
| [e.celestia.world](https://e.celestia.world) | 公眾面孔 | 落地頁、定價、部落格、行動呼籲 |
| [dev.celestia.world](https://dev.celestia.world) | 開發者 | 開發者入口與狀態 |

## 唯一規則：不重複

- 中心站**絕不複製**專案文件。主題屬於專案（協定如何運作、服務如何配置），中心站就連結過去，而不是轉述。
- 專案站**可以鏈回**中心站獲取哲學與跨專案脈絡。
- 當一個專案足以自行維護文件時，中心站將其涵蓋範圍縮減為地圖條目加連結。

## 站點如何構建

每個文件站（含本站）都用 [lagrange](https://github.com/celestia-island/lagrange) 從專案倉庫中的 Markdown 構建，帶共享語言切換器。內容以英文撰寫；翻譯遵循同一結構，部分翻譯會明確標註。

## 深入閱讀

- [專案地圖](./projects.md) —— 存在哪些站點、服務於哪些專案。
- [貢獻指南](../meta/CONTRIBUTING.md) —— 如何為文件做貢獻。
