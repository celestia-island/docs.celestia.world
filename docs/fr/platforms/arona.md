# Arona — Passerelle de modèles, mémoire et cluster

Arona est le plan de contrôle de la plateforme : passerelle de modèles,
gestionnaire de runtime d'auto-déploiement et tableau de bord web. Le
problème qu'il résout : transformer « un modèle téléchargé sur une machine
quelconque » en quelque chose que toute la plateforme peut router, mesurer et
mémoriser. Ce guide est organisé par capacité : routage de modèles, mémoire
long terme et clusters multi-nœuds.

## L'architecture en un coup d'œil

```text
shittim-chest / tout client OpenAI
         │  /v1/chat/completions (clé API Bearer)
         ▼
    Passerelle Arona (node-2:8420)
    ├─ Routeur : alias → équilibrage de charge au moindre nombre de requêtes en cours entre les backends
    ├─ Passerelle mémoire : injection du rappel → chat → réécriture (épisodes)
    └─ Plan de contrôle des agents (/ws/agent) ──► arona-agent sur les nœuds GPU
         │
         ▼
    Backends : ollama · externes (compatibles OpenAI) · moteurs déployés par agent
```

Tout le trafic de gestion (tableau de bord, agents, mémoire) passe par
WebSocket avec des messages JSON-RPC 2.0 ; la seule surface REST est les
endpoints compatibles OpenAI `/v1/*`.

## 1. Modèles

### Enregistrer un backend

Les backends sont enregistrés comme `ollama` ou `external` (tout serveur
compatible OpenAI — vLLM, TGI, LMDeploy, le routeur de TileRT, …) :

```bash
POST /api/admin/backends        # Bearer ADMIN_TOKEN
  {"type": "ollama", "name": "node3-ollama", "url": "http://host:11434"}
  {"type": "external", "name": "my-vllm", "url": "http://host:8000",
   "api_key": "...", "models": ["qwen2.5-72b"]}
```

Les backends enregistrés persistent entre les redémarrages (table
`backend_configs`) et leur santé est sondée en continu : les backends
externes restent en mode fail-closed jusqu'à leur première sonde
`/v1/models` réussie, et leur liste de modèles est rafraîchie dynamiquement.

### Auto-déployer un modèle sur un nœud

Le binaire `arona-agent` tourne sur les machines GPU et se connecte en
retour au panneau. Déployez un modèle depuis la page **Agents** du tableau de
bord (ou via `agents.deploy` avec un `agent_id` vide pour cibler
automatiquement le nœud le moins chargé). L'agent télécharge le modèle
(registre HuggingFace ou Ollama), démarre le moteur (llama.cpp / vLLM /
Ollama) et rapporte l'endpoint du moteur — le panneau l'enregistre
automatiquement comme un backend routable `agent-{model}` et le retire à
l'arrêt.

Adresse de liaison du moteur : réglez `ARONA_AGENT_BIND_ADDR=0.0.0.0` sur les
nœuds qui doivent servir du trafic vers le panneau. Note : les ports des
moteurs ne sont pas authentifiés — ne déployez que sur des réseaux de
confiance.

### Affinité de conversation

Les conversations sont épinglées à un seul backend (affinité de session), ce
qui permet de réutiliser les caches KV du runtime. Si un backend épinglé
devient défaillant, le routeur bascule et épingle à nouveau.

## 2. Mémoire long terme

Arona est une **passerelle mémoire** : il n'entraîne pas de modèles — il
orchestre un service de mémoire (l'agent PhiLia d'entelecheia) autour de
votre modèle existant.

### Activer

```bash
ARONA_MEMORY_URL=ws://<scepter-host>:8424/ws
ARONA_MEMORY_TOKEN=<scepter connection token>
ARONA_MEMORY_WRITEBACK=1        # activé par défaut ; 0 désactive la réécriture
```

### Ce qui se passe à chaque chat

1. **Rappel** — le dernier message utilisateur est transformé en embedding et
   interrogé auprès du service de mémoire ; les mémoires pertinentes sont
   injectées comme section système `## Relevant Long-Term Memories`
   (idempotent).
2. **Chat** — le contexte assemblé est routé vers le modèle.
3. **Réécriture** — le tour terminé est extrait de manière heuristique
   (`User: … / Assistant: …`, zéro appel LLM) et stocké comme épisode dans le
   graphe de mémoire (adossé à pgvector, survit aux redémarrages).
4. **État** — chaque réponse indique `memory: enabled | disabled | offline` ;
   la surface REST ajoute un en-tête `X-Arona-Memory`. Les échecs ne
   bloquent jamais le chat ; `offline` signifie que le service de mémoire est
   injoignable et c'est toujours visible dans l'UI.

Surcharge par appel : `chat.send` accepte `memory: true|false`.

### Gérer

La page **Mémoire** du tableau de bord montre l'activité
rappel/réécriture/suppression et permet de supprimer les nœuds stockés. Les
sessions persistent côté serveur : passez `conversation_id` à `chat.send` et
le serveur assemble l'historique à la place du client.

## 3. Opérations

- **Auth** : l'inscription se verrouille après le premier bootstrap
  administrateur (`ARONA_REGISTRATION_OPEN=1` la rouvre). Les endpoints
  d'administration exigent `ARONA_ADMIN_TOKEN` ; ils échouent en mode fermé
  sans lui.
- **Mesure** : l'usage et le coût sont enregistrés par clé API (`usage.list`,
  paliers de facturation avec quotas et limites de débit).
- **Santé** : `/api/health` et `/v1/health` rapportent la version et le hash
  de build.

## Référence des variables d'environnement

| Variable | Rôle |
|---|---|
| `DATABASE_URL` | Postgres (requis) |
| `JWT_SECRET` | Signature des jetons (requis hors mode mock) |
| `ARONA_HOST` / `ARONA_PORT` | Adresse de liaison (défaut `0.0.0.0:8420`) |
| `ARONA_ADMIN_TOKEN` | Jeton Bearer pour `/api/admin/*` |
| `ARONA_REGISTRATION_OPEN` | Rouvrir l'auto-inscription |
| `ARONA_MEMORY_URL` / `ARONA_MEMORY_TOKEN` / `ARONA_MEMORY_WRITEBACK` | Passerelle mémoire |
| `ARONA_AGENT_NAME` / `ARONA_PANEL_URL` / `ARONA_AGENT_BIND_ADDR` | Nœud agent |
