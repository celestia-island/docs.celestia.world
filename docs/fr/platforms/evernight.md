# Evernight — Courtier de protocoles industriels

Evernight est le bord industriel : un courtier multiplateforme qui parle les
protocoles de terrain (Modbus, S7comm, MC Protocol, EtherNet/IP, EtherCAT,
CAN, OPC UA, MQTT, …), interroge les capteurs, évalue les alarmes et pousse
des événements dans la pile celestia-island. Il gère aussi les serveurs de
modèles sur le nœud (ollama / whisper / vLLM) pour l'inférence en bord.

## L'architecture en un coup d'œil

```text
Terrain : PLC / MCU / capteurs (Modbus, S7comm, MC, EtherCAT, CAN, OPC UA, …)
         ▼
    evernight (nœud de bord)
    ├─ Adaptateurs de protocoles : interrogation → décodage → lectures typées
    ├─ Moteur d'alarmes : règles de seuil → événements déclencheurs
    ├─ Séries temporelles : lectures mises en tampon à double horodatage
    ├─ Enregistrement/relecture : tampon circulaire → stockage segmenté → injection de relecture
    ├─ Gestionnaire de serveurs de modèles : déploie ollama/whisper/vLLM (GPU d'abord)
    └─ Nord (northbound) : déclencheurs JSON-RPC par socket Unix → entelecheia
         │
         ▼
    scepter (agents, flux de travail industriels, approbation d'écriture)
```

## 1. Protocoles de terrain

Les adaptateurs convertissent la lecture/écriture native de chaque protocole
en lectures et commandes typées. Le chemin d'écriture est verrouillé : les
écritures industrielles exigent la validation des politiques et
l'approbation humaine dans la plateforme (OreXis + flux d'approbation).

## 2. Détection et alarmes

- Boucles d'interrogation par station avec des périodes configurables ; les
  échecs remontent comme événements de santé.
- Le moteur d'alarmes évalue des règles de seuil sur les lectures et émet
  des événements routés par topic vers le récepteur de déclencheurs nord.

## 3. Temps et enregistrement

Les lectures portent un double horodatage (horloge murale pour
l'affichage/audit, monotone pour l'ordonnancement/fusion). Un pipeline
enregistrement/relecture maintient un tampon circulaire, persiste des
segments et peut réinjecter des données rejouées dans le pipeline de
déclencheurs — le prérequis partagé des couches état-du-monde et
apprentissage.

## 4. Service de modèles en bord

`model_server` gère les runtimes de modèles sur le nœud : déploiement de
modèles sur conteneurs (ollama, whisper.cpp, vLLM) avec placement GPU
d'abord, repli CPU — la brique de base d'une inférence réactive en bord qui
ne dépend jamais d'un LLM en ligne.

## 5. Intégration nord (northbound)

Les événements affluent vers le scepter d'entelecheia via un récepteur de
déclencheurs JSON-RPC par socket Unix (routage par topic) ; la passerelle
équipement↔cloud enregistre l'identité du nœud et la télémétrie. Tout ce qui
est physique passe par evernight.

## Référence des variables d'environnement (extrait)

| Variable | Rôle |
|---|---|
| `EVERNIGHT_SOCK` | Socket Unix pour les déclencheurs/télémétrie vers scepter |
| `EVERNIGHT_*` | Configuration de connexion par protocole |
| env conteneur/GPU | Déploiement des serveurs de modèles (runtimes ollama/vLLM) |
