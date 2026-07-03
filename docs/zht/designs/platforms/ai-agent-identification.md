# AI 智慧體標識與提交共同作者策略

## 概述

`evernight` 以兩種方式參與 celestia-island 的共同作者策略：

1. **作為提交宿主**：當 AI 智慧體透過 evernight 編排一次提交（主機 A 上的智慧體 →
   evernight SSH/exec → 主機 B → `git commit`）時，主機側的 `commit-msg` 鉤子（由
   `noa` 安裝）會在本地觸發併為提交打上溯源元資料。
2. **作為中轉提供商**：當 evernight 中轉模型流量時，它可以作為服務方平臺出現在作者郵箱
   中，使傳輸跳可被審計。

本文件規定 evernight 的角色。權威機制定義於 `noa` 的設計文件；此處涵蓋 evernight 專屬的
整合。

## 提供商標識模型

作者郵箱使用 `celestia.world` 信任名稱空間：

```text
顯示名 <provider-<or-platform-id@celestia.world>>
```

當 evernight 中轉一個模型時，提供商 id 反映該中轉：

```text
GLM 5 <evernight.<celestia.world@celestia.world>>   # 經 evernight 中轉的 GLM 5
```

第一方提供商保留自己的域名（`anthropic.com`、`deepseek.com`、`zhipuai.cn`……）；第三方中轉
保留自己的（`opencode.ai`、`jdcloud.com`、`openrouter.ai`……）。這使"哪個模型、經由誰"
的鏈條在每次提交上可見。

## 共同作者 Trailer

- Trailer 鍵：`Co-authored-by`（git 識別）。
- 每個不同模型一行，按使用順序排列。
- 完全在 YOLO 巡航控制下執行的鏈路額外獲得：
  `Co-authored-by: Entelecheia <demiurge@celestia.world>`。

## 內嵌 Token 用量

追加在共同作者 trailer 之後（空行分隔）：

```text
Co-authored-by: Claude Opus 4.8 (↑ 12.5k ↓ 8.3k ●45.2k) <anthropic.<com@celestia.world>>
Co-authored-by: Deepseek V4 Pro (↑ 5.1k ↓ 3.2k) <deepseek.<com@celestia.world>>
```

- `Upload` = 輸入 token；`Download` = 輸出 token。
- `Cache` 僅在快取輸入 token 被上報且 > 0 時才出現。
- 計數以千為單位（`k`），保留一位小數，去除尾部零。

## evernight 整合點

### 主機側鉤子

透過 `evernight` 的 `Command.Exec` JSON-RPC（被 entelecheia 的手術管線和 `KaLos:auto_fix`
迴圈使用）產出的提交呼叫系統 `git`，因此由 `noa hook install` 安裝的
`.git/hooks/commit-msg` 鉤子原樣適用。對於在已安裝鉤子的主機上進行的提交，無需修改
evernight 程式碼。

### 中轉提供商身份

當 evernight 代理 LLM 流量（例如將模型呼叫路由到遠端主機的本地推理）時，可告知共同作者
解析器該中轉端點，使提供商 id 成為 `evernight.celestia.world`。這透過 `noa co-author
resolve` 讀取的同一份 `aporia.toml` 提供商列表配置。

## 完整提交訊息示例

```text
perf(screen): cache X11 connection to avoid per-frame reconnect

X11CaptureBackend previously called x11rb::connect on every capture_frame.
Cache the connection in a Mutex<Option<..>>, reusing it across frames.

Co-authored-by: Entelecheia <demiurge@celestia.world>
Co-authored-by: Deepseek V4 Pro (↑ 18.2k ↓ 2.1k) <deepseek.<com@celestia.world>>
```

## 安全考量

- 共同作者 trailer 是自報告溯源，非密碼學證明。
- 解析器安全降級：缺失 `noa` 或解析錯誤產出空塊，提交不受影響。
- 提供商標識來自本地 `aporia.toml`，反映已配置的提供商。

## 提供商標識參考（初始登錄檔）

| 提供商 id | 品牌 | 端點提示 |
| --- | --- | --- |
| `zhipuai.cn` | GLM | `open.bigmodel.cn` |
| `deepseek.com` | Deepseek | `api.deepseek.com` |
| `anthropic.com` | Claude | `api.anthropic.com` |
| `openai.com` | GPT / OpenAI | `api.openai.com` |
| `evernight.celestia.world` | （中轉） | evernight 代理 |
| `opencode.ai` | （中轉） | `opencode.ai` |
| `jdcloud.com` | （中轉） | `jdcloud.com` |
