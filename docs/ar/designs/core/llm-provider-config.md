# تصميم نظام تهيئة المزودين TOML

## نظرة عامة

نظام تهيئة المزودين TOML يهاجر كل تهيئة مزود LLM من قيم مشفّرة إلى ملفات تهيئة TOML، محققًا فصل التهيئة عن الكود، وتحسين قابلية الصيانة والتوسع.

## الأهداف الأساسية

| الهدف | الوصف |
| --- | --- |
| قابلية الصيانة | التهيئة مفصولة عن الكود، لا حاجة لإعادة الترجمة للتغييرات |
| قابلية التوسع | إضافة مزود جديد يتطلب فقط إضافة ملف TOML |
| قابلية القراءة | ملفات التهيئة واضحة وسهلة الفهم |
| إعادة الاستخدام | يمكن مشاركة التهيئة عبر بيئات مختلفة |

## تصميم البنية

### عملية تحميل التهيئة

```mermaid
flowchart TB
    subgraph Initialization Phase
        A[Application Start] --> B[Scan res/ Directory]
        B --> C[Load All .toml Files]
        C --> D[Parse TOML Structure]
    end

    subgraph Validation Phase
        D --> E{Validate Configuration Completeness}
        E -->|Pass| F[Store in Config Cache]
        E -->|Fail| G[Log Error]
        G --> H[Use Default Config]
    end

    subgraph Runtime
        F --> I[Provider Request]
        I --> J[Get Config from Cache]
        J --> K[Return ProviderConfig]
    end
```

### هرمية التهيئة

```mermaid
graph TB
    subgraph ProviderConfig
        A[Provider Info]
        B[API Config]
        C[Limits Config]
        D[Pricing Config]
        E[Capabilities Config]
        F[Model List]
    end

    A --> A1[id, name, type, protocol]
    B --> B1[base_url, endpoints, auth]
    C --> C1[concurrency limits, rate limits, timeout]
    D --> D1[billing mode, quota info]
    E --> E1[streaming, vision, function_calling]
    F --> F1[ModelConfig List]

    subgraph ModelConfig
        F1 --> M1[id, name, context_window]
        F1 --> M2[capability support flags]
        F1 --> M3[pricing info]
        F1 --> M4[benchmark data]
    end
```

## أولوية التهيئة

```mermaid
graph LR
    A[User Config] -->|Highest Priority| D[Effective Config]
    B[Community Config] -->|Medium Priority| D
    C[Official Config] -->|Base Priority| D

    style A fill:#90EE90
    style B fill:#FFD700
    style C fill:#87CEEB
```

### قواعد دمج الأولوية

| الطبقة | المصدر | الوصف |
| --- | --- | --- |
| 1 | التهيئة الرسمية | بيانات وثائق المزود الرسمية، كافتراضات أساسية |
| 2 | تهيئة المجتمع | تهيئة محسّنة يساهم بها المجتمع، تتجاوز البيانات الرسمية |
| 3 | تهيئة المستخدم | تهيئة معرّفة من قبل المستخدم، الأولوية الأعلى |

## نماذج التسعير

```mermaid
stateDiagram-v2
    [*] --> PayAsYouGo: Pay Per Use
    [*] --> OneTime: One-time Purchase
    [*] --> Periodic: Periodic Quota
    [*] --> Free: Free

    PayAsYouGo --> Meter Usage
    OneTime --> Check Balance
    Periodic --> Check Period Quota
    Free --> Unlimited
```

### مقارنة نماذج التسعير

| النموذج | السيناريوهات القابلة للتطبيق | الخصائص |
| --- | --- | --- |
| PayAsYouGo | OpenAI، Anthropic | دفع لكل token، خصم فوري |
| OneTime | باقات مدفوعة مسبقًا | شراء حصة مسبقًا، الاستخدام حتى النفاد |
| Periodic | GLM China، إلخ | إعادة تعيين الحصة الدورية |
| Free | نماذج Ollama المحلية | لا حدود للتكلفة |

## تصنيف نوع المزود

```mermaid
graph TB
    subgraph Cloud Providers
        A[OpenAI Compatible Protocol]
        B[Anthropic Protocol]
        C[Google Gemini Protocol]
    end

    subgraph Local Providers
        D[Ollama]
        E[LocalAI]
    end

    subgraph Custom Providers
        F[User-defined Endpoints]
    end

    A --> A1[OpenAI, DeepSeek, Qwen]
    B --> B1[Claude Series]
    C --> C1[Gemini Series]
```

## آلية إعادة التحميل الساخن

```mermaid
sequenceDiagram
    participant FS as File System
    participant Watcher as Config Watcher
    participant Cache as Config Cache
    participant App as Application

    FS->>Watcher: File Change Event
    Watcher->>Watcher: Parse Changed Content
    Watcher->>Cache: Update Cache
    Cache->>App: Send Config Update Notification
    App->>App: Apply New Config
```

## استراتيجية معالجة الأخطاء

```mermaid
flowchart TB
    A[Config Loading] --> B{Parse Success?}
    B -->|Yes| C[Validate Config]
    B -->|No| D[Log Parse Error]

    C --> E{Validation Pass?}
    E -->|Yes| F[Store in Cache]
    E -->|No| G[Log Validation Error]

    D --> H[Use Default Config]
    G --> H

    F --> I[Normal Use]
    H --> I
```

## تصميم قابلية التوسع

### إضافة مزود جديد

```mermaid
flowchart LR
    A[Create TOML File] --> B[Define Provider Info]
    B --> C[Configure API Endpoints]
    C --> D[Add Model List]
    D --> E[Set Pricing Info]
    E --> F[Restart Application]
    F --> G[Auto Load Config]
```

### قواعد التحقق من التهيئة

| الحقل | قاعدة التحقق | معالجة الأخطاء |
| --- | --- | --- |
| provider.id | غير فارغ، فريد | رفض التحميل، تسجيل الخطأ |
| api.base_url | تنسيق URL صالح | استخدام القيمة الافتراضية |
| models[].id | غير فارغ | تخطي ذلك النموذج |
| pricing.model | فحص قيمة المعدّد | افتراضي PayAsYouGo |

## اعتبارات الأمان

```mermaid
flowchart TB
    subgraph Sensitive Info Handling
        A[API Key] --> B[Encrypted Storage]
        B --> C[Use in Memory]
        C --> D[Log Masking]
    end

    subgraph Access Control
        E[Config Read] --> F{Permission Check}
        F -->|Has Permission| G[Return Config]
        F -->|No Permission| H[Deny Access]
    end
```

## الامتدادات المستقبلية

| الميزة | الوصف | الأولوية |
| --- | --- | --- |
| إعادة التحميل الساخن للتهيئة | تحميل ملفات تهيئة خارجية وقت التشغيل | عالية |
| التحقق من التهيئة | التحقق من اكتمال التهيئة عند البدء | عالية |
| دمج التهيئة | تهيئة المستخدم تتجاوز التهيئة الافتراضية | متوسطة |
| استيراد/تصدير التهيئة | دعم استيراد/تصدير ملف التهيئة | متوسطة |
| تحديث الوكيل | تحديث تلقائي للتهيئة من الوثائق الرسمية | منخفضة |

# تصميم إدارة البيانات الوصفية للمزودين

## نظرة عامة

نظام إدارة البيانات الوصفية للمزودين مسؤول عن جلب معلومات التهيئة ديناميكيًا من وثائق مزود LLM الرسمية، مما يتيح التحديثات والتحقق المؤتمت من بيانات التهيئة.

## المشكلة الأساسية

التنفيذ الحالي يحتوي على إحصائيات استخدام مشفّرة ويفتقر إلى دعم بيانات المزود الديناميكية. يجب إنشاء آلية مؤتمتة للحصول على البيانات الوصفية وإدارتها.

## تصميم البنية

### بنية تدفق البيانات

```mermaid
flowchart TB
    subgraph Data Sources
        A[Official Docs]
        B[API Endpoints]
        C[Community Contributions]
    end

    subgraph Collection Layer
        D[Config Agent]
        E[Web Scraper]
        F[API Client]
    end

    subgraph Processing Layer
        G[Data Parser]
        H[Validation Engine]
        I[Merge Strategy]
    end

    subgraph Storage Layer
        J[Config Database]
        K[Cache Layer]
    end

    A --> D
    B --> F
    C --> D
    D --> G
    E --> G
    F --> G
    G --> H
    H --> I
    I --> J
    J --> K
```

### نموذج أولوية التهيئة

```mermaid
graph TB
    subgraph Priority Layers
        A[User Config] -->|Highest| D[Effective Config]
        B[Community Config] -->|Medium| D
        C[Official Config] -->|Base| D
    end

    subgraph Merge Rules
        D --> E[Field-level Override]
        E --> F[Keep High Priority Value]
    end
```

## بنية البيانات الوصفية

### هرمية تهيئة المزود

```mermaid
classDiagram
    class ProviderConfig {
        +provider_id: String
        +display_name: String
        +available_models: List~ModelConfig~
        +default_model: String
        +pricing_model: PricingModel
        +usage_type: UsageType
        +api_endpoint: String
    }

    class ModelConfig {
        +model_id: String
        +model_name: String
        +context_window: u64
        +max_output_tokens: u64
        +supports_vision: bool
        +supports_function_calling: bool
    }

    class PricingModel {
        <<enumeration>>
        OneTime
        Periodic
        PayAsYouGo
    }

    class UsageType {
        <<enumeration>>
        Metered
        Quota
        Unlimited
    }

    ProviderConfig --> ModelConfig
    ProviderConfig --> PricingModel
    ProviderConfig --> UsageType
```

### تصنيف مصدر التهيئة

| نوع المصدر | الوصف | الموثوقية | تكرار التحديث |
| --- | --- | --- | --- |
| رسمي | وثائق المزود الرسمية | عالية | دوري تلقائي |
| مجتمع | بيانات يساهم بها المجتمع | متوسطة | تحديث يدوي |
| تجاوز المستخدم | مخصص من قبل المستخدم | الأعلى | فوري |

## نظام جمع الوكلاء

### عملية الجمع

```mermaid
sequenceDiagram
    participant Scheduler as Scheduler
    participant Agent as Config Agent
    participant Source as Data Source
    participant Parser as Parser
    participant Validator as Validator
    participant DB as Database

    Scheduler->>Agent: Trigger collection task
    Agent->>Source: Request official docs
    Source-->>Agent: Return HTML/JSON
    Agent->>Parser: Parse content
    Parser-->>Agent: Structured data
    Agent->>Validator: Validate data
    Validator-->>Agent: Validation result
    Agent->>DB: Store config
    DB-->>Agent: Store success
    Agent-->>Scheduler: Task complete
```

### مسؤوليات وكيل المزود

```mermaid
flowchart LR
    subgraph OpenAI Agent
        A1[Get model list]
        A2[Parse pricing info]
        A3[Extract rate limits]
    end

    subgraph Anthropic Agent
        B1[Get Claude models]
        B2[Parse context window]
        B3[Extract capability info]
    end

    subgraph GLM Agent
        C1[Get GLM models]
        C2[Parse quota info]
        C3[Extract reset period]
    end
```

## آلية التحقق من البيانات

### عملية التحقق

```mermaid
flowchart TB
    A[Receive config data] --> B{Format validation}
    B -->|Pass| C{Logic validation}
    B -->|Fail| D[Log error]

    C -->|Pass| E{Completeness validation}
    C -->|Fail| D

    E -->|Pass| F{Consistency validation}
    E -->|Fail| G[Fill defaults]

    F -->|Pass| H[Accept config]
    F -->|Fail| I[Mark for review]

    G --> F
    D --> J[Reject config]
```

### قواعد التحقق

| نوع التحقق | محتوى الفحص | معالجة الفشل |
| --- | --- | --- |
| التحقق من التنسيق | أنواع البيانات، تنسيقات الحقول | رفض وتسجيل |
| التحقق المنطقي | نطاقات القيم، قيم المعدّدات | استخدام القيم الافتراضية |
| التحقق من الاكتمال | الحقول المطلوبة موجودة | ملء القيم الافتراضية |
| التحقق من الاتساق | العلاقات بين الحقول صحيحة | وضع علامة للمراجعة |

## استراتيجية دمج التهيئة

### الدمج على مستوى الحقل

```mermaid
flowchart TB
    subgraph Input
        A[Official Config]
        B[Community Config]
        C[User Config]
    end

    subgraph Merge Process
        D[By field priority]
        E[Keep non-null values]
        F[Validate result]
    end

    A --> D
    B --> D
    C --> D
    D --> E
    E --> F
    F --> G[Effective Config]
```

### مثال على الدمج

| الحقل | القيمة الرسمية | قيمة المجتمع | قيمة المستخدم | القيمة النهائية |
| --- | --- | --- | --- | --- |
| context_window | 128000 | - | 64000 | 64000 |
| max_concurrent | 100 | 50 | - | 50 |
| pricing_model | PayAsYouGo | - | - | PayAsYouGo |

## واجهة تهيئة المستخدم

### بنية ملف التهيئة

```mermaid
graph TB
    subgraph User Config File
        A[Provider display name]
        B[Usage type settings]
        C[Quota limits]
        D[Concurrency control]
        E[Context management]
        F[Model overrides]
    end

    A --> A1[Custom display name]
    B --> B1[metered/quota/unlimited]
    C --> C1[Data limit/Recovery period]
    D --> D1[Max concurrent]
    E --> E1[Theoretical limit/Practical limit]
    F --> F1[Custom model list]
```

## آلية التحديث المجدول

```mermaid
sequenceDiagram
    participant Timer as Timer
    participant Queue as Task Queue
    participant Agent as Agent Pool
    participant DB as Database

    Timer->>Queue: Add update task
    Queue->>Agent: Assign task

    loop Each Provider
        Agent->>Agent: Get latest config
        Agent->>DB: Compare changes
        alt Has changes
            DB->>DB: Update config
            DB->>DB: Log changes
        else No changes
            DB->>DB: Update check time
        end
    end

    Agent-->>Queue: Task complete
```

## معالجة الأخطاء

### معالجة فشل الجمع

```mermaid
flowchart TB
    A[Collection failed] --> B{Failure type}
    B -->|Network error| C[Retry mechanism]
    B -->|Parse error| D[Log and skip]
    B -->|Validation error| E[Mark for review]

    C --> F{Retry count}
    F -->|Not exceeded| G[Delayed retry]
    F -->|Exceeded| H[Use cached data]

    G --> A
    D --> I[Continue next]
    E --> J[Manual review queue]
```

## تصميم قابلية التوسع

### إضافة مزود جديد

```mermaid
flowchart LR
    A[Define Agent] --> B[Implement collection interface]
    B --> C[Configure parse rules]
    C --> D[Register to scheduler]
    D --> E[Start collection]
```

### نقاط الامتداد

| نوع الامتداد | الوصف | التنفيذ |
| --- | --- | --- |
| مزود جديد | إضافة مصدر تهيئة جديد | تنفيذ واجهة Provider Agent |
| حقل جديد | توسيع بنية التهيئة | تحديث نموذج البيانات وقواعد التحقق |
| قاعدة تحقق جديدة | إضافة منطق تحقق | إضافة تطبيق مدقق |

## تنفيذ وكيل Layer3

### وكيل ProviderScratch

`ProviderScratch` هو أول وكيل Layer3 رسمي، يعمل كمثال تنفيذ لمرافق الكشط.

```mermaid
flowchart TB
    subgraph ProviderScratch Agent
        A[Agent Entry] --> B{Execution Mode}
        B -->|TUI Mode| C[Interactive Interface]
        B -->|CI Mode| D[Automated Execution]

        C --> E[Select Provider]
        D --> F[Read env vars]

        E --> G[Call Skill]
        F --> G

        G --> H[Scrape docs]
        H --> I[Parse data]
        I --> J[Generate TOML]

        J --> K{Confirm commit?}
        K -->|Yes| L[Write to workspace]
        K -->|No| M[Discard changes]

        L --> N[Request user commit]
    end
```

### بنية المهارة

يقابل كل مزود مهارة مستقلة:

```mermaid
graph LR
    subgraph Skills
        A[openai]
        B[anthropic]
        C[glm]
        D[deepseek]
        E[qwen]
        F[gemini]
    end

    subgraph Shared Components
        G[Doc Scraper]
        H[Data Parser]
        I[TOML Generator]
    end

    A --> G
    B --> G
    C --> G
    D --> G
    E --> G
    F --> G

    G --> H
    H --> I
```

### بنية الدليل

```mermaid
flowchart LR
    Root[".amphoreus/provider_scratch/"]
    AT["agent.toml"]
    OV["overview/"]
    SK["skills/"]
    Root --> AT
    Root --> OV
    Root --> SK
    OV --> ZH["zhs.md"]
    SK --> OA["openai/"]
    SK --> AN["anthropic/"]
    SK --> GL["glm/"]
    SK --> DS["deepseek/"]
    SK --> QW["qwen/"]
    SK --> GE["gemini/"]
    OA --> OAP["prompt.md"]
    AN --> ANP["prompt.md"]
    GL --> GLP["prompt.md"]
    DS --> DSP["prompt.md"]
    QW --> QWP["prompt.md"]
    GE --> GEP["prompt.md"]
```

### أتمتة CI

```mermaid
flowchart LR
    A[Scheduled trigger] --> B[Checkout code]
    B --> C[Run ProviderScratch]
    C --> D{Detect changes}
    D -->|Has changes| E[Create branch]
    E --> F[Commit changes]
    F --> G[Create PR]
    G --> H[Wait for review]
    D -->|No changes| I[Complete]
```

### متغيرات البيئة

| اسم المتغير | الوصف |
| --- | --- |
| `AMPHOREUS_PROVIDER_SCRATCH_PROVIDERS` | قائمة المزودين للكشط |
| `AMPHOREUS_PROVIDER_SCRATCH_OUTPUT_DIR` | مسار دليل الإخراج |
| `AMPHOREUS_PROVIDER_SCRATCH_GIT_BRANCH` | فرع Git المستهدف |
| `AMPHOREUS_PROVIDER_SCRATCH_DRY_RUN` | تشغيل تجريبي فقط |

## الخطط المستقبلية

| الميزة | الوصف | الأولوية |
| --- | --- | --- |
| تحكم إصدار التهيئة | تتبع تاريخ تغيير التهيئة | عالية |
| إشعار التغيير | إشعار المستخدمين بتحديثات التهيئة | متوسطة |
| تراجع التهيئة | دعم التراجع إلى الإصدارات التاريخية | متوسطة |
| توصيات ذكية | توصية التهيئات بناءً على أنماط الاستخدام | منخفضة |
| GitHub巡回 Agent | إنشاء PRs تلقائيًا لتحديث التهيئات | عالية |
