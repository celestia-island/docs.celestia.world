# Web UI — 从第一句话开始的旅程

两个界面，一条动线：**Arona** 是控制台（模型、钥匙、账本、记忆），**Chest**
是工作台（聊天、面板、看世界）。本文按**功能模块**组织——每个模块讲清楚三
件事：你要做什么、它背后怎么工作、有哪些坑。页面只是入口，机制才是主角。

## 模型：从来源到被调用

![Arona 控制台](res/screenshots/arona-dashboard.png)

一个模型从"存在"到"能被聊天用上"，要经过四个环节：

1. **来源** —— Providers 页是模型来源的目录：registry 的模型（如
   HuggingFace 快速开始集）与你的自定义源。注意这是**元数据**：它描述
   "模型可以从哪来"，本身不提供推理。
2. **注册** —— 真正提供推理的是后端（backend）。通过管理 API 注册两类：
   - `ollama`：指向 Ollama 实例（`http://host:11434`）
   - `external`：任意 OpenAI 兼容服务（vLLM / TGI / LMDeploy / TileRT 的
     router…），携带 `api_key` 与 `models` 清单
   注册会持久化（`backend_configs` 表），重启不丢。
3. **部署** —— 需要新机器时用 Agents 页：每行是一个 `arona-agent` 节点
   （心跳判定在线）。Deploy 下发模型 ID；**模型名留空 = 自动选最闲的节点**
   （在线 + 平均 GPU 利用率最低）。部署成功后节点汇报引擎端口，面板自动把
   它注册为 `agent-{model}` 路由——停止时自动注销。
4. **路由** —— Models 页是最终可路由清单。网关按最少请求数在后端间负载
   均衡，会话有亲和性（同一 conversation 固定后端，利于 KV cache 复用；
   后端失活自动回退重选）。

**关键机制**：external 后端是 fail-closed 的——首次 `/v1/models` 探测成功前
拒绝路由；随后持续探测并动态刷新模型清单。agent 引擎默认只绑 127.0.0.1，
要让面板可达需 `ARONA_AGENT_BIND_ADDR=0.0.0.0`；**引擎端口无鉴权**，仅在
可信网络部署。

## 身份与计量

![Arona API Keys](res/screenshots/arona-apikeys.png)

![Arona Billing](res/screenshots/arona-billing.png)

- **API Keys** —— 你的身份。网关对 `/v1/*` 用 Bearer 鉴权；`curl` 与 Chest
  都拿它进门。密钥可限项目作用域。
- **Usage** —— 每把钥匙的逐次调用流水：token、模型、后端、成本。
- **Billing** —— 档位配额（USD / token / 限流）。**配额到了是硬拒**，不是
  降速——先看档位再放开用。

## 聊天与记忆

![Arona Playground](res/screenshots/arona-playground.png)

聊天在 Playground 进行，但每一轮都经过记忆服务，看徽章就知道走没走：

- 发送时：最后一条用户消息被嵌入并语义检索（`## Relevant Long-Term
  Memories` system 段注入，幂等）；随后消息被路由到模型。
- 完成后：这一轮被**启发式提取**为 episode（`User: … / Assistant: …`
  转录，零 LLM 调用）写入记忆图，pgvector 持久化，重启不丢。
- 徽章含义：`Memory on` = 本轮有记忆注入；`Memory offline` = 记忆服务
  不可达（**不是 bug，是诚实信号**——平台从不假装记得）；`disabled` =
  未启用或无相关记忆。

**管理**：Memory 页显示召回/写回/删除事件流；写回条目可直接删除（记忆可以
反悔）。会话在服务端持久化——传 `conversation_id`，历史由服务端装配。
服务端配置：`ARONA_MEMORY_URL` / `ARONA_MEMORY_TOKEN` / `ARONA_MEMORY_WRITEBACK`。

## 面板与工控（Chest）

![Arona Agents](res/screenshots/arona-agents.png)

- **聊天**：会话服务端持久化，换设备不丢；消息流里可见 agent 工具调用与
  思考块。
- **面板**：一个提示词创建 → 引擎生成布局 → 持久化到 scepter 的
  workspace 存储（`.amphoreus/workspace.toml` + `.noa/views/*.view.toml`）。
  编辑是结构化的：数据源绑定、组件清单、连接状态可见可改——**不是黑盒**。
  三类面板：数据表格（排序/筛选/分组，写入真校验+回滚）、媒体管线
  （Dify 风格节点图，服务端执行 + 流式进度，可被 agent 当工具调用）、
  3D 孪生（设备模型 + 世界坐标）。
- **看世界**：Topology 与 Holographic 是同一批设备的两种看法；Reports
  里历史报告可语义搜索（ApoRia workspace 索引 + PhiLia 记忆融合）。
- **工控写门**：工业写入要过策略校验与人工审批——这是闭环的终点，也是
  平台最重的一环。

管理后台（`/backend`）日常用不到：邀请人、配渠道（IM/webhook）、看告警、
调 RBAC 时才进去。

登录入口：

![Arona 登录](res/screenshots/arona-login.png)

## 收尾

整条动线：**钥匙 → 模型 → 对话 → 记忆 → 工控**。各模块里"你要做什么"看
本文，"它怎么工作"在对应平台指南里展开（Arona / Chest / Entelecheia /
Evernight / Core Infrastructure）。走到哪算哪，迷路了回来找路标。
