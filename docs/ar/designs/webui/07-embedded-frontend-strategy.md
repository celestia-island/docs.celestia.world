# استراتيجية الواجهة الأمامية المضمنة

## نظرة عامة

يدعم shittim-chest وضعين لاستضافة الواجهة الأمامية: في وضع التطوير، يراقب `dev.py` مصادر الواجهة الأمامية ويُطلق `pnpm build` عند التغييرات، مع خدمة الخلفية للملفات الثابتة و API معًا على `:3000`؛ وفي وضع الإصدار، تُضمَّن ملفات الواجهة الأمامية الثابتة في الثنائي Rust وقت الترجمة وتُقدَّم على `:80`. تُبدَّل الأوضاع عبر ميزة `embedded-frontend` في Cargo، مع ترجمة شرطية على مستوى الكود باستخدام `#[cfg(feature = "embedded-frontend")]`.

## مقارنة البنية

```mermaid
flowchart TB
    subgraph Dev[وضع التطوير: dev.py + الخلفية]
        D1[dev.py يراقب مصدر الواجهة الأمامية] --> D2[pnpm build → dist/]
        D2 --> D3[shittim_chest :3000 يقدم ثابت + API]
    end
    subgraph Release[وضع الإصدار: مضمن]
        R1[المتصفح] --> R2[shittim_chest :80]
        R2 --> R3[API + LLM]
        R2 --> R4[/static/*\nSPA مضمن]
    end
```

| البُعد | التطوير (بدون ميزة) | الإصدار (embedded-frontend) |
| --- | --- | --- |
| مصدر الواجهة الأمامية | مبني بواسطة Vite، يُخدم بواسطة الخلفية | تضمين وقت الترجمة `include_dir!` |
| إعادة التحميل الساخن | إعادة بناء تلقائية عبر dev.py | غير مدعوم (ثابت) |
| توجيه طلبات API | اتصال مباشر بالمتصفح (نفس الأصل) | اتصال مباشر بالمتصفح |
| حجم الثنائي | الخلفية فقط | + مجلد frontend dist/ |
| يتطلب Node | نعم (للبناء فقط) | لا |
| طريقة بدء التشغيل | `dev.py` (يراقب + يعيد البناء) | إطلاق لمرة واحدة `just up` |

## تفاصيل التنفيذ

### الترجمة الشرطية

```rust
# [cfg(feature = "embedded-frontend")]
static ARONA_DIR: Dir<'_> = include_dir!("$CARGO_MANIFEST_DIR/../../dist/arona");

async fn serve_arona() -> impl IntoResponse {
    #[cfg(feature = "embedded-frontend")]
    {
        // قراءة من Dir المضمن وقت الترجمة
    }
    #[cfg(not(feature = "embedded-frontend"))]
    {
        // قراءة من نظام الملفات ./dist/arona/index.html
    }
}
```

تعمل الترجمة الشرطية على **مستوى جسم الدالة** بدلًا من مستوى الوحدة، مما يبقي واجهة API العامة متطابقة عبر كلا الوضعين.

### تراجع SPA

التطبيق هو تطبيق صفحة واحدة. جميع المسارات غير المطابقة للأصول الثابتة تُعيد `index.html`:

```text
GET /               → index.html
GET /chat/123       → index.html (يتعامل موجّه الواجهة الأمامية)
GET /backend        → index.html
GET /backend/providers → index.html (يتعامل موجّه الواجهة الأمامية)
```

### كشف نوع MIME

تُعيد خدمة الملفات الثابتة Content-Type الصحيح بناءً على امتداد الملف:

| الامتداد | Content-Type |
| --- | --- |
| `.js` | `application/javascript` |
| `.css` | `text/css` |
| `.html` | `text/html` |
| `.json` | `application/json` |
| `.png` | `image/png` |
| `.svg` | `image/svg+xml` |
| `.woff/.woff2` | `font/woff2` |
| أخرى | `application/octet-stream` |

## بناء الواجهة الأمامية في Dockerfile

```text
المرحلة 1 (الواجهة الأمامية):
  node:22-slim → pnpm install → pnpm build:all → /app/dist/arona/

المرحلة 2 (البناء):
  rust:1.85-slim → COPY /app/dist/ → cargo build --features embedded-frontend

المرحلة 3 (وقت التشغيل):
  debian:bookworm-slim → COPY binary → ENTRYPOINT ["./shittim_chest"]
```

يُكمل بناء الواجهة الأمامية وترجمة Rust داخل نفس Dockerfile. تحتوي صورة وقت التشغيل النهائية على الثنائي المُترجم فقط.

## قرارات التصميم

1. **يستخدم وضع التطوير dev.py لإعادة البناء التلقائي**: يراقب `dev.py` مصادر الواجهة الأمامية ويعيد البناء عند التغييرات، مع خدمة الخلفية لكل شيء على منفذ واحد.
1. **لا يتطلب وضع الإصدار وكيلًا عكسيًا**: يُضمِّن الثنائي SPA، مما يمكّن النشر بعملية واحدة ويقلل التعقيد التشغيلي.
1. **لا تُحمَّل الواجهة الأمامية ديناميكيًا وقت التشغيل**: يتجنب اعتماديات نظام الملفات وعدم اتساق الإصدارات. تحتوي صورة الإصدار على ملف ثنائي واحد فقط.
1. **SPA واحد**: تُقدَّم الواجهة الأمامية على `/` مع لوحة الإدارة على `/backend`.
