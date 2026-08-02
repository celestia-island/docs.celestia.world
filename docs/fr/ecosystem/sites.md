# Sites & Propriété

La documentation de cet écosystème suit une règle : **le hub explique pourquoi
et où ; chaque site de projet explique comment.** Cela garde le hub petit et les
sites de projets autoritaires.

## Qui possède quoi

| Site | Possède | Contenu |
| --- | --- | --- |
| [docs.celestia.world](https://docs.celestia.world) | l'écosystème | Philosophie, carte de l'écosystème, bien démarrer, gouvernance (licence, CLA, CoC, sécurité, contribution) |
| `<name>.docs.celestia.world` | chaque projet | Guides, architecture, designs, références — construits depuis le dépôt du projet lui-même |
| [celestia-island.github.io](https://celestia-island.github.io) | l'organisation | Présence, liens, actifs de marque |
| [e.celestia.world](https://e.celestia.world) | la face publique | Page d'accueil, tarification, blog, appel à l'action |
| [dev.celestia.world](https://dev.celestia.world) | les développeurs | Portail développeur et statut |

## La règle : pas de duplication

- Le hub **ne copie jamais** la documentation des projets. Si un sujet
  appartient à un projet (comment fonctionne un protocole, comment configurer
  un service), le hub renvoie au site du projet au lieu d'en faire un résumé.
- Les sites de projets **peuvent renvoyer** vers le hub pour la philosophie et
  le contexte inter-projets.
- Quand un projet est assez important pour tenir sa propre documentation, le
  hub réduit sa couverture à une entrée de carte plus des liens.

## Comment les sites sont construits

Chaque site de docs (celui-ci inclus) est construit avec
[lagrange](https://github.com/celestia-island/lagrange) à partir du Markdown du
dépôt du projet, avec un sélecteur de langue partagé. Le contenu est rédigé en
anglais ; les traductions suivent la même structure et sont marquées quand
elles sont partielles.

## Pour aller plus loin

- [Carte des projets](./projects.md) — quels sites existent et pour quels projets.
- [Contribuer](../meta/CONTRIBUTING.md) — comment contribuer à la documentation.
