# دليل البناء

-----------------------------------------------------------------------------

## جدول المحتويات

- [المتطلبات الأساسية](#المتطلبات-الأساسية)
- [التثبيت](#التثبيت)
- [التكوين](#التكوين)
- [البناء](#البناء)
- [التشغيل](#التشغيل)
- [إدارة قاعدة البيانات](#إدارة-قاعدة-البيانات)
- [بيئة التطوير](#بيئة-التطوير)
- [النشر](#النشر)
- [استكشاف الأخطاء وإصلاحها](#استكشاف-الأخطاء-وإصلاحها)
- [تشغيل بوت الـ webhook](#تشغيل-بوت-الـ-webhook)

-----------------------------------------------------------------------------

## المتطلبات الأساسية

### متطلبات النظام

- **نظام التشغيل**: Linux، أو macOS، أو Windows (يتطلب Docker CLI)
- **الذاكرة**: الحد الأدنى 8 غيغابايت، يُنصح بـ 16 غيغابايت
- **التخزين**: 20 غيغابايت مساحة حرة كحد أدنى
- **المعالج**: 4 أنوية أو أكثر يُنصح بها

> ملاحظة (نية التصميم)
> المتطلب الأساسي على جانب Windows هو توفر Docker CLI؛ يمكن تشغيل الأوامر مباشرةً في PowerShell أو Windows Terminal.
> مع ذلك، لا تزال الحاويات تتطلب في النهاية وقت تشغيل Linux لاستضافتها:
> 1. الحل المحلي عادةً ما يكون Docker Desktop (يعتمد عمومًا على واجهة WSL2 الخلفية).
> 2. البديل هو تثبيت Docker CLI فقط على الجهاز المحلي والتوجيه إلى مضيف Docker Linux بعيد عبر `docker context`.

### متطلبات البرمجيات

#### البرمجيات المطلوبة

- **Docker أو Podman** (بيئة وقت تشغيل الحاويات)

```bash
docker --version
docker compose version
```

يرجى استخدام طريقة التثبيت الموصى بها رسميًا لمنصتك الحالية:

- Linux: ثبّت Docker Engine، أو Docker Desktop لنظام Linux، أو Podman الذي توفره توزيعتك
- macOS: ثبّت Docker Desktop أو Podman Desktop
- Windows: ثبّت Docker Desktop أو Podman Desktop

**ملاحظات مهمة**:

- تبعات وقت التشغيل مثل PostgreSQL مُضمَّنة بالفعل في البيئة المعبأة في حاويات
- مع ذلك، إذا كنت تريد تشغيل وصفات `just` أو البرمجيات النصية المساعدة داخل المستودع، فلا يزال المضيف بحاجة إلى تثبيت Python 3.8+
- ليست هناك حاجة لتثبيت PostgreSQL بشكل منفصل على المضيف
- على Windows، يمكن تشغيل الأوامر مباشرةً في PowerShell أو Windows Terminal، لكن النشر لا يزال يتطلب وقت تشغيل Docker/Podman Linux متاحًا. النشر المحلي عادةً يعني استخدام Docker Desktop مع واجهة WSL2 الخلفية؛ وبدلًا من ذلك، يمكنك التوجيه إلى مضيف Docker Linux بعيد عبر Docker CLI/context المحلي.

- **Rust 1.85+** (مطلوب لبناء التطوير فقط)

```bash
rustup update stable
```

يرجى استخدام طريقة تثبيت rustup الرسمية لمنصتك:

- Linux/macOS: زُر <https://rustup.rs>
- Windows: نزّل وشغّل `rustup-init.exe` من <https://rustup.rs>، ثم شغّل `rustup update stable`

#### البرمجيات الموصى بها

- **just** (مشغّل الأوامر)

```bash
  # Using cargo
  cargo install just

  # Using brew (macOS)
  brew install just
  ```

- **VS Code** مع إضافة rust-analyzer المثبتة

-----------------------------------------------------------------------------

## التثبيت

### الخطوة 1: استنساخ المستودع

```bash
git clone https://github.com/celestia-island/entelecheia.git
cd entelecheia
```

### الخطوة 2: تكوين متغيرات البيئة

```bash
# Edit the configuration after creating .env from .env.example
nano .env  # or use your preferred editor
```

استخدم صدفتك الحالية أو مدير الملفات لنسخ `.env.example` إلى `.env`.

صدفة POSIX:

```bash
cp .env.example .env
```

PowerShell:

```powershell
Copy-Item .env.example .env
```

#### التكوين الأساسي

```bash
# Database configuration (configured automatically inside the container)
# DATABASE_URL=postgresql://entelecheia:password@localhost:5432/entelecheia
# DATABASE_MAX_CONNECTIONS=10

# LLM quick init; import ApoRia after startup
# Single provider:
# LLM_API_KEY=your-api-key-here
# LLM_BASE_URL=https://api.openai.com/v1
# LLM_MODEL=gpt-4
# Multiple providers (semicolon-separated):
# LLM_API_KEY=key1;key2
# LLM_BASE_URL=https://api.one/v1;https://api.two/v1
# LLM_PROTOCOL=openai;openai,api-key
# LLM_MODEL_DEEP=model-a1,model-a2;model-b1
# LLM_MODEL_NORMAL=model-a3;model-b2
# LLM_MODEL_BASIC=model-a4;model-b3

# Provider-level shortcut entry (recommended)
OPENAI_API_KEY=your-api-key-here
# ANTHROPIC_API_KEY=
# DEEPSEEK_API_KEY=
# DASHSCOPE_API_KEY=
# BIGMODEL_API_KEY=
# ZAI_API_KEY=

# WebSocket configuration
WS_BIND_ADDRESS=127.0.0.1:42470
WS_MAX_CONNECTIONS=100
```

#### ملاحظات تكوين متغيرات بيئة LLM

> **مهم**: تُدار تكوينات مزود LLM حاليًا بشكل مركزي بواسطة ApoRia. تعمل متغيرات البيئة فقط كنقطة إدخال أولية ولم تعد مصدر التكوين طويل الأمد.

**كيفية عملها**:

1. عندما تحتاج TUI إلى بدء تشغيل الخادم تلقائيًا، فإنها تقرأ متغيرات التهيئة السريعة العامة `LLM_*`، أو المتغيرات على مستوى المزود مثل `OPENAI_API_KEY`. يستخدم تكوين المزودات المتعددة مصفوفات متوازية مفصولة بفواصل منقوطة: `LLM_API_KEY`، `LLM_BASE_URL`، `LLM_PROTOCOL`، `LLM_MODEL_DEEP`، `LLM_MODEL_NORMAL`، `LLM_MODEL_BASIC`. تدعم متغيرات بيئة خطة البرمجة (مثل `BIGMODEL_API_KEY_CODING_PRO`) أيضًا مفاتيح متعددة مفصولة بفواصل منقوطة، مع ترقيم تلقائي `(#2)`، `(#3)`. تُظهر المزودات المخصصة اسم نطاقها بين قوسين.
1. قبل أن يبدأ الخادم، تقوم TUI أولًا بكتابة الدفعة الأولى من تكوينات المزودين إلى `res/prompts/agents/aporia/config.toml`
1. بعد اكتمال الكتابة المسبقة، تأخذ تكوين ApoRia وصفحة Models في TUI الأسبقية
1. لا تُستبدل المزودات الحالية ذات مفتاح API غير الفارغ بمتغيرات البيئة

**الاستخدام الموصى به**:

- استخدم متغيرات البيئة لإكمال التهيئة الأولى
- بعد ذلك، حافظ على كل شيء عبر صفحة Models أو `res/prompts/agents/aporia/config.toml`

### الخطوة 3: بدء الخدمات

```bash
# Start all services using Docker Compose
docker compose up -d

# Or use the just command (if installed)
just dev
```

-----------------------------------------------------------------------------

## التكوين

### تكوين مزود LLM

يدعم Entelecheia مزودات LLM متعددة. كوّن مزودك المفضل:

#### OpenAI

```bash
OPENAI_API_KEY=sk-...
```

#### Anthropic

```bash
ANTHROPIC_API_KEY=sk-ant-...
```

#### LLM محلي (Ollama)

```bash
# Configure the local provider via the Models page or res/prompts/agents/aporia/config.toml
# endpoint = http://localhost:11434
# model = llama2
```

### تكوين Docker

```bash
# Docker socket (usually auto-detected)
DOCKER_HOST=unix:///var/run/docker.sock

# Container settings
CONTAINER_NETWORK=entelecheia-network
CONTAINER_REGISTRY=127.0.0.1:5000
```

-----------------------------------------------------------------------------

## البناء

### بناء التطوير

```bash
# Quick development build
just build-dev
```

### بناء الإنتاج

```bash
# Optimized release build
just build
```

### بناء مكونات محددة

```bash
# Build only the server
cargo build -p scepter

# Build only the TUI
cargo build -p entelecheia-tui

# Build a specific agent
cargo build -p haplotes
```

### نواتج البناء

بعد البناء، ستجد:

- **الملفات التنفيذية**: في `target/debug/` أو `target/release/`
- **صور Docker**: تُبنى تلقائيًا أثناء `just dev`

-----------------------------------------------------------------------------

## التشغيل

### وضع التطوير

```bash
# Start the full development environment (including the TUI)
just dev

# Start only the server (no TUI)
just dev --no-tui

# Clean start (deletes all data)
just dev-clean
```

### وضع الإنتاج

```bash
# Start the server
just server

# Start the TUI client
just tui

# Start all agents
just agents-up
```

### معاملات توافق الطرفية

تعتمد TUI على تسلسلات الهروب ANSI، وأحداث الفأرة، وعرض الصور (بروتوكولا Sixel/Kitty). في بيئات الطرفيات المقيّدة — مثل جلسات SSH، وأطواق المنافذ التسلسلية، ومنفّذي CI، أو محاكيات الطرفيات القديمة — تتوفر ثلاثة معاملات تدرّجية للتدهور:

#### `--no-image-render`

يُعطّل جميع عرض الصور. تبقى الميزات الأخرى — الألوان، الفأرة، تحديث الفروقات — تعمل بكامل وظائفها.

```bash
just tui -- --no-image-render
```

السيناريوهات المطبّقة: تدعم الطرفية الألوان والفأرة لكنها تفتقر إلى دعم بروتوكول صور Sixel/Kitty (الحالة الأكثر شيوعًا).

#### `--no-ansi`

يُعطّل التقاط الفأرة والاستماع للمفاتيح الخاصة. تُحفَظ الألوان وتحديث الشاشة (الجزئي) بالفروقات. مفيد عندما تتداخل أحداث الفأرة مع تحديد الطرفية، أو النسخ واللصق، أو سجل التمرير.

```bash
just tui -- --no-ansi
```

السيناريوهات المطبّقة: تحتاج إلى الألوان لكن التقاط الفأرة يسبب مشاكل (مضاعفات الطرفية، `screen`، تكوينات `tmux` الأساسية، إلخ).

#### `--no-ansi-pure`

وضع أحادي اللون نقي — أكثر تدهورًا صرامة. يُعطّل جميع ألوان ANSI (يفرض `Color::Reset` عالميًا)، ويُعطّل التقاط الفأرة، ويعيد رسم الشاشة بالكامل في كل إطار. يُستبدل شعار شاشة البداية بنسخة ASCII art نقية. تتضمن هذه المعاملَة `--no-ansi` ضمنيًا.

```bash
just tui -- --no-ansi-pure
```

السيناريوهات المطبّقة: التشغيل عبر SSH، أو أطواق المنافذ التسلسلية، أو `docker exec`، أو بيئات CI بأقل دعم للطرفية، أو أي طرفية لا تتعامل مع أكواد ألوان ANSI بشكل صحيح.

#### مقارنة المعاملات

| الميزة | الافتراضي | `--no-image-render` | `--no-ansi` | `--no-ansi-pure` |
| --- | --- | --- | --- | --- |
| الألوان | كاملة | كاملة | كاملة | معطّلة |
| التقاط الفأرة | نعم | نعم | لا | لا |
| عرض الصور | نعم | لا | لا | لا |
| تحديث الشاشة | فروقات | فروقات | فروقات | إعادة رسم كاملة |
| شعار البدء | لون ANSI | لون ANSI | لون ANSI | ASCII art نقي |

### إدارة الخدمات

```bash
# Check service status
just dev-status

# View logs
just dev-logs

# Stop services
just dev-down

# Force-kill all services
just dev-kill
```

-----------------------------------------------------------------------------

## إدارة قاعدة البيانات

### تهيئة قاعدة البيانات

```bash
# Create the database
just db-create

# Run migrations
just db-migrate

# Initialize with seed data
just db-init
```

### عمليات قاعدة البيانات

```bash
# Check database status
just db-status

# Back up the database
just db-backup

# Restore the database
just db-restore backups/backup_xxx.sql

# Reset the database (warning: deletes all data)
just db-reset
```

### إدارة الهجرات

```bash
# Create a new migration
cargo test -p scepter test_create_migration -- --nocapture --ignored

# Roll back the last migration
just db-migrate-down
```

-----------------------------------------------------------------------------

## بيئة التطوير

### إعداد البيئة

```bash
# Initialize all dependencies
just init

# Check Python dependencies

# Format code
just fmt

# Run the linter
just clippy
```

### الاختبار

```bash
# Run all tests
just test

# Run a specific type of test
just test unit
just test integration
just test e2e
just test llm-providers

# Verbose output
just test verbose
```

### جودة الكود

```bash
# Format code
just fmt

# Check formatting
just fmt-check

# Run clippy
just clippy

# Type checking
just check
```

-----------------------------------------------------------------------------

## النشر

### النشر عبر Docker

#### بناء الصورة

```bash
docker build -t entelecheia:latest .
```

#### تشغيل الحاوية

```bash
docker run -d --name entelecheia \
  --env-file .env \
  -p 8424:8424 \
  -v /var/run/docker.sock:/var/run/docker.sock \
  entelecheia:latest
```

### النشر عبر Docker Compose

```bash
# Start all services
docker compose up -d

# View logs
docker compose logs -f

# Stop services
docker compose down
```

-----------------------------------------------------------------------------

## استكشاف الأخطاء وإصلاحها

### مشكلات شائعة

#### رفض إذن Docker

```bash
# Add the user to the docker group
sudo usermod -aG docker $USER

# Log out and log back in
```

#### المنفذ مستخدم بالفعل

```bash
# Check the process using the port
lsof -i :8424

# Kill the process
kill -9 <PID>
```

#### فشل البناء

```bash
# Clean build artifacts
cargo clean

# Update dependencies
cargo update

# Rebuild
just build
```

#### فشل بدء الحاوية

```bash
# Check Docker logs
docker compose logs

# Rebuild the container
docker compose down
docker compose build --no-cache
docker compose up -d
```

### الحصول على المساعدة

1. ابحث في [GitHub Issues](https://github.com/celestia-island/entelecheia/issues)
1. انضم إلى [نقاشاتنا](https://github.com/celestia-island/entelecheia/discussions)

-----------------------------------------------------------------------------

## تشغيل بوت الـ webhook

يقع بوت الـ webhook تحت `plugins/github-webhook/`. لكل منصة دليلها الخاص.

### المتطلبات الأساسية

- Python 3.10+ (البوتات الحالية)
- Node.js 18+ (لأجل الترحيل المستقبلي إلى TypeScript)
- رموز البوت لكل منصة (انظر [دليل تكوين الـ webhook](webhook-setup.md))

### تشغيل بوت واحد

```bash
# GitHub
cd plugins/github-webhook/github
pip install -r requirements.txt
python bot.py

# Gitee
cd plugins/github-webhook/gitee
pip install -r requirements.txt
python bot.py

# Discord
cd plugins/github-webhook/discord
pip install -r requirements.txt
python bot.py
```

### تشغيل جميع البوتات

```bash
just webhooks-up
```

### متغيرات البيئة

انسخ ملف البيئة النموذجي وكوّنه:

```bash
cp plugins/github-webhook/.env.example plugins/github-webhook/.env
```

للحصول على تفاصيل التكوين الخاصة بكل منصة، انظر [دليل تكوين الـ webhook](webhook-setup.md).

-----------------------------------------------------------------------------

## الخطوات التالية

- اقرأ [دليل الأساسيات](fundamentals.md) لفهم البنية
- تصفّح [وثائق الوكلاء](../../agents/) للتعرّف على الوكلاء المتاحة

-----------------------------------------------------------------------------

**نتمنى لك بناءً موفقًا!** 🚀
