# Démarrage rapide

Parcourez la [boucle fermée](../philosophy/closed-loop.md) en environ 30
minutes. Les adresses exactes dépendent de votre déploiement ; demandez l'URL
du panneau et votre invitation à votre administrateur.

## 1. Créer un compte

L'inscription est limitée sur invitation : le premier utilisateur d'un
déploiement devient l'administrateur, après quoi l'auto-inscription se
verrouille. Contactez les mainteneurs pour obtenir une invitation, puis
inscrivez-vous via le panneau Arona (`https://arona.celestia.world` dans un
déploiement public, ou `http://<host>:8420` en interne).

## 2. Créer une clé API

Dans le panneau Arona, créez une clé API pour votre compte. Cette clé est votre
identité pour tout ce qui suit — gestion des modèles, backends de chat et
opérations d'agents.

## 3. Déployer un modèle

Depuis le panneau, choisissez un runtime de modèle (par exemple un modèle
adossé à Ollama), déployez-le sur un nœud et liez-le à un backend de chat. Le
panneau affiche la santé et l'usage ; la mesure et la tarification sont gérées
par la couche plateforme.

## 4. Chatter et exécuter des agents

Ouvrez [shittim-chest](https://shittim-chest.docs.celestia.world) (application
de bureau ou webUI), connectez-vous avec votre clé API et démarrez une
conversation. Pour le travail multi-agents, le runtime scepter d'entelecheia
orchestre les agents derrière la même interface ; les journaux d'agents et les
appels d'outils sont visibles dans l'UI.

## 5. Contrôler des équipements industriels

Avec [evernight](https://evernight.docs.celestia.world) en fonctionnement,
connectez un pont de protocoles (Modbus, S7comm, OPC UA), abonnez-vous à la
télémétrie et — après validation des politiques et confirmation humaine —
émettez des écritures. Pendant la bêta interne, ce segment tourne contre des
équipements simulés ou de laboratoire ; la chaîne de sécurité est identique
dans les deux cas.

## 6. Vérifier

Consultez le statut de supervision (services gérés par malkuth), inspectez les
enregistrements d'usage et signalez les problèmes via les canaux du
[guide de bêta](./beta-guide.md). Si quelque chose est cassé, la boucle n'est
pas terminée — dites-nous où.

## Que faire en cas de problème ?

- **Un service est en panne** — malkuth aurait dû le redémarrer ; vérifiez la
  page de statut des services ou les journaux.
- **Le panneau ne s'ouvre pas** — vérifiez que vous êtes sur le bon hôte/port
  et que le déployeur a activé la webUI intégrée.
- **La mémoire ou le rappel est indisponible** — la réponse API et l'UI le
  signalent explicitement (`memory: "offline"`) ; le chat fonctionne toujours
  sans.

## Pour aller plus loin

- [Guide de la bêta fermée](./beta-guide.md) — ce que couvre la bêta et comment signaler les bugs.
- [La Boucle Fermée](../philosophy/closed-loop.md) — la philosophie derrière ces étapes.
