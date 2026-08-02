# Carte des projets

L'inventaire complet des dépôts de celestia-island, regroupés par couche. Les
dépôts marqués d'un site de documentation portent leurs propres docs *how* sur
`<name>.docs.celestia.world` ; tout le reste est documenté dans son dépôt.

## Couche 0 — Auth

| Projet | Rôle | Docs |
| --- | --- | --- |
| [kirino](https://github.com/celestia-island/kirino) | Authentification zero-trust et RBAC : sessions JWT, hachage Argon2id, limitation de débit des connexions, moteur de permissions | [kirino.docs.celestia.world](https://kirino.docs.celestia.world) |

## Couche 1 — Plateforme

| Projet | Rôle | Docs |
| --- | --- | --- |
| [plana](https://github.com/celestia-island/plana) | Types partagés, client et serveur JSON-RPC, sessions SSE, circuit breakers, mesure et tarification LLM, coquille d'UI d'administration | dépôt |
| [provider-registry](https://github.com/celestia-island/provider-registry) | Registre de modèles et de fournisseurs (format TOML d'entrée) | dépôt |

## Couche 2 — UI

| Projet | Rôle | Docs |
| --- | --- | --- |
| [hikari](https://github.com/celestia-island/hikari) | Bibliothèque de composants UI (Vue/TS + Rust) partagée par toutes les webUI | dépôt |

## Couche 3 — Services

| Projet | Rôle | Docs |
| --- | --- | --- |
| [arona](https://github.com/celestia-island/arona) | Panneau d'administration API cloud : comptes, clés API, déploiement de modèles, backends, enregistrements d'usage | dépôt |
| [shittim-chest](https://github.com/celestia-island/shittim-chest) | Chat desktop/webUI et shell | [shittim-chest.docs.celestia.world](https://shittim-chest.docs.celestia.world) |
| [entelecheia](https://github.com/celestia-island/entelecheia) | Plateforme de collaboration multi-agents : microkernel exec-only, serveur d'orchestration scepter, pipeline d'exécution IEPL | [entelecheia.docs.celestia.world](https://entelecheia.docs.celestia.world) |
| [evernight](https://github.com/celestia-island/evernight) | Courtier de protocoles industriels : Modbus, S7comm, OPC UA ; opérations à distance, télémétrie, portes d'écriture | [evernight.docs.celestia.world](https://evernight.docs.celestia.world) |
| [malkuth](https://github.com/celestia-island/malkuth) | Boîte à outils de supervision de services : mises à jour progressives, sondes de santé, proxy inverse, récupération de boucles de crash | [malkuth.docs.celestia.world](https://malkuth.docs.celestia.world) |
| [lagrange](https://github.com/celestia-island/lagrange) | Moteur de documentation Markdown qui alimente ce site et tous les sites de docs de projets | [lagrange.docs.celestia.world](https://lagrange.docs.celestia.world) |

## Outils & bibliothèques

| Projet | Rôle | Docs |
| --- | --- | --- |
| [noa](https://github.com/celestia-island/noa) | Contrôle de version distribué natif IA : isolation d'espace de travail par agent, journaux JSONL append-only, historique par snapshots | [noa.docs.celestia.world](https://noa.docs.celestia.world) |
| [seia](https://github.com/celestia-island/seia) | Bibliothèque de recherche web multi-moteurs et CLI | [seia.docs.celestia.world](https://seia.docs.celestia.world) |
| [ichika](https://github.com/celestia-island/ichika) | Macros de pipelines à pool de threads (tubes de messages basés sur flume) | [ichika.docs.celestia.world](https://ichika.docs.celestia.world) |
| [yuuka](https://github.com/celestia-island/yuuka) | Proc-macro pour générer des structures imbriquées complexes depuis une simple macro | [yuuka.docs.celestia.world](https://yuuka.docs.celestia.world) |
| [aoba](https://github.com/celestia-island/aoba) | CLI Modbus et sources de données | [aoba.docs.celestia.world](https://aoba.docs.celestia.world) |
| [kou](https://github.com/celestia-island/kou) | Moteur de terminal virtuel autonome : gestion PTY, VT100/ANSI | dépôt |
| [hifumi](https://github.com/celestia-island/hifumi) | Bibliothèque de sérialisation pour migrer des données entre versions | dépôt |
| [aris](https://github.com/celestia-island/aris) | Moteur de navigateur dérivé de servo, intégrable comme bibliothèque (WebGL pour les jumeaux numériques) | dépôt |
| [shirabe](https://github.com/celestia-island/shirabe) | Bibliothèque légère d'automatisation et de débogage de navigateur native Rust | dépôt |
| [tairitsu](https://github.com/celestia-island/tairitsu) | Framework full-stack propulsé par le WASM Component Model | dépôt |
| [ratatui-markdown](https://github.com/celestia-island/ratatui-markdown) | Rendu Markdown pour les TUI ratatui | dépôt |
| [arcaea](https://github.com/celestia-island/arcaea) | Bibliothèque Rust pour le protocole de persona celestia | dépôt |
| [scriptum](https://github.com/celestia-island/scriptum) | Interface terminal (TUI) pour entelecheia : un « écran muet » qui parle au serveur scepter | dépôt |

## Périphérie & matériel

| Projet | Rôle | Docs |
| --- | --- | --- |
| [kei](https://github.com/celestia-island/kei) | Noyau de système d'exploitation Rust pour dispositifs de périphérie ARM64/RISC-V ; noyau temps réel déterministe pour le long horizon | dépôt |

## Infrastructure & outillage

| Projet | Rôle | Docs |
| --- | --- | --- |
| [celestia-devtools](https://github.com/celestia-island/celestia-devtools) | Chaîne d'outils de développement partagée : recettes justfile, enregistrement de patches, linting | dépôt |
| [celestia-integration](https://github.com/celestia-island/celestia-integration) | Suites de tests d'intégration sur matériel réel pour la boucle entière | dépôt |
| [sysl](https://github.com/celestia-island/sysl) | Synthetic Source License (SySL) : une licence conçue pour le code généré par IA | dépôt |

## Présence web

| Propriété | Rôle | Docs |
| --- | --- | --- |
| [celestia-island.github.io](https://celestia-island.github.io) | Présence de l'organisation | dépôt |
| [docs.celestia.world](https://docs.celestia.world) | Ce site — philosophie, carte, bien démarrer | dépôt |
| [e.celestia.world](https://e.celestia.world) | Page d'accueil publique | dépôt |
| [dev.celestia.world](https://dev.celestia.world) | Portail développeur | dépôt |
| [arona.celestia.world](https://arona.celestia.world) | Panneau d'administration API cloud (produit) | — |

## Pour aller plus loin

- [Architecture en couches](../philosophy/layered-architecture.md) — pourquoi ces couches existent.
- [La Boucle Fermée](../philosophy/closed-loop.md) — comment les projets coopèrent le long de la boucle.
- [Sites & Propriété](./sites.md) — qui documente quoi, et où.
