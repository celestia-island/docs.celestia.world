# دليل البناء والتطوير

> **الجمهور**: المساهمون الذين يُعدّون بيئة تطوير محلية لـ shittim-chest.
> **آخر تحديث**: 2026-05-25

## المتطلبات الأساسية

| الأداة | الحد الأدنى للإصدار | ملاحظات |
| --- | --- | --- |
| Rust | 1.85+ | إصدار 2024 مطلوب؛ ثبّته عبر <https://rustup.rs> |
| Node.js | 20+ | يُنصح بالإصدار LTS |
| pnpm | 9+ | `corepack enable && corepack prepare pnpm@latest --activate` |
| just | الأحدث | مشغّل الأوامر؛ `cargo install just` |
| PostgreSQL | 18+ | shittim_chest_db للمصادقة + بيانات الدردشة |
| entelecheia scepter | اختياري | مطلوب لميزات الوكيل/الأجهزة؛ اختياري للدردشة المستقلة |

تحقق من كل شيء:

```bash
rustc --version    # >= 1.85
node --version     # >= 20
pnpm --version     # >= 9
just --version
psql --version     # >= 18
```

## الاستنساخ والتمهيد

```bash
git clone https://github.com/celestia-island/shittim-chest.git
cd shittim-chest
cp .env.example .env
```

## متغيرات البيئة

حرّر `.env` بعد الاستنساخ. كل متغير موثَّق سطرًا بسطر؛ فيما يلي ملخص.

### الخادم

| المتغير | الافتراضي | الغرض |
| --- | --- | --- |
| `SHITTIM_CHEST_HOST` | `0.0.0.0` | عنوان الاستماع |
| `SHITTIM_CHEST_PORT` | `80` | منفذ الاستماع |

### قاعدة البيانات

| المتغير | الافتراضي | الغرض |
| --- | --- | --- |
| `SHITTIM_CHEST_DATABASE_URL` | `postgresql://sc:pass@localhost:5432/shittim_chest` | نص اتصال PostgreSQL |
| `SHITTIM_CHEST_DATABASE_MAX_CONNECTIONS` | `10` | حجم تجمع اتصالات SeaORM |

أنشئ قاعدة البيانات والمستخدم:

```sql
CREATE USER sc WITH PASSWORD 'pass';
CREATE DATABASE shittim_chest OWNER sc;
```

### JWT والتشفير

| المتغير | الافتراضي | الغرض |
| --- | --- | --- |
| `JWT_SECRET` | `change-me-in-production` | سر مشترك مع scepter؛ **يجب أن يتطابق** |
| `JWT_EXPIRATION_SECONDS` | `3600` | عمر رمز الوصول (ساعة واحدة) |
| `JWT_REFRESH_EXPIRATION_SECONDS` | `604800` | عمر رمز التحديث (7 أيام) |
| `SHITTIM_CHEST_ENCRYPTION_KEY` | `change-me-32-bytes-base64-encoded` | مفتاح AES-256-GCM لمفاتيح API ورموز OAuth |

أنشئ مفتاح إنتاج:

```bash
openssl rand -base64 32
```

### مزودات LLM (للتشغيل المستقل)

اضبط هذه لاستخدام shittim-chest بشكل مستقل بدون entelecheia:

| المتغير | الغرض |
| --- | --- |
| `LLM_DEFAULT_PROVIDER_ENDPOINT` | نقطة نهاية API متوافقة مع OpenAI (مثل `https://api.deepseek.com/v1`) |
| `LLM_DEFAULT_PROVIDER_API_KEY` | مفتاح API للمزود |
| `LLM_DEFAULT_PROVIDER_MODELS` | قائمة نماذج مفصولة بفواصل (مثل `deepseek-chat,deepseek-reasoner`) |
| `LLM_DEFAULT_PROVIDER_CATEGORY` | فئة المزود: `chat` أو `image` |
| `LLM_STREAM_BUFFER_SECONDS` | مهلة تخزين البث المؤقت (الافتراضي: 60) |
| `LLM_MAX_TOKENS_DEFAULT` | الحد الأقصى الافتراضي للرموز (الافتراضي: 4096) |
| `LLM_REQUEST_TIMEOUT_SECONDS` | مهلة طلب HTTP (الافتراضي: 120) |

### الأجهزة البعيدة

| المتغير | الافتراضي | الغرض |
| --- | --- | --- |
| `REMOTE_DEVICES_ENABLED` | `false` | تفعيل ميزات الأجهزة البعيدة |
| `REMOTE_DEVICES_SCEPTER_SOCK` | `/run/entelecheia/device_stream.sock` | مقبس Unix لبيانات الأجهزة |
| `REMOTE_DEVICES_FRAME_BUFFER_SIZE` | `4194304` | حجم تخزين الإطارات بالبايت |
| `REMOTE_DEVICES_MAX_SESSIONS_PER_USER` | `3` | الحد الأقصى لجلسات الأجهزة المتزامنة |
| `WEBRTC_ICE_SERVERS` | `stun:stun.l.google.com:19302` | قائمة خوادم ICE |

### GitHub OAuth

| المتغير | الغرض |
| --- | --- |
| `GITHUB_CLIENT_ID` | معرّف عميل تطبيق GitHub OAuth |
| `GITHUB_CLIENT_SECRET` | سر عميل تطبيق GitHub OAuth |
| `GITHUB_REDIRECT_URI` | عنوان URL لاستدعاء OAuth (مثل `https://your-domain/api/auth/github/callback`) |

### اتصال Scepter (لميزات الوكيل)

| المتغير | الافتراضي | الغرض |
| --- | --- | --- |
| `ENTELECHEIA_SCEPTER_URL` | `http://localhost:8424` | نقطة نهاية HTTP لـ scepter |
| `ENTELECHEIA_SCEPTER_WS_URL` | `ws://localhost:8424` | نقطة نهاية WebSocket لـ scepter |
| `ENTELECHEIA_TUI_SOCK` | `/run/entelecheia/entelecheia.sock` | مقبس Unix لتمرير المُحفِّزات |

### Webhook

| المتغير | الغرض |
| --- | --- |
| `WEBHOOK_GITHUB_SECRET` | سر HMAC للتحقق من webhook الخاص بـ GitHub |
| `WEBHOOK_GITLAB_SECRET` | رمز التحقق من webhook الخاص بـ GitLab |
| `WEBHOOK_PUBLIC_URL` | عنوان URL المواجه للعامة لنقاط نهاية الـ webhook |

## إعداد قاعدة البيانات

```bash
just db-init      # Create schema (runs SeaORM migrations)
just db-migrate   # Apply pending migrations
```

### نظرة عامة على المخطط

يملك `shittim_chest_db` البيانات المواجهة للمستخدم:

| الجدول | الغرض |
| --- | --- |
| `auth_users` | حسابات المستخدمين مع تجزئات كلمات مرور argon2 |
| `sessions` | الجلسات النشطة مع رموز التحديث |
| `api_keys` | سجلات مفاتيح API (مجزّأة) |
| `oauth_connections` | روابط OAuth الطرف الثالث (GitHub) |
| `conversations` | محادثات الدردشة |
| `messages` | رسائل الدردشة مع بيانات نداء الأدوات |
| `llm_providers` | تكوينات مزود LLM (مفاتيح API مشفّرة) |
| `remote_devices` | سجلات الأجهزة البعيدة |
| `device_sessions` | جلسات الأجهزة النشطة |
| `channel_configs` | تكوينات قنوات متعددة المنصات |
| `channel_messages` | سجلات رسائل القنوات |
| `channel_pairings` | اقتران قناة-دردشة |

إعادة تعيين قاعدة البيانات:

```bash
just db-reset
```

## تطوير الواجهة الخلفية

```bash
just dev-backend
```

يشغل هذا `cargo run --package shittim_chest`. يبدأ الخادم على `:80`.

### أوامر CLI

```bash
shittim_chest db-init      # Create database schema
shittim_chest db-migrate   # Apply pending migrations
shittim_chest db-reset     # Drop and recreate schema
shittim_chest server       # Start the web server
```

### إعادة التحميل الساخن

```bash
cargo install cargo-watch
cargo watch -x 'run --package shittim_chest -- server'
```

### نظرة عامة على نقاط نهاية API

| مجموعة المسارات | الغرض |
| --- | --- |
| `/api/auth/*` | تسجيل الدخول، التسجيل، GitHub OAuth، التحديث، تسجيل الخروج |
| `/api/chat/*` | المحادثات، الرسائل، بث SSE/WS، البحث، التصدير |
| `/api/providers/*` | CRUD لمزود LLM، إدارة مفاتيح API، الاختبار |
| `/api/generation/*` | توليد الصور، قائمة النماذج |
| `/api/devices/*` | قائمة الأجهزة البعيدة، الجلسات، إشارات WebRTC |
| `/api/webhook/*` | دخول webhook لـ GitHub/GitLab/Gitee/مخصص |
| `/api/proxy/*` | وكيل عكسي إلى scepter (HTTP + WebSocket) |
| `/static/*` | استضافة ملفات SPA الثابتة |

## تطوير الواجهة الأمامية

### تثبيت التبعيات

```bash
pnpm install
```

### webui

```bash
just dev    # build frontend + start backend on :3000
just watch  # auto-rebuild on file changes
```

تُبنى كلتا الواجهتين الأماميتين بواسطة Vite في `dist/`. تخدم الواجهة الخلفية هذه الملفات الثابتة مباشرةً على `:3000` — لا حاجة إلى خادم Vite تطويري منفصل أو وكيل. في وضع التطوير، تراقب `dev.py` مصادر الواجهة الأمامية وتعيد البناء تلقائيًا.

## إعداد المشاريع المتقاطعة

للتطوير المحلي مع كرة بروتوكول `arona` المشتركة، عالِجها إلى نسختك المحلية المسحوبة. حرّر `~/.cargo/config.toml` (لا تُلتزم أبدًا بالمستودع):

```toml
[patch.'https://github.com/celestia-island/arona']
arona = { path = "/path/to/arona" }
```

بالنسبة لـ npm، تستهلك واجهة الويب روابط TS الخاصة بكرة `arona` عبر الاسم المستعار للمسار `@celestia-island/arona`، مشيرةً إلى `packages/webui/src/types/arona/`.

## البناء للإنتاج

```bash
just build
```

يشغل هذا `cargo build --release` و`pnpm run build:all`. مواقع المخرجات:

- الملف التنفيذي للواجهة الخلفية: `target/release/shittim_chest`
- أصول الواجهة الأمامية: `packages/webui/dist/`

### Docker

ابنِ وشغّل عبر غلاف الـ CLI (يستخدم Docker API مباشرةً):

```bash
just dev
```

أو يدويًا:

```bash
just build        # build Docker image
just up           # start all services
just migrate      # run database migrations
```

يقدم الملف التنفيذي للإنتاج أصول الواجهة الأمامية عبر وسيط الملفات الثابتة في Axum على `/`. لا حاجة لخادم واجهة أمامية منفصل.

## مشكلات شائعة

### رفض اتصال قاعدة البيانات

```text
error: connection to server at "localhost", port 5432 failed
```

**الإصلاح**: تأكد من أن PostgreSQL يعمل وأن `SHITTIM_CHEST_DATABASE_URL` في `.env` يطابق إعدادك. تحقق عبر `psql "$SHITTIM_CHEST_DATABASE_URL" -c 'SELECT 1'`.

### تعذّر الوصول إلى Scepter

```text
error: error sending request for url (http://localhost:8424/...)
```

**الإصلاح**: ابدأ نسخة entelecheia scepter، أو استخدم الوضع المستقل مع تكوين مزودات LLM. تعمل الواجهة الخلفية بدون scepter للدردشة/توليد الصور.

### أخطاء CORS في المتصفح

```text
Access-Control-Allow-Origin header is present on the requested resource
```

**الإصلاح**: تُفعّل الواجهة الخلفية للتطوير CORS لنطاقات `localhost`. إذا غيّرت المنافذ، حدّث تكوين CORS. على النشرات الإنتاجية تكوين وكيل عكسي (nginx/caddy) للتعامل مع CORS.

### فشل pnpm install

**الإصلاح**: تأكد من أنك تستخدم pnpm 9+. شغّل `corepack enable && corepack prepare pnpm@latest --activate` لإعداد النسخة الصحيحة.

### فشل cargo build مع الكرات المشتركة

**الإصلاح**: إذا كانت لديك تعديلات محلية في `~/.cargo/config.toml`، تأكد من أن المسارات موجودة وأن أسماء الكرات تتطابق. أزِل قسم التعديل لاستخدام تبعيات git بدلًا من ذلك.
