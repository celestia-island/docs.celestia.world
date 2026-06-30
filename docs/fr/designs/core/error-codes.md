
# Référence des Codes d'Erreur

> **IMPORTANT** : Les "codes d'erreur" documentés ci-dessous (par ex. `DB_CONNECT_FAILED`,
> `LLM_CALL_FAILED`) sont des **motifs de message basés sur des chaînes** extraits du
> code source — ce sont des étiquettes de commodité informelles, pas une taxonomie d'erreur
> formelle. Les **types d'erreur structurés faisant autorité** sont les énumérations définies
> dans [`packages/shared/core/src/errors.rs`](../packages/shared/core/src/errors.rs) :
> `AgentErrorCode` (ligne 8), `StructuredAgentError`, `CoreError`, `CredentialError`,
> `PromptLoadError`, `SoulLoadError`, et leurs variantes. Lors de l'intégration ou
> du signalement d'erreurs par programmation, utilisez ces énumérations, pas les motifs de chaîne
> listés ici.

Ce document catalogue les motifs d'erreur utilisés dans la base de code Rust d'Entelecheia.
Les codes d'erreur structurés sont en cours d'élaboration ; la plupart des erreurs utilisent actuellement `anyhow`/`thiserror`
avec des messages descriptifs.

## Catégories d'Erreur

### Base de Données (`DB_*`)

| Code | Motif de Message | Source |
| --- | --- | --- |
| `DB_CONNECT_FAILED` | `échec de la connexion à la base de données : {}` | `scepter/src/app/setup.rs` |
| `DB_MIGRATE_FAILED` | `échec de la migration de la base de données : {}` | `scepter/src/app/setup.rs` |
| `DB_TABLE_CHECK_FAILED` | `échec de la vérification de l'existence de la table : {}` | `packages/shared/infra_services/src/persistence.rs` |
| `DB_INIT_SCRIPT_FAILED` | `échec de l'exécution du script d'initialisation : {}` | `packages/shared/infra_services/src/persistence.rs` |
| `DB_SAVE_FAILED` | `échec de la sauvegarde des informations de l'agent : {}` | `packages/shared/infra_services/src/persistence.rs` |
| `DB_UPDATE_FAILED` | `échec de la mise à jour du statut de l'agent : {}` | `packages/shared/infra_services/src/persistence.rs` |
| `DB_LOG_FAILED` | `échec de l'enregistrement du journal : {}` | `packages/shared/infra_services/src/persistence.rs` |
| `DB_CLEANUP_FAILED` | `échec du nettoyage des anciens journaux : {}` | `packages/shared/infra_services/src/persistence.rs` |

### Configuration (`CFG_*`)

| Code | Motif de Message | Source |
| --- | --- | --- |
| `CFG_CREDENTIAL_INIT_FAILED` | `échec de l'initialisation du stockage des credentials : {}` | `scepter/src/app/setup.rs` |
| `CFG_PROVIDER_INIT_FAILED` | `échec de l'initialisation de la configuration du fournisseur : {}` | `scepter/src/app/setup.rs` |
| `CFG_MODEL_INIT_FAILED` | `échec de l'initialisation de la configuration du modèle : {}` | `scepter/src/app/setup.rs` |
| `CFG_USER_INIT_FAILED` | `échec de l'initialisation de la configuration utilisateur : {}` | `scepter/src/app/setup.rs` |
| `CFG_KEY_STORE_INIT_FAILED` | `échec de l'initialisation du service de stockage des clés : {}` | `scepter/src/app/setup.rs` |

### État (`ST_*`)

| Code | Motif de Message | Source |
| --- | --- | --- |
| `ST_SERIALIZE_FAILED` | `échec de la sérialisation de l'état : {}` | `scepter/src/state/state_persistence.rs` |
| `ST_WRITE_FAILED` | `échec de l'écriture du fichier temporaire : {}` | `scepter/src/state/state_persistence.rs` |
| `ST_READ_FAILED` | `échec de la lecture du fichier d'état : {}` | `scepter/src/state/state_persistence.rs` |
| `ST_PARSE_FAILED` | `échec de l'analyse du fichier d'état : {}` | `scepter/src/state/state_persistence.rs` |

### WebSocket (`WS_*`)

| Code | Motif de Message | Source |
| --- | --- | --- |
| `WS_SEND_FAILED` | `échec de l'envoi du message : {}` | `packages/shared/infra_services/src/ws_transport.rs` |
| `WS_TIMEOUT` | `délai d'attente de réponse dépassé ou canal fermé` | `packages/shared/infra_services/src/ws_transport.rs` |
| `WS_PARSE_FAILED` | `échec de l'analyse de la liste des agents : {}` | `packages/shared/infra_services/src/ws_transport.rs` |
| `WS_NOT_CONNECTED` | `connexion websocket non établie` | `packages/shared/infra_services/src/ws_transport.rs` |

### Agent (`AG_*`)

| Code | Motif de Message | Source |
| --- | --- | --- |
| `AG_CONNECT_FAILED` | `échec de la connexion : {}` | `packages/shared/core/src/errors.rs:7-28` |
| `AG_SEND_FAILED` | `échec de l'envoi : {}` | `packages/shared/core/src/errors.rs:7-28` |
| `AG_CHANNEL_NOT_INIT` | `canal d'envoi non initialisé` | `packages/shared/core/src/errors.rs:7-28` |
| `AG_REGISTRATION_FAILED` | `échec de l'envoi du message d'enregistrement : {}` | `packages/shared/core/src/errors.rs:7-28` |
| `AG_RE_REGISTER_FAILED` | `ré-enregistrement interne de l'agent échoué` | `scepter/src/state/state_restoration.rs` |

### LLM (`LLM_*`)

| Code | Motif de Message | Source |
| --- | --- | --- |
| `LLM_CALL_FAILED` | `échec de l'appel LLM : {}` | `scepter/src/state_machine/llm_chat/chat_loop.rs` |

### Agents Couche 2 (`L2_*`)

| Code | Motif de Message | Source |
| --- | --- | --- |
| `L2_INIT_FAILED` | `échec de l'initialisation de la configuration de l'agent couche 2 : {}` | `scepter/src/app/setup.rs` |
| `L2_SKILLS_VALIDATE_FAILED` | `échec de la validation des compétences de l'agent couche 2 : {}` | `scepter/src/app/setup.rs` |

### Compétences (`SK_*`)

| Code | Motif de Message | Source |
| --- | --- | --- |
| `SK_PROMPT_LOAD_FAILED` | `erreur du chargeur de prompt` | `packages/shared/prompt/src/prompt_loader.rs` |
| `SK_TOML_PARSE_FAILED` | `échec de l'analyse TOML : {}` | `packages/shared/prompt/src/prompt_loader.rs` |

### Exécution (`RT_*`)

| Code | Motif de Message | Source |
| --- | --- | --- |
| `RT_ARC_UNWRAP_DOMAIN` | `Arc::try_unwrap a échoué pour llm_domain/agent_domain` | `scepter/src/state_machine/mod.rs` |
| `RT_UNDO_NO_ACTIVE_SKILL` | `active_streaming_skill est None, retour par défaut à HubRis` | `scepter/src/state_machine/mod.rs` |

---

> **Note** : Ceci est un catalogue au meilleur effort. Entelecheia migre vers
> des types d'erreur structurés avec des codes uniques. Les contributions pour étendre cette
> référence sont les bienvenues.
