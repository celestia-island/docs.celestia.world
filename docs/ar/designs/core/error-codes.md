# مرجع رموز الأخطاء

> **مهم**: "رموز الأخطاء" الموثقة أدناه (مثل `DB_CONNECT_FAILED`،
> `LLM_CALL_FAILED`) هي **أنماط رسائل نصية** مستخرجة من
> الكود المصدري — وهي تسميات ملائمة غير رسمية، وليست تصنيفًا رسميًا للأخطاء.
> **أنواع الأخطاء المنظّمة المعتمدة** هي المعدّات المعرفة في
> [`packages/shared/core/src/errors.rs`](../packages/shared/core/src/errors.rs):
> `AgentErrorCode` (السطر 8)، `StructuredAgentError`، `CoreError`، `CredentialError`،
> `PromptLoadError`، `SoulLoadError`، ومتغيراتها. عند التكامل أو
> الإبلاغ عن الأخطاء برمجيًا، استخدم تلك المعدّات، وليس الأنماط النصية
> المذكورة هنا.

يفهرس هذا المستند أنماط الأخطاء المستخدمة عبر قاعدة كود Entelecheia بلغة Rust.
أنواع الأخطاء المنظّمة قيد التطوير؛ تستخدم معظم الأخطاء حاليًا `anyhow`/`thiserror`
مع رسائل وصفية.

## فئات الأخطاء

### قاعدة البيانات (`DB_*`)

| الرمز | نمط الرسالة | المصدر |
| --- | --- | --- |
| `DB_CONNECT_FAILED` | `database connection failed: {}` | `scepter/src/app/setup.rs` |
| `DB_MIGRATE_FAILED` | `database migration failed: {}` | `scepter/src/app/setup.rs` |
| `DB_TABLE_CHECK_FAILED` | `failed to check table existence: {}` | `packages/shared/infra_services/src/persistence.rs` |
| `DB_INIT_SCRIPT_FAILED` | `failed to execute initialization script: {}` | `packages/shared/infra_services/src/persistence.rs` |
| `DB_SAVE_FAILED` | `failed to save agent info: {}` | `packages/shared/infra_services/src/persistence.rs` |
| `DB_UPDATE_FAILED` | `failed to update agent status: {}` | `packages/shared/infra_services/src/persistence.rs` |
| `DB_LOG_FAILED` | `failed to log entry: {}` | `packages/shared/infra_services/src/persistence.rs` |
| `DB_CLEANUP_FAILED` | `failed to clean up old logs: {}` | `packages/shared/infra_services/src/persistence.rs` |

### التهيئة (`CFG_*`)

| الرمز | نمط الرسالة | المصدر |
| --- | --- | --- |
| `CFG_CREDENTIAL_INIT_FAILED` | `credential storage initialization failed: {}` | `scepter/src/app/setup.rs` |
| `CFG_PROVIDER_INIT_FAILED` | `provider config initialization failed: {}` | `scepter/src/app/setup.rs` |
| `CFG_MODEL_INIT_FAILED` | `model config initialization failed: {}` | `scepter/src/app/setup.rs` |
| `CFG_USER_INIT_FAILED` | `user config initialization failed: {}` | `scepter/src/app/setup.rs` |
| `CFG_KEY_STORE_INIT_FAILED` | `key storage service initialization failed: {}` | `scepter/src/app/setup.rs` |

### الحالة (`ST_*`)

| الرمز | نمط الرسالة | المصدر |
| --- | --- | --- |
| `ST_SERIALIZE_FAILED` | `state serialization failed: {}` | `scepter/src/state/state_persistence.rs` |
| `ST_WRITE_FAILED` | `temp file write failed: {}` | `scepter/src/state/state_persistence.rs` |
| `ST_READ_FAILED` | `state file read failed: {}` | `scepter/src/state/state_persistence.rs` |
| `ST_PARSE_FAILED` | `state file parse failed: {}` | `scepter/src/state/state_persistence.rs` |

### WebSocket (`WS_*`)

| الرمز | نمط الرسالة | المصدر |
| --- | --- | --- |
| `WS_SEND_FAILED` | `failed to send message: {}` | `packages/shared/infra_services/src/ws_transport.rs` |
| `WS_TIMEOUT` | `response wait timeout or channel closed` | `packages/shared/infra_services/src/ws_transport.rs` |
| `WS_PARSE_FAILED` | `failed to parse agent list: {}` | `packages/shared/infra_services/src/ws_transport.rs` |
| `WS_NOT_CONNECTED` | `websocket connection not established` | `packages/shared/infra_services/src/ws_transport.rs` |

### الوكيل (`AG_*`)

| الرمز | نمط الرسالة | المصدر |
| --- | --- | --- |
| `AG_CONNECT_FAILED` | `connection failed: {}` | `packages/shared/core/src/errors.rs:7-28` |
| `AG_SEND_FAILED` | `send failed: {}` | `packages/shared/core/src/errors.rs:7-28` |
| `AG_CHANNEL_NOT_INIT` | `send channel not initialized` | `packages/shared/core/src/errors.rs:7-28` |
| `AG_REGISTRATION_FAILED` | `failed to send registration message: {}` | `packages/shared/core/src/errors.rs:7-28` |
| `AG_RE_REGISTER_FAILED` | `internal agent re-registration failed` | `scepter/src/state/state_restoration.rs` |

### نماذج اللغة الكبيرة (`LLM_*`)

| الرمز | نمط الرسالة | المصدر |
| --- | --- | --- |
| `LLM_CALL_FAILED` | `LLM call failed: {}` | `scepter/src/state_machine/llm_chat/chat_loop.rs` |

### وكلاء Layer2 (`L2_*`)

| الرمز | نمط الرسالة | المصدر |
| --- | --- | --- |
| `L2_INIT_FAILED` | `layer2 agent config initialization failed: {}` | `scepter/src/app/setup.rs` |
| `L2_SKILLS_VALIDATE_FAILED` | `layer2 agent skills validation failed: {}` | `scepter/src/app/setup.rs` |

### المهارات (`SK_*`)

| الرمز | نمط الرسالة | المصدر |
| --- | --- | --- |
| `SK_PROMPT_LOAD_FAILED` | `prompt loader error` | `packages/shared/prompt/src/prompt_loader.rs` |
| `SK_TOML_PARSE_FAILED` | `TOML parse failed: {}` | `packages/shared/prompt/src/prompt_loader.rs` |

### بيئة التشغيل (`RT_*`)

| الرمز | نمط الرسالة | المصدر |
| --- | --- | --- |
| `RT_ARC_UNWRAP_DOMAIN` | `Arc::try_unwrap failed for llm_domain/agent_domain` | `scepter/src/state_machine/mod.rs` |
| `RT_UNDO_NO_ACTIVE_SKILL` | `active_streaming_skill is None, defaulting to HubRis` | `scepter/src/state_machine/mod.rs` |

-----------------------------------------------------------------------------

> **ملاحظة**: هذا فهرس بأفضل جهد ممكنة. تنتقل Entelecheia نحو
> أنواع أخطاء منظّمة برموز فريدة. المساهمات لتوسيع هذا
> المرجع مرحب بها.
