# La Boucle Fermée

Le produit est la boucle, pas un projet isolé :

> découvrir → installer → s'authentifier → déployer un modèle → chatter et
> exécuter des agents → contrôler des équipements industriels → vérifier et
> assister

Chaque segment est détenu par un ensemble précis de projets. Si un segment est
rompu, la plateforme n'est pas terminée.

## Segment par segment

| # | Segment | Ce qui se passe | Projets |
| --- | --- | --- | --- |
| 1 | **Découvrir** | Un utilisateur potentiel découvre l'écosystème, comprend sa philosophie et choisit un point d'entrée | [docs.celestia.world](https://docs.celestia.world) (ce site), [celestia-island.github.io](https://celestia-island.github.io), [e.celestia.world](https://e.celestia.world) |
| 2 | **Installer** | L'utilisateur obtient un système opérationnel : panneau d'administration, shell de bureau/web, services supervisés | [arona](https://github.com/celestia-island/arona) (panneau d'administration API cloud), [shittim-chest](https://github.com/celestia-island/shittim-chest) (chat desktop/webUI), [malkuth](https://github.com/celestia-island/malkuth) (supervision de services) |
| 3 | **S'authentifier** | Identité zero-trust : inscription (sur invitation), connexion avec limitation de débit, clés API, RBAC | [kirino](https://github.com/celestia-island/kirino) (primitives d'authentification et moteur RBAC) |
| 4 | **Déployer un modèle** | Choisir un runtime de modèle, le déployer sur un nœud, le lier à un backend de chat, mesurer l'usage | [arona](https://github.com/celestia-island/arona) (panneau + backends), [entelecheia](https://github.com/celestia-island/entelecheia) (runtime scepter), [plana](https://github.com/celestia-island/plana) (mesure et tarification) |
| 5 | **Chat & agents** | Discuter avec les modèles, exécuter des collaborations multi-agents, conserver les conversations, gérer la mémoire | [shittim-chest](https://github.com/celestia-island/shittim-chest) (UI et chat), [entelecheia](https://github.com/celestia-island/entelecheia) (orchestration d'agents), [noa](https://github.com/celestia-island/noa) (contrôle de version natif IA) |
| 6 | **Contrôle industriel** | Opérations à distance et courtage de protocoles : Modbus, S7comm, OPC UA ; télémétrie et portes d'écriture | [evernight](https://github.com/celestia-island/evernight) (courtier de protocoles), [aoba](https://github.com/celestia-island/aoba) (CLI Modbus et sources de données) |
| 7 | **Vérifier & assister** | Tests d'intégration sur matériel réel, supervision et auto-réparation, enregistrements d'usage, canaux de retour | [celestia-integration](https://github.com/celestia-island/celestia-integration), [malkuth](https://github.com/celestia-island/malkuth), [plana](https://github.com/celestia-island/plana) (enregistrements d'usage) |

## Comment la boucle se comporte

- **Chaque étape est testable.** Chaque segment a un test d'acceptation défini
  dans [celestia-integration](https://github.com/celestia-island/celestia-integration) ;
  une release n'est pas verte tant que la boucle entière ne passe pas sur des
  nœuds réels.
- **Chaque étape est observable.** Supervision, endpoints de santé et
  enregistrements d'usage rendent l'état de chaque segment visible plutôt que
  supposé.
- **Pas de dégradation silencieuse.** Quand un segment se dégrade (par exemple
  la mémoire hors ligne ou un backend injoignable), la réponse API et l'UI le
  disent explicitement. Les échecs sont bruyants par conception.
- **La sécurité n'est pas un segment.** Les portes d'écriture, la validation
  des politiques et la confirmation humaine sont tissées dans les segments 5 et
  6, pas ajoutées à la fin. Voir [Principes de sécurité](./safety.md).

## Pour aller plus loin

- [Pourquoi celestia-island](./why.md) — le problème qui définit la boucle.
- [Architecture en couches](./layered-architecture.md) — comment les pièces restent ordonnées.
- [Carte des projets](../ecosystem/projects.md) — l'inventaire complet des dépôts.
- [Démarrage rapide](../getting-started/quickstart.md) — parcourez la boucle en 30 minutes.
