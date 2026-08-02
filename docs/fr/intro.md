# Bienvenue sur celestia-island

**celestia-island** est une suite de projets pour le contrôle industriel par IA :
collaboration multi-agents, opérations à distance et automatisation critique pour
la sécurité. Ce site en est le *pourquoi* — la philosophie, la carte de
l'écosystème et le point d'entrée. Le *comment* vit dans les sites de
documentation par projet auxquels renvoient les liens depuis cette page.

## Répondre à trois questions

| Question | Où | Ce que vous y trouverez |
| --- | --- | --- |
| **Pourquoi cela existe-t-il ?** | [Philosophie](./philosophy/why.md) | Le problème que nous résolvons, la boucle fermée, la doctrine de sécurité et l'horizon à long terme |
| **Qu'y a-t-il à l'intérieur ?** | [Écosystème](./ecosystem/projects.md) | Chaque projet, son rôle dans la boucle et l'emplacement de sa documentation |
| **Comment commencer ?** | [Bien démarrer](./getting-started/quickstart.md) | Le parcours de 30 minutes du compte à un agent de chat fonctionnel et au contrôle industriel |

## Le résumé en un paragraphe

celestia-island construit la **boucle fermée** de la découverte à la vérification
pour le contrôle industriel piloté par IA : découvrir → installer →
s'authentifier → déployer un modèle → chatter et exécuter des agents → contrôler
des équipements industriels → tout vérifier. La boucle est assemblée à partir de
briques petites et strictement stratifiées : primitives d'authentification
([kirino](https://github.com/celestia-island/kirino)), infrastructures de
plateforme ([plana](https://github.com/celestia-island/plana)), composants UI
([hikari](https://github.com/celestia-island/hikari)) et services qui
n'implémentent que la logique métier
([arona](https://github.com/celestia-island/arona),
[shittim-chest](https://github.com/celestia-island/shittim-chest),
[entelecheia](https://github.com/celestia-island/entelecheia),
[evernight](https://github.com/celestia-island/evernight)). Rien n'est jamais
implémenté deux fois : la capacité générique est construite une seule fois en
amont, puis consommée par chaque service en aval.

La raison de tout cela est une observation simple : sur la Lune, un aller-retour
de signal prend 2,6 secondes ; sur Mars, de 6 à 44 minutes. Les robots là-bas ne
peuvent pas attendre un humain sur Terre — ils doivent être autonomes
localement. La couche de décision, le modèle du monde et les portes de sécurité
que nous construisons aujourd'hui pour le contrôle industriel ont la même forme
que ce dont l'autonomie aura besoin demain.

## Où tout se trouve

- **Documentation par projet** — `<name>.docs.celestia.world`, générée depuis
  chaque dépôt. Retrouvez la liste complète dans
  [Sites & Propriété](./ecosystem/sites.md).
- **Présence de l'organisation** —
  [celestia-island sur GitHub](https://github.com/celestia-island).
- **Panneaux produits (WIP pendant la bêta)** — [arona](https://arona.celestia.world)
  (admin API cloud), [dev](https://dev.celestia.world) (portail développeur) ; le
  panneau en direct tourne en interne sur `arona:8420` jusqu'à la fin de la bêta.

Utilisez le sélecteur de langue (en bas à droite) pour lire ce site dans une
autre langue. Le contenu est rédigé en anglais ; les traductions suivent la même
structure.
