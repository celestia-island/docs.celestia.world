# Entelecheia — منصة الوكلاء والذاكرة

Entelecheia هو منصة الوكلاء: بيئة تشغيل scepter التي تنسّق الوكلاء
المتخصصين («الأرواح»)، وتصون الذاكرة طويلة الأمد (PhiLia)، وتوفر البحث
الدلالي، وتستضيف طبقة التكامل الصناعي. خلف قدرات Arona وChest تقف هذه
المنصة. هذا الدليل مرتّب حسب القدرة: الوكلاء، والذاكرة، والبحث، والمعرفة،
والاتصالات.

## البنية في لمحة

```text
Clients: Arona (gateway) · Shittim Chest (chat/panels) · TUI/CLI
        │  JSON-RPC 2.0 over WebSocket (token or API key)
        ▼
   scepter runtime (node-3:8424)
   ├─ Agent manager: L1 souls (PhiLia, Skopeo, Hubris, Kalos, …)
   ├─ Skill chains: pipelines of LLM + tool calls with RAG prefetch
   ├─ PhiLia: long-term memory (vector + graph, pgvector-backed)
   ├─ ApoRia: knowledge base + workspace index (semantic search)
   ├─ OreXis: policy / safety gates on tool execution
   └─ Reflection: lesson store re-injected into prompts
```

## 1. الوكلاء (الأرواح)

كل روح وكيل متخصص بوثيقة هوية وأدوات (على طراز MCP) ومهارات خاصة بها.
تؤلّف سلاسل المهارات استدعاءات LLM مع تنفيذ الأدوات؛ وقبل كل استدعاء تُجلب
مسبقًا الذكريات طويلة الأمد ذات الصلة ومحتوى قاعدة المعرفة وتُحقن في موجّه
النظام.

السلامة: يمرّ تنفيذ الأدوات عبر بوابات سياسات OreXis، وتتطلب عمليات الكتابة
الصناعية تدفقات موافقة صريحة.

## 2. الذاكرة طويلة الأمد (PhiLia)

PhiLia هي خدمة الذاكرة خلف بوابة ذاكرة Arona:

- **التخزين** — تُخزَّن الحلقات والكيانات والنتاجات عقدًا في مخطط ذاكرة،
  وتُدمَج وتُنعكس إلى pgvector (`philia_chunks`).
- **الاستعلام** — يجمع الاسترجاع الدلالي بين تشابه المتجهات، واجتياز
  المخطط، واضمحلال الحداثة (عمر نصف 14 يومًا).
- **التوحيد** — يربط الدمج الدوري العقد ذات الصلة.
- **سطح السلك** — طرائق من الدرجة الأولى `Sync.MemoryStoreRequest` /
  `MemoryQueryRequest` / `MemoryDeleteRequest` (RBAC: SystemWrite /
  SystemRead) إلى جانب مسار `Mcp.CallTool` العام.

الدمج: يُضبط عبر `OLLAMA_HOST` + `OLLAMA_EMBED_MODEL` (مثل
`nomic-embed-text`)، أو عبر API بعيد، مع الرجوع إلى نموذج ONNX محلي.

## 3. البحث الدلالي

يدمج `Sync.SearchRequest` مخزنين في قائمة مرتّبة واحدة:

- **ApoRia** — فهرس مساحة العمل، وتقارير الوكلاء، ومستندات قواعد المعرفة
  (هجين: متجهات + كلمات مفتاحية مع RRF).
- **PhiLia** — الذكريات طويلة الأمد (المصدر `philia_memory`).

## 4. قاعدة المعرفة

أنشئ قواعد معرفة، وأضف مستندات، واشترك في اشتراكات rag — كلها محفوظة في
Postgres. تُدمَج المستندات في مخزن ApoRia وتُسترجع عبر سطح البحث نفسه.

## 5. التأمل

تُخزَّن الدروس المستفادة في مخزن دروس (pgvector) وتُحقن مجددًا في الموجهات
المقبلة — ذاكرة ثانية دائمة وخفيفة إلى جانب PhiLia.

## 6. اتصال العملاء

- WebSocket عبر `ws://<host>:8424/ws` — صادق عند الترقية بـ
  `?token=<connection token>` (أو Bearer)؛ ثم `Sync.ConnectHandshake`.
- HTTP JSON-RPC عبر `POST /api/rpc?token=…` للاستخدام الطلبي/الاستجابي.
- رمز الاتصال: `~/.config/entelecheia/scepter.token` على عقدة scepter.

## مرجع متغيرات البيئة (مختصر)

| المتغير | الغرض |
|---|---|
| `SERVER_BIND_ADDRESS` | عنوان الربط (الافتراضي 127.0.0.1؛ اضبط 0.0.0.0:8424 لعملاء بعيدين) |
| `DATABASE_URL` | Postgres (config.toml أو متغير بيئة) |
| `OLLAMA_HOST` / `OLLAMA_EMBED_MODEL` | خلفية الدمج |
| `JWT_SECRET` | رموز مصادقة دائمة (عشوائية لكل جلسة عند الغياب) |
| `connection_token` | ملف رمز اتصال scepter |
