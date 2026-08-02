# Principes de sécurité

Le contrôle industriel est critique pour la sécurité : une défaillance peut
déplacer des équipements physiques. La sécurité est donc conçue dans
l'architecture, pas ajoutée à la fin.

## 1. Le LLM ne touche jamais le monde directement

Dans [entelecheia](https://github.com/celestia-island/entelecheia), le modèle ne
voit qu'une poignée d'outils primitifs (`exec`, `write_to_var`). Tout le travail
réel se déroule dans un pipeline d'exécution sandboxé où le code des agents
répartit les tâches sur une large surface d'outils MCP entre les agents. Le
modèle ne peut pas inventer de comportement ; il ne peut appeler que les
primitives que la plateforme expose.

## 2. Une profondeur de sécurité multicouche

Chaque opération qui peut affecter le monde physique traverse toute la chaîne,
dans l'ordre :

1. **Revue des instructions** — ce qu'on a dit au modèle de faire
2. **Exécution sandboxée** — le code s'exécute isolé, avec des contraintes de politique
3. **Validation des politiques** — la porte d'écriture : l'opération correspond-elle à la politique ?
4. **Confirmation humaine** — le dernier mot pour les actions irréversibles
5. **Journal d'audit** — tout est enregistré, rien n'est silencieux

## 3. Criticité mixte : le temps réel ne dépend jamais du LLM

Les systèmes sont répartis par temps de réponse, et **les couches les plus
rapides ne dépendent jamais d'un modèle en ligne** :

| Couche | Cadence | S'exécute sur | Dépendance LLM |
| --- | --- | --- | --- |
| L3 — Cognition | secondes–minutes | arona, shittim-chest, entelecheia (Linux) | consommateur principal |
| L2 — Modèle du monde | 10–50 Hz | services de plateforme | optionnelle |
| L1 — Réactif / périphérie | 10–100 Hz | evernight sur SBC ; petits modèles locaux | aucune |
| L0 — Contrôle temps réel | 100 Hz–1 kHz | boucle rapide MCU, verrouillages locaux | jamais |

Si le LLM passe hors ligne, la plateforme se dégrade gracieusement : soit un
état sûr, soit la poursuite de l'exécution d'une trajectoire déjà approuvée.
Des watchdogs matériels ancrent cette sémantique — le contrôle n'attend jamais
un appel réseau.

## 4. Zero trust, échec par fermeture

- L'authentification et l'autorisation viennent de
  [kirino](https://github.com/celestia-island/kirino) : JWT avec sessions à
  courte durée, hachage de mots de passe Argon2id, limitation de débit des
  connexions et moteur RBAC.
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
- [Documentation d'evernight](https://evernight.docs.celestia.world) — courtage de protocoles et portes d'écriture.
