# تحديد وكيل الذكاء الاصطناعي واستراتيجية المشاركة في التأليف (Co-author) للالتزامات

## نظرة عامة

يشارك `evernight` في استراتيجية المشارك في تأليف celestia-island بطريقتين:

1. **كمضيف التزام**: عندما ينسق وكيل ذكاء اصطناعي التزامًا عبر evernight
   (وكيل على المضيف A ← evernight SSH/exec ← المضيف B ← `git commit`)، يطلق ربط
   `commit-msg` الخاص بالمضيف (الذي يثبّته `noa`) محليًا ويختم الالتزام بـ
   بيانات وصفية للمصدر.
2. **كمزود عبور**: عندما يرحل evernight حركة النموذج، يمكن أن يظهر في
   بريد المؤلف كمنصة خدمة، مما يجعل قفزة النقل قابلة للتدقيق.

تحدد هذه الوثيقة دور evernight. الآلية القانونية معرّفة في
وثيقة تصميم `noa`؛ هذا يغطي التكامل الخاص بـ evernight.

## نموذج هوية المزود

يستخدم بريد المؤلف نطاق ثقة `celestia.world`:

```
Display Name <provider-or-platform-id@celestia.world>
```

عندما يرحل evernight نموذجًا، يعكس معرّف المزود المرحل:

```
GLM 5 <evernight.celestia.world@celestia.world>   # GLM 5 relayed via evernight
```

يحتفظ مزودو الطرف الأول بنطاقهم الخاص (`anthropic.com`، `deepseek.com`،
`zhipuai.cn`، ...)؛ تحتفظ مرحلات الطرف الثالث بنطاقها (`opencode.ai`، `jdcloud.com`،
`openrouter.ai`، ...). هذا يجعل السلسلة "أي نموذج، عبر من" مرئية على
كل التزام.

## مقطور المشارك

- مفتاح المقطور: `Co-authored-by` (معترف به من git).
- مقطور واحد لكل نموذج مميز، بترتيب الاستخدام.
- سلسلة تعمل بالكامل تحت تحكم YOLO تحصل إضافيًا على:
  `Co-authored-by: Entelecheia <demiurge@celestia.world>`.

## استخدام الرموز المضمّن

مُلحق بعد مقاطير المشارك (مفصول بسطر فارغ):

```
Co-authored-by: Claude Opus 4.8 (↑ 12.5k ↓ 8.3k ●45.2k) <anthropic.com@celestia.world>
Co-authored-by: Deepseek V4 Pro (↑ 5.1k ↓ 3.2k) <deepseek.com@celestia.world>
```

- `Upload` = رموز الإدخال؛ `Download` = رموز المخرج.
- يظهر `Cache` فقط عند الإبلاغ عن رموز الإدخال المؤقتة وأنها > 0.
- العدّ بآلاف (`k`)، منزلة عشرية واحدة، صفر زائد مُزال.

## نقاط تكامل evernight

### الربط على جانب المضيف

الالتزامات المُجراة عبر `Command.Exec` JSON-RPC الخاص بـ `evernight` (المستخدم بواسطة خط أنابيب
الجراحة في entelecheia وحلقة `KaLos:auto_fix`) تستدعي `git` الخاص بالنظام، لذا ينطبق
ربط `.git/hooks/commit-msg` المثبّت بواسطة `noa hook install` دون تغيير. لا
تغيير في كود evernight مطلوب للالتزامات المُجراة على مضيف حيث الربط
مثبّت.

### هوية مزود العبور

عندما يوكّل evernight حركة LLM (مثل توجيه استدعاء نموذج إلى استدلال
محلي على مضيف بعيد)، يمكن إخبار محلل المشارك بنقطة نهاية المرحل ليصبح
معرّف المزود `evernight.celestia.world`. هذا مُكوَّن عبر نفس
قائمة مزودي `aporia.toml` التي يقرأها `noa co-author resolve`.

## مثال رسالة التزام كاملة

```
perf(screen): cache X11 connection to avoid per-frame reconnect

X11CaptureBackend previously called x11rb::connect on every capture_frame.
Cache the connection in a Mutex<Option<..>>, reusing it across frames.

Co-authored-by: Entelecheia <demiurge@celestia.world>
Co-authored-by: Deepseek V4 Pro (↑ 18.2k ↓ 2.1k) <deepseek.com@celestia.world>
```

## اعتبارات الأمان

- مقاطير المشارك هي مصدر مُبلَّغ ذاتيًا وليس دليلًا تشفيريًا.
- يتدهور المحلل بأمان: `noa` مفقود أو خطأ تحليل ينتج كتلة فارغة
  ويمر الالتزام دون مساس.
- معرّفات المزود تأتي من `aporia.toml` المحلي، عاكسةً المزودين المكوَّنين.

## مرجع معرّفات المزودين (السجل المبدئي)

| معرّف المزود | العلامة | تلميح نقطة النهاية |
| --- | --- | --- |
| `zhipuai.cn` | GLM | `open.bigmodel.cn` |
| `deepseek.com` | Deepseek | `api.deepseek.com` |
| `anthropic.com` | Claude | `api.anthropic.com` |
| `openai.com` | GPT / OpenAI | `api.openai.com` |
| `evernight.celestia.world` | (مرحلة) | وكيل evernight |
| `opencode.ai` | (مرحلة) | `opencode.ai` |
| `jdcloud.com` | (مرحلة) | `jdcloud.com` |
