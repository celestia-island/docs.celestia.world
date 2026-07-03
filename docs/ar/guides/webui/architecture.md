# تعمّق في البنية

> **الجمهور**: المطوّرون الذين يحتاجون إلى فهم كيفية عمل shittim-chest داخليًا.
> **آخر تحديث**: 2026-05-25

## نظرة عامة على المشروع

shittim-chest هو **الصدفة المواجهة للمستخدم** لـ [entelecheia](https://github.com/celestia-island/entelecheia)، وهي منصة تعاون متعددة الوكلاء مبنية بلغة Rust. هذا الحد متعمَّد:

- **entelecheia** يملك تنسيق الوكلاء (scepter، 13 وكيلًا، وقت تشغيل Cosmos/IEPL)، والهوية، والصلاحيات.
- **shittim-chest** يملك مصادقة المستخدم، وإدارة الجلسات، وبيانات الدردشة، وتكوين مزود LLM، وعرض الواجهة الأمامية، والجسر الوكيل إلى scepter.

يتواصلان عبر HTTP وWebSocket موثَّقَين بـ JWT. لا يصل shittim-chest أبدًا مباشرةً إلى قاعدة بيانات entelecheia لعمليات الوكلاء.

## حزمة الواجهة الخلفية

### موجّه Axum

الواجهة الخلفية الأساسية (`packages/core`) هي تطبيق Axum 0.8. يركّب الموجّه مجموعات الوحدات هذه:

```text
/                   → health check
/api/auth/*         → AuthService (login, register, GitHub OAuth, refresh, logout)
/api/chat/*         → ChatService (conversations, messages, SSE/WS streaming, search, export)
/api/providers/*    → ProviderService (LLM provider CRUD, API key encryption, testing)
/api/generation/*   → GenerationService (image generation)
/api/devices/*      → DeviceService (remote device listing, sessions, signaling)
/api/webhook/*      → WebhookService (GitHub, GitLab, Gitee, custom; HMAC validation)
/api/proxy/*        → ProxyService (HTTP reverse proxy + WebSocket bridge to scepter)
/static/*           → SPA static hosting (production only)
```

### SeaORM + PostgreSQL

يستخدم الوصول إلى قاعدة البيانات SeaORM 1.x مع PostgreSQL. يخزّن `shittim_chest_db`:

- مصادقة المستخدم: تجزئات كلمات المرور (argon2)، الجلسات، رموز التحديث، مفاتيح API، اتصالات OAuth
- بيانات الدردشة: المحادثات، الرسائل
- تكوينات مزود LLM (مفاتيح API مشفّرة عند السكون بـ AES-256-GCM)
- سجلات الأجهزة البعيدة وجلسات الأجهزة
- تكوينات القنوات للرسائل متعددة المنصات
- سجلات تسليم الـ webhook

تقع 5 هجرات و25 نموذج كيان في `packages/core/src/{migration,entity}/`.

### مصادقة JWT

يُصدِر `shittim_chest` رموز JWT تحتوي على `{ sub: user_id, groups: [...] }`. السر JWT مشترك مع scepter بحيث يمكن لكلتا الخدمتين التحقق من الرموز بشكل مستقل. تنتهي رموز الوصول خلال ساعة واحدة؛ ترميزات التحديث خلال 7 أيام مع تدوير عند كل استخدام.

## قدرة LLM المستقلة

يملك shittim-chest طبقة توجيه LLM خاصة به تعمل بشكل مستقل عن entelecheia:

- **LlmRouter**: موجّه متعدد المزودين مع اختيار قائم على الأولوية وتجاوز عند الفشل
- **إدارة المزود**: نقاط نهاية CRUD لإضافة/تحرير/إزالة مزودي LLM
- **تشفير مفتاح API**: مفاتيح API للمزودين مشفّرة عند السكون بـ AES-256-GCM
- **متوافق مع OpenAI**: يعمل مع أي API متوافق مع OpenAI (DeepSeek، OpenAI، النماذج المحلية، إلخ)
- **بث مزدوج**: SSE (Server-Sent Events) وبث WebSocket لاستجابات الدردشة

هذا يعني أن shittim-chest يمكنه العمل كتطبيق دردشة مستقل بدون entelecheia، أو استخدام وكلاء entelecheia عبر طبقة الوكيل.

## سير المصادقة

### تسلسل تسجيل الدخول

```text
User → shittim_chest: POST /api/auth/login { username, password }
shittim_chest → shittim_chest_db: SELECT user WHERE username = ? (verify argon2 hash)
shittim_chest → scepter: GET /api/user/{id}/permissions
scepter → entelecheia_db: query groups + permissions
scepter → shittim_chest: { groups: [...], permissions: {...} }
shittim_chest → User: { access_token, refresh_token }
shittim_chest: Store session + cache RBAC
```

### GitHub OAuth

```text
User → shittim_chest: GET /api/auth/github
shittim_chest → User: 302 redirect to GitHub OAuth
User → GitHub: authorize
GitHub → shittim_chest: GET /api/auth/github/callback?code=...
shittim_chest → GitHub: exchange code for access token
shittim_chest → GitHub: GET /user (fetch user info)
shittim_chest → shittim_chest_db: INSERT/UPDATE oauth_connections
shittim_chest → User: { access_token, refresh_token } (auto-creates user if new)
```

## بنية الدردشة

### سير الرسائل (LLM مستقل)

```text
User → POST /api/chat/conversations/:id/messages
shittim_chest: validate JWT, load conversation
shittim_chest → LlmRouter: route request to best provider
LlmRouter → LLM Provider: POST chat/completions (streaming)
LLM Provider → LlmRouter: SSE stream
LlmRouter → User: SSE/WS stream (tokens as they arrive)
shittim_chest: persist message to shittim_chest_db
```

### SSE مقابل بث WebSocket

- **SSE** (`/api/chat/stream`): بث HTTP بسيط، يعمل عبر الوكلاء، إعادة اتصال تلقائي
- **WebSocket** (`/ws/chat/stream`): ثنائي الاتجاه، يدعم الإلغاء والتفاعل الفوري

## بنية الوكيل

تُمرِّر نقطة النهاية `/api/proxy/*` الطلبات الموثَّقة إلى scepter:

1. يفتح المتصفح `ws://shittim-chest:80/api/proxy/chat` مع JWT
1. يتحقق `shittim_chest` من JWT، ويفتح اتصالًا بـ scepter مرمِّزًا إليه JWT
1. تمرير رسائل ثنائي الاتجاه بين المتصفح وscepter
1. يطبّق `shittim_chest` حدود المعدل، ويسجّل الاستخدام، ويدير دورة حياة الاتصال

## خط أنابيب الـ Webhook

تدخل الـ webhooks من الخدمات الخارجية عبر `/api/webhook/*`:

```text
GitHub/GitLab/Gitee → POST /api/webhook/{source} → HMAC validation → Parse event → Forward to scepter via Unix socket
```

المصادر المدعومة: GitHub (HMAC-SHA256)، GitLab (token)، Gitee (HMAC + تراجع إلى token)، بالإضافة إلى نقطة نهاية عامة `/api/webhook/custom/{name}`. الميزات:

- كشف التسليم المكرر (ذاكرة تخزين مؤقت LRU، 10000 معرّف)
- سجل تسليم مع API للقائمة
- قائمة IP بيضاء لمصادر الـ webhook

## إدارة الأجهزة البعيدة

تُدار الأجهزة البعيدة عبر مرحّل إشارات:

```text
Browser (webui) → WS /api/devices/stream → shittim_chest (signal relay) → Unix socket → entelecheia/polemos
```

الميزات:

- قائمة الأجهزة وCRUD للجلسات عبر REST
- إشارات WebRTC (عرض/قبول SDP، مرشحو ICE)
- مرحّل الطرفية (WebSocket إلى xterm.js)
- مرحّل إطارات سطح المكتب
- الواجهة الخلفية لمتصفح ملفات SFTP

لا يتصل shittim-chest بالأجهزة البعيدة مباشرةً أبدًا — كل البيانات تتدفق عبر وكيل polemos الخاص بـ entelecheia.

## ملكية البيانات

### shittim_chest_db

| البيانات | الجدول | المنطق |
| --- | --- | --- |
| تجزئات كلمات المرور (argon2) | `auth_users` | طبقة العرض تملك سير تسجيل الدخول |
| الجلسات النشطة، رموز التحديث | `sessions` | إدارة الجلسات شأن متعلق بالواجهة الأمامية |
| مفاتيح API المشفّرة | `api_keys` | إصدار مفتاح API مواجه للمستخدم |
| اتصالات OAuth | `oauth_connections` | ربط المصادقة بطرف ثالث مواجه للمستخدم |
| المحادثات، الرسائل | `conversations`، `messages` | بيانات الدردشة مواجهة للمستخدم |
| تكوينات مزود LLM | `llm_providers` | إدارة المزود مواجهة للمستخدم (المفاتيح مشفّرة) |
| سجلات الأجهزة البعيدة | `remote_devices`، `device_sessions` | تتبع الأجهزة مواجه للمستخدم |
| تكوينات القنوات | `channel_configs`، إلخ. | تكوين متعدد المنصات مواجه للمستخدم |

### entelecheia_db

| البيانات | المنطق |
| --- | --- |
| هوية المستخدم، المجموعات، تعيينات الأدوار | النواة تطبّق الصلاحيات |
| GroupPermissions (حصص المزود، قوائم الوكلاء البيضاء) | سياسة مستوى الوكيل تعيش مع الوكلاء |
| تكوينات الوكلاء، حالة Cosmos/IEPL | بيانات التنسيق تخص النواة |

## استراتيجية الواجهة الأمامية المزدوجة

### المرحلة 1: Vue 3 (الحالية)

| الحزمة | التقنية | المنفذ | الغرض |
| --- | --- | --- | --- |
| `webui` | Vue 3 + Vite + Pinia (TSX) | `:3000 (shared)` | واجهة ويب موحدة: دردشة، توليد الصور، أجهزة، إدارة (مزودون، وكلاء، RBAC، webhooks) |

### المرحلة 2: Rust WASM (المستقبل)

| الحزمة | التقنية | الغرض |
| --- | --- | --- |
| `webui` | Rust ← WASM (Tairitsu) | واجهة ويب موحدة طويلة الأمد (دردشة + إدارة) |

تعمل الواجهات الأمامية القديمة كمواصفات حية. أثناء الانتقال، تعمل كلتا النسختين بالتوازي، ويجب أن تنتج التفاعلات المتطابقة من المستخدم نتائج متطابقة.

## أوضاع نشر الوكيل العكسي

يدعم shittim-chest ثلاثة أوضاع للوكيل العكسي، يتحكم بها `SHITTIM_CHEST_PROXY_MODE` في `.env`.

### الوضع 1: لا شيء (مباشر)

```bash
# .env
SHITTIM_CHEST_PROXY_MODE=none   # or unset
```

يرتبط الخادم الأساسي مباشرةً بـ `SHITTIM_CHEST_HOST:SHITTIM_CHEST_PORT` (الافتراضي `0.0.0.0:80`). لا TLS، لا حاوية وكيل عكسي. مناسب لـ:

- التطوير المحلي
- خلف وكيل عكسي موجود (Cloudflare Tunnel، AWS ALB، تصنيفات Traefik)
- شبكات Docker حيث تتعامل خدمة أخرى مع إنهاء TLS

### الوضع 2: Caddy تلقائي

```bash
# .env
SHITTIM_CHEST_PROXY_MODE=caddy
SHITTIM_CHEST_PROXY_DOMAIN=app.example.com
```

يُنشئ الـ CLI حاوية `shittim-chest-caddy` (الصورة `caddy:2`) تقوم بـ:

1. الاستماع على المنفذين 80/443 (قابلة للتكوين عبر `SHITTIM_CHEST_PROXY_HTTP_PORT` / `SHITTIM_CHEST_PROXY_HTTPS_PORT`)
1. توفير شهادات TLS تلقائيًا عبر Let's Encrypt (ACME المدمج في Caddy)
1. تمثيل جميع الطلبات إلى الواجهة الخلفية الأساسية على شبكة Docker

لا حاجة لملف Caddyfile — يُنشئ الـ CLI واحدًا تلقائيًا. يجب أن يملك النطاق DNS عامًا يشير إلى المضيف.

### الوضع 3: Caddy مخصص

```bash
# .env
SHITTIM_CHEST_PROXY_MODE=caddy
SHITTIM_CHEST_PROXY_CONFIG_PATH=/etc/caddy/Caddyfile
SHITTIM_CHEST_PROXY_EXTRA_VOLUMES=/etc/letsencrypt:/etc/letsencrypt
```

نفس حاوية Caddy، لكنك توفّر ملف Caddyfile خاصًا بك (محمَّل من المضيف). استخدم هذا عندما تحتاج إلى:

- مضيفين افتراضيين متعددين
- مسارات شهادات TLS مخصصة
- وسيط إضافي (مصادقة أساسية، تحديد المعدل، إلخ)
- تقديم ملفات ثابتة إلى جانب الـ API

### الوضع 4: Nginx مخصص

```bash
# .env
SHITTIM_CHEST_PROXY_MODE=nginx
SHITTIM_CHEST_PROXY_CONFIG_PATH=/etc/nginx/conf.d/default.conf
```

يُنشئ حاوية `nginx:bookworm` بملف التكوين الخاص بك. أنت تدير شهادات TLS بنفسك. مناسب للبيئات التي يكون فيها Nginx هو المعيار.

### دورة حياة الحاوية

تُدار جميع حاويات الوكيل بواسطة الـ CLI عبر Docker API (`bollard`):

| الأمر | السلوك |
| --- | --- |
| `just dev` / `chest up` | ينشئ/يبدأ حاوية الوكيل إذا كان `PROXY_MODE` مُعيَّنًا |
| `just dev-stop` / `chest down` | يوقف ويزيل حاوية الوكيل |
| الحاوية قيد التشغيل بالفعل | يعيد استخدام الحاوية الموجودة (متساوي القوة) |

تنضم حاوية الوكيل إلى نفس شبكة Docker كالواجهة الخلفية الأساسية، بحيث تصل إلى الواجهة الخلفية عبر اسم المضيف الداخلي (`core` أو `shittim-chest`).
