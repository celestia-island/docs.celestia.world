# هندسة المزامنة التزايدية

## نظرة عامة

آلية مزامنة تزايدية لحالة متعددة العملاء مبنية على Automerge CRDT، تدعم التحديثات التزايدية في الوقت الفعلي والمزامنة الكاملة عند الاتصال/إعادة الاتصال، وتغطي جميع لوحات TUI.

## مخطط الهندسة المعمارية

```mermaid
flowchart TB
    subgraph Clients["TUI Clients (Multiple)"]
        C1["Client 1"]
        C2["Client 2"]
        C3["Client N"]
    end

    subgraph Server["Server"]
        SM["SyncManager<br/>Single State Tree"]
        BH["BroadcastHelper"]
        WS["WebSocket Broadcast"]
        REG["StateRegistry<br/>Full State"]
    end

    subgraph Storage["Automerge CRDT"]
        AD["AgentDoc<br/>per-agent"]
        V["Version Vectors"]
    end

    %% Full sync requests (pull mode)
    C1 -->|"On Connection"| WS
    C2 -->|"On Connection"| WS
    C3 -->|"On Connection"| WS

    WS -->|"RequestFullSnapshot"| BH
    BH -->|"list_agents"| SM
    SM -->|"AgentSnapshot"| BH
    BH -->|"broadcast"| WS
    WS -->|"AgentSnapshot"| C1
    WS -->|"AgentSnapshot"| C2
    WS -->|"AgentSnapshot"| C3

    %% Incremental updates (push mode)
    SM -->|"State Change"| BH
    BH -->|"update_agent"| SM
    SM -->|"Generate AgentPatch"| BH
    BH -->|"broadcast"| WS
    WS -->|"AgentPatch"| C1
    WS -->|"AgentPatch"| C2
    WS -->|"AgentPatch"| C3

    %% Automerge storage
    SM <-->|"agent_docs"| AD
    SM <-->|"version"| V

    style SM fill:#e1f5fe
    style BH fill:#fff3e0
    style WS fill:#f3e5f5
    style AD fill:#e8f5e9
    style REG fill:#fff9c4
```

## مصفوفة استراتيجية المزامنة

| اللوحة | طريقة المزامنة | المحفّز | التكرار | أنواع الرسائل |
| --- | --- | --- | --- | --- |
| **الجدول الزمني للوكلاء** | تزايدية + كاملة | مزامنة عند الاتصال + دفع في الوقت الفعلي | عند الاتصال / وقت حقيقي | `AgentPatch` / `GlobalSnapshot` |
| **الحاويات** | تزايدية + كاملة | مزامنة عند الاتصال + دفع في الوقت الفعلي | عند الاتصال / وقت حقيقي | `ContainerPatch` / `GlobalSnapshot` |
| **المهام** | تزايدية + كاملة | مزامنة عند الاتصال + دفع في الوقت الفعلي | عند الاتصال / وقت حقيقي | `TaskPatch` / `GlobalSnapshot` |
| **قائمة النماذج** | كاملة | طلب نشط من العميل | عند فتح اللوحة | `ModelsSnapshot` |
| **تكوين المزودين** | كاملة | طلب نشط من العميل | عند فتح اللوحة | `ProvidersSnapshot` |

## تدفق الرسائل

### تدفق التحديث التزايدي (الوكلاء)

```mermaid
sequenceDiagram
    participant Agent as Agent Runtime
    participant SM as SyncManager
    participant BH as BroadcastHelper
    participant WS as WebSocket
    participant Client as TUI Client

    Agent->>SM: State Update
    SM->>SM: update_agent()
    SM->>SM: Generate AgentPatch
    SM->>BH: Return patch
    BH->>WS: broadcast(AgentPatch)
    WS->>Client: AgentPatch message
    Client->>Client: apply_agent_patch()
    Client->>Client: Update UI
```

### تدفق المزامنة الكاملة

```mermaid
sequenceDiagram
    participant Client as TUI Client
    participant WS as WebSocket
    participant BH as BroadcastHelper
    participant SM as SyncManager
    participant Registry as State Registry

    Note over Client: On Connection / Reconnection
    Client->>WS: RequestGlobalSnapshot
    WS->>BH: send_full_snapshot()
    BH->>Registry: list_agents()
    Registry-->>BH: Vec<AgentInfo>
    BH->>SM: create_snapshot(agents)
    SM-->>BH: AgentSnapshot
    BH->>WS: broadcast(AgentSnapshot)
    WS-->>Client: AgentSnapshot message
    Client->>Client: Replace local state
```

### تدفق مزامنة قائمة النماذج

```mermaid
sequenceDiagram
    participant Client as TUI Client
    participant WS as WebSocket
    participant Server as Server

    Note over Client: When opening Models panel
    Client->>WS: Request Models list
    WS->>Server: Query Models config
    Server-->>WS: Models list
    WS-->>Client: ModelsSnapshot message
    Client->>Client: Update Models panel
```

### تدفق المزامنة الكاملة للحاويات

```mermaid
sequenceDiagram
    participant Client as TUI Client
    participant WS as WebSocket
    participant Server as Server

    Note over Client: When opening Containers panel
    Client->>WS: RequestContainerSnapshot
    WS->>Server: Query Containers state
    Server-->>WS: ContainerSnapshot
    WS-->>Client: ContainerSnapshot message
    Client->>Client: Replace local Containers state
```

### تدفق المزامنة الكاملة للمهام

```mermaid
sequenceDiagram
    participant Client as TUI Client
    participant WS as WebSocket
    participant Server as Server

    Note over Client: When opening Tasks panel
    Client->>WS: RequestTasksSnapshot
    WS->>Server: Query Tasks state
    Server-->>WS: TasksSnapshot
    WS-->>Client: TasksSnapshot message
    Client->>Client: Replace local Tasks state
```

## هياكل البيانات

### AgentPatch (تحديث تزايدي)

```rust
pub struct AgentPatch {
    pub agent_id: String,
    pub version: u64,
    pub llm_working_changed: Option<bool>,
    pub work_status: Option<String>,
    pub current_model: Option<String>,
    pub token_usage_delta: Option<(u32, u32)>,
    pub token_usage_absolute: Option<(u32, u32)>,
    pub request_state: Option<RequestState>,
    pub cpu_usage: Option<f64>,
    pub memory_mb: Option<u64>,
}
```

### AgentSnapshot (لقطة كاملة)

```rust
pub struct AgentSnapshot {
    pub version: u64,
    pub timestamp: i64,
    pub agents: Vec<TuiAgentInfo>,
}
```

### GlobalSnapshot (لقطة شاملة)

```rust
pub struct GlobalSnapshot {
    pub version: u64,
    pub timestamp: i64,
    pub agents: Vec<TuiAgentInfo>,
    pub models: Vec<ModelInfo>,
    pub providers: Vec<ProviderInfo>,
    pub active_tasks: Vec<TaskInfo>,
}
```

### ModelsSnapshot (قائمة النماذج)

```rust
pub struct ModelsSnapshot {
    pub models: Vec<ModelInfo>,
}
```

### ContainerPatch (تزايدي حالة الحاويات)

```rust
pub struct ContainerPatch {
    pub container_id: String,
    pub version: u64,
    pub status_changed: Option<String>,
    pub cpu_usage_changed: Option<f64>,
    pub memory_usage_changed: Option<u64>,
}
```

### ContainerSnapshot (كامل حالة الحاويات)

```rust
pub struct ContainerSnapshot {
    pub version: u64,
    pub timestamp: i64,
    pub containers: Vec<ContainerInfo>,
}
```

### TaskPatch (تزايدي حالة المهام)

```rust
pub struct TaskPatch {
    pub task_id: Uuid,
    pub version: u64,
    pub status_changed: Option<String>,
    pub progress_changed: Option<u8>,
}
```

### TasksSnapshot (كامل حالة المهام)

```rust
pub struct TasksSnapshot {
    pub version: u64,
    pub timestamp: i64,
    pub tasks: Vec<TaskInfo>,
}
```

## استراتيجية المزامنة

| النوع | الاتجاه | المحفّز | التكرار |
| --- | --- | --- | --- |
| تحديث تزايدي للوكلاء | الخادم ← العميل | تغيير الحالة | وقت حقيقي |
| مزامنة كاملة للوكلاء | الخادم ← العميل | عند الاتصال | عند الاتصال / إعادة الاتصال |
| تزايدي الحاويات | الخادم ← العميل | تغيير الحالة | وقت حقيقي |
| مزامنة كاملة للحاويات | الخادم ← العميل | عند الاتصال | عند الاتصال / إعادة الاتصال |
| تزايدي المهام | الخادم ← العميل | تغيير الحالة | وقت حقيقي |
| مزامنة كاملة للمهام | الخادم ← العميل | عند الاتصال | عند الاتصال / إعادة الاتصال |
| قائمة النماذج | العميل ← الخادم | طلب نشط | عند فتح اللوحة |
| تكوين المزودين | العميل ← الخادم | طلب نشط | عند فتح اللوحة |

## الميزات الرئيسية

- **شجرة حالة واحدة**: يحافظ الخادم على `SyncManager` واحد، جميع العملاء يستقبلون نفس تحديثات الحالة
- **حل تعارض CRDT**: حل تعارض تلقائي مبني على Automerge
- **تحديثات تزايدية**: نقل الحقول المتغيرة فقط لتقليل حركة الشبكة
- **اتساق نهائي**: تضمن المزامنة الكاملة عند الاتصال الاتساق النهائي
- **سحب عند الطلب**: تُطلب النماذج والمزودون عند الطلب عند فتح لوحاتهم لتجنب النقل الشبكي غير الضروري
- **مزامنة الصفحة الرئيسية**: تُزامن الوكلاء والحاويات والمهام عند الاتصال لأنها مرئية على الصفحة الرئيسية

## حالة التنفيذ

- ✅ مزامنة تزايدية/كاملة للوكلاء
- ✅ مزامنة قائمة النماذج
- ✅ مزامنة تكوين المزودين
- ✅ مزامنة تزايدية/كاملة للحاويات
- ✅ مزامنة تزايدية/كاملة للمهام
- ✅ استمرار الحالة (تخزين /tmp، إعادة تحميل عند إعادة التشغيل)
