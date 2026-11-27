# Téléchargements

Ce que vous installez dépend de votre place dans la boucle fermée. Pendant la
bêta interne, la plupart des participants n'ont besoin que de l'application de
bureau ; tout le reste est hébergé par votre administrateur ou optionnel.

## Application de bureau (shittim-chest)

L'application de bureau shittim-chest est publiée à chaque tag `v*`. Les
installateurs ne sont **pas signés** — attendez-vous à un avertissement de
sécurité de l'OS au premier lancement. La page de téléchargement reste vide
tant que le premier tag de bêta n'a pas été poussé.

| Plateforme | Asset |
| --- | --- |
| Linux | `.AppImage` ou `.deb` |
| Windows 10+ | `.exe` (NSIS) ou `.msi` |
| macOS | pas encore publié |

Les builds de release couvrent Linux et Windows uniquement ; macOS ne fait pas
partie du pipeline de release. En attendant la première release (ou si vous
préférez ne rien installer), utilisez la
[webUI](https://dev.celestia.world) de shittim-chest.

## Panneau d'administration (arona)

Arona est hébergé côté serveur — il n'y a rien à installer localement. Ouvrez
l'URL du panneau fournie par votre administrateur et connectez-vous avec votre
invitation.

## Runtime d'agents (optionnel)

Les utilisateurs qui exécutent eux-mêmes la plateforme d'agents utilisent
l'installateur unifié de
[plana](https://github.com/celestia-island/plana/tree/master/scripts/install)
([Linux/macOS](https://github.com/celestia-island/plana/blob/master/scripts/install/celestia-install.sh),
[Windows](https://github.com/celestia-island/plana/blob/master/scripts/install/celestia-install.ps1)).
Tout est construit à partir des dépôts de l'écosystème lui-même, donc les
prérequis sont une chaîne d'outils Rust, Docker et le lanceur de tâches `just`.

## Pour aller plus loin

- [Démarrage rapide](./quickstart.md) — le parcours de 30 minutes à travers la boucle.
- [Guide de la bêta fermée](./beta-guide.md) — ce que couvre la bêta et comment signaler les bugs.
- [Carte des projets](../ecosystem/projects.md) — la liste complète des projets.
