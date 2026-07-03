# تصميم نظام RBAC

## 1. الأهداف

تنفيذ نظام تحكم شامل في الوصول القائم على الأدوار لـ Shittim Chest، يدعم:

- **إدارة المستخدمين**: يمكن للمدراء دعوة/إنشاء/تعطيل/حذف المستخدمين
- **إدارة المجموعات**: دعم لمجموعات الحسابات؛ قد ينتمي المستخدمون إلى عدة مجموعات
- **صلاحيات دقيقة**: التحكم فيما إذا كان يمكن للمستخدمين إضافة/تعديل/استخدام مزودي نماذج محددين، أدوات MCP، وكلاء Layer3، قنوات IM، إلخ.
- **مفاتيح تبديل الميزات**: التحكم فيما إذا كان يمكن للمستخدمين استخدام ميزات متقدمة مثل وضع التحكم الآلي
- **أوضاع تفويض مرنة**: يمكن للمدراء اختيار تكوين موحد شامل، أو تكوين لكل مستخدم، أو تكوين مشترك للمجموعة

## 2. المفاهيم الأساسية

### 2.1 الأدوار

| الدور | الوصف |
| --- | --- |
| `admin` | مدير خارق بكل الصلاحيات؛ يمكنه إدارة RBAC نفسه |
| `operator` | موظفو العمليات؛ يمكنهم إدارة معظم الموارد (المزودين، القنوات، الوكلاء، إلخ.) |
| `member` | عضو عادي؛ يمكنه استخدام الموارد المصرّح بها |
| `viewer` | مستخدم للقراءة فقط؛ يمكنه المشاهدة لكن ليس التعديل |

الأدوار **مُعدَّة مسبقًا** — الأدوار المخصصة غير مدعومة (لتبسيط التنفيذ). لكل مستخدم دور أساسي واحد.

### 2.2 الصلاحيات

صيغة الصلاحية: `<resource>.<action>`

| الفئة | الصلاحية | الوصف |
| --- | --- | --- |
| **المزودون** | `provider.list` | عرض قائمة المزودين |
| | `provider.create` | إضافة مزود |
| | `provider.update` | تعديل تكوين المزود |
| | `provider.delete` | حذف مزود |
| | `provider.use` | استخدام نماذج المزود للدردشة |
| **أدوات MCP** | `mcp.list` | عرض قائمة أدوات MCP |
| | `mcp.create` | تسجيل أداة MCP |
| | `mcp.update` | تعديل تكوين أداة MCP |
| | `mcp.delete` | حذف أداة MCP |
| | `mcp.use` | استخدام أدوات MCP في المحادثات |
| **الوكلاء** | `agent.list` | عرض قائمة الوكلاء |
| | `agent.create` | إنشاء وكيل |
| | `agent.update` | تعديل تكوين الوكيل |
| | `agent.delete` | حذف وكيل |
| | `agent.use` | استخدام الوكلاء في وضع التحليل |
| **قنوات IM** | `channel.list` | عرض قائمة قنوات IM |
| | `channel.create` | إنشاء قناة IM |
| | `channel.update` | تعديل تكوين القناة |
| | `channel.delete` | حذف قناة |
| | `channel.use` | إرسال/استقبال الرسائل عبر قناة |
| **وضع التحكم الآلي** | `yolo.use` | استخدام وضع التحكم الآلي المستقل |
| **مساحات العمل** | `workspace.list` | عرض مساحات العمل |
| | `workspace.create` | إنشاء مساحة عمل |
| | `workspace.manage` | إدارة مساحات العمل (حذف، تصدير) |
| **الأجهزة** | `device.list` | عرض الأجهزة البعيدة |
| | `device.connect` | الاتصال بجهاز بعيد |
| **النظام** | `system.read` | عرض إعدادات النظام |
| | `system.write` | تعديل إعدادات النظام |
| | `rbac.manage` | إدارة RBAC (المستخدمين/المجموعات/الصلاحيات) |
| **OAuth** | `oauth.read` | عرض تكوين OAuth |
| | `oauth.write` | تعديل تكوين OAuth |

### 2.3 صلاحيات الدور الافتراضية

| الصلاحية | admin | operator | member | viewer |
| --- | --- | --- | --- | --- |
| `provider.*` | ✅ | ✅ | `list` + `use` | `list` |
| `mcp.*` | ✅ | ✅ | `list` + `use` | `list` |
| `agent.*` | ✅ | ✅ | `list` + `use` | `list` |
| `channel.*` | ✅ | ✅ | `list` + `use` | `list` |
| `yolo.use` | ✅ | ✅ | ❌ (مغلق افتراضيًا) | ❌ |
| `workspace.*` | ✅ | ✅ | `list` + `create` | `list` |
| `device.*` | ✅ | ✅ | `list` + `connect` | `list` |
| `system.*` | ✅ | ❌ | ❌ | ❌ |
| `rbac.manage` | ✅ | ❌ | ❌ | ❌ |
| `oauth.*` | ✅ | ✅ | ❌ | ❌ |

### 2.4 أوضاع التفويض

للموارد مثل المزودين، MCP، الوكلاء، القنوات، إلخ.، تُدعم ثلاثة أوضاع تفويض:

| الوضع | الوصف | حالة الاستخدام |
| --- | --- | --- |
| **تكوين شامل** | جميع المستخدمين يتشاركون نفس الصلاحيات | الفرق الصغيرة، الاستخدام الشخصي |
| **تكوين لكل مستخدم** | لكل مستخدم صلاحيات موارد مستقلة | السيناريوهات التي تتطلب تحكمًا دقيقًا |
| **تكوين لكل مجموعة** | المستخدمون في نفس المجموعة يتشاركون الصلاحيات | التقسيم القائم على القسم/الفريق |

يختار المدير وضع تفويض على صفحة "مصفوفة الصلاحيات"، ثم يكوّن قواعد السماح/المنع المحددة.

**الأولوية**: لكل مستخدم > لكل مجموعة > شامل > افتراضيات الدور

## 3. مخطط قاعدة البيانات

### 3.1 الجداول الجديدة

#### `rbac_groups` — مجموعات المستخدمين

```sql
CREATE TABLE rbac_groups (
    id          UUID PRIMARY KEY,
    name        VARCHAR(64) NOT NULL UNIQUE,
    description TEXT,
    created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
```

#### `rbac_user_groups` — ربط المستخدم-المجموعة

```sql
CREATE TABLE rbac_user_groups (
    id         UUID PRIMARY KEY,
    user_id    UUID NOT NULL REFERENCES auth_users(id) ON DELETE CASCADE,
    group_id   UUID NOT NULL REFERENCES rbac_groups(id) ON DELETE CASCADE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE(user_id, group_id)
);
```

#### `rbac_grants` — منح الصلاحيات (جدول موحد)

```sql
CREATE TABLE rbac_grants (
    id           UUID PRIMARY KEY,
    -- Grant target (exactly one)
    scope        VARCHAR(16) NOT NULL, -- 'global' | 'group' | 'user'
    user_id      UUID REFERENCES auth_users(id) ON DELETE CASCADE,
    group_id     UUID REFERENCES rbac_groups(id) ON DELETE CASCADE,
    -- Permission
    permission   VARCHAR(64) NOT NULL, -- e.g. 'provider.use', 'yolo.use'
    resource_id  VARCHAR(128),         -- Optional: restrict to a specific resource (provider name, channel id, etc.); NULL means all resources in the category
    -- Grant type
    granted      BOOLEAN NOT NULL DEFAULT TRUE, -- TRUE=allow, FALSE=deny
    created_at   TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    -- Constraint: scope and corresponding FK must be consistent
    CONSTRAINT rbac_grants_scope_check CHECK (
        (scope = 'global' AND user_id IS NULL AND group_id IS NULL) OR
        (scope = 'user'   AND user_id IS NOT NULL AND group_id IS NULL) OR
        (scope = 'group'  AND user_id IS NULL AND group_id IS NOT NULL)
    )
);
CREATE INDEX idx_rbac_grants_user ON rbac_grants(user_id);
CREATE INDEX idx_rbac_grants_group ON rbac_grants(group_id);
CREATE INDEX idx_rbac_grants_permission ON rbac_grants(permission);
```

### 3.2 تعديل الجداول الموجودة

#### إضافة حقل الدور إلى `auth_users`

```sql
ALTER TABLE auth_users ADD COLUMN role VARCHAR(16) NOT NULL DEFAULT 'member';
-- Migration: set users with is_admin=true to 'admin'
UPDATE auth_users SET role = 'admin' WHERE is_admin = TRUE;
```

يُحتفظ بحقل `is_admin` للتوافق مع الإصدارات السابقة، لكن الكود الجديد يستخدم `role` أولًا.

### 3.3 منطق فحص الصلاحية (شفرة زائفة)

```rust
fn has_permission(user, permission, resource_id=None) -> bool {
    // 1. admin role always passes
    if user.role == "admin" { return true; }

    // 2. Collect all matching grants, sorted by priority
    let grants = [];

    // 2a. Role defaults (lowest priority)
    grants.push(role_defaults(user.role, permission));

    // 2b. Global config
    grants.extend(query_grants(scope="global", permission, resource_id));

    // 2c. Group config (all groups the user belongs to)
    for group in user.groups:
        grants.extend(query_grants(scope="group", group_id=group.id, permission, resource_id));

    // 2d. User-level config (highest priority)
    grants.extend(query_grants(scope="user", user_id=user.id, permission, resource_id));

    // 3. Priority: user > group > global > role_default
    // Within the same scope, denied takes precedence over granted
    // Any user-scope denied → deny
    // Any group-scope denied → deny (unless user-scope granted)
    // Final result
    resolve_grants(grants)
}
```

## 4. تصميم API

### 4.1 إدارة المستخدمين (`/api/rbac/users`)

| الطريقة | المسار | الصلاحية | الوصف |
| --- | --- | --- | --- |
| GET | `/api/rbac/users` | `rbac.manage` | قائمة بكل المستخدمين (مع الدور، المجموعات) |
| POST | `/api/rbac/users` | `rbac.manage` | دعوة مستخدم (إرسال بريد إلكتروني أو إنشاء حساب) |
| PUT | `/api/rbac/users/:id` | `rbac.manage` | تحديث دور المستخدم، تفعيل/تعطيل |
| DELETE | `/api/rbac/users/:id` | `rbac.manage` | حذف مستخدم |

### 4.2 إدارة المجموعات (`/api/rbac/groups`)

| الطريقة | المسار | الصلاحية | الوصف |
| --- | --- | --- | --- |
| GET | `/api/rbac/groups` | `rbac.manage` | قائمة بكل المجموعات |
| POST | `/api/rbac/groups` | `rbac.manage` | إنشاء مجموعة |
| PUT | `/api/rbac/groups/:id` | `rbac.manage` | تحديث المجموعة (الاسم، الوصف) |
| DELETE | `/api/rbac/groups/:id` | `rbac.manage` | حذف مجموعة |
| POST | `/api/rbac/groups/:id/members` | `rbac.manage` | إضافة عضو |
| DELETE | `/api/rbac/groups/:id/members/:userId` | `rbac.manage` | إزالة عضو |

### 4.3 إدارة الصلاحيات (`/api/rbac/grants`)

| الطريقة | المسار | الصلاحية | الوصف |
| --- | --- | --- | --- |
| GET | `/api/rbac/grants` | `rbac.manage` | قائمة بكل قواعد الصلاحيات (تدعم تصفية ?scope=&permission=) |
| PUT | `/api/rbac/grants` | `rbac.manage` | تعيين دفعي للصلاحيات (تقديم قائمة قواعد كاملة، يكتب فوق قواعد النطاق المقابل) |
| DELETE | `/api/rbac/grants/:id` | `rbac.manage` | حذف قاعدة واحدة |

### 4.4 فحص الصلاحيات (`/api/rbac/check`)

| الطريقة | المسار | الصلاحية | الوصف |
| --- | --- | --- | --- |
| GET | `/api/rbac/check?permission=xxx&resource_id=yyy` | (أي مستخدم مصادق عليه) | التحقق مما إذا كان المستخدم الحالي يملك الصلاحية المحددة |
| GET | `/api/rbac/my-permissions` | (أي مستخدم مصادق عليه) | إعادة القائمة الكاملة للصلاحيات الفعّالة للمستخدم الحالي |

### 4.5 إعادة هيكلة ظهور الموارد

واجهات برمجة تطبيقات الموارد الموجودة تحتاج تصفية الصلاحيات:

- `GET /api/chat/providers` ← يعيد فقط المزودين الذين يملك المستخدم الحالي صلاحية `provider.list` لهم، ويعرض فقط النماذج بصلاحية `provider.use`
- `GET /api/channel` ← يعيد فقط القنوات بصلاحية `channel.list`
- قبل بدء وضع التحكم الآلي ← فحص صلاحية `yolo.use`

## 5. تصميم الواجهة الأمامية

### 5.1 إعادة هيكلة RbacView

مقسمة إلى ثلاث تبويبات:

#### التبويب 1: إدارة المستخدمين

- جدول قائمة المستخدمين: صورة رمزية، اسم المستخدم، بريد إلكتروني، الدور (تبديل منسدل)، وسوم المجموعات، الحالة (نشط/معطّل)، إجراءات
- زر دعوة مستخدم ← يفتح نافذة منبثقة (إدخال اسم المستخدم/البريد/كلمة المرور، اختيار الدور)
- إجراءات الصف: تعديل الدور، تعطيل/تفعيل، حذف

#### التبويب 2: إدارة المجموعات

- جدول قائمة المجموعات: الاسم، الوصف، عدد الأعضاء، إجراءات
- إنشاء مجموعة ← يفتح نافذة منبثقة
- النقر على مجموعة ← توسيع قائمة الأعضاء، يمكن إضافة/إزالة الأعضاء

#### التبويب 3: مصفوفة الصلاحيات

- أعلى اليسار: اختيار وضع التفويض: شامل / لكل مجموعة / لكل مستخدم
- بعد اختيار مجموعة أو مستخدم، عرض جدول مصفوفة الصلاحيات:
  - الصفوف: فئات الموارد (المزودون، MCP، الوكلاء، القنوات، وضع التحكم الآلي...)
  - الأعمدة: الإجراءات (قائمة، إنشاء، تعديل، حذف، استخدام)
  - الخلايا: تبديل ثلاثي الحالات (✅ سماح / ❌ منع / ➖ وراثة الافتراضي)
- تحكم دقيق لمعرفات موارد محددة (مثلًا، السماح فقط بمزود محدد)

### 5.2 التحكم في صلاحيات التنقل

- عناصر الشريط الجانبي تُظهر/تُخفى ديناميكيًا بناءً على صلاحيات المستخدم الحالي
- حراس المسارات يضيفون فحوصات صلاحيات؛ إعادة توجيه لصفحة 403 عند عدم الصلاحية
- أزرار الإجراءات (مثل "إضافة مزود") تُظهر/تُخفى بناءً على الصلاحيات

## 6. خطوات التنفيذ

### المرحلة 1: أساس الخلفية

1. إضافة ترحيل قاعدة البيانات (جداول `rbac_groups`، `rbac_user_groups`، `rbac_grants` + حقل auth_users.role)
1. إضافة نماذج كيان SeaORM
1. تنفيذ مسارات API الخاصة بـ RBAC (CRUD المستخدمين، المجموعات، المنح)
1. تنفيذ وسيط/مستخرج فحص الصلاحيات
1. إضافة حقل الدور إلى مطالبات JWT

### المرحلة 2: تكامل الخلفية

1. إضافة فحوصات الصلاحيات إلى واجهات برمجة تطبيقات الموارد الموجودة (المزودين، القنوات، إلخ.)
1. تنفيذ `/api/rbac/check` و `/api/rbac/my-permissions`
1. تعديل طلبات موارد arona لاستيعاب تصفية الصلاحيات

### المرحلة 3: واجهة المستخدم الأمامية

1. إعادة هيكلة RbacView في arona (تبويبات المستخدم/المجموعة/مصفوفة-الصلاحيات)
1. تنفيذ حراس الشريط الجانبي والمسار
1. إظهار/إخفاء الميزات بناءً على الصلاحيات في arona (مثل زر وضع التحكم الآلي)

## 7. اعتبارات الأمان

- لا يمكن تجاوز صلاحيات دور `admin` بواسطة `rbac_grants` (سماح مُشفر ثابت)
- تُنفَّذ فحوصات الصلاحيات بشكل موحد في طبقة الوسيط، لا تعتمد على كود الأعمال للفحص اليدوي
- العمليات الحساسة (حذف المستخدمين، تعديل الصلاحيات) تُسجَّل في سجل تدقيق
- يحتوي JWT على الدور فقط؛ الصلاحيات المحددة تُستعلم من قاعدة البيانات في الوقت الفعلي (لتجنب الرموز القديمة بعد تغييرات الصلاحيات)
