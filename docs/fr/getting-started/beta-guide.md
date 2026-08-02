# Guide de la bêta fermée

La **bêta fermée interne** couvre la boucle produit complète, de l'inscription
du compte au contrôle industriel. La participation se fait uniquement sur
invitation.

## Ce que couvre la bêta

1. **Enregistrer un compte et créer une clé API** dans le panneau
   d'administration API cloud [Arona](https://github.com/celestia-island/arona).
   Le panneau est interne uniquement pendant la bêta (`arona:8420` sur l'hôte
   du déploiement).
2. **Déployer un modèle** et le lier à un backend de chat via le panneau.
3. **Chatter et exécuter des agents** depuis l'application de bureau
   [shittim-chest](https://github.com/celestia-island/shittim-chest) ;
   l'orchestration des agents est fournie par le runtime **scepter**
   d'entelecheia.
4. **Contrôle industriel** : les opérations à distance et le courtage de
   protocoles passent par [evernight](https://github.com/celestia-island/evernight).

## Obtenir l'accès

- L'accès est **sur invitation**. L'auto-inscription publique est fermée par
  défaut.
- Les invitations sont émises par les mainteneurs et liées à un seul compte.
- Pour les questions d'accès, contactez-nous via les canaux listés dans
  [Contribuer](../meta/CONTRIBUTING.md).

## Signaler des bugs

Signalez les problèmes sur GitHub, un problème par bug, en utilisant les
modèles d'issue :

| Produit | Dépôt |
| --- | --- |
| Chat desktop/web — shittim-chest | [celestia-island/shittim-chest](https://github.com/celestia-island/shittim-chest/issues) |
| Orchestration d'agents — entelecheia/scepter | [celestia-island/entelecheia](https://github.com/celestia-island/entelecheia/issues) |
| Contrôle industriel — evernight | [celestia-island/evernight](https://github.com/celestia-island/evernight/issues) |
| Panneau d'administration & plateforme — arona/plana | [celestia-island/arona](https://github.com/celestia-island/arona/issues) |

Incluez toujours : les informations d'environnement (OS, versions des
produits), les étapes pour reproduire, le comportement attendu par rapport au
comportement réel, et les journaux pertinents.

## Limitations connues

- Le panneau Arona est **interne uniquement** et n'est pas exposé publiquement
  pendant la bêta.
- L'inscription est fermée par défaut ; l'inscription ouverte n'est pas encore
  disponible.
- Le relais de dispositifs WebRTC et la télémétrie SCADA en direct exigent une
  instance scepter en fonctionnement ; sans elle, l'UI retombe sur des données
  de démo simulées.
- Les applications mobiles et les plugins IDE ne font pas partie de cette bêta.
- Certaines langues de documentation sont des traductions partielles.

## Pour aller plus loin

- [Démarrage rapide](./quickstart.md) — le parcours de 30 minutes à travers la boucle.
- [Pourquoi celestia-island](../philosophy/why.md) — la philosophie derrière la bêta.
