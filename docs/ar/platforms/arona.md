# Arona — بوابة النماذج والذاكرة والعنقود

Arona هو مستوى تحكّم المنصة: بوابة نماذج، ومدير بيئة تشغيل للنشر الذاتي،
ولوحة ويب. المشكلة التي يحلّها هي تحويل «نموذج نُزِّل إلى جهاز ما» إلى شيء
يمكن للمنصة كلها توجيهه وقياسه وتذكّره. هذا الدليل مرتّب حسب القدرة: توجيه
النماذج، والذاكرة طويلة الأمد، والعناقيد متعددة العقد.

## البنية في لمحة

```text
shittim-chest / any OpenAI client
        │  /v1/chat/completions (Bearer API key)
        ▼
   Arona gateway (node-2:8420)
   ├─ Router: aliases → least-count load balancing across backends
   ├─ Memory Gateway: recall inject → chat → writeback (episodes)
   └─ Agent control plane (/ws/agent) ──► arona-agent on GPU nodes
        │
        ▼
   Backends: ollama · external (OpenAI-compatible) · agent-deployed engines
```

تجري كل حركة الإدارة (اللوحة، الوكلاء، الذاكرة) عبر WebSocket برسائل
JSON-RPC 2.0؛ والسطح الوحيد من نوع REST هو نقاط النهاية المتوافقة مع
OpenAI في `/v1/*`.

## 1. النماذج

### تسجيل خلفية

تُسجَّل الخلفيات بوصفها `ollama` أو `external` (أي خادم متوافق مع OpenAI —
vLLM وTGI وLMDeploy وموجّه TileRT و…):

```bash
POST /api/admin/backends        # Bearer ADMIN_TOKEN
  {"type": "ollama", "name": "node3-ollama", "url": "http://host:11434"}
  {"type": "external", "name": "my-vllm", "url": "http://host:8000",
   "api_key": "...", "models": ["qwen2.5-72b"]}
```

تبقى الخلفيات المسجلة محفوظة عبر إعادة التشغيل (جدول `backend_configs`)
وتُفحص صحتها باستمرار: تعمل الخلفيات الخارجية بمبدأ الفشل المغلق إلى أن
ينجح أول فحص `/v1/models`، وتُحدَّث قائمة نماذجها ديناميكيًا.

### نشر نموذج ذاتيًا على عقدة

يعمل الثنائي `arona-agent` على أجهزة GPU ويتصل عائدًا إلى اللوحة. انشر
نموذجًا من صفحة **الوكلاء** في لوحة التحكم (أو عبر `agents.deploy` بقيمة
`agent_id` فارغة لاستهداف العقدة الأقل انشغالًا تلقائيًا). ينزّل الوكيل
النموذج (من HuggingFace أو سجل Ollama)، ويشغّل المحرك (llama.cpp / vLLM /
Ollama)، ويُفيد بنقطة نهاية المحرك — فتسجّله اللوحة تلقائيًا خلفية قابلة
للتوجيه باسم `agent-{model}` وتزيله عند التوقف.

عنوان ربط المحرك: اضبط `ARONA_AGENT_BIND_ADDR=0.0.0.0` على العقد التي يجب
أن تقدّم حركة مرور إلى اللوحة. ملاحظة: منافذ المحرك غير مصادَقة — انشر على
شبكات موثوقة فقط.

### ترابط المحادثات

تُثبَّت المحادثات على خلفية واحدة (ترابط الجلسة)، وهو ما يتيح إعادة استخدام
مخازن KV في وقت التشغيل. إذا تدهورت صحة خلفية مثبَّتة، يتراجع الموجّه
ويعيد التثبيت على غيرها.

## 2. الذاكرة طويلة الأمد

Arona **بوابة ذاكرة**: لا يدرّب النماذج — بل ينسّق خدمة ذاكرة (وكيل PhiLia
في entelecheia) حول نموذجك القائم.

### التمكين

```bash
ARONA_MEMORY_URL=ws://<scepter-host>:8424/ws
ARONA_MEMORY_TOKEN=<scepter connection token>
ARONA_MEMORY_WRITEBACK=1        # default on; 0 disables writeback
```

### ماذا يحدث في كل محادثة

1. **الاستدعاء** — تُدمَج آخر رسالة للمستخدم ويُستعلم بها عن خدمة الذاكرة؛
   وتُحقن الذكريات ذات الصلة قسمًا نظاميًا باسم `## Relevant Long-Term
   Memories` (تكرار التنفيذ آمن).
2. **المحادثة** — يوجَّه السياق المُجمَّع إلى النموذج.
3. **الكتابة الراجعة** — يُستخرج الدور المكتمل استخراجًا استكشافيًا
   (`User: … / Assistant: …`، بصفر استدعاءات LLM) ويُخزَّن حلقةً في مخطط
   الذاكرة (مدعوم بـ pgvector، يصمد عبر إعادة التشغيل).
4. **الحالة** — تُفيد كل استجابة بـ `memory: enabled | disabled | offline`؛
   ويضيف سطح REST ترويسة `X-Arona-Memory`. الأعطال لا تعطّل المحادثة أبدًا؛
   و`offline` تعني تعذّر الوصول إلى خدمة الذاكرة، وهي مرئية دائمًا في
   الواجهة.

تجاوز لكل استدعاء: يقبل `chat.send` القيمة `memory: true|false`.

### الإدارة

تعرض صفحة **الذاكرة** في اللوحة نشاط الاستدعاء/الكتابة الراجعة/الحذف وتتيح
لك حذف العقد المخزنة. الجلسات تبقى على الخادم: مرّر `conversation_id` إلى
`chat.send` ويجمع الخادم التاريخ بدلًا من العميل.

## 3. العمليات

- **المصادقة**: يُقفل التسجيل بعد تهيئة أول مسؤول (`ARONA_REGISTRATION_OPEN=1`
  يعيد فتحه). تتطلب نقاط نهاية الإدارة `ARONA_ADMIN_TOKEN`؛ وتفشل مغلقةً
  بدونه.
- **القياس**: يُسجَّل الاستخدام والتكلفة لكل مفتاح API (`usage.list`،
  ومستويات فوترة بحصص وحدود معدل).
- **الصحة**: يُفيد `/api/health` و`/v1/health` بالإصدار وبصمة البناء.

## مرجع متغيرات البيئة

| المتغير | الغرض |
|---|---|
| `DATABASE_URL` | Postgres (مطلوب) |
| `JWT_SECRET` | توقيع الرموز (مطلوب خارج وضع المحاكاة) |
| `ARONA_HOST` / `ARONA_PORT` | عنوان الربط (الافتراضي `0.0.0.0:8420`) |
| `ARONA_ADMIN_TOKEN` | رمز Bearer لـ `/api/admin/*` |
| `ARONA_REGISTRATION_OPEN` | إعادة فتح التسجيل الذاتي |
| `ARONA_MEMORY_URL` / `ARONA_MEMORY_TOKEN` / `ARONA_MEMORY_WRITEBACK` | بوابة الذاكرة |
| `ARONA_AGENT_NAME` / `ARONA_PANEL_URL` / `ARONA_AGENT_BIND_ADDR` | عقدة الوكيل |
