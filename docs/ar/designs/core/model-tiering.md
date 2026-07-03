# تصميم نظام تصنيف النماذج

## نظرة عامة

نظام تصنيف النماذج هو آلية اختيار ذكية للنماذج تعيّن مستويات النماذج المناسبة بناءً على تعقيد المهمة، مما يزيد من استغلال الموارد مع ضمان الجودة.

> **وثيقة ذات صلة**: نظام النماذج ثلاثي المستويات المعرّف في هذه الوثيقة هو أساس [نظام حلقة التطور الذاتي](04-self-evolution-loop.md).

## المبادئ الأساسية

### نظام النماذج ثلاثي المستويات

```mermaid
graph TB
    subgraph Model Tiers
        T1[T1 Deep Thinking<br/>Complex Reasoning]
        T2[T2 Normal Thinking<br/>Standard Tasks]
        T3[T3 Basic Thinking<br/>Atomic Operations]
    end

    T1 --> |Degradation| T2
    T2 --> |Degradation| T3
    T3 --> |Fine-tuning Evolution| T3_Fine[Fine-tuned T3]
```

### مقارنة المستويات

| المستوى | التموضع | التكلفة | السيناريوهات النموذجية |
| --- | --- | --- | --- |
| T1 (عميق) | استدلال معقد، قرارات | الأعلى | تصميم البنية، تحليل المشكلات |
| T2 (عادي) | مهام قياسية | متوسطة | كتابة الكود، توليد المستندات |
| T3 (أساسي) | عمليات ذرّية | الأدنى | قراءة الملفات، تحويل التنسيق |

## آلية اختيار النماذج

### عملية الاختيار

```mermaid
flowchart TD
    Request[Task Request] --> Parse[Parse level Field]
    Parse --> Filter{Filter Matching Tier Models}
    Filter --> |Available Models| Check{Check Quota}
    Filter --> |No Available Models| Downgrade[Try Degradation]
    Check --> |Quota Sufficient| Select[Select Highest Priority]
    Check --> |Quota Exhausted| Next[Try Next One]
    Select --> Execute[Execute Task]
    Downgrade --> Filter
    Next --> Check
```

### استراتيجية التدهور

```mermaid
stateDiagram-v2
    [*] --> Deep: deep Task
    Deep --> Normal: deep Model Unavailable
    Normal --> Basic: normal Model Unavailable
    Basic --> [*]: Execute or Error

    Deep --> [*]: Successful Execution
    Normal --> [*]: Successful Execution
```

## آلية التهيئة

### توضيح مستوى المهارة/MCP

تصرح كل مهارة وأداة MCP بمستوى النموذج المطلوب عبر حقل `level`:

```mermaid
graph LR
    subgraph Configuration Layer
        S[Skill Config]
        M[MCP Config]
    end

    subgraph Level Field
        L[level: deep/normal/basic]
    end

    S --> L
    M --> L
    L --> |Runtime| Select[Model Selector]
```

### تحكم الأولوية

```mermaid
graph LR
    subgraph Priority Factors
        A[User Config Priority]
        B[Model Tier Match]
        C[Quota Status]
    end

    A --> |Highest Weight| Sort[Sort]
    B --> |Secondary Weight| Sort
    C --> |Filter Condition| Filter[Filter]
    Filter --> Sort
    Sort --> Select[Select Model]
```

## العلاقة مع الوحدات الأخرى

```mermaid
graph TB
    A[Model Tiering System] --> B[Self-Evolution Loop]
    A --> C[Period Usage Statistics]
    A --> D[Cost Reports]

    B --> |Fine-tuning Target| A
    C --> |Selection Basis| A
    D --> |Cost Data| A
```

## اعتبارات التصميم

### تحسين التكلفة

- إعطاء الأولوية للنماذج الأدنى مستوى
- التدهور التلقائي يتجنب فشل المهمة
- تنبيهات مراقبة الحصة

### ضمان الجودة

- المهام المعقدة تتطلب مستوى عاليًا
- التدهور يتطلب التحقق من الجدوى
- إعادة المحاولة التلقائية عند الفشل

### قابلية التوسع

- دعم مستويات مخصصة
- تهيئة أولوية مرنة
- استراتيجيات اختيار قابلة للإدراج
