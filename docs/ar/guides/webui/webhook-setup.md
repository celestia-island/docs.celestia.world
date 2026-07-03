# دليل إعداد Webhook

> **الجمهور**: المسؤولون الذين يدمجون الخدمات الخارجية مع shittim-chest.
> **آخر تحديث**: 2026-05-25

## نظرة عامة

تتيح الـ webhooks للخدمات الخارجية (GitHub، GitLab، Gitee) إرسال أحداث لحظية إلى shittim-chest. تُتحقَّق الأحداث وتُحلَّل وتُعاد توجيهها إلى scepter الذي يرسلها إلى الوكيل المناسب.

```text
External Service → shittim_chest → scepter → Agent
```

يدعم `shittim_chest` أيضًا نقاط نهاائية webhook مخصصة للخدمات غير المدعومة أصليًا.

## إعداد GitHub Webhook

### الخطوة 1: إعداد البيئة

اضبط سر webhook في ملف `.env` الخاص بك:

```bash
WEBHOOK_GITHUB_SECRET=your-hmac-secret-here
WEBHOOK_PUBLIC_URL=https://your-domain.com
```

ولِّد سرًا قويًا:

```bash
openssl rand -hex 32
```

### الخطوة 2: إنشاء الـ webhook في GitHub

1. انتقل إلى مستودعك ← **Settings** ← **Webhooks** ← **Add webhook**
1. اضبط **Payload URL** على `https://your-domain.com/api/webhook/github`
1. اضبط **Content type** على `application/json`
1. اضبط **Secret** على نفس قيمة `WEBHOOK_GITHUB_SECRET`
1. اختر الأحداث: `push`، `pull_request`، `issues`، `issue_comment`
1. تأكد من تحديد **Active**
1. انقر **Add webhook**

### الخطوة 3: التحقق

سيرسل GitHub حدث `ping` فورًا. تحقق من تبويب **Recent Deliveries** للتأكد من استجابة `200`.

## إعداد GitLab Webhook

### الخطوة 1: إعداد البيئة

```bash
WEBHOOK_GITLAB_SECRET=your-gitlab-secret-token
```

### الخطوة 2: إنشاء الـ webhook في GitLab

1. انتقل إلى مشروعك ← **Settings** ← **Webhooks**
1. اضبط **URL** على `https://your-domain.com/api/webhook/gitlab`
1. اضبط **Secret token** على نفس قيمة `WEBHOOK_GITLAB_SECRET`
1. اختر المشغلات: `Push events`، `Merge request events`، `Issue events`
1. تأكد من تحديد **Enable SSL verification** (لـ HTTPS)
1. انقر **Add webhook**

### الخطوة 3: التحقق

استخدم زر **Test** في GitLab لإرسال حدث اختباري. تأكد من نجاح التسليم.

## إعداد Gitee Webhook

تُدعم webhooks لـ Gitee (码云) أيضًا.

### الخطوة 1: إعداد البيئة

يستخدم Gitee نفس `WEBHOOK_GITLAB_SECRET` للتحقق HMAC (مع الرمز كبديل). بدلًا من ذلك، اضبط `WEBHOOK_GITEE_PASSWORD` إذا كنت تستخدم مصادقة قائمة على كلمة المرور.

### الخطوة 2: إنشاء الـ webhook في Gitee

1. انتقل إلى مستودعك ← **Management** ← **Webhooks**
1. اضبط **URL** على `https://your-domain.com/api/webhook/gitee`
1. اضبط **Password/Signing Key** على نفس السر
1. اختر الأحداث: `Push`، `Pull Request`، `Issues`
1. انقر **Add**

## الـ webhooks المخصصة

يدعم `shittim_chest` نقطة نهاائية webhook مخصصة عامة على `/api/webhook/custom/{name}`. لإضافة مصدر webhook مخصص:

1. اضبط `WEBHOOK_PUBLIC_URL` في `.env`
1. أعد إعداد خدمتك الخارجية لإرسال POST إلى `https://your-domain.com/api/webhook/custom/{name}`
1. تُعاد توجيه الأحداث إلى scepter مع اسم الـ webhook كمصدر للحدث

لدمج مزودي webhook جدد على مستوى الكود:

1. أضف معالجًا في `packages/core/src/webhook.rs`
1. نفذ تحقق HMAC أو الرمز للمزود الجديد
1. حلل صيغة الحدث المخصصة وأعد التوجيه إلى scepter عبر مقبس Unix

## قائمة IP البيضاء

يدعم `shittim_chest` قائمة IP البيضاء لمصادر webhook لرفض الطلبات من المصادر غير المعروفة:

```bash
# .env
WEBHOOK_IP_WHITELIST=140.82.112.0/20,192.30.252.0/22  # عناوين GitHub IP
```

أعد إعداد نطاقات CIDR لكل مزود webhook. تُرفض الطلبات من عناوين IP خارج القائمة البيضاء.

## أنواع الأحداث

الأحداث المدعومة وتعيينها إلى مشغلات scepter:

| المصدر | الحدث | `event_type` في scepter |
| --- | --- | --- |
| GitHub | `push` | `github.push` |
| GitHub | `pull_request` | `github.pull_request` |
| GitHub | `issues` | `github.issues` |
| GitHub | `issue_comment` | `github.issue_comment` |
| GitLab | `push` | `gitlab.push` |
| GitLab | `merge_request` | `gitlab.merge_request` |
| GitLab | `issues` | `gitlab.issues` |
| Gitee | `push` | `gitee.push` |
| Gitee | `pull_request` | `gitee.pull_request` |
| Gitee | `issues` | `gitee.issues` |

## سجل التسليم

يحتفظ `shittim_chest` بسجل تسليم لأحداث webhook. تُكشَف عمليات التسليم المكررة باستخدام ذاكرة LRU مؤقتة (حتى 10000 معرف تسليم). الوصول إلى سجلات التسليم عبر:

- **REST API**: `GET /api/webhook/deliveries`
- لوحة الإدارة: **Webhooks** ← **Delivery Log**

## الأمان

يجب أن تجتاز جميع الـ webhooks التحقق من التوقيع:

- **GitHub**: يستخدم ترويسة `X-Hub-Signature-256`. تُتحقَّق مقابل `WEBHOOK_GITHUB_SECRET`.
- **GitLab**: يستخدم ترويسة `X-Gitlab-Token`. تُتحقَّق مقابل `WEBHOOK_GITLAB_SECRET`.
- **Gitee**: يستخدم توقيع HMAC-SHA256 مع تراجع إلى الرمز.

تُرفض الطلبات بدون توقيعات صالحة بـ `401 Unauthorized`. لا تكشف أسرار الـ webhook أبدًا في كود جانب العميل أو السجلات.

## الاختبار

استخدم لوحة الإدارة لاختبار تكامل webhook:

1. سجل الدخول إلى لوحة الإدارة (افتراضي `:3000`)
1. انتقل إلى **Webhooks** في الشريط الجانبي
1. اعرض سجلات التسليم والإعداد
1. اختبر نقاط النهاية عبر وظيفة الاختبار للخدمة الخارجية

يمكنك أيضًا الاختبار يدويًا باستخدام curl:

```bash
curl -X POST https://your-domain.com/api/webhook/github \
  -H "Content-Type: application/json" \
  -H "X-Hub-Signature-256: sha256=<computed-hmac>" \
  -d '{"action":"push","ref":"refs/heads/main"}'
```

## استكشاف الأخطاء وإصلاحها

### 401 Unauthorized

**السبب**: عدم تطابق توقيع HMAC أو أن IP ليس في القائمة البيضاء.
**الإصلاح**: تأكد من أن السر في `.env` يطابق السر المُعد في المنصة المصدر. تحقق من المسافات الزائدة أو مشاكل الترميز. تحقق من إعداد قائمة IP البيضاء.

### 502 Bad Gateway

**السبب**: scepter غير قابل للوصول.
**الإصلاح**: تحقق من `ENTELECHEIA_SCEPTER_URL` و `ENTELECHEIA_TUI_SOCK` في `.env`. تأكد من أن مثيل scepter قيد التشغيل وأن مسار مقبس Unix قابل للوصول.

### الأحداث لا تصل إلى الوكلاء

**السبب**: نوع الحدث غير معين أو الوكيل غير مُعد للتعامل معه.
**الإصلاح**: تحقق من سجلات الخلفية لـ `event_type` المحلل. تأكد من أن الوكيل المستهدف لديه معالج مسجل لهذا الحدث. تحقق من سجل التسليم عبر API أو لوحة الإدارة.

### عمليات التسليم المكررة

**السبب**: تعيد الخدمة الخارجية المحاولة بسبب المهلة. يكشف `shittim_chest` المكررات تلقائيًا عبر ذاكرة LRU المؤقتة.
**الإصلاح**: إذا كانت إعادة المحاولات الصحيحة تُحجب، زِد حجم ذاكرة معرف التسليم المؤقتة. تأكد من استجابة `shittim_chest` ضمن نافذة مهلة الخدمة (GitHub: 10 ثوانٍ).
