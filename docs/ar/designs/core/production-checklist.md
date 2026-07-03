# قائمة فحص نشر إنتاج Entelecheia

> قائمة من 12 خطوة لنشر Entelecheia في الإنتاج.

## ما قبل النشر

- [ ] **1. اختر وضع قاعدة البيانات**
  - pglite المضمّن: ثنائي واحد، لا قاعدة بيانات خارجية. مناسب لأقل من 50 وكيل متزامن.
  - PostgreSQL: موصى به للإنتاج. اضبط `DATABASE_URL`.

  ```bash
  # Embedded mode
  docker run -d -p 8080:8080 -v data:/data entelecheia:latest

  # PostgreSQL mode
  docker-compose up -d
  ```

- [ ] **2. هيّئ هوية المستخدم**

  ```bash
  export ENTELECHEIA_USER_UUID=$(uuidgen)
  ```

هذا الـ UUID هو هوية مالك مساحة العمل. كل عمليات الوكيل محدودة به.

- [ ] **3. أعد مزودي LLM**

  ```bash
  entelecheia-cli config set-provider openai --api-key sk-...
  entelecheia-cli config set-provider anthropic --api-key sk-ant-...
  ```

مفاتيح API مشفّرة أثناء التخزين بـ AES-256-GCM عبر وكيل Aporia.

- [ ] **4. هيّئ بيئة تشغيل الحاويات**
  - Docker (افتراضي): `--container-backend docker`
  - Youki (OCI بدون جذر): `--container-backend youki`
  - تحقق من ملف seccomp: `configs/seccomp/`

- [ ] **5. راجع سياسات الأمان**

  ```bash
  # List registered security policies
  entelecheia-cli security policy-list

  # Review OreXis sentinel configuration
  entelecheia-cli config show orexis
  ```

## النشر

- [ ] **6. ابنِ الصورة أو اسحبها**

  ```bash
  # Build from source
  docker build -t entelecheia:latest .

  # Or use release
  curl -fsSL https://raw.githubusercontent.com/celestia-island/entelecheia/main/scripts/deploy/install.sh | bash
  ```

- [ ] **7. ابدأ الخدمة**

  ```bash
  # Using Docker Compose (recommended)
  docker-compose up -d

  # Or standalone
  docker run -d --name entelecheia \
    -p 8080:8080 \
    -v entelecheia-data:/data \
    -e ENTELECHEIA_USER_UUID=$ENTELECHEIA_USER_UUID \
    --restart unless-stopped \
    entelecheia:latest
  ```

- [ ] **8. تحقق من الصحة**

  ```bash
  entelecheia-cli status
  curl http://localhost:8080/health
  ```

- [ ] **9. تهيئ صور Docker للوكلاء**

  ```bash
  entelecheia-cli init-docker-images
  ```

هذا يبني صور الحاويات التي يستخدمها كل وكيل Layer-1 للتنفيذ المعزول.

## ما بعد النشر

- [ ] **10. أعد المراقبة**

  ```bash
  # Enable tracing
  export RUST_LOG=info,entelecheia=debug

  # Check timeline for issues
  entelecheia-cli timeline list --agent orexis
  ```

- [ ] **11. هيّئ النسخ الاحتياطية**
  - الوضع المضمّن: انسخ احتياطيًا دليل `/data`
  - PostgreSQL: `pg_dump` أو أرشفة WAL
  - سجلات تدقيق الجدول الزمني: صدّ دوريًا

- [ ] **12. اختبر الحِمل**

  ```bash
  # Send a test message
  entelecheia-cli send "Hello, verify the system is operational"

  # Check agent status
  entelecheia-cli agent list

  # Verify audit trail
  entelecheia-cli trace-chain demiurge.001
  ```

## تقوية الأمان (موصى به)

| الفحص | الأمر |
| --- | --- |
| تحقق من عدم وجود أسرار في البيئة | `env \| grep -i key` |
| راجع مجموعات RBAC | `entelecheia-cli security rbac-list` |
| فحص حدود المعدل | `entelecheia-cli config show channel.rate_limit` |
| تحقق من عزل الحاويات | `docker inspect entelecheia \| grep SecurityOpt` |
| راجع سجل تدقيق OreXis | `entelecheia-cli logs --agent orexis --lines 100` |

## استكشاف الأخطاء وإصلاحها

| العرض | التشخيص |
| --- | --- |
| الوكلاء لا يستجيبون | `entelecheia-cli status` ← تحقق من تشغيل scepter |
| فشل استدعاءات LLM | تحقق من مفاتيح API: `entelecheia-cli config show providers` |
| أخطاء الحاويات | `docker logs entelecheia` ← ابحث عن أخطاء Youki/Docker |
| مشاكل قاعدة البيانات | تحقق من `DATABASE_URL` أو أذونات دليل بيانات pglite |
| رفض صلاحية الأداة | `entelecheia-cli security policy-list` ← راجع الاستدعاءات المرفوضة |
