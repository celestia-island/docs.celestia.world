# Entelecheia — Plateforme d'agents et mémoire

Entelecheia est la plateforme d'agents : le runtime scepter qui orchestre
des agents spécialisés (les « âmes »), maintient la mémoire long terme
(PhiLia), fournit la recherche sémantique et héberge la couche d'intégration
industrielle. Derrière les capacités d'Arona et de Chest se dresse cette
plateforme. Ce guide est organisé par capacité : agents, mémoire, recherche,
connaissances et connexions.

## L'architecture en un coup d'œil

```text
Clients : Arona (passerelle) · Shittim Chest (chat/panneaux) · TUI/CLI
         │  JSON-RPC 2.0 sur WebSocket (jeton ou clé API)
         ▼
    runtime scepter (node-3:8424)
    ├─ Gestionnaire d'agents : âmes L1 (PhiLia, Skopeo, Hubris, Kalos, …)
    ├─ Chaînes de compétences : pipelines d'appels LLM + outils avec préchargement RAG
    ├─ PhiLia : mémoire long terme (vectoriel + graphe, adossée à pgvector)
    ├─ ApoRia : base de connaissances + index d'espace de travail (recherche sémantique)
    ├─ OreXis : portes de politique / sécurité sur l'exécution des outils
    └─ Réflexion : magasin de leçons réinjecté dans les prompts
```

## 1. Agents (âmes)

Chaque âme est un agent spécialisé avec son propre document d'identité, ses
outils (façon MCP) et ses compétences. Les chaînes de compétences composent
des appels LLM avec l'exécution d'outils ; avant chaque appel, les mémoires
long terme pertinentes et le contenu de la base de connaissances sont
préchargés et injectés dans le prompt système.

Sécurité : l'exécution des outils passe par les portes de politique OreXis,
et les écritures industrielles exigent des flux d'approbation explicites.

## 2. Mémoire long terme (PhiLia)

PhiLia est le service de mémoire derrière la passerelle mémoire d'Arona :

- **Stockage** — les épisodes, entités et artefacts sont stockés comme
  nœuds dans un graphe de mémoire, vectorisés (embeddings) et reflétés vers
  pgvector (`philia_chunks`).
- **Requête** — la récupération sémantique combine similarité vectorielle,
  traversée de graphe et décroissance de récence (demi-vie de 14 jours).
- **Consolidation** — des fusions périodiques relient les nœuds apparentés.
- **Surface de protocole** — méthodes de premier plan
  `Sync.MemoryStoreRequest` / `MemoryQueryRequest` / `MemoryDeleteRequest`
  (RBAC : SystemWrite / SystemRead) aux côtés de la route générique
  `Mcp.CallTool`.

Embeddings : configurés via `OLLAMA_HOST` + `OLLAMA_EMBED_MODEL` (par ex.
`nomic-embed-text`), ou une API distante, avec repli sur un modèle ONNX
local.

## 3. Recherche sémantique

`Sync.SearchRequest` fusionne deux magasins en une seule liste classée :

- **ApoRia** — index d'espace de travail, rapports d'agents et documents de
  la base de connaissances (hybride vectoriel + mots-clés avec RRF).
- **PhiLia** — mémoires long terme (source `philia_memory`).

## 4. Base de connaissances

Créez des bases de connaissances, ajoutez des documents et abonnez-vous aux
abonnements rag — tout est persisté dans Postgres. Les documents sont
vectorisés dans le magasin ApoRia et récupérables via la même surface de
recherche.

## 5. Réflexion

Les leçons apprises sont stockées dans un magasin de leçons (pgvector) et
réinjectées dans les prompts futurs — une seconde mémoire persistante,
légère, aux côtés de PhiLia.

## 6. Connecter les clients

- WebSocket `ws://<host>:8424/ws` — authentification à l'upgrade avec
  `?token=<connection token>` (ou Bearer) ; puis `Sync.ConnectHandshake`.
- JSON-RPC sur HTTP `POST /api/rpc?token=…` pour un usage requête/réponse.
- Jeton de connexion : `~/.config/entelecheia/scepter.token` sur le nœud
  scepter.

## Référence des variables d'environnement (extrait)

| Variable | Rôle |
|---|---|
| `SERVER_BIND_ADDRESS` | Adresse de liaison (défaut 127.0.0.1 ; réglez 0.0.0.0:8424 pour les clients distants) |
| `DATABASE_URL` | Postgres (config.toml ou variable d'environnement) |
| `OLLAMA_HOST` / `OLLAMA_EMBED_MODEL` | Backend d'embeddings |
| `JWT_SECRET` | Jetons d'authentification persistants (aléatoires par session si non défini) |
| `connection_token` | Fichier du jeton de connexion scepter |
