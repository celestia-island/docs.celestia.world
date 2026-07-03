# Intégration des protocoles industriels — Evernight

Evernight est le **courtier obligatoire de capacités matérielles** pour
l'écosystème celestia-island. Aucun crate amont n'importe `aoba` / `rust7` /
etc. directement — toutes les E/S physiques transitent par les modules de
protocole d'evernight.

## Niveaux de protocole

Tous les protocoles ne se valent pas. Evernight les classe en trois niveaux :

| Niveau | Catégorie | Intégré ? | Dans l'image aris ? | Exemples |
|------|------|-----------|----------------|----------|
| **Tier 1** | Standards ouverts — toujours disponibles | ✅ Oui | ✅ Oui | OPC UA, Modbus TCP/RTU, CAN, EtherCAT |
| **Tier 2** | Spécifiques au fournisseur — crates officiels, optionnels | Fonctionnalité optionnelle | ❌ Non | S7comm, MC Protocol, EtherNet/IP |
| **Tier 3** | Plug-ins tiers — chargés au runtime | ❌ Processus externe | ❌ Non | Tout ce que vous écrivez |

### Pourquoi des niveaux ?

**Tier 1 (standards ouverts)** est le chemin principal. Les PLC modernes de
tous les principaux constructeurs (Siemens S7-1500, Mitsubishi iQ-R, Rockwell
ControlLogix 5580) sont livrés avec des serveurs OPC UA intégrés. Si un
périphérique parle OPC UA, utilisez-le — aucun code spécifique au constructeur
n'est nécessaire.

**Tier 2 (spécifiques au constructeur)** couvre le parc installé historique.
Des millions de PLC sur le terrain (S7-300/1200, MELSEC Q, anciens
Allen-Bradley) n'ont pas d'OPC UA et ne parlent que leur protocole
propriétaire. Ces protocoles sont :

- Implémentés comme des **crates autonomes** (non embarqués dans le cœur d'evernight)
- Compilés uniquement lorsque la fonctionnalité Cargo est activée
- **Non inclus** dans l'image OS de la passerelle aris par défaut
- Chaque crate sert également de **mise en œuvre de référence** pour les auteurs de plug-ins Tier 3

**Tier 3 (plug-ins tiers)** permet à quiconque d'ajouter la prise en charge
d'un protocole sans toucher au code source d'evernight. Un plug-in est un
processus externe qui parle JSON-RPC (en utilisant les types
[arona](https://github.com/celestia-island/arona)) sur WebSocket ou un socket
de domaine Unix. La configuration TOML de la passerelle déclare où se trouve
chaque plug-in.

```
  ┌──────────────────────────────────────────────────────┐
  │                  ProtocolRegistry                     │
  │                                                       │
  │  Tier 1 (always loaded)                               │
  │  ├── Modbus TCP/RTU  (open, IEC 61158)               │
  │  ├── OPC UA         (open, IEC 62541)                │
  │  ├── CAN 2.0B       (open, ISO 11898)                │
  │  └── EtherCAT       (open, IEC 61158)                │
  │                                                       │
  │  Tier 2 (opt-in features, NOT in aris image)          │
  │  ├── S7comm         (Siemens, feature = "s7comm")    │
  │  ├── MC Protocol    (Mitsubishi, feature = "mc")     │
  │  └── EtherNet/IP    (Rockwell, feature = "enip")     │
  │                                                       │
  │  Tier 3 (runtime plugins, declared in TOML)           │
  │  ├── fins_tcp       → ws://127.0.0.1:51001            │
  │  ├── mewtocol       → ipc:///run/evernight/mew.sock   │
  │  └── your_protocol  → ws://...                        │
  └──────────────────────────────────────────────────────┘
```

## Tier 1 : Standards ouverts

### Modbus (RTU sur série / TCP)

Modbus est le cheval de trait de la communication industrielle. C'est un
standard ouvert (IEC 61158) pris en charge par quasiment tous les PLC,
capteurs et variateurs du marché.

**Toujours compilé.** Aucune feature flag nécessaire.

```rust
use evernight::protocol::{ProtocolRegistry, ModbusProbe, TransportInfo};
use std::sync::Arc;

let mut registry = ProtocolRegistry::new();
registry.register_probe(Arc::new(ModbusProbe));

let transport = TransportInfo::Tcp { host: "192.168.1.20".into(), port: 502 };
if let Some(result) = registry.auto_detect(&transport, 0.5).await {
    println!("Detected {} ({:.0}%)", result.protocol, result.confidence * 100.0);
}
```

### OPC UA

OPC UA (IEC 62541) est le standard universel de communication industrielle. Les
PLC modernes de Siemens, Mitsubishi, Rockwell et d'autres incluent des serveurs
OPC UA intégrés. Si un périphérique prend en charge OPC UA, c'est le chemin à
privilégier — aucun protocole spécifique au constructeur n'est nécessaire.

```toml
[dependencies]
evernight = { version = "0.1", features = ["opcua"] }
```

### CAN 2.0B / EtherCAT

Standards ouverts pour la communication de bus de terrain (piles à
combustible, servo-variateurs, contrôle de mouvement). Activés via les
fonctionnalités `can` et `ethercat`.

---

## Tier 2 : Protocoles spécifiques au constructeur

Chaque protocole Tier 2 est un **crate autonome** qui implémente les traits
`ProtocolBackend` et `ProtocolProbe`. Ils sont optionnels — activez la
fonctionnalité Cargo pour les compiler, ou laissez-les de côté pour garder le
binaire léger.

> **Les crates Tier 2 ne sont PAS inclus dans l'image OS de la passerelle aris
> par défaut.** L'image est livrée avec Tier 1 uniquement. Si vous avez besoin
> d'un protocole spécifique au constructeur sur la passerelle, soit :
> 1. Vous compilez une image aris personnalisée avec la fonctionnalité activée, ou
> 2. Vous exécutez le protocole comme un plug-in Tier 3 (voir ci-dessous).

### S7comm (Siemens S7-1200/1500/300/400)

```toml
[dependencies]
evernight = { version = "0.1", features = ["s7comm"] }
```

S7comm est le protocole natif de Siemens sur ISO-on-TCP (port 102). C'est le
**protocole constructeur à la plus haute priorité** — Siemens possède le plus
grand parc installé dans les marchés cibles (énergie hydrogène, chimie,
pharmacie).

```rust
use evernight::protocol::s7comm::{S7CommClient, S7ConnectParams};

let client = S7CommClient::new(S7ConnectParams {
    host: "192.168.1.10".into(),
    port: 102,
    rack: 0,
    slot: 1,
});
client.connect().await?;
let bytes = client.read_db(1, 0, 4).await?;
let temp = f32::from_be_bytes(bytes.try_into().unwrap());
println!("DB1.DBD0 = {:.1} °C", temp);
```

**Validation :** Vérifié face à la mise en œuvre de référence Snap7 en C
(standard industriel open source vieux de 15 ans). Un test différentiel au
niveau des octets confirme la conformité du format de transmission. 19 tests
d'intégration réussissent dans le CI.

### MC Protocol (Mitsubishi MELSEC)

```toml
[dependencies]
evernight = { version = "0.1", features = ["mc"] }
```

MC Protocol (trame binaire 3E) couvre les séries Mitsubishi MELSEC Q/L/iQ-R.
**Priorité la plus basse** des protocoles constructeurs — l'écosystème
Mitsubishi est en source fermée sans mise en œuvre de serveur de référence.
Cependant, les PLC modernes de Mitsubishi (iQ-R, iQ-F) intègrent OPC UA, donc
**OPC UA est le chemin à privilégier pour les périphériques Mitsubishi**.

**Validation :** Recoupé face à six sources indépendantes (manuel officiel
Mitsubishi, pilote Beijer Electronics, docs Neuron, émulateur Sym3, client
pymcprotocol, captures de trames testées sur le terrain).

### EtherNet/IP (Rockwell/Allen-Bradley)

```toml
[dependencies]
evernight = { version = "0.1", features = ["enip"] }
```

EtherNet/IP + CIP couvre les PLC Rockwell Automation / Allen-Bradley,
principalement sur le marché nord-américain.

---

## Tier 3 : Protocole plug-in — JSON-RPC sur WebSocket / IPC

Tier 3 permet à **n'importe qui** d'ajouter la prise en charge d'un protocole à
evernight sans modifier le code source d'evernight. Un plug-in est un processus
externe qui :

1. Écoute sur un WebSocket (`ws://host:port`) ou un socket de domaine Unix (`ipc:///path`)
2. Parle JSON-RPC 2.0 en utilisant les types [arona](https://github.com/celestia-island/arona)
3. Implémente la même interface `connect` / `read` / `write` / `ping` que les backends intégrés

### Déclarer des plug-ins dans la TOML de la passerelle

```toml
# /etc/evernight/gateway.toml

[[protocol_plugins]]
name = "fins_tcp"                    # Omron FINS/TCP
transport = "ws://127.0.0.1:51001"   # plugin process WebSocket
priority = 60                        # probe priority (lower = first)

[[protocol_plugins]]
name = "mewtocol"                    # Panasonic Mewtocol
transport = "ipc:///run/evernight/mewtocol.sock"  # Unix socket
priority = 70

[[protocol_plugins]]
name = "custom_protocol"
transport = "ws://192.168.1.100:8080"  # remote plugin on another machine
priority = 80
```

Au démarrage, evernight lit ce fichier, instancie un `RemotePluginBackend`
pour chaque entrée et l'enregistre dans le `ProtocolRegistry`. À partir de là,
le plug-in participe à l'auto-détection et aux E/S de données exactement comme
un backend intégré.

### Interface JSON-RPC (types arona)

Le plug-in doit répondre à ces méthodes JSON-RPC (définies dans arona) :

| Méthode | Paramètres | Retourne |
|--------|-----------|---------|
| `protocol.connect` | `{ transport: TransportInfo }` | `{ connected: bool }` |
| `protocol.read` | `{ address: DataAddress }` | `{ raw: [u8], latency_us: u64 }` |
| `protocol.write` | `{ address: DataAddress, data: [u8] }` | `{ confirmed: bool }` |
| `protocol.ping` | `{}` | `{ reachable: bool }` |
| `protocol.probe` | `{ transport: TransportInfo }` | `{ protocol: string, confidence: float }` |

Consultez le [crate arona](https://github.com/celestia-island/arona) pour les
définitions de types complètes et les liaisons TypeScript.

### Écrire un plug-in Tier 3

Un crate Tier 2 (p. ex. `evernight-s7comm`) sert également de **mise en œuvre
de référence**. Les auteurs de plug-ins peuvent étudier sa source pour
comprendre le contrat du trait `ProtocolBackend`, puis implémenter la même
logique dans n'importe quel langage (Python, Go, C, Node.js) derrière un
serveur JSON-RPC.

Exemple de plug-in Python minimal :

```python
#!/usr/bin/env python3
"""Minimal Tier 3 plugin — speaks JSON-RPC over WebSocket."""
import json, asyncio, websockets

async def handle(ws):
    async for msg in ws:
        req = json.loads(msg)
        method = req["method"]
        if method == "protocol.connect":
            await ws.send(json.dumps({"id": req["id"], "result": {"connected": True}}))
        elif method == "protocol.read":
            # Your protocol-specific read logic here
            await ws.send(json.dumps({"id": req["id"], "result": {"raw": [0,0,1,92], "latency_us": 500}}))
        elif method == "protocol.ping":
            await ws.send(json.dumps({"id": req["id"], "result": {"reachable": True}}))

asyncio.run(websockets.serve(handle, "127.0.0.1", 51001))
```

---

## Architecture

Chaque protocole — quel que soit son niveau — implémente les deux mêmes
traits :

```rust
pub trait ProtocolBackend: Send + Sync {
    fn protocol_name(&self) -> &'static str;
    fn tier(&self) -> ProtocolTier;
    async fn connect(&self, transport: &TransportInfo) -> Result<()>;
    async fn read(&self, addr: &DataAddress) -> Result<ProtocolReadResult>;
    async fn write(&self, addr: &DataAddress, data: &[u8]) -> Result<ProtocolWriteResult>;
}

pub trait ProtocolProbe: Send + Sync {
    fn protocol_name(&self) -> &'static str;
    async fn probe(&self, transport: &TransportInfo) -> Result<Option<ProtocolProbeResult>>;
    fn confidence(&self) -> f32;
    fn priority(&self) -> i32;
}
```

```
                          ┌──────────────────────────────────┐
   Your application ────► │         evernight crate           │
   (CLI / library /       │                                   │
    sensor-poll /         │  ProtocolBackend trait            │
    API server)           │  ProtocolProbe trait              │
                          │  ProtocolRegistry                 │
                          │  ┌─────────┐ ┌─────────┐         │
                          │  │ Tier 1  │ │ Tier 2  │         │
                          │  │ Modbus  │ │ S7comm  │  …      │
                          │  │ OPC UA  │ │ MC Proto│         │
                          │  └────┬────┘ └────┬────┘         │
                          │       │           │              │
                          │       │     ┌─────┴──────┐       │
                          │       │     │ Tier 3 RPC │       │
                          │       │     │ (arona     │       │
                          │       │     │  JSON-RPC) │       │
                          │       │     └─────┬──────┘       │
                          └───────┼───────────┼──────────────┘
                                  │           │
                          ┌───────▼───┐ ┌─────▼──────────┐
                          │  aoba /   │ │ External plugin │
                          │  asyncua  │ │ process (any    │
                          │  (Tier 1) │ │  language)      │
                          └───────────┘ └────────────────┘
```

## Priorité d'auto-détection

Lors du sondage d'un périphérique inconnu, les sondes Tier 1 de standards
ouverts s'exécutent en premier :

| Priorité | Protocole | Port |
|----------|----------|------|
| 10 | OPC UA | 4840 |
| 20 | Modbus TCP | 502 |
| 30 | EtherCAT | — |
| 40 | CAN | — |
| 50 | S7comm (Tier 2) | 102 |
| 60 | MC Protocol (Tier 2) | 5000 |
| 70 | EtherNet/IP (Tier 2) | 44818 |
| 100+ | Plug-ins Tier 3 | varie |

Les standards ouverts obtiennent les numéros de priorité les plus bas (sondés
en premier) car si un périphérique parle OPC UA, c'est le chemin que vous
souhaitez — quel que soit le constructeur.

## Référence des commandes CLI

| Commande | Description |
|---------|-------------|
| `evernight probe <host> [--ports 502,102,...]` | Sonder un hôte pour des protocoles (tous niveaux) |
| `evernight sensor-poll [--manifest X.toml]` | Scruter des capteurs, émettre des alarmes |
| `evernight api-serve --transport ws` | Démarrer le serveur d'API JSON-RPC |

## Types de données de champ S7

| Type | Taille | Format d'offset | Décodage |
|------|------|---------------|--------|
| `BOOL` | 1 bit | `8.0` (octet 8, bit 0) | test de bit |
| `BYTE` | 1 octet | `8` | `u8` |
| `WORD` | 2 octets | `8` | `u16::from_be_bytes` |
| `INT` | 2 octets | `8` | `i16::from_be_bytes` |
| `DWORD` | 4 octets | `8` | `u32::from_be_bytes` |
| `DINT` | 4 octets | `8` | `i32::from_be_bytes` |
| `REAL` | 4 octets | `0` | `f32::from_be_bytes` |
| `STRING` | var | `20` | ASCII à préfixe de longueur |

> La partie fractionnaire de `offset` encode l'**index de bit** pour les champs
> BOOL.

## Routage des alarmes

Les lectures de capteurs transitent par un pipeline d'alarme partagé. Chaque
protocole obtient son propre espace de noms de sujet (topic) :

| Protocole | Sujet de déclenchement | Identifiant source |
|----------|---------------|-----------|
| Modbus | `modbus.{station}.{field}.{level}` | `evernight.modbus.{station}` |
| S7comm | `s7comm.{station}.{field}.{level}` | `evernight.s7comm.{station}` |
| OPC UA | `opcua.{node}.{field}.{level}` | `evernight.opcua.{node}` |

Les niveaux d'alarme suivent la norme ISA-18.2 : `ll` / `l` / `h` / `hh` /
`roc`.
