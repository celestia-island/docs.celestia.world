# دليل استخدام CLI

`entelecheia-cli` هي واجهة سطر الأوامر لمنصة تعاون Entelecheia متعددة الوكلاء. تتواصل مع خادم scepter عبر مقبس Unix باستخدام JSON-RPC، مما يوفر تفاعل الدردشة، وإدارة دورة حياة الخدمات، والتحكم بالوكلاء، والتكوين، والمزيد.

> ملاحظة: لم تصل CLI بعد إلى تعادل كامل في الميزات مع TUI. للحالة الحالية، انظر [ARCHITECTURE.md](../../designs/core/architecture.md).

---

## جدول المحتويات

- [التثبيت](#التثبيت)
- [الاستخدام الأساسي](#الاستخدام-الأساسي)
- [الخيارات العامة](#الخيارات-العامة)
- [أوامر الدردشة](#أوامر-الدردشة)
- [إدارة الوكلاء](#إدارة-الوكلاء)
- [دورة حياة الخدمات](#دورة-حياة-الخدمات)
- [التكوين](#التكوين)
- [سياق الاتصال](#سياق-الاتصال)
- [الحالة والمراقبة](#الحالة-والمراقبة)
- [الاشتراكات (Layer3)](#الاشتراكات-layer3)
- [تشغيل الوكلاء](#تشغيل-الوكلاء)
- [المخطط الزمني](#المخطط-الزمني)
- [صور Docker](#صور-docker)
- [الاستخدام المتقدم](#الاستخدام-المتقدم)

---

## التثبيت

### البناء من المصدر

```bash
# Clone the repository
git clone https://github.com/celestia-island/entelecheia.git
cd entelecheia

# Build the CLI binary
cargo build --package entelecheia-cli

# Or use just
just cli
```

يقع الملف التنفيذي في `target/debug/entelecheia-cli` (تصحيح) أو `target/release/entelecheia-cli` (إصدار).

### الملفات التنفيذية المبنية مسبقًا

تتوفر ملفات تنفيذية مبنية مسبقًا من [GitHub Releases](https://github.com/celestia-island/entelecheia/releases). نزّل الأرشيف الخاص بمنصتك وضع الملف التنفيذي في `PATH` الخاص بك.

---

## الاستخدام الأساسي

```bash
# Show help
entelecheia-cli --help

# Send a message through the skill chain
entelecheia-cli send explain the architecture of this project

# Send a message via a pipe
echo "summarize this file" | entelecheia-cli send

# Check system status
entelecheia-cli status
```

---

## الخيارات العامة

| الخيار | الوصف | الافتراضي |
| --- | --- | --- |
| `-l, --log-level <LEVEL>` | مستوى السجل (trace، debug، info، warn، error) | `warn` |
| `-d, --daemon` | تنفيذ الأمر في الخلفية والخروج فورًا | — |
| `-c, --clean` | تنظيف حاويات Cosmos وملفات المقابس | — |
| `-a, --auto-approve` | الموافقة التلقائية على العمليات (تأكد من أن الخادم يعمل) | — |
| `-t, --table` | مخرجات جدولية مقروءة بشريًا (منسَّقة بـ ANSI) | الافتراضي |
| `-j, --json` | مخرجات JSON (قابلة للقراءة آليًا) | — |
| `-r, --raw` | مخرجات نصية خام (بدون تنسيق) | — |
| `--format <FORMAT>` | تنسيق المخرجات (table، json، raw) | `table` |

خيارات تنسيق المخرجات:

- `table` — مخرجات جدولية مقروءة بشريًا
- `json` — مخرجات JSON قابلة للقراءة آليًا

**أمثلة:**

```bash
# Clean up containers
entelecheia-cli --clean

# Get status as JSON
entelecheia-cli status --format json

# Send a message in debug mode
entelecheia-cli -l debug send "debug connection issue"

# Run an agent in the background (returns immediately)
entelecheia-cli -d run my-agent --ci
```

---

## أوامر الدردشة

يدير الأمر الفرعي `chat` التفاعل التحادثي مع نظام وكيل الجلسة.

### إرسال رسالة

```bash
entelecheia-cli chat send [OPTIONS]
```

| الخيار | الوصف |
| --- | --- |
| `-m, --message <MSG>` | نص الرسالة المُرسَلة |
| `--stdin` | قراءة الرسالة من المدخل القياسي |
| `-f, --file <PATH>` | قراءة الرسالة من ملف |

يمكن استخدام مصدر إدخال واحد فقط في كل مرة.

**أمثلة:**

```bash
# Send a message directly
entelecheia-cli chat send -m "Hello, what can you do?"

# From standard input
echo "analyze the code in src/main.rs" | entelecheia-cli chat send --stdin

# From a file
entelecheia-cli chat send -f ./prompts/review.txt
```

يرسل الأمر `chat send` الرسالة عبر **سلسلة المهارات** — خط أنابيب التنفيذ الأساسي الذي ينسّق وكلاء متعددين. يُعرض التقدم عبر رسوم متحركة دوّارة أثناء التنفيذ.

### سجل الدردشة

```bash
entelecheia-cli chat history [OPTIONS]
```

| الخيار | الوصف | الافتراضي |
| --- | --- | --- |
| `--conversation <ID>` | التصفية حسب معرّف المحادثة | — |
| `--agent <TYPE>` | التصفية حسب نوع الوكيل | — |
| `--role <ROLE>` | التصفية حسب الدور (user/assistant/system) | — |
| `--from <ISO8601>` | تاريخ ووقت البداية (ISO 8601) | — |
| `--to <ISO8601>` | تاريخ ووقت النهاية (ISO 8601) | — |
| `--limit <N>` | الحد الأقصى لعدد الرسائل المُعادة | `50` |
| `--offset <N>` | إزاحة ترقيم الصفحات | `0` |

**مثال:**

```bash
entelecheia-cli chat history --agent ApoRia --limit 20 --from 2026-05-01T00:00:00Z
```

### الرسائل الأخيرة

```bash
entelecheia-cli chat recent [OPTIONS]
```

| الخيار | الوصف | الافتراضي |
| --- | --- | --- |
| `--timeline <ID>` | التصفية حسب معرّف المخطط الزمني/المحادثة | — |
| `--agent <TYPE>` | التصفية حسب نوع الوكيل | — |
| `--limit <N>` | الحد الأقصى لعدد الرسائل المُعادة | `20` |

---

## إدارة الوكلاء

إدارة دورة حياة الوكلاء (القائمة، البدء، الإيقاف، إعادة التشغيل).

```bash
entelecheia-cli agent <COMMAND>
```

### الأوامر

```bash
# List all agents and their state
entelecheia-cli agent list

# Start an agent by type
entelecheia-cli agent start <AGENT_TYPE>

# Stop a running agent
entelecheia-cli agent stop <AGENT_TYPE>

# Restart an agent
entelecheia-cli agent restart <AGENT_TYPE>
```

**أنواع الوكلاء المتاحة:** ApoRia, EleOs, EpieiKeia, Haplotes, HubRis, Kalos, NeiKos, OreXis, PhiLia, Polemos, SkeMma, SkoPeo.

> ملاحظة: تعمل الوكلاء ككرات مكتبة (library crates) داخل وقت تشغيل scepter، وليس كملفات تنفيذية مستقلة. يحاول الأمر `agent start` تشغيل ملف تنفيذي يطابق اسم الوكيل، وهو ما ينطبق بشكل أساسي عندما يُجمَّع الوكيل كملف تنفيذي منفصل. عمليًا، تُفعَّل الوكلاء عبر خادم scepter.

---

## دورة حياة الخدمات

إدارة مجموعة خدمات Entelecheia بحاويات Docker.

### تهيئة الخدمات

```bash
entelecheia-cli init [OPTIONS]
```

يُعدّ مجموعة الخدمات الكاملة: PostgreSQL (مع pgvector)، وسجل Docker، وخادم scepter، و WebUI. ينشئ شبكات Docker المطلوبة ويسحب/يبني الصور.

| الخيار | الوصف | الافتراضي |
| --- | --- | --- |
| `--prefix <STR>` | بادئة اسم الحاوية | `e-` |
| `--source-build` | بناء الصور من المصدر بدلًا من السحب | `false` |
| `--webui-port <PORT>` | منفذ WebUI | `3424` |

**مثال:**

```bash
entelecheia-cli init --prefix ent- --webui-port 8080
```

### بدء جميع الخدمات

```bash
entelecheia-cli serve [OPTIONS]
```

يبدأ جميع الحاويات المُهيأة مسبقًا. يتطلب أن يكون قد تم تشغيل `init` أولًا.

| الخيار | الوصف | الافتراضي |
| --- | --- | --- |
| `--prefix <STR>` | بادئة اسم الحاوية | `e-` |
| `--webui-port <PORT>` | منفذ WebUI | `3424` |

### إيقاف جميع الخدمات

```bash
entelecheia-cli stop [OPTIONS]
```

يوقف جميع الحاويات قيد التشغيل بالترتيب التالي: webui ← scepter ← registry ← postgres.

| الخيار | الوصف | الافتراضي |
| --- | --- | --- |
| `--prefix <STR>` | بادئة اسم الحاوية | `e-` |

### بدء WebUI فقط

```bash
entelecheia-cli webui [OPTIONS]
```

يبدأ أو ينشئ حاوية WebUI فقط.

| الخيار | الوصف | الافتراضي |
| --- | --- | --- |
| `--prefix <STR>` | بادئة اسم الحاوية | `e-` |
| `--webui-port <PORT>` | منفذ WebUI | `3424` |

---

## التكوين

عرض تكوين النظام والتحقق منه.

### عرض التكوين

```bash
entelecheia-cli config show
```

يعرض التكوين الحالي، بما في ذلك:

- عنوان URL لقاعدة البيانات وإعدادات الاتصال
- تكوين مزود LLM في ApoRia (الاسم، النموذج، نقطة النهاية)
- عنوان ربط WebSocket
- مستوى السجل

تُقلَم مفاتيح API في المخرجات (تظهر كـ `***`).

### التحقق من التكوين

```bash
entelecheia-cli config validate
```

ينفّذ فحوصات التحقق:

- عنوان URL لقاعدة البيانات مُعيَّن
- مزود ApoRia واحد على الأقل مُكوَّن بإعدادات كاملة
- عنوان ربط WebSocket مُعيَّن

يُعيد نتيجة نجاح/فشل مع تفاصيل عن أي مشكلات.

**مثال على المخرجات:**

```text
Validate Configuration:

Validating database configuration...
  [ OK ]  Database URL set

Validating ApoRia LLM configuration...
  [ OK ]  ApoRia providers configured

Validating WebSocket configuration...
  [ OK ]  WebSocket Bind Address set

[ OK ]  Configuration validation passed
```

---

## سياق الاتصال

يدير الأمر الفرعي `context` ملفات اتصال مسمَّاة، مما يتيح لك التبديل بين خوادم scepter المحلية (مقبس Unix) والبعيدة (WebSocket). يعمل بشكل مشابه لأمر `docker context` في Docker.

### المفاهيم

**السياق (context)** هو ملف تعريف مسمًّى يسجّل كيفية اتصال CLI بخادم scepter:

- **local** — اتصال عبر مقبس Unix (الافتراضي، يُحل تلقائيًا إلى `/run/.../entelecheia-tui.sock`)
- **remote** — اتصال WebSocket مع مصادقة رمز Bearer

تُخزَّن السياقات في `~/.config/entelecheia/contexts/contexts.toml`.

### عرض السياقات

```bash
entelecheia-cli context list
```

السياق النشط حاليًا يُعلَّم بعلامة `*`.

### عرض السياق الحالي

```bash
entelecheia-cli context show
```

يعرض نوع السياق النشط ومسار المقبس وعنوان WS والوصف.

### إنشاء سياق

```bash
# Remote WebSocket context
entelecheia-cli context create staging \
  --ws-url ws://scepter.example.com:8424/ws \
  --bearer-token <TOKEN> \
  --description "Staging server"

# An additional local context
entelecheia-cli context create dev --description "Development server"
```

للحصول على رمز Bearer من خادم بعيد:

```bash
# On the server machine
docker exec e-scepter cat /home/entelecheia/.config/entelecheia/scepter.token
```

### تبديل السياق

```bash
entelecheia-cli context use staging
# From now on, all commands (send, status, chat, etc.) will be routed through staging
```

### إزالة سياق

```bash
entelecheia-cli context remove staging
```

لا يمكن إزالة السياق `default`.

### مثال على سير العمل

```bash
# View current contexts
entelecheia-cli context list

# Create a remote context for the staging server
entelecheia-cli context create staging \
  --ws-url ws://192.168.1.100:8424/ws \
  --bearer-token $(cat /path/to/token)

# Switch to staging
entelecheia-cli context use staging

# Send a message through the remote server
entelecheia-cli send "list current to-do items"

# Check the remote server status
entelecheia-cli status

# Switch back to local
entelecheia-cli context use default
```

---

## الحالة والمراقبة

### حالة النظام

```bash
entelecheia-cli status
```

يعرض:

- إصدار الخادم
- حالة الاتصال (حالة المقبس)
- ملخص مزود LLM
- عنوان ربط WebSocket
- قائمة الوكلاء مع حالة التشغيل/الإيقاف
- موارد النظام (استخدام الذاكرة، متوسط الحِمل)

### استعلام مسار الحالة

يقبل الأمر `status` وسيطة شبيهة بالمسار للاستعلام عن أنظمة فرعية محددة. يدعم الصياغة المخططات الزمنية حسب الوكيل، وفحص سجل الدردشة، وإعداد الأجهزة.

```bash
entelecheia-cli status <PATH> [--raw]
```

| صياغة المسار | الوصف |
| --- | --- |
| `timeline.#agent[-N]` | عرض أحدث سجلَّات N لاستدعاء المهارات لوكيل ما |
| `timeline.#agent[N][M]` | عرض النداء M ضمن المهارة رقم N لاستدعاء MCP/الأداة |
| `history[-N]` | عرض أحدث N رسالة دردشة (جميع الأدوار) |
| `history[-N].body` | عرض محتوى الرسالة قبل الأخيرة بترتيب N |
| `device` | عرض جميع الأجهزة الطرفية التي يتعرف عليها Polemos |
| `device[N]` | عرض تفاصيل الجهاز رقم N من Polemos |

**أمثلة:**

```bash
# The 30 most recent skill-scheduling records for the Haplotes #001 agent
entelecheia-cli status timeline.#hap_lotes.001[-30]

# The 2nd MCP/tool call in the 3rd skill invocation
entelecheia-cli status timeline.#hap_lotes.001[3][2]

# The 30 most recent messages
entelecheia-cli status history[-30]

# The body of the 3rd-from-last message (plain text)
entelecheia-cli status history[-3].body --raw

# All Polemos devices
entelecheia-cli status device

# Details of the 3rd Polemos device
entelecheia-cli status device[3]
```

> **ملاحظة حول الصدفة:** في bash/zsh، ضع المسارات التي تحتوي على `[...]` بين علامات اقتباس مفردة لمنع توسيع الأنماط: `entelecheia-cli status 'history[-30]'`. لا يحتاج الحرف `#` إلى تخطي عندما يكون متضمنًا في وسط كلمة. في صدفة fish، لا تتطلب أي من هذه المسارات علامات اقتباس.

تتواصل استعلامات مسار الحالة مع الخادم عبر مقبس Unix باستخدام JSON-RPC. تتطلب استعلامات `timeline.*` و`history.*` أن يكون الخادم قيد التشغيل. يتطلب استعلام `device` مساحة عمل Polemos مسجَّلة على الخادم.

### عرض السجلات

```bash
entelecheia-cli logs [OPTIONS]
```

| الخيار | الوصف | الافتراضي |
| --- | --- | --- |
| `-a, --agent <NAME>` | تصفية السجلات حسب اسم الوكيل | جميع الوكلاء |
| `-l, --lines <N>` | عدد الأسطر المراد عرضها (النهاية) | `100` |

**أمثلة:**

```bash
# Show the last 200 lines of logs for all agents
entelecheia-cli logs -l 200

# Show ApoRia logs
entelecheia-cli logs -a ApoRia
```

تُقرأ السجلات من الدليل `./logs/`. لكل وكيل ملف سجل خاص به (`ApoRia.log`، `EleOs.log`، إلخ).

---

## الاشتراكات (Layer3)

إدارة اشتراكات وكلاء Layer3 — حزم وكلاء خارجية يمكن تثبيتها وتشغيلها.

### عرض الاشتراكات

```bash
entelecheia-cli subscribe list
```

يعرض جميع الاشتراكات المُكوَّنة، بما في ذلك الحالة (مثبَّت/معلَّق)، وحالة التفعيل، وإعداد التحديث التلقائي، والمصدر.

### إضافة اشتراك

```bash
entelecheia-cli subscribe add [OPTIONS]
```

| الخيار | الوصف |
| --- | --- |
| `--name <NAME>` | اسم الاشتراك (مطلوب) |
| `--source <SOURCE>` | نوع المصدر: `official`، أو `github`، أو `url` (مطلوب) |
| `--repository <REPO>` | مستودع GitHub (لمصادر github) |
| `--url <URL>` | عنوان URL مباشر (لمصادر url) |
| `--version <VER>` | قيد الإصدار |
| `--auto-update` | تفعيل التحديث التلقائي |
| `--disabled` | إضافته في حالة معطَّلة |

**مثال:**

```bash
entelecheia-cli subscribe add --name my-agent --source github --repository user/repo
```

### إزالة اشتراك

```bash
entelecheia-cli subscribe remove <NAME>
```

### مزامنة الاشتراكات

```bash
# Sync all subscriptions
entelecheia-cli subscribe sync

# Sync a specific subscription
entelecheia-cli subscribe sync --name my-agent
```

### التحديث التلقائي

```bash
entelecheia-cli subscribe auto-update
```

يحدّث جميع الاشتراكات التي فعّل لها `auto_update`.

---

## تشغيل الوكلاء

```bash
entelecheia-cli run <AGENT> [OPTIONS]
```

يشغّل نص برمجي لوكيل Layer3. يبحث عن `.amphoreus/<AGENT>/run.py` في الدليل الحالي. عند أول تنفيذ، يُجري تدقيقًا تمهيديًا للفحص.

| الخيار | الوصف |
| --- | --- |
| `--ci` | تفعيل وضع CI |
| `--auto-pr` | تفعيل وضع الـ PR التلقائي |
| `--dry-run` | تشغيل تجريبي (بدون تغييرات فعلية) |
| `--providers <LIST>` | قائمة مفصولة بفواصل للمزودين |
| `--output-dir <DIR>` | دليل المخرجات |

**أمثلة:**

```bash
# Run a Layer3 agent in dry-run mode
entelecheia-cli run my-agent --dry-run

# Run with specified providers
entelecheia-cli run my-agent --providers openai,anthropic

# CI mode with automatic PR submission
entelecheia-cli run my-agent --ci --auto-pr

# Run in background mode (returns immediately; child runs detached)
entelecheia-cli -d run my-agent --ci --auto-pr
```

### وضع الخلفية (`-d` / `--daemon`)

يتسبب علم وضع الخلفية في أن تُنشئ CLI عملية ابنة منفصلة مع إزالة الوسيطة `--daemon`، وتعود فورًا. ترث العملية الابنة الأمر الأصلي وتعمل بشكل مستقل. يمكنك التحقق من التقدم بعد ذلك باستخدام `status`.

يُطبَّق على العمليات طويلة التشغيل مثل `run` و`init` و`deploy`:

```bash
# Dispatch an agent run in the background
entelecheia-cli -d run my-agent

# Dispatch service initialization in the background
entelecheia-cli -d init --prefix prod-

# Check status later
entelecheia-cli status
entelecheia-cli status history[-5]
```

---

## المخطط الزمني

عرض المخططات الزمنية للجلسات.

### عرض المخططات الزمنية

```bash
entelecheia-cli timeline list [OPTIONS]
```

| الخيار | الوصف | الافتراضي |
| --- | --- | --- |
| `--agent <TYPE>` | التصفية حسب نوع الوكيل | — |
| `--limit <N>` | الحد الأقصى لعدد النتائج | `50` |
| `--offset <N>` | إزاحة ترقيم الصفحات | `0` |

### عرض تفاصيل المخطط الزمني

```bash
entelecheia-cli timeline show <CONVERSATION_ID> [OPTIONS]
```

| الخيار | الوصف | الافتراضي |
| --- | --- | --- |
| `--include-messages` | تضمين الرسائل في المخرجات | `true` |

---

## صور Docker

```bash
entelecheia-cli init-docker-images [OPTIONS]
```

يبني أو يسحب صور Docker التي تتطلبها المنصة.

| الخيار | الوصف |
| --- | --- |
| `--source-build` | بناء الصور من المصدر بدلًا من السحب |
| `--tag <TAG>` | وسم الصورة (الافتراضي: `latest`) |

**أمثلة:**

```bash
# Build all images from source
entelecheia-cli init-docker-images --source-build

# Pull with a custom tag
entelecheia-cli init-docker-images --tag v0.2.0
```

الصور المُدارة:

- `entelecheia` — خادم التنسيق (مع وقت تشغيل cosmos المضمَّن)
- `pgvector/pgvector` — PostgreSQL مع امتداد المتجهات

---

## الاستخدام المتقدم

### مخرجات JSON للبرمجة النصية

استخدم `--format json` للحصول على مخرجات قابلة للقراءة آليًا، يمكن توجيهها إلى `jq` أو أدوات أخرى:

```bash
entelecheia-cli status --format json | jq '.server_version'
entelecheia-cli chat history --format json | jq '.messages[].content'
```

### التنظيف والتهيئة المتسلسلة

```bash
# Full teardown and rebuild
entelecheia-cli --clean && entelecheia-cli init --prefix my-
```

### وضع التنقيح

```bash
# Enable trace-level logging for debugging
entelecheia-cli -l trace send "test message"
```

### الاستخدام إلى جانب TUI

تتصل CLI وTUI بنفس خادم scepter. يمكن استخدام كليهما في وقت واحد:

- ابدأ TUI للجلسات التفاعلية: `cargo run --bin entelecheia-tui`
- استخدم CLI للبرمجة النصية والأتمتة والاستعلامات السريعة

---

## استكشاف الأخطاء وإصلاحها

### "لم يُحدَّد أي أمر"

شغّل `--help` لرؤية الأوامر المتاحة، أو استخدم `send "message"` لإرسال رسالة بسرعة.

### "تعذّر الاتصال بـ Docker"

تأكد من أن Docker (أو Podman) يعمل:

```bash
docker info
docker run hello-world
```

### "لم يُعثر على ملف الوكيل التنفيذي"

الوكلاء هي كرات مكتبة داخلية لوقت تشغيل scepter، وليست ملفات تنفيذية مستقلة. ابدأ خادم scepter لتفعيل الوكلاء:

```bash
entelecheia-cli init && entelecheia-cli serve
```

### "لا توجد مزودات LLM مُكوَّنة"

عيّن تكوين مزود ApoRia عبر متغيرات البيئة. لتعليمات إعداد المزود، انظر [دليل البناء](building.md).

### "فشل التحقق من التكوين"

شغّل `entelecheia-cli config validate` لمعرفة الفحوصات التي فشلت. المشكلات الشائعة:

- متغير بيئة `DATABASE_URL` مفقود
- إعداد مزود ApoRia غير مكتمل (الاسم، النموذج، `api_key`)
- عنوان ربط WebSocket مفقود
