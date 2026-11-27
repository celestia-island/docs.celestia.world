# Infrastructure centrale — Auth, RPC et fondations

Toutes les plateformes que vous utilisez reposent sur la même fondation. Lisez
cette page une fois et les guides de plateforme s'assemblent d'eux-mêmes : kirino
(authentification zero-trust et RBAC), plana (types de protocole et
infrastructures de plateforme) et hikari (la bibliothèque de composants UI).

## Authentification et autorisation (kirino)

- **Identité** : hachage de mots de passe, jetons de session à durée de vie
  courte, limitation de débit des connexions et verrouillage des comptes. Les
  algorithmes et leurs paramètres sont documentés dans la
  [documentation de kirino](https://kirino.docs.celestia.world), pas ici.
- **RBAC** : les permissions sont hiérarchiques et résolues par appelant ; les
  rôles regroupent des permissions (un administrateur voit tout, un lecteur est
  en lecture seule). Les affectations persistent dans la base de la plateforme.
- **Délégation** : un service qui se trouve derrière un autre n'authentifie
  personne lui-même — la couche qui authentifie est toujours en amont, et
  l'identité de l'appelant est transmise uniquement pour l'isolation des espaces
  de travail.

## Protocole et RPC (plana)

- Le trafic de la plateforme est du **JSON-RPC 2.0**, sur WebSocket pour le
  streaming et en HTTP POST pour le requête/réponse. Les noms de méthodes sont
  de la forme `<Domaine>.<Action>`.
- Les types du protocole sont l'unique source de vérité du protocole et vivent
  dans plana ; les dépôts en aval épinglent une version publiée plutôt que de
  forker une copie.
- Les notifications n'ont pas d'`id` et poussent des événements comme les
  fragments de streaming et les mises à jour du panneau ; les requêtes portent
  un `id` renvoyé en écho dans la réponse.
- Les surfaces chargées en état suivent partout le même motif : le serveur est
  autoritaire, les clients déclarent ce qu'ils regardent, et le serveur diffuse
  la différence.

## Mesure et tarification (plana)

L'usage est mesuré par clé API et tarifé depuis une table canonique unique
partagée par tous les services : jetons de prompt et de complétion, estimation
des coûts et application des quotas sont le même calcul dans chaque produit.

## Composants UI (hikari)

La bibliothèque de composants fournit les boutons, badges, tableaux, modales et
dialogues de confirmation utilisés par chaque webUI, afin qu'un écran ait la
même apparence et le même comportement partout où il est monté. Les composants
partagés remontent ici plutôt que d'être réimplémentés par dépôt.

## Règles de dépendances

- Couche 0 : kirino (auth) → Couche 1 : plana (protocole/fondations) →
  Couche 2 : hikari (UI) → Couche 3 : services (arona, chest, entelecheia,
  evernight).
- Les services n'implémentent que de la logique métier ; les capacités
  partagées viennent de l'amont. Les dépendances inter-dépôts utilisent des
  références git ou des tags épinglés — jamais de dépendances locales par
  chemin.
