# Architecture en couches

L'écosystème reste gérable parce qu'il est strictement stratifié. Les
dépendances ne pointent que dans un sens : **les services en aval consomment les
capacités en amont ; une capacité générique n'est jamais réimplémentée.**

## Les quatre couches

| Couche | Projets | Ce qu'elles fournissent |
| --- | --- | --- |
| **Couche 0 — Auth** | [kirino](https://github.com/celestia-island/kirino) | Primitives zero-trust : signature et rafraîchissement JWT, hachage de mots de passe Argon2id, limitation de débit des connexions, moteur RBAC, registre d'invitations, sessions |
| **Couche 1 — Plateforme** | [plana](https://github.com/celestia-island/plana) | Infrastructures partagées : types et routage JSON-RPC 2.0, DTO de services, détection réseau, sessions SSE, circuit breakers, mesure et tarification LLM |
| **Couche 2 — UI** | [hikari](https://github.com/celestia-island/hikari) | Bibliothèque de composants UI (Vue/TS + Rust) partagée par toutes les webUI |
| **Couche 3 — Services** | [arona](https://github.com/celestia-island/arona), [shittim-chest](https://github.com/celestia-island/shittim-chest), [entelecheia](https://github.com/celestia-island/entelecheia), [evernight](https://github.com/celestia-island/evernight), [malkuth](https://github.com/celestia-island/malkuth), [lagrange](https://github.com/celestia-island/lagrange) | Logique métier uniquement. Ils consomment les couches 0 à 2 et ajoutent le comportement qui rend chaque produit réel |

## La doctrine

1. **Ne jamais implémenter deux fois.** Avant d'écrire du code, demandez :
   kirino l'a-t-il ? plana l'a-t-il ? hikari l'a-t-il ? Exemple : les types
   JSON-RPC viennent de plana, le JWT de kirino, la limitation de débit des
   connexions de kirino, les circuit breakers de plana, les DTO de santé de
   plana, la tarification de plana.
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
