# Carte des projets

L'inventaire des dépôts et produits de la plateforme celestia-island, regroupés
par couche. Un nom accompagné d'un lien est un dépôt public que vous pouvez lire
dès aujourd'hui ; un nom sans lien est un produit livré avec la plateforme mais
dont la source n'est pas encore publique. Les dépôts marqués d'un site de
documentation portent leurs propres docs *how* ; tout le reste est documenté
dans le dépôt lui-même.

## Couche 0 — Auth

| Projet | Rôle | Docs |
| --- | --- | --- |
| [kirino](https://github.com/celestia-island/kirino) | Authentification et autorisation zero-trust : sessions, permissions, limitation de débit | [kirino.docs.celestia.world](https://kirino.docs.celestia.world) |

## Couche 1 — Plateforme

| Projet | Rôle | Docs |
| --- | --- | --- |
| [plana](https://github.com/celestia-island/plana) | Types de protocole partagés, transport, mesure et les infrastructures que chaque service consomme | dépôt |
| [provider-registry](https://github.com/celestia-island/provider-registry) | Catalogue de modèles et de fournisseurs partagé entre les produits | dépôt |

## Couche 2 — UI

| Projet | Rôle | Docs |
| --- | --- | --- |
| [hikari](https://github.com/celestia-island/hikari) | La bibliothèque de composants UI partagée par toutes les webUI | dépôt |

## Couche 3 — Services

| Projet | Rôle | Docs |
| --- | --- | --- |
| arona | Passerelle de modèles et panneau de déploiement : clés, backends, routage, usage | [Arona](../platforms/arona.md) |
| shittim-chest | Chat, panneaux et intégrations — la surface d'atelier | [Shittim Chest](../platforms/chest.md) |
| entelecheia | Plateforme d'agents : agents, mémoire long terme, recherche sémantique, intégration industrielle | [Entelecheia](../platforms/entelecheia.md) |
| evernight | Courtier de protocoles industriels : protocoles de terrain, alarmes, enregistrement, inférence en périphérie | [Evernight](../platforms/evernight.md) |
| [malkuth](https://github.com/celestia-island/malkuth) | Supervision de services : mises à jour progressives, sondes de santé, proxy inverse, récupération de crash | [malkuth.docs.celestia.world](https://malkuth.docs.celestia.world) |
| [lagrange](https://github.com/celestia-island/lagrange) | Le moteur de documentation derrière ce site et chaque site de docs de projet | [lagrange.docs.celestia.world](https://lagrange.docs.celestia.world) |
| celestia-erp | Back-office métier : organisations, facturation, factures | — |
| electrode_recon | Moteur de calcul de microstructure d'électrodes — la première instance externe sur le tissu moteur | — |

## Outils & bibliothèques

| Projet | Rôle | Docs |
| --- | --- | --- |
| [noa](https://github.com/celestia-island/noa) | Contrôle de version distribué natif agents avec espaces de travail isolés | [dépôt](https://github.com/celestia-island/noa) |
| [seia](https://github.com/celestia-island/seia) | Recherche web multi-moteurs | [seia.docs.celestia.world](https://seia.docs.celestia.world) |
| [aoba](https://github.com/celestia-island/aoba) | CLI de débogage et de simulation multi-protocoles (Modbus RTU et compagnie) | [aoba.docs.celestia.world](https://aoba.docs.celestia.world) |
| [ichika](https://github.com/celestia-island/ichika) | Pipelines à pool de threads sur des tubes de messages | dépôt |
| [yuuka](https://github.com/celestia-island/yuuka) | Macros pour structures imbriquées composées et fusion/patch JSON | dépôt |
| [kou](https://github.com/celestia-island/kou) | Moteur de terminal virtuel : PTY, VT100/ANSI, graphismes en ligne | dépôt |
| [hifumi](https://github.com/celestia-island/hifumi) | Sérialisation pour migrer des données entre versions | dépôt |
| [lacrymira](https://github.com/celestia-island/lacrymira) | Accès typé aux données SQL et KV derrière une seule surface de commandes | dépôt |
| [himari](https://github.com/celestia-island/himari) | Représentation intermédiaire de formules dimensionnées | dépôt |
| [kotama](https://github.com/celestia-island/kotama) | Boîte à outils de rétro-ingénierie : dissection, décompilation, références croisées | dépôt |
| [ayane](https://github.com/celestia-island/ayane) | Service de messagerie : plan de contrôle, webmail et protection | dépôt |
| [aris](https://github.com/celestia-island/aris) | Moteur de navigateur pure-Rust dérivé de servo, intégrable comme bibliothèque | dépôt |
| [shirabe](https://github.com/celestia-island/shirabe) | Automatisation et débogage de navigateur sans interface | dépôt |
| [tairitsu](https://github.com/celestia-island/tairitsu) | Framework full-stack sur le WASM Component Model | dépôt |
| [akivili](https://github.com/celestia-island/akivili) | Hôte de plugins et SDK pour extensions d'agents | dépôt |
| [celestia-plugin](https://github.com/celestia-island/celestia-plugin) | SDK de plugins et de moteurs Python | dépôt |
| [shun](https://github.com/celestia-island/shun) | Installateurs, programmeurs de flash et livraison de charges utiles en mode portable | dépôt |
| [ratatui-markdown](https://github.com/celestia-island/ratatui-markdown) | Rendu Markdown dans les interfaces terminal | dépôt |
| arcaea | Bibliothèque de protocole de persona | dépôt |
| scriptum | Interface terminal de la plateforme d'agents | — |
| official-plugins | Les paquets de plugins de première partie | dépôt |

## Périphérie & matériel

| Projet | Rôle | Docs |
| --- | --- | --- |
| [kei](https://github.com/celestia-island/kei) | Noyau Rust pour passerelles de périphérie ARM64 et RISC-V | dépôt |
| [hare](https://github.com/celestia-island/hare) | Bibliothèque de pont `no_std` pour nœuds industriels embarqués | dépôt |
| evernight-appliance | La distribution d'appliance : firmware de démarrage, programmeur de flash, contrat de pilotes | — |

## Infrastructure & outillage

| Projet | Rôle | Docs |
| --- | --- | --- |
| [celestia-devtools](https://github.com/celestia-island/celestia-devtools) | Chaîne d'outils de développement partagée : recettes de build, linting, portes de release | dépôt |
| [cherino](https://github.com/celestia-island/cherino) | Abstraction de conteneurs sandboxés pour l'exécution d'agents | dépôt |
| [celestia-artifacts](https://github.com/celestia-island/celestia-artifacts) | Hébergement public des binaires et images d'artefacts pour les releases | dépôt |
| celestia-integration | Tests d'intégration inter-dépôts pour la boucle entière | — |
| fuuka | Plan d'exécution CI auto-hébergée | — |
| [sysl](https://github.com/celestia-island/sysl) | La Synthetic Source License qu'utilise la majeure partie de ce code | dépôt |

## Présence web

| Propriété | Rôle | Docs |
| --- | --- | --- |
| [celestia-island.github.io](https://celestia-island.github.io) | Présence de l'organisation | dépôt |
| [docs.celestia.world](https://docs.celestia.world) | Ce site — philosophie, carte, bien démarrer | dépôt |
| [e.celestia.world](https://e.celestia.world) | Page d'accueil publique | dépôt |
| [dev.celestia.world](https://dev.celestia.world) | Panneau et tableau de bord développeur (sur invitation pendant la bêta) | dépôt |
| [celestia.ac.cn](https://celestia.ac.cn) | Site de la société et des services enterprise | dépôt |

## Pour aller plus loin

- [Architecture en couches](../philosophy/layered-architecture.md) — pourquoi ces couches existent.
- [La Boucle Fermée](../philosophy/closed-loop.md) — comment les projets coopèrent le long de la boucle.
- [Sites & Propriété](./sites.md) — qui documente quoi, et où.
