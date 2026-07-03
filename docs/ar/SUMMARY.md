# الملخص

[ترحيب](./intro.md)

-----------------------------------------------------------------------------

# معلومات

- [الترخيص](./meta/license.md)
- [CLA](./meta/cla.md)
- [مدونة السلوك](./meta/code-of-conduct.md)
- [الأمان](./meta/security.md)
- [المساهمة](./meta/CONTRIBUTING.md)

# أدلة

## انتيليشيا (النواة)

- [نظرة عامة](./guides/core/README.md)
- [البنية](./guides/core/architecture.md)
- [الأساسيات](./guides/core/fundamentals.md)
- [البناء](./guides/core/building.md)
- [CLI](./guides/core/cli.md)
- [تطوير الوكيل](./guides/core/agent-development.md)
- [تطوير أدوات MCP](./guides/core/mcp-tool-development.md)
- [خط الأنابيب متعدد الوسائط](./guides/core/multimodal-pipeline.md)
- [إعداد Webhook](./guides/core/webhook-setup.md)
- [تتبع المشكلات](./guides/core/issue-tracking.md)
- [المساهمة](./guides/core/CONTRIBUTING.md)
- [انتيليشيا](./guides/core/README-entelecheia.md)

## شيتيم-تشيست (WebUI)

- [نظرة عامة](./guides/webui/README.md)
- [البنية](./guides/webui/architecture.md)
- [الأساسيات](./guides/webui/fundamentals.md)
- [البناء](./guides/webui/building.md)
- [إعداد Webhook](./guides/webui/webhook-setup.md)
- [المساهمة](./guides/webui/CONTRIBUTING.md)
- [شيتيم-تشيست](./guides/webui/README-shittim-chest.md)

## المنصات (أرونا · إيفرنايت)

- [البدء](./guides/platforms/getting-started.md)
- [البروتوكولات](./guides/platforms/protocols.md)
- [التكامل](./guides/platforms/integration.md)
- [أرونا](./guides/platforms/README-arona.md)
- [إيفرنايت](./guides/platforms/README-evernight.md)
- [نوا](./guides/platforms/README-noa.md)
- [إعداد بوابة تيا](./guides/platforms/tia-portal-setup.md)

# التصاميم

## انتيليشيا (النواة)

- [نظرة عامة](./designs/core/README.md)
- [البنية](./designs/core/architecture.md)
- [نظام تكوين الوكيل](./designs/core/agent-config-system.md)
- [إجماع الوكيل](./designs/core/agent-consensus.md)
- [تعريف وكيل الذكاء الاصطناعي](./designs/core/ai-agent-identification.md)
- [معيار Mock LLM](./designs/core/benchmark-mock-llm.md)
- [محرك جافاسكريبت Boa](./designs/core/boa-javascript-engine.md)
- [تحليل المنافسين](./designs/core/competitor-analysis.md)
- [تنفيذ الوكيل المعزول بالحاوية](./designs/core/container-sandboxed-agent-execution.md)
- [إعداد السياق](./designs/core/context_preparation.md)
- [تنسيق المحادثة](./designs/core/conversation-orchestration.md)
- [جدولة Cosmos](./designs/core/cosmos-scheduling.md)
- [توجيه المهارات عبر الوكلاء](./designs/core/cross_agent_skill_routing.md)
- [قرارات التصميم](./designs/core/design-decisions.md)
- [رموز الأخطاء](./designs/core/error-codes.md)
- [سطح أداة النواة الدقيقة للتنفيذ فقط](./designs/core/exec-only-microkernel-tool-surface.md)
- [محرك تنفيذ IEPL Typescript](./designs/core/iepl-typescript-execution-engine.md)
- [مزامنة تزايدية](./designs/core/incremental-sync.md)
- [مواصفات حزمة Layer2](./designs/core/layer2-package-spec.md)
- [مساحة عمل Crate متعددة الطبقات](./designs/core/layered-crate-workspace.md)
- [تكوين مزود LLM](./designs/core/llm-provider-config.md)
- [الذاكرة والذات](./designs/core/memory-and-self.md)
- [تصنيف النماذج](./designs/core/model-tiering.md)
- [بنية Namespace](./designs/core/namespace-architecture.md)
- [الخطة](./designs/core/plan.md)
- [تخزين PostgreSQL pgvector](./designs/core/postgresql-pgvector-storage.md)
- [قائمة مراجعة الإنتاج](./designs/core/production-checklist.md)
- [بنية الانعكاس](./designs/core/reflection-architecture.md)
- [بنية Scepter](./designs/core/scepter-architecture.md)
- [الأمان](./designs/core/security.md)
- [سياسة دورة حياة الجلسة](./designs/core/session-lifecycle-policy.md)
- [بنية Soul Prompt](./designs/core/soul-prompt-architecture.md)
- [نظام إضافات WASI](./designs/core/wasi-plugin-system.md)

## شيتيم-تشيست (WebUI)

- [نظرة عامة](./designs/webui/README.md)
- [البنية](./designs/webui/architecture.md)
- [حول](./designs/webui/about.md)
- [التموضع في المشهد التنافسي](./designs/webui/01-positioning-competitive-landscape.md)
- [تنسيق Bollard Docker](./designs/webui/02-bollard-docker-orchestration.md)
- [مسارات النشر المزدوجة](./designs/webui/03-dual-deployment-paths.md)
- [استراتيجية فحص الصحة](./designs/webui/04-health-check-strategy.md)
- [بنية LLM المستقلة](./designs/webui/05-independent-llm-architecture.md)
- [اقتران مرن مع انتيليشيا](./designs/webui/06-loose-coupling-with-entelecheia.md)
- [استراتيجية الواجهة الأمامية المضمنة](./designs/webui/07-embedded-frontend-strategy.md)
- [اصطلاحات التسجيل](./designs/webui/08-logging-conventions.md)
- [استراتيجية Wasm المزدوجة للواجهة الأمامية](./designs/webui/09-dual-frontend-wasm-strategy.md)
- [قاعدة بيانات اختبار مضمنة](./designs/webui/10-embedded-test-database.md)
- [تنسيق مشروع Plant](./designs/webui/plant-project-format.md)
- [تصميم RBAC](./designs/webui/rbac-design.md)

## المنصات

- [نظرة عامة](./designs/platforms/README.md)
- [البنية](./designs/platforms/architecture.md)
- [فهرس ADR](./designs/platforms/adr-index.md)
- [تعريف وكيل الذكاء الاصطناعي](./designs/platforms/ai-agent-identification.md)

### سجلات قرارات البنية

- [وقت التشغيل غير المتزامن](./designs/platforms/adr/async-runtime.md)
- [سمات الواجهة الخلفية](./designs/platforms/adr/backend-traits.md)
- [URI إدخال الاتصال](./designs/platforms/adr/connection-entry-uri.md)
- [وقت تشغيل الحاوية](./designs/platforms/adr/container-runtime.md)
- [معالجة الأخطاء](./designs/platforms/adr/error-handling.md)
- [علامات الميزات](./designs/platforms/adr/feature-flags.md)
- [فصل الوحدات](./designs/platforms/adr/module-decoupling.md)
- [التقاط الشاشة](./designs/platforms/adr/screen-capture.md)
- [المنفذ التسلسلي Aoba](./designs/platforms/adr/serial-port-aoba.md)
- [نقل الإشارات](./designs/platforms/adr/signaling-transport.md)
- [واجهة SSH الخلفية](./designs/platforms/adr/ssh-backend.md)
- [محلل تكوين SSH](./designs/platforms/adr/ssh-config-parser.md)
- [تجمع اتصالات SSH](./designs/platforms/adr/ssh-connection-pool.md)
- [عميل VNC RFB](./designs/platforms/adr/vnc-rfb-client.md)

