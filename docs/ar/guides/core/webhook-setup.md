# إعداد منصة Webhook

> وصف لتخطيط webhook الحالي ونطاق التكامل

## نظرة عامة

يحتوي المستودع بالفعل على تكاملات webhook لمنصات استضافة الكود ومنصات المحادثة، لكن الشيء كله لا يزال في مرحلة انتقالية وليس حلًا موحدًا ومكتملًا ومستقرًا بالكامل.

تحتوي بنية الدليل الحالية على كل من:

- أدلة قديمة خاصة بكل منصة، مثل `plugins/github-webhook/github/`، `gitee/`، `gitlab/`، `telegram/`، `qq/`، `lark/`
- تنفيذ TypeScript أحدث: `plugins/github-webhook/ts/`

حزمة TypeScript تدمج حاليًا:

- GitHub
- Gitee
- GitLab
- Feishu / Lark
- QQ
- Discord
- Telegram

## ما الذي يعمل حاليًا

- استقبال أحداث webhook أو البوت
- إعادة توجيه الأحداث إلى Scepter عبر WebSocket أو استدعاءات مساعدة HTTP
- توفير نقطة نهاائية فحص صحة `/health` في خدمة TypeScript

## ما لا يمكن افتراضه حاليًا

- نهج نشر موحد ومستقر عبر جميع المنصات
- سلسلة مهارات كاملة مدفوعة بالمشكلات لكل منصة
- نفس مستوى النضج لكل تكامل منصة

## حزمة TypeScript

الموقع: `plugins/github-webhook/ts/`

تشغيل التطوير:

```bash
cd plugins/github-webhook/ts
npm install
npm run dev
```

بناء الإنتاج:

```bash
cd plugins/github-webhook/ts
npm run build
npm start
```

## متغيرات البيئة الرئيسية

- `PORT`: منفذ خدمة webhook، افتراضي `8000`
- `SCEPTER_URL`: عنوان إعادة توجيه HTTP، افتراضي `http://localhost:8424`
- `SCEPTER_WS_URL`: عنوان إعادة توجيه WebSocket، افتراضي `ws://localhost:8424/ws`

## توصيات الاستخدام

يمكنك معاملة قدرة webhook على أنها "موجودة، لكن بنضج غير متساوٍ." إذا كنت تعتمد على منصة معينة، تحقق أولًا من التنفيذ الفعلي للموجّه أو البوت المقابل ضمن `plugins/github-webhook/` قبل وصفه بأنه مستقر للاستخدام في الإنتاج.
