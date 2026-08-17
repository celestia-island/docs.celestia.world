# Shittim Chest — Chat, panneaux et intégrations

Shittim Chest est le visage utilisateur : chat, panneaux et intégrations
multi-canaux — la couche qui transforme les capacités des modèles et des
agents en quelque chose que vous utilisez tous les jours. Il prend les
modèles et la mémoire d'Arona, et les agents, panneaux et flux de travail
industriels du scepter d'entelecheia. Ce guide est organisé par capacité :
chat, panneaux, canaux, recherche et authentification.

## L'architecture en un coup d'œil

```text
Vous
 │  application de bureau · web UI · 12+ canaux IM (discord/slack/matrix/lark/…)
 ▼
 Cœur de Shittim Chest (node-2:8425)
  ├─ Chat : conversations persistées dans Postgres, diffusées en SSE/WS
  ├─ Panneaux : grille de données / pipeline média / jumeau 3D (moteur de panneaux)
  ├─ Pipeline média : revue visuelle LLM, génération d'images, gén 3D (stub)
  ├─ Pont de canaux : IM ↔ cœur bidirectionnel (webhooks + WS)
  └─ Pont RPC → scepter (agents, recherche sémantique, base de connaissances)
         │
         ▼
 Arona (modèles, mémoire) · scepter (agents, panneaux, recherche)
```

## 1. Chat

- Les conversations et les messages persistent dans Postgres (tables
  `conversations` / `messages`). L'historique complet est assemblé côté
  serveur.
- Streaming via SSE avec relecture des fragments ; le shell de bureau
  affiche les fragments de raisonnement et les appels d'outils des agents
  scepter.
- `chat.send` prend en charge l'identifiant de conversation, la surcharge de
  modèle et les indicateurs mémoire (voir le [guide Arona](./arona.md) pour
  la sémantique de la passerelle mémoire).

## 2. Panneaux

Les panneaux sont créés à partir d'un simple prompt : le moteur génère la
disposition et les widgets, puis les persiste dans le stockage d'espace de
travail de scepter (`.amphoreus/workspace.toml` + `.noa/views/*.view.toml`).
L'édition est structurée, pas une boîte noire : la liaison brute de source de
données, la liste des widgets et l'état de connexion sont visibles, avec un
dialogue d'édition approfondie par ligne et une zone de réglage en langage
naturel repliée.

Trois types de panneaux :

- **Grille de données** — vues tabulaires avec champs typés,
  tri/filtre/groupement ; les écritures passent par des types d'édition
  `table.*` avec validation et annulation réelles.
- **Pipeline média** — un graphe de nœuds façon Dify (nœuds LLM, génération
  d'images, HTTP, récupération de connaissances, branchement) ; les
  pipelines tournent côté serveur avec progression en streaming et peuvent
  être invoqués comme outils par les agents.
- **Jumeau 3D** — arborescences de modèles d'équipements avec coordonnées
  monde, configuration de scène et signets de caméra.

## 3. Intégrations multi-canaux

Le pont de canaux connecte le cœur aux plateformes IM (Discord, Slack,
Matrix, Lark, …). Les messages entrants deviennent des tours de chat ; les
réponses sortantes reviennent en streaming sur le même canal. Chaque canal
exige son application OAuth approuvée pour un usage en production.

## 4. Recherche sémantique et connaissances

- `search.semantic` fait le pont vers la recherche vectorielle de scepter
  (index d'espace de travail ApoRia + mémoires long terme PhiLia fusionnées
  en une seule liste classée).
- Les bases de connaissances (création / ajout de documents / abonnement)
  persistent dans Postgres et sont interrogeables via la même surface RPC.
- Les rapports d'agents sont indexés automatiquement, ainsi les rapports
  passés sont récupérables sémantiquement.

## 5. Authentification

L'authentification est déléguée : scepter se fie à l'identifiant utilisateur
de l'appelant fourni par la passerelle chest (`X-User-Id` / `user_id`), que
chest obtient d'Arona ou du flux d'invitation. Les rôles RBAC
(admin / operator / viewer / agent) protègent les opérations d'écriture sur
les panneaux et les espaces de travail.

## Référence des variables d'environnement (extrait)

| Variable | Rôle |
|---|---|
| `DATABASE_URL` | Postgres (requis) |
| `ENTELECHEIA_SCEPTER_URL` / `WS_URL` | Endpoints RPC/WS du moteur d'agents |
| `LLM_DEFAULT_PROVIDER_ENDPOINT` / `_API_KEY` / `_MODELS` | Fournisseur de modèles de chat (généralement Arona) |
| `BIGMODEL_API_KEY*` | Pipeline média (vision GLM / génération d'images CogView) |
| `CHANNEL_*` | Identifiants de canal IM par plateforme |
