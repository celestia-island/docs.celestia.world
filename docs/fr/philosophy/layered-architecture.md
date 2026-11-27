# Architecture en couches

L'écosystème reste gérable parce qu'il est strictement stratifié. Les
dépendances ne pointent que dans un sens : **les services en aval consomment les
capacités en amont ; une capacité générique n'est jamais réimplémentée.**

## Les quatre couches

| Couche | Projets | Ce qu'elles fournissent |
| --- | --- | --- |
| **Couche 0 — Auth** | [kirino](https://github.com/celestia-island/kirino) | Identité zero-trust : authentification, sessions, permissions |
| **Couche 1 — Plateforme** | [plana](https://github.com/celestia-island/plana) | Types de protocole partagés, transport et les infrastructures dont chaque service a besoin |
| **Couche 2 — UI** | [hikari](https://github.com/celestia-island/hikari) | La bibliothèque de composants partagée par toutes les webUI |
| **Couche 3 — Services** | arona, shittim-chest, entelecheia, evernight, [malkuth](https://github.com/celestia-island/malkuth), [lagrange](https://github.com/celestia-island/lagrange) | Logique métier uniquement. Ils consomment les couches 0 à 2 et ajoutent le comportement qui rend chaque produit réel |

## La doctrine

1. **Ne jamais implémenter deux fois.** Avant d'écrire du code, demandez :
   kirino l'a-t-il ? plana l'a-t-il ? hikari l'a-t-il ? Un service qui
   réimplémente une capacité amont est un défaut, pas une fonctionnalité.
2. **La capacité générique va en amont.** Une fonctionnalité que deux services
   ou plus réutiliseront est d'abord construite dans kirino, plana ou hikari,
   puis consommée.
3. **Pas de dépendances inverses.** Les services dépendent de kirino/plana/hikari ;
   plana peut dépendre de kirino ; kirino ne dépend jamais de plana ni de hikari.
4. **Étendre l'amont avant de consommer.** Si l'amont manque d'une capacité
   nécessaire, étendez l'amont, puis consommez. Une nouvelle capacité n'est
   jamais prototypée dans un service et réimplémentée plus tard.
5. **Les dépendances inter-dépôts sont des références git.** Tous les dépôts
   consomment l'amont via des références git vers la branche `master` (ou des
   versions épinglées), jamais de dépendances locales par chemin. Chaque dépôt
   se compile de manière identique sur chaque machine.

## Pourquoi c'est important

- **Un correctif se propage.** Un correctif de sécurité dans kirino atteint
  chaque service avec un bump de dépendance, pas une chasse aux
  réimplémentations.
- **La relecture est proportionnelle au risque.** Les changements de couche 3
  sont de la logique produit ; les changements de couche 0 sont de
  l'infrastructure — le niveau d'exigence de relecture le reflète.
- **La carte reste lisible.** Les nouveaux ingénieurs lisent cette page et
  savent où vit chaque capacité. La [Carte des projets](../ecosystem/projects.md)
  est l'inventaire complet.

## Pour aller plus loin

- [Pourquoi celestia-island](./why.md) — le problème derrière la stratification.
- [Principes de sécurité](./safety.md) — la doctrine posée au-dessus des couches.
- [Carte des projets](../ecosystem/projects.md) — chaque dépôt, par couche.
