# Web UI — le voyage depuis votre première phrase

Deux surfaces, un seul flux : **arona** est le plan de contrôle headless (modèles,
clés, registre, mémoire) ; **shittim-chest** est l'atelier que vous avez réellement
sous les yeux (chat, panneaux, vision du monde). Chaque écran ci-dessous est une
vue de l'atelier — l'atelier dialogue avec arona via sa surface RPC ; arona
lui-même n'embarque aucune UI.

![Console backend de l'atelier](https://raw.githubusercontent.com/celestia-island/docs.celestia.world/master/res/screenshots/arona-dashboard.png)

## Modèles : de la source à l'invocation

Un modèle passe d'« existant » à « prêt pour le chat » en quatre étapes : **source**
(le catalogue des fournisseurs — des métadonnées, pas d'inférence) →
**enregistrement** (un backend `ollama` ou `external` compatible OpenAI, persisté
entre les redémarrages) → **déploiement** (la page Agents remet un identifiant de
modèle à un nœud `arona-agent` ; un nom de modèle vide choisit automatiquement le
nœud le moins chargé) → **routage** (la page Modèles ; équilibrage de charge au
moindre nombre de requêtes en cours, avec affinité de session). Les backends
externes restent en mode fail-closed tant que la première sonde n'a pas réussi.
L'API exacte de chaque étape se trouve dans les
[docs d'arona](https://arona.docs.celestia.world).

## Identité et comptage

![Clés API de l'atelier](https://raw.githubusercontent.com/celestia-island/docs.celestia.world/master/res/screenshots/arona-apikeys.png)

![Facturation de l'atelier](https://raw.githubusercontent.com/celestia-island/docs.celestia.world/master/res/screenshots/arona-billing.png)

Les **clés API** sont votre identité — la passerelle authentifie `/v1/*` par jetons
Bearer, et `curl` comme l'atelier en présentent une à l'entrée. **Usage** est un
registre, appel par appel et par clé : jetons, modèle, backend, coût. Les paliers
de **facturation** fixent des quotas (USD / jetons / limites de débit) ; en
atteindre un vaut refus net, pas ralentissement.

## Chat et mémoire

![Chat de l'atelier](https://raw.githubusercontent.com/celestia-island/docs.celestia.world/master/res/screenshots/arona-playground.png)

Chaque tour de conversation passe par le service de mémoire — le badge sur chaque
tour vous dit si c'est le cas. `Memory on` signifie que les mémoires long terme
pertinentes ont été injectées avant le routage ; `Memory offline` signifie que le
service de mémoire est injoignable (un signal d'honnêteté, pas un bug) ;
`disabled` signifie que rien de pertinent n'a été trouvé. Les tours terminés sont
extraits en épisodes et persistés, ainsi la mémoire survit aux redémarrages — et
les entrées de réécriture peuvent être supprimées directement depuis la page
Mémoire.

## Panneaux et contrôle industriel

![Agents de l'atelier](https://raw.githubusercontent.com/celestia-island/docs.celestia.world/master/res/screenshots/arona-agents.png)

Un prompt crée un panneau ; le moteur génère la disposition et la persiste dans le
stockage d'espace de travail de scepter. L'édition est structurelle — liaisons de
sources de données, listes de composants, états de connexion — pas une boîte
noire. Topologie et Holographique sont deux vues de la même flotte ; Rapports
ajoute la recherche sémantique sur l'historique. Les écritures industrielles
passent la validation des politiques et l'**approbation humaine** avant que quoi
que ce soit ne bouge : la fin de la boucle fermée, et sa plus lourde étape.

![Connexion à l'atelier](https://raw.githubusercontent.com/celestia-island/docs.celestia.world/master/res/screenshots/arona-login.png)

## Pour aller plus loin

- La référence complète de la plateforme arona — [arona docs](https://arona.docs.celestia.world)
- L'atelier chest et ses panneaux — [shittim-chest docs](https://shittim-chest.docs.celestia.world)
- Agents, espaces de travail et porte d'écriture industrielle — [entelecheia docs](https://entelecheia.docs.celestia.world)
