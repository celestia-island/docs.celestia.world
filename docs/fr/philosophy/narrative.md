# Récit & Horizon

## La latence, c'est le destin

Un aller-retour de signal prend **2,6 secondes** vers la Lune et **de 6 à 44
minutes** vers Mars. Les machines aussi éloignées de la Terre ne peuvent pas
attendre les instructions d'un humain. Elles doivent prendre des décisions
**localement, en toute sécurité et de manière prévisible** — avec l'autorité
d'agir et la discipline de refuser.

C'est l'horizon vers lequel cet écosystème est construit. Tout ce que nous
construisons aujourd'hui pour le contrôle industriel est choisi pour avoir la
*même forme* que ce dont un robot lunaire ou martien autonome aura besoin :

- une **couche de décision d'agents** qui planifie et orchestre
- un **modèle du monde** qui sait ce qui se passe à l'instant présent
- une **porte de sécurité** qui peut dire non, appuyée par un contrôle temps
  réel qui ne dépend jamais du réseau

La Lune n'est pas une histoire marketing : c'est la raison pour laquelle la
stratification existe.

## La feuille de route

L'écosystème avance par étapes — une phase n'est débloquée que lorsque la
précédente remplit ses critères de sortie :

| Phase | Cible | Critères de sortie |
| --- | --- | --- |
| **Bêta interne** | maintenant | Zéro problème de sécurité P0 ; la boucle entière passe les tests d'intégration ; un nouvel utilisateur parcourt compte → clé → chat en 30 minutes |
| **Bêta publique** | 2026 | Inscription ouverte ; documentation publique, téléchargements et pages légales ; revue de sécurité indépendante |
| **Y1 — Lignes industrielles** | 2027-08 | Démo de ligne de production PLC + MCU réels : capteurs à 100 Hz, boucle fermée à 10 Hz, paquets de déploiement, tests d'acceptation |
| **Y3 — Installations incarnées** | 2029-08 | Paquet d'installation incarnée réplicable (état du monde + couche de politique + site de référence), verrouillé sur la forme *industriel incarné* |
| **Y5 — Aérospatial** | 2031-08 | Proposition logiciel/matériel complète plus au moins une preuve en orbite ou en vol — pas d'héritage, pas de ventes |
| **Y5+ — Lunaire/Martien** | 2031+ | Récit d'autonomie, partenariats de recherche, livre blanc |

## Quatre pistes partagent une même base d'actifs

1. **Piste B — Contrôle industriel** ([evernight](https://github.com/celestia-island/evernight) en scène principale) : pipelines de capteurs, enregistrement/relecture, boucles rapides, nœuds embarqués.
2. **Piste E — Intelligence incarnée** : un service d'état du monde, une couche de politique avec de petits modèles locaux, une visualisation en jumeau numérique.
3. **Piste K — noyau temps réel kei** : un noyau déterministe avec une couche de personnalité ABI Linux — la réponse à long terme pour une exécution bornée et prévisible.
4. **Piste S — Aérospatial** : redondance modulaire triple au niveau système, héritage de vol, filière de certification.

Une discipline tient toutes les pistes ensemble : **protocole filaire, état du
monde, portes de sécurité et pipeline d'enregistrement sont des actifs
partagés.** Toute piste qui en démarre une nouvelle doit passer une revue
d'architecture. Et les gammes de produits ne dépendent jamais de kei : si kei
glisse, le chiffre d'affaires ne suit pas.

## Pour aller plus loin

- [Pourquoi celestia-island](./why.md) — l'énoncé du problème derrière l'horizon.
- [Principes de sécurité](./safety.md) — la sémantique temps réel sur laquelle repose le récit.
- [Carte des projets](../ecosystem/projects.md) — où vit le travail de chaque piste aujourd'hui.
