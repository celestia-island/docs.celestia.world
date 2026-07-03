# تصميم جدولة حاويات Cosmos وتوجيه الرموز

## نظرة عامة

تصف هذه الوثيقة بنية جدولة حاويات Cosmos: كيف تُوجَّه أدوات MCP الموسومة بـ `ToolLocation::Cosmos` عبر JSON-RPC بمقبس Unix إلى حاوياتها المقابلة، وكيف يرتبط نظام الرموز (رقم الوكيل) بهوية الحاوية والتوجيه.

## I. نموذج موقع الأداة

### بيئة تنفيذ مزدوجة

```mermaid
flowchart LR
    subgraph Scepter["Scepter (Central Process)"]
        A1[LLM Calls]
        A2[RAG Queries]
        A3[Task Management]
        A4[Credential Storage]
    end

    subgraph Cosmos["Cosmos (Container Per Agent)"]
        P1[File System Access]
        P2[Script Execution]
        P3[Hardware Access]
        P4[REPL Sessions]
    end

    Scepter -->|ToolLocation::Scepter| Local[Local Invoke]
    Cosmos -->|ToolLocation::Cosmos| Socket[Unix Socket RPC]
```

### معدّد ToolLocation

| المتغير | موقع التنفيذ | النقل |
| --- | --- | --- |
| `Scepter` (افتراضي) | في العملية عبر `McpToolInvoker` | استدعاء دالة مباشر |
| `Cosmos` | في الحاوية عبر `CosmosConnector` | JSON-RPC بمقبس Unix |

### معايير قرار الموقع

```mermaid
flowchart TD
    Tool[MCP Tool] --> Q1{Needs Container Resources?}
    Q1 -->|Yes: file system, scripts, hardware| Cosmos[ToolLocation::Cosmos]
    Q1 -->|No: LLM, RAG, state management| Scepter[ToolLocation::Scepter]
```

الأدوات التي تتطلب موارد حاوية (نظام الملفات، تنفيذ السكربت، الوصول للأجهزة) موسومة `Cosmos`. الخدمات المركزية (LLM، RAG، إدارة المهام، التفاعل البشري) تبقى `Scepter`.

## II. نظام الرموز وهوية الحاوية

### تخصيص رقم الوكيل

```mermaid
sequenceDiagram
    participant SM as SkillChain Manager
    participant AIM as AgentIdManager
    participant SC as SnowflakeContainer
    participant PC as CosmosConnector

    SM->>AIM: Request agent number
    AIM-->>SM: Assign 000-999 token
    SM->>SC: Create container for token
    SC-->>SM: Container UUID + socket path
    SM->>PC: connect(UUID, socket_path)
    PC-->>SM: Connection established
```

### خصائص الرمز

| الخاصية | الوصف |
| --- | --- |
| التنسيق | رقم ثلاثي: `000`-`999` |
| المخصّص | `AgentIdManager` في سلسلة المهارات |
| الربط | رمز واحد لكل لوحة سلسلة مهارات |
| العرض | يظهر في سطر إحصائيات TUI كـ `cosmos#NNN` |
| الاستمرارية | ينجو عبر إعادة تشغيل الوكيل |

## III. تدفق توجيه الطلبات

### استدعاء MCP منشأ من TUI

```mermaid
sequenceDiagram
    participant TUI as TUI Client
    participant MSR as mcp_skill_router
    participant AM as AgentManager
    participant BI as BridgeInvoker
    participant BS as HapLotesBridgeServer
    participant PR as McpRouter (Cosmos)

    TUI->>MSR: McpMessage::CallTool(tool_name, agent_type, params)
    MSR->>AM: get_tool_location(tool_name)
    AM-->>MSR: ToolLocation

    alt ToolLocation::Cosmos
        MSR->>AM: invoke_tool(tool_name, agent_type, params)
        AM->>BI: route to correct agent
        BI->>BS: forward via HapLotes bridge
        BS->>PR: bridge.call(tool_name, params)
        PR-->>BS: result
        BS-->>BI: JSON-RPC response
        BI-->>AM: McpToolResult
        AM-->>MSR: McpToolResult
        MSR-->>TUI: McpMessage::ToolResponse
    else ToolLocation::Scepter
        MSR->>AM: route through HapLotes gateway
        AM->>AM: mcp_tools.invoke() locally
        AM-->>TUI: McpMessage::ToolResponse via WS
    end
```

### منطق التوجيه الرئيسي

يحدث قرار التوجيه في `mcp_skill_router.rs`:

1. فحص `agent_manager.get_tool_location(tool_name)`
1. إذا `ToolLocation::Cosmos` والوضع المعزول بالحاويات نشط:

   - استدعاء `agent_manager.invoke_tool()` الذي يوجه عبر `BridgeInvoker` ← جسر HapLotes ← `McpRouter` الخاص بـ Cosmos
   - يوزع `McpRouter` الخاص بـ Cosmos محليًا (skemma) أو للخلف إلى Scepter عبر الجسر للوكلاء البعيدين
   - إرجاع `McpMessage::ToolResponse` مباشرة إلى TUI

1. وإلا: التوجيه عبر بوابة HapLotes إلى عملية الوكيل

## IV. بنية CosmosConnector / الجسر

### جسر HapLotes (الحالي)

جسر HapLotes هو **قناة الاتصال الوحيدة** بين Scepter وحاويات Cosmos.

```mermaid
flowchart LR
    subgraph Cosmos["Cosmos (Container)"]
        MR[McpRouter] -->|ToolSource::Local| SK[skemma Boa JS]
        MR -->|ToolSource::Bridge| BC[HapLotesBridgeClient]
    end

    subgraph Scepter["Scepter (Host)"]
        BS[HapLotesBridgeServer] --> BI[BridgeInvoker]
        BI --> AG1[Aporia]
        BI --> AG2[KaLos]
        BI --> AG3[...all agents]
    end

    BC -->|Unix Socket JSON-RPC| BS
```

### تجمع الاتصالات (CosmosConnector — جانب Scepter)

```mermaid
classDiagram
    class CosmosConnector {
        -connections: RwLock~HashMap~String, CosmosConnection~~
        +connect(instance_uuid, socket_path) Result
        +invoke_tool(instance_uuid, tool_name, params) Result~Value~
        +list_tools(instance_uuid) Result~Vec~String~~
        +disconnect(instance_uuid)
    }

    class CosmosConnection {
        -transport: Mutex~JsonRpcTransport~
    }

    class JsonRpcTransport {
        +send_request(request) Result~JsonRpcResponse~
    }

    CosmosConnector --> CosmosConnection
    CosmosConnection --> JsonRpcTransport
```

### بروتوكول JSON-RPC

تستخدم كل أسماء الدوال معدّد `UnixMethod` لأمان النوع وقت الترجمة:

| متغير UnixMethod | الاتجاه | المعاملات |
| --- | --- | --- |
| `UnixMethod::McpCall` | Scepter ← Cosmos | `{ tool_name, parameters }` |
| `UnixMethod::McpListTools` | Scepter ← Cosmos | لا شيء |
| `UnixMethod::ReplSnapshot` | Scepter ← Cosmos | `{ path }` |
| `UnixMethod::ReplRestore` | Scepter ← Cosmos | `{ path }` |
| `UnixMethod::BridgeCall` | Cosmos ← Scepter | `{ tool_name, parameters }` |
| `UnixMethod::BridgeListTools` | Cosmos ← Scepter | لا شيء |

### تنسيق الاستجابة

```json
{
  "success": true,
  "data": { ... },
  "error": null
}
```

## V. دورة حياة الحاوية

```mermaid
stateDiagram-v2
    [*] --> Pending: Skill Chain Started
    Pending --> Creating: SnowflakeManager.create()
    Creating --> Starting: Container Running
    Starting --> Connected: CosmosConnector.connect()
    Connected --> Ready: Health Check Pass

    Ready --> Executing: invoke_tool()
    Executing --> Ready: Result Returned

    Ready --> Stopping: Skill Chain Complete
    Stopping --> Disconnected: CosmosConnector.disconnect()
    Disconnected --> [*]

    Creating --> Failed: Timeout
    Starting --> Failed: Connection Error
    Failed --> [*]
```

### وكلاء الحاوية

داخل حاويات Cosmos، فقط skemma يعمل محليًا (محرك Boa JS). كل أدوات الوكلاء الأخرى تُوجَّه عبر جسر HapLotes للخلف إلى Scepter:

| الوكيل | الدور | في Cosmos؟ |
| --- | --- | --- |
| SkeMma | تنفيذ السكربت (Boa JS) | **محلي** (في العملية) |
| Aporia | دردشة LLM | عبر الجسر ← Scepter |
| KaLos | إدخال/إخراج الملف | عبر الجسر ← Scepter |
| NeiKos | إدارة الحاويات | عبر الجسر ← Scepter |
| EleOs | بحث الويب | عبر الجسر ← Scepter |
| الباقون | متنوع | عبر الجسر ← Scepter |

## VI. تكامل سطر الإحصائيات

### تنسيق العرض

في `AgentDetailPage` الخاص بـ TUI، يعرض سطر الإحصائيات:

```mermaid
flowchart LR
    BORDER["|"] --> TOK["1.2k tokens"] --> SEP1["|"] --> DUR["3.5s"] --> SEP2["|"] --> COSMOS["cosmos#042"] --> TIER["[T2]"]

    TOK -.->|"McpToolResult.token_usage"| SRC1["Token Usage"]
    DUR -.->|"Instant::now()"| SRC2["Duration"]
    COSMOS -.->|"AgentIdManager"| SRC3["Agent Number"]
    TIER -.->|"McpToolConfig.tier"| SRC4["Model Tier"]
```

| المقطع | المصدر |
| --- | --- |
| `1.2k tokens` | `McpToolResult.token_usage` |
| `3.5s` | المدة من `Instant::now()` |
| `cosmos#042` | رقم الوكيل من `AgentIdManager` |
| `[T2]` | مستوى النموذج من `McpToolConfig.tier` |

## VII. معالجة الأخطاء

### أوضاع الفشل

```mermaid
flowchart TD
    Call[Tool Call] --> Q1{Container Online?}
    Q1 -->|No| E1[Error: AGENT_OFFLINE]
    Q1 -->|Yes| Q2{Socket Connected?}
    Q2 -->|No| E2[Error: Connection Lost]
    Q2 -->|Yes| Q3{Tool Exists?}
    Q3 -->|No| E3[Error: Tool Not Found]
    Q3 -->|Yes| Q4{Execution Success?}
    Q4 -->|No| E4[Error: Execution Failed]
    Q4 -->|Yes| Result[Return Result]

    E1 --> Fallback[Fallback: Try Scepter execution]
    E2 --> Retry[Retry: Reconnect socket]
```

### التدهور الرشيد

عندما تكون الحاوية غير متاحة، يمكن للنظام اختياريًا التراجع إلى تنفيذ `Scepter` المحلي إذا كان للأداة تطبيق محلي مسجل.

## VIII. الامتدادات المستقبلية

| الميزة | الوصف | الأولوية |
| --- | --- | --- |
| تجميع الحاويات | إعادة استخدام الحاويات عبر سلاسل المهارات | متوسطة |
| مراقبة الصحة | فحوصات صحة دورية للحاويات | عالية |
| حدود الموارد | حدود CPU/ذاكرة لكل حاوية | عالية |
| أدوات متعددة الحاويات | أدوات تمتد عبر حاويات متعددة | منخفضة |
| ترحيل الحاويات | نقل الحاويات الجارية بين المضيفين | منخفضة |
