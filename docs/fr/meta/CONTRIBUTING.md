# Contribuer à Celestia Island

Merci de votre intérêt pour la contribution ! Celestia Island est une famille de projets couvrant l'ensemble de la plateforme — kirino (auth), plana (plateforme), hikari (UI), la couche de services, ainsi que les webUI et les sites qui les entourent. Ce guide décrit la politique de contribution partagée par l'ensemble du groupe de projets ; les instructions de build et de développement d'un projet donné se trouvent dans le dépôt et le site de documentation de ce projet.

## Politique de contribution (à lire en premier)

Le groupe est construit comme des couches à criticité mixte — Couche 0 (kirino, auth), Couche 1 (plana, plateforme), Couche 2 (hikari, UI) et les services de la Couche 3 par-dessus — si bien que **la justesse, la compatibilité ascendante et la stabilité priment sur le débit de contribution**. Merci de lire cette section avant d'ouvrir une pull request.

- **Seuil de fusion élevé, pas une feuille de route publique.** Ouvrir une pull request ne garantit nullement sa fusion. Nous n'acceptons qu'un nombre volontairement restreint de changements, et uniquement lorsqu'ils s'inscrivent dans l'architecture et passent la revue. C'est un choix délibéré, pas de l'impolitesse.
- **Ce que nous accueillons volontiers :** les rapports de bugs, les correctifs ciblés, les fonctionnalités et les champs de protocole additifs (sans rupture), l'amélioration de la documentation, et les discussions de conception avant le code.
- **Ce que nous ne fusionnerons généralement pas :** les réécritures massives non sollicitées, les changements cassants des contrats partagés et des surfaces de protocole (par exemple les types du protocole JSON-RPC 2.0 partagés par toute la plateforme Entelecheia), les changements d'architecture sans discussion de conception préalable, les pull requests massives « vibe-coded », et tout ce qui abaisse le niveau de compatibilité, de sûreté ou de sécurité d'une couche inférieure.
- **Cœur vs périphérie.** Le cœur d'authentification zero-trust, les types de plateforme partagés et la bibliothèque de composants UI partagée sont soumis au niveau d'exigence le plus strict et maintenus par l'équipe centrale ; toute proposition de changement doit y commencer comme une discussion de conception.
- **CLA obligatoire.** Toute contribution acceptée exige un Accord de licence contributeur signé. Voir [`CLA.md`](cla.md). Les commits doivent porter une ligne `Signed-off-by` (`git commit -s`).

> **La licence peut s'ouvrir ; le seuil de fusion, lui, ne bougera pas.** Au **2030-01-01**, les projets du groupe passent de BUSL-1.1 à Apache-2.0 ou MIT (au choix du destinataire) — voir [`LICENSE`](../../../LICENSE). Cela élargit *ce que vous pouvez faire du code* ; cela **n'abaisse** pas le niveau d'examen, ne supprime pas la CLA et ne signifie pas que nous acceptons davantage de pull requests. La politique de contribution reste inchangée avant et après la date de changement.

## Sécurité

N'ouvrez **pas** d'issue publique pour signaler une vulnérabilité de sécurité. Signalez-la de manière confidentielle via les GitHub Security Advisories du dépôt concerné, ou par courriel à <security@celestia.world>. Voir [`SECURITY.md`](security.md).

## Code de conduite

Soyez respectueux, constructifs et inclusifs. Nous suivons le [Code de conduite du Contributor Covenant](code-of-conduct.md).

## Premiers pas

Choisissez le dépôt sur lequel vous souhaitez travailler et suivez son README et son site de documentation. Les projets Rust se vérifient avec `cargo fmt`, `cargo clippy -D warnings` et `cargo test` ; les projets web avec `pnpm lint`, `pnpm build` et `pnpm test`. La [carte de l'écosystème](../ecosystem/sites.md) recense chaque projet et l'endroit où vit sa documentation.

## Processus de pull request

1. Forkez et créez une branche depuis la branche par défaut du dépôt.
1. Discutez d'abord des changements importants ou touchant des contrats partagés dans une issue.
1. Faites des commits atomiques : chaque sujet de commit est constitué d'un seul gitmoji suivi d'une phrase anglaise commençant par une majuscule et terminée par un point, les détails figurant dans le corps du commit.
1. Assurez-vous que les vérifications du projet passent avant de pousser.
1. Signez la CLA et ajoutez `Signed-off-by` à chaque commit.
1. Traitez les retours de revue ; réservez les force-push au seul rebase.

## Licence et CLA

Les projets de ce groupe sont concédés sous la **Business Source License 1.1 (BUSL-1.1)** avec une **date de changement** fixée au **2030-01-01**, à laquelle chacun passe, au choix du destinataire, à **Apache-2.0 ou MIT**. Pour les usages internes, académiques, gouvernementaux, éducatifs et non commerciaux, ils sont déjà aujourd'hui équivalents à Apache-2.0 ou MIT (voir l'Additional Use Grant dans le fichier [`LICENSE`](../../../LICENSE) de chaque dépôt). Les usages commerciaux restreints (hébergement, revente ou exploitation sous une autre marque en tant que service) exigent une licence commerciale distincte jusqu'à la date de changement.

En contribuant, vous acceptez que vos contributions soient concédées sous la licence du projet et que vous signiez la CLA ([`CLA.md`](cla.md)). La CLA accorde au projet une licence permissive **incluant le droit de changer de licence**, afin que les projets puissent conserver leur cheminement BUSL→Apache/MIT et adapter leur licence à l'avenir.

## Pour aller plus loin

- [CLA](cla.md) — l'Accord de licence contributeur que vous signez.
- [Politique de sécurité](security.md) — comment signaler une vulnérabilité de manière confidentielle.
- [Code de conduite](code-of-conduct.md) — le comportement que nous nous tenons d'appliquer les uns envers les autres.
- [Carte de l'écosystème](../ecosystem/sites.md) — chaque projet, chaque site, et l'endroit où vit sa documentation.
