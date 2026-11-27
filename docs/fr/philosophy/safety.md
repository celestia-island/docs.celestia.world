# Principes de sécurité

Le contrôle industriel est critique pour la sécurité : une défaillance peut
déplacer des équipements physiques. La sécurité est donc conçue dans
l'architecture, pas ajoutée à la fin.

## 1. Le modèle ne touche jamais le monde directement

Un modèle est un planificateur, pas un actionneur. Il peut demander qu'un
travail soit fait ; il ne peut pas l'accomplir. Entre le modèle et
l'équipement se trouvent un bac à sable, une vérification de politique et — pour
les actions irréversibles — un humain. Le modèle ne peut pas inventer de
comportement en dehors des primitives que la plateforme expose.

## 2. Une profondeur de sécurité multicouche

Chaque opération qui peut affecter le monde physique traverse toute la chaîne,
dans l'ordre :

1. **Revue des instructions** — ce qu'on a dit au modèle de faire
2. **Exécution sandboxée** — le code s'exécute isolé, avec des contraintes de politique
3. **Validation des politiques** — la porte d'écriture : l'opération correspond-elle à la politique ?
4. **Confirmation humaine** — le dernier mot pour les actions irréversibles
5. **Journal d'audit** — tout est enregistré, rien n'est silencieux

Aucune couche ne fait confiance à la précédente. En sauter une est un défaut,
pas un raccourci.

## 3. Criticité mixte : le temps réel ne dépend jamais du modèle

Le système est réparti par temps de réponse, et **plus une couche est rapide,
moins elle dépend d'un modèle en ligne** :

| Couche | Ce qu'elle fait | Dépendance LLM |
| --- | --- | --- |
| Cognition | planification, conversation, orchestration | consommateur principal |
| État du monde | ce qui est vrai maintenant, pas ce qui a été dit | optionnelle |
| Réactif | réactions locales sur la machine elle-même | aucune |
| Contrôle temps réel | verrouillages et boucle rapide | jamais |

Si le modèle passe hors ligne, la plateforme se dégrade gracieusement : soit un
état sûr, soit la poursuite de l'exécution d'une trajectoire déjà approuvée. Le
contrôle n'attend jamais un appel réseau.

## 4. Zero trust, échec par fermeture

- L'authentification et l'autorisation viennent de
  [kirino](https://github.com/celestia-island/kirino), la couche
  d'authentification zero-trust de l'écosystème. Rien n'est digne de confiance
  du seul fait d'être à l'intérieur du réseau.
- L'inscription est limitée sur invitation par défaut ; le premier utilisateur
  d'un déploiement devient l'administrateur, après quoi l'auto-inscription se
  verrouille.
- Tout ce qui n'est pas explicitement autorisé est refusé. Quand un service a
  un mode *mock*, le mode mock est désactivé par défaut et refuse de s'exécuter
  dans les déploiements de production sans un flag explicite.

## 5. Les échecs sont bruyants

La dégradation silencieuse est traitée comme un bug de sécurité. Si le rappel
mémoire échoue, qu'un backend est injoignable ou qu'un déploiement échoue, la
réponse API et l'UI doivent le dire explicitement — pas de faux succès, pas de
repli sur de fausses données. Cette règle existe parce que les incidents réels
ont montré que les défaillances invisibles sont les dangereuses.

## Pour aller plus loin

- [La Boucle Fermée](./closed-loop.md) — où se trouvent les portes de sécurité dans le flux.
- [Architecture en couches](./layered-architecture.md) — les couches que la sécurité traverse.
- [Documentation de kirino](https://kirino.docs.celestia.world) — le modèle d'authentification en détail.
