# Infrastructure centrale — Auth, RPC et fondations

Toutes les plateformes que vous utilisez reposent sur la même fondation. Lisez
cette page une fois et les guides de plateforme s'assemblent d'eux-mêmes :
kirino (authentification zero-trust et RBAC), plana (types de protocole,
transport JSON-RPC, mesure, moteur de synchronisation) et hikari (la
bibliothèque de composants UI).

## Authentification et autorisation (kirino)

- **Identité** : hachage de mots de passe avec Argon2id ; jetons JWT
  d'accès/rafraîchissement (`TokenManager`, `kirino-session`) ; limitation de
  débit des connexions et verrouillage des comptes.
- **RBAC** : permissions hiérarchiques (agent.*, system.*, knowledge.*, …)
  résolues par un `GrantResolver` ; les rôles regroupent des permissions
  (admin voit tout, viewer est en lecture seule). Les affectations persistent
  dans Postgres.
- **Délégation** : scepter se fie à l'identifiant utilisateur de l'appelant
  fourni par la passerelle chest (`X-User-Id` / `user_id`) et ne l'utilise que
  pour l'isolation des espaces de travail — la couche qui authentifie est
  toujours en amont.
- **Surface d'administration** : les endpoints d'administration du panneau
  exigent un `ARONA_ADMIN_TOKEN` dédié et échouent en mode fail-closed sans
  lui.

## Protocole et RPC (plana)

- Tout le trafic de la plateforme est du **JSON-RPC 2.0 sur WebSocket** (et
  requête/réponse via HTTP POST `/api/rpc`). Les méthodes sont nommées
  `<Domaine>.<Action>` — par ex. `Sync.MemoryQueryRequest`, `Cli.Search`,
  `Mcp.CallTool`.
- Les types du protocole vivent dans plana (`plana-state-sync` /
  `plana-types`) : une seule source de vérité pour le protocole ; les dépôts
  en aval épinglent un tag publié.
- Les notifications (sans `id`) poussent des événements comme les fragments
  de streaming et les mises à jour du panneau ; les requêtes portent un `id`
  renvoyé en écho dans la réponse.
- Le moteur de synchronisation (`plana-sync`) est un arbre d'état autoritaire
  côté serveur : les clients déclarent des viewports, le serveur diffuse des
  diffs avec des instantanés complets périodiques.

## Mesure et tarification (plana)

L'usage est mesuré par clé API et tarifé depuis une table canonique (mesure
de `plana-llm-provider`) : jetons de prompts/completions, estimation des
coûts et application des quotas sont partagés entre les services.

## Composants UI (hikari)

La bibliothèque de composants Vue (`@celestia-island/hikari`) fournit les
boutons, badges, tableaux, modales et dialogues de confirmation utilisés par
chaque webUI ; les pages des plateformes les composent avec le shell UI de
plana. Les composants partagés doivent remonter ici plutôt que d'être
réimplémentés par dépôt.

## Règles de dépendances

- Couche 0 : kirino (auth) → Couche 1 : plana (protocole/fondations) →
  Couche 2 : hikari (UI) → Couche 3 : services (arona, chest, entelecheia,
  evernight).
- Les services n'implémentent que de la logique métier ; les capacités
  partagées viennent de l'amont. Les dépendances inter-dépôts utilisent des
  références git ou des tags épinglés — jamais de dépendances locales par
  chemin.
