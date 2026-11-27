# Récit & Horizon

## La forme du problème

Nous ne construisons pas un chatbot sur lequel on a greffé un panneau de
contrôle, et nous ne construisons pas un système de contrôle sur lequel on a
greffé un modèle de langage. Les deux moitiés doivent former un seul système,
car dès l'instant où un modèle peut déplacer un équipement physique, chaque
agrément d'un produit de chat devient une contrainte d'un système de contrôle :
un comportement déterministe, une latence bornée, un journal d'audit et un
moyen de dire non.

L'argument complet se trouve dans [Pourquoi celestia-island](./why.md). Cette
page présente la trajectoire qui en découle.

## Où cela mène

**Plus près de la machine.** Aujourd'hui, la boucle va du navigateur web d'un
opérateur à un courtier de protocoles, puis à un automate. Chaque étape plus
proche du matériel contient moins de modèle et moins de réseau, jusqu'à une
boucle qui s'exécute localement et n'attend aucun aller-retour. Cet ordre est
tout l'enjeu : les parties qui ne doivent pas échouer sont celles qui
n'appellent jamais l'extérieur.

**L'autonomie locale comme perspective.** Ce même ordre se généralise partout
où un aller-retour coûte cher — un site distant, une liaison intermittente,
une usine dont l'opérateur n'est pas sur le terrain. Les machines qui ne
peuvent pas attendre un humain doivent décider localement, en toute sécurité et
de manière prévisible : avec l'autorité d'agir et la discipline de refuser.
C'est une direction de long terme, pas un plan daté, et c'est pourquoi la couche
de décision, le modèle du monde et la porte de sécurité sont construits comme
des choses séparées plutôt que comme un monolithe.

**Réutilisable par construction.** Quelle que soit la forme du prochain
déploiement, il devrait être assemblé à partir de la même base d'actifs plutôt
que reconstruit : le protocole filaire, l'état du monde, les portes de sécurité
et le pipeline d'enregistrement sont des actifs partagés. Une piste qui en
démarre un nouveau doit passer une revue d'architecture. Et aucune gamme de
produits ne dépend jamais d'un cœur non publié — si le cœur glisse, le chiffre
d'affaires ne suit pas.

## Ce qui ne bouge pas

Quel que soit l'horizon, trois choses ne bougent pas :

- **La sécurité avant l'autonomie.** Un système autonome qui ne sait pas
  refuser n'est pas autonome, il est sans garde-fou. Voir
  [Principes de sécurité](./safety.md).
- **La boucle reste entière.** Chaque capacité n'est réelle qu'à travers la
  boucle fermée à laquelle elle appartient — voir
  [La Boucle Fermée](./closed-loop.md).
- **La structure passe en premier.** L'ordre entre des dizaines de dépôts vient
  de la stratification, pas de la discipline du moment — voir
  [Architecture en couches](./layered-architecture.md).

## Pour aller plus loin

- [Pourquoi celestia-island](./why.md) — l'énoncé du problème derrière l'horizon.
- [Principes de sécurité](./safety.md) — la sémantique temps réel sur laquelle repose le récit.
- [Carte des projets](../ecosystem/projects.md) — où vit le travail de chaque piste aujourd'hui.
