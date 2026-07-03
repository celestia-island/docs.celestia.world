# Benchmark & Mock LLM 服务端设计

> 核心命题：**任何模型 + Entelecheia 工具系统，能完成多少任务？**
>
> 不预设"弱/强"分類別。環境變數传了哪个 provider 的 key，就创建哪个模型的编码套餐設定并测试。一个 key 都没有 → 直接报错退出。

## 0. 关键发现：复用现有 Provider 注册表

Entelecheia **已有**完整的 env-var 驱动 provider 发现系统：

- `provider-registry` 仓库：926 个 TOML 文件，覆盖 OpenAI / Anthropic / DeepSeek / GLM / Qwen / Kimi / MiniMax 等全部主流 provider
- `derive_config_from_env()`：遍历所有 entrypoint TOML，凡 `env_var` 已设置的 provider 自动激活
- `ModelTier`（Deep / Normal / Basic）三级 + fallback chain
- `_shared_llm_provider::ProviderRegistry`：全局注册，5 种協定（OpenAI Chat / Responses / Anthropic v1/v2 / Gemini）

**不需要新建 provider 注册表**——benchmark runner 直接复用 `_shared_config` + `_shared_llm_provider`。

## 1. 编码套餐（Coding Plan）概念

每个可用模型自动生成一个 benchmark profile：

| 字段 | 来源 | 说明 |
|------|------|------|
| provider_id | entrypoint TOML | 如 `deepseek` / `zhipu_glm` |
| model_id | entrypoint defaults | 如 `deepseek-coder` / `glm-4-plus` |
| tier | ModelTier::Deep | 编码任务使用 Deep tier |
| base_url | entrypoint api.base_url | 真实远端 API |
| api_key | 環境變數（entrypoint api.env_var） | 运行时读取 |
| protocol | entrypoint api.protocol | GenProtocol 枚举值 |
| context_window | model card | 从 `models/<provider>/<model>.toml` 读取 |
| max_output_tokens | model card | 同上 |
| supports_function_calling | model card | 决定工具呼叫方式 |

Profile 在运行时从 env vars 动态构建，不预存設定文件。

## 2. 架構

```
┌─────────────────────────────────────────────────────────┐
│                    Benchmark Runner                      │
│  (遍历資料集實例，收集结果，输出 JSONL)                     │
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
       │ (任务實例環境)    │
       │ - 程式碼仓库       │
       │ - 工具链         │
       │ - 测试套件       │
       └─────────────────┘
```

## 3. Mock LLM 服务端

### 3.1 Record/Replay 協定

Mock 服务端兼容 OpenAI Chat Completions API（`/v1/chat/completions`），支援两种工作模式：

**录制模式（首次跑真实模型时）**：
```
Client → Mock Server → Real API → Mock Server (录制响应) → Client
```

**回放模式（CI/离线时）**：
```
Client → Mock Server (匹配请求 → 回傳录制的响应) → Client
```

### 3.2 请求匹配策略

请求通过以下字段的哈希进行匹配：
- `model`（模型名）
- `messages` 的内容哈希（归一化后）
- `tools` 的结构哈希（如有）
- `temperature`、`max_tokens` 等參數

**Strict 模式**（CI 預設开启）：任何未匹配的请求立即报错，不 fallback 到真实 API。确保 fixture 完整。

**Lenient 模式**（开发用）：未匹配时 fallback 到真实 API 并录制。

### 3.3 Fixture 存储

```
tests/fixtures/llm/
├── swe-bench-verified/
│   ├── gpt-4o/
│   │   ├── <request_hash>.json      # 录制的响应
│   │   └── index.toml                # 请求摘要索引
│   ├── claude-sonnet/
│   └── llama-8b/
└── aider-polyglot/
    └── ...
```

### 3.4 實作选择

| 方案 | 优点 | 缺点 |
|------|------|------|
| **AIMock**（CopilotKit） | 成熟、支援 streaming/tool-calls/MCP、Docker 映像檔 | 外部依赖 |
| **自建简易伺服器** | 完全可控、零外部依赖 | 需自己处理 streaming/edge case |
| **VCR.py / wiremock** | 语言生态成熟 | 非 LLM 专用，需适配 |

**推荐**：先用自建简易伺服器（一个 axum/actix 路由，匹配 + 回傳 JSON），后续如需 streaming 再迁移到 AIMock。

## 4. SWE-bench 适配器

### 4.1 任务执行流程

```
for instance in dataset:
    1. 拉取 SWE-bench Docker 映像檔 (base + env + instance 三層)
    2. 启动容器，挂载程式碼仓库
    3. 注入 issue 文本作为任务描述
    4. 启动 Entelecheia Agent Runtime（連線到容器内的 bash/文件系统）
    5. Agent 执行直到完成或超时（step cap: 50, wall-clock: 15min）
    6. 容器内执行 git diff → 提取 patch
    7. 输出 JSONL: {instance_id, model_name_or_path, model_patch}
    8. 销毁容器
```

### 4.2 Agent Runtime 注入

Entelecheia 在 SWE-bench 容器内运行时，需要：
- 文件操作工具 → 映射到容器内文件系统
- 命令执行工具 → 映射到容器内 bash
- 搜索工具 → `rg`/`grep`（容器内预装）
- **禁用**与该任务无关的 agent（PoleMos/工业協定等），减少上下文噪声

### 4.3 评分

直接使用 SWE-bench 原生 harness：
```bash
python -m swebench.harness.run_evaluation \
    --dataset_name princeton-nlp/SWE-bench_Verified \
    --predictions_path entelecheia_predictions.jsonl \
    --max_workers 8 --run_id entelecheia-eval
```

输出：每个實例 resolved/unresolved，汇总 resolution rate。

## 5. 实验矩阵

### 5.1 核心对比

固定資料集（SWE-bench Verified），变化两个维度：

|  | Baseline (mini-SWE-agent) | Entelecheia |
|--|---------------------------|-------------|
| **GPT-4o** | A₁ | B₁ |
| **Claude Sonnet** | A₂ | B₂ |
| **Llama 3.1 8B** | A₃ | B₃ |
| **Qwen 2.5 7B** | A₄ | B₄ |

- Bᵢ/Aᵢ = 模型 i 的放大系数
- 跨行对比：弱模型（Llama/Qwen）的 AF 是否高于强模型（GPT-4o）？

### 5.2 消融实验

| 設定 | 目的 |
|------|------|
| 完整 Entelecheia（12 agent + 全部 skill） | 满血基线 |
| 仅 HubRis + KaLos + SkeMma（规划+文件+执行） | 测多 agent 编排的增量 |
| 仅 KaLos + bash（单 agent + 文件工具） | 接近 baseline，测 skill chain 增量 |
| 无 soul identity（去掉身份/隐喻 prompt） | 测 persona prompt 的效果 |

## 6. 實作路线图

### Phase 1：Mock LLM 服务端（1-2 天）
- [ ] 實作 OpenAI 兼容的 record/replay 伺服器
- [ ] 请求哈希匹配 + strict/lenient 模式
- [ ] Fixture 存储结构
- [ ] `ENTELECHEIA_LLM_BASE_URL` 環境變數切换

### Phase 2：SWE-bench 适配器（2-3 天）
- [ ] JSONL 任务加载器
- [ ] Docker 容器编排（复用 SWE-bench 映像檔）
- [ ] Agent Runtime 注入容器
- [ ] Patch 提取 + JSONL 输出
- [ ] 接入原生 harness 评分

### Phase 3：首次评测（1 天）
- [ ] 用 GPT-4o 跑 SWE-bench Lite（300 题）的 baseline + entelecheia
- [ ] 录制 fixture（供后续 CI 使用）
- [ ] 计算 AF，出第一份对比报告

### Phase 4：多模型横向（2-3 天）
- [ ] 接入 Claude / Llama / Qwen
- [ ] 运行完整实验矩阵
- [ ] 消融实验
- [ ] 出最终报告

## 7. 与 Entelecheia 现有架構的集成点

| 组件 | 集成方式 |
|------|---------|
| `ApoRia::llm_chat` | 切换 base_url 指向 mock 或 real API |
| `SkoPeo` 编排 | 新增 `benchmark` 执行模式，跳过交互式确认 |
| `HubRis` 规划 | 接受 benchmark 任务描述作为输入 |
| `NeiKos` 容器 | 管理 SWE-bench Docker 容器生命周期 |
| `KaLos` 文件 | 映射到容器内文件系统 |
| `OreXis` 安全 | benchmark 模式下放宽安全策略（允许任意程式碼执行） |

## 8. 注意事项

- **成本控制**：SWE-bench Verified 全量 500 题 × 4 模型 × 2 設定 = 4000 次运行。按平均 50 步/题、每步 ~2K tokens 估算，约 400M tokens。需设置 `--max_cost` 上限。
- **容器资源**：每个 SWE-bench 實例需要独立 Docker 容器，建议 ≥120GB 磁盘、≥32GB RAM。
- **确定性**：Mock 模式保证 CI 可复现；Real 模式固定 `temperature=0` + 记录请求哈希，检测漂移。
- **污染检测**：SWE-bench 存在记忆泄露问题（arXiv:2506.12286），建议保留一部分自合成任务作为 holdout。
