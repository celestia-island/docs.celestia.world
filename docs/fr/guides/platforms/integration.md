# Guide d'Intégration — Evernight

Comment connecter evernight à chaque protocole pris en charge, quel logiciel serveur
utiliser, et comment vérifier que la connexion fonctionne de bout en bout.

## Architecture

```
  Your app (CLI / TUI / Web / Agent)
         │
         ▼
   evernight crate
   ├── Industrial protocols (Modbus / S7comm / MC / EtherNet/IP / OPC UA / CAN / IPMI / EtherCAT)
   ├── Remote control (SSH / VNC / RDP)
   ├── Cloud (Proxmox / EC2 / k8s / libvirt / Tailscale / CODESYS / OpenPLC)
   ├── Security (vault / broker gates / write-approval)
   └── Tooling (MCP server / FFI / scripting / CLI)
         │
         ▼
   Physical hardware / remote servers / cloud APIs
```

---

## 1. Modbus RTU (Série)

### Côté serveur
- **Périphérique** : n'importe quel esclave Modbus RTU (PLC, capteur, onduleur)
- **Test sans serveur** : `socat PTY,raw,echo=0,link=/tmp/vcom_a PTY,raw,echo=0,link=/tmp/vcom_b &`
  — crée une paire série virtuelle ; exécutez `tests/modbus_slave_sim.rs` pour 6 stations.

### Côté evernight
```rust
use evernight::serial::modbus::ModbusMaster;

let master = ModbusMaster::builder(19)      // station 19
    .with_port("/dev/ttyUSB0")
    .with_baud_rate(57600)
    .with_timeout(2000)
    .open()?;

let result = master.read_registers(RegisterMode::Holding, 0x10, 33)?;
println!("Pressures: {:?}", &result.values[..3]);
```

### CLI
```bash
evernight sensor-poll --manifest corridor.toml
```

---

## 2. S7comm (Siemens)

### Côté serveur
- **Périphérique** : PLC S7-1200/1500/300/400
- **Prérequis** : TIA Portal → activer « Permit PUT/GET » + désactiver « Optimized block access »
- **Test sans matériel** : `cargo test --features full --test s7comm_integration` (utilise un serveur snap7 in-process)

### Côté evernight
```rust
use evernight::protocol::s7comm::{S7CommClient, S7ConnectParams};

let client = S7CommClient::new(S7ConnectParams {
    host: "192.168.1.10".into(), port: 102, rack: 0, slot: 1,
});
client.connect().await?;
let bytes = client.read_db(1, 0, 4).await?;       // DB1 offset 0, 4 bytes
let temp = f32::from_be_bytes(bytes.try_into().unwrap());
println!("Temperature: {:.1} °C", temp);
```

---

## 3. Protocole MC (Mitsubishi)

### Côté serveur
- **Périphérique** : PLC MELSEC FX/Q/L/iQ-R
- **Test sans matériel** : `tests/mc_test_server.rs` (serveur MC simulé in-process)

### Côté evernight
```rust
use evernight::protocol::mc_protocol::{McProtocolClient, McDevice};

let client = McProtocolClient::new("192.168.1.5", 5000);
client.connect().await?;
let words = client.read_devices(McDevice::D, 0, 10).await?;
println!("D0-D9: {:?}", words);
```

---

## 4. EtherNet/IP (Rockwell)

### Côté serveur
- **Périphérique** : Allen-Bradley CompactLogix / ControlLogix
- **Test sans matériel** : tests unitaires avec des trames construites à la main (pas de simulateur en direct)

### Côté evernight
```rust
use evernight::protocol::ethernet_ip_backend::EthernetIpBackend;
use evernight::protocol::backend::{ProtocolBackend, TransportInfo, DataAddress};

let mut backend = EthernetIpBackend::new("192.168.1.10", 44818);
backend.connect(&TransportInfo::Tcp { host: "192.168.1.10".into(), port: 44818 })?;
let result = backend.read(&DataAddress::Raw {
    data: b"0x6E:0x01:0x05".to_vec(),  // class 0x6E, instance 1, attr 5
    size: 4,
})?;
println!("Value: {:02X?}", result.raw);
```

---

## 5. OPC UA

### Côté serveur
- **Périphérique/Logiciel** : n'importe quel serveur OPC UA (KEPServerEX, Ignition, CODESYS, etc.)
- **Auto-hébergé** : evernight lui-même peut agir comme serveur OPC UA :

```rust
use evernight::protocol::opcua_server::OpcUaSensorServer;

let mut server = OpcUaSensorServer::new("opc.tcp://0.0.0.0:4840", 4840)?;
let node = server.add_sensor_variable("temperature", 25.5)?;
// server.run();  // blocks — run in a separate thread
```

### Côté client evernight
```rust
use evernight::protocol::opcua_client::{OpcUaClient, OpcUaEndpoint, OpcUaSecurity};

let endpoint = OpcUaEndpoint::new_anonymous("opc.tcp://192.168.1.50:4840");
let client = OpcUaClient::connect(&endpoint).await?;
let value = client.read_node("ns=2;s=Temperature").await?;
println!("Temperature: {}", value);
```

---

## 6. SSH

### Côté serveur
- N'importe quel serveur SSH (OpenSSH, Dropbear, etc.)
- **Gestion des clés** : `evernight vault init ~/.config/evernight/vault "passphrase"`
  puis ajoutez les identifiants.

### Côté evernight
```bash
# Interactive terminal
evernight connect ssh://user@192.168.1.100

# One-shot command
evernight exec --host 192.168.1.100 --user root --key ~/.ssh/id_ed25519 \
  --command "uname -a"

# File transfer
evernight file put ./config.yaml root@192.168.1.100:/etc/app/config.yaml

# SOCKS5 proxy through SSH
evernight proxy 1080 --host 192.168.1.100 --user root
```

---

## 7. VNC

### Côté serveur
- **Logiciel** : TigerVNC, x11vnc, RealVNC, etc.
- **Installation** : `apt install tigervnc-standalone-server && vncserver :1`
- **Accès navigateur** : evernight peut proxifier le VNC vers WebSocket :

```bash
# Start a VNC-to-WebSocket proxy (noVNC-compatible)
# (programmatically via evernight::vnc::ws::serve_vnc_websocket)
```

### Côté evernight
```bash
# CLI one-shot — handshake + server info + one frame capture
evernight connect vnc://192.168.1.100:5901
```

---

## 8. RDP

### Côté serveur
- **Windows** : RDP natif (Paramètres → Bureau à distance → Activer)
- **Linux** : `apt install xrdp`
  - Pour TLS : définir `security_layer=tls` dans `/etc/xrdp/xrdp.ini`
  - Générer un certificat : `openssl req -x509 -newkey rsa:2048 -nodes -keyout key.pem -out cert.pem -days 365 -subj "/CN=localhost"`
  - Copier vers `/etc/xrdp/cert.pem` + `/etc/xrdp/key.pem`

### Côté evernight
```rust
use evernight::rdp::x224::{RdpClient, RdpConfig};

let config = RdpConfig {
    host: "192.168.1.100".to_string(),
    port: 3389,
    username: Some("admin".into()),
    password: Some("password".into()),
    ..Default::default()
};
let mut client = RdpClient::connect(&config).await?;
println!("Connected: {}x{}, TLS", client.width(), client.height());
// Send MCS Connect-Initial, Attach-User, Channel-Join, ...
// Receive bitmap updates, decode to RGBA via bitmap::decode_to_rgba
```

```bash
# CLI one-shot — handshake + protocol/desktop info
evernight connect rdp://192.168.1.100:3389
```

### État actuel du RDP
- ✅ Transport : X.224 + montée en version TLS (vérifié face à un vrai xrdp)
- ✅ MCS : Connect-Initial/Response + Attach-User (vérifié)
- ✅ Bitmap : décodage non compressé + Interleaved RLE → RGBA
- ✅ Entrée : scancodes clavier + événements souris
- ✅ Canaux : CLIPRDR + RDPDR + RDPSND + DVC
- ✅ NLA : NTLMv2 + CredSSP (Kerberos nécessite un KDC)
- ◐ Session : nécessite Channel-Join → échange de capacités → boucle framebuffer continue

---

## 9. Kubernetes

### Côté serveur
- N'importe quel cluster k8s (minikube, kind, EKS, GKE, etc.)
- Authentification : `~/.kube/config` ou compte de service in-cluster

### Côté evernight
```rust
use evernight::cloud::k8s::K8sClient;

let client = K8sClient::from_kubeconfig("default").await?;
let pods = client.list_pods().await?;
for pod in &pods {
    println!("{}: {} ({} containers)", pod.name, pod.phase, pod.containers.len());
}
```

---

## 10. libvirt

### Côté serveur
- `apt install libvirt-daemon-system libvirt-dev`
- Démarrer libvirtd : `systemctl start libvirtd`

### Côté evernight
```rust
use evernight::cloud::libvirt_client::LibvirtClient;

let client = LibvirtClient::open_read_only("qemu:///system")?;
let domains = client.list_domains()?;
for d in &domains {
    println!("{}: {:?}", d.name, d.state);
}
```

---

## La Question du Client : Faut-il Construire un Visualiseur ?

### Le problème

Evernight décode les bitmaps RDP en tampons RGBA et les trames VNC en pixels, mais
**sans aucun endroit où les afficher**. Sans moteur de rendu :

- Vous ne pouvez pas vérifier visuellement que le décodage bitmap est correct (vous pouvez seulement vérifier
  qu'il ne plante pas)
- Vous ne pouvez pas faire de dogfooding — evernight est censé être un « gestionnaire de connexions
  universel de classe XPipe », or XPipe affiche les bureaux distants
- Les tests manuels nécessitent un visualiseur externe (mstsc.exe / xfreerdp / vinagre)

### Recommandation : OUI — construire un visualiseur embarqué minimal

Trois niveaux d'effort, du plus simple au plus utile :

#### Tier 1 : Capture d'écran headless (effort minimal, valeur de test maximale)

```
evernight connect rdp://host --screenshot out.png
```

Capture UNE trame après l'établissement de la session et l'écrit dans un PNG. Aucune interface graphique requise.
Utilise le `bitmap::decode_to_rgba` existant + un encodeur PNG simple (ou PPM,
qui ne nécessite aucune dépendance). Cela vous apporte :

- **Régression visuelle automatisée** : comparer les captures d'écran entre les commits
- **Correction du protocole** : vous pouvez VOIR si le décodage bitmap RDP est correct
- **Adapté à la CI** : aucun serveur d'affichage requis

Effort estimé : ~100 lignes (encodage PNG + boucle de capture en une fois).

#### Tier 2 : Fenêtre egui (effort modéré, tests manuels complets)

```
evernight connect rdp://host --gui
```

Ouvre une fenêtre [egui](https://github.com/emilk/egui) affichant le framebuffer RDP
en direct. L'entrée clavier/souris est renvoyée via le codec d'entrée existant.
Cela vous apporte :

- **Boucle fermée complète** : saisir → voir la sortie → vérifier l'interaction
- **Aucune dépendance externe** : egui est en Rust pur, multiplateforme
- **Binaire unique** : pas d'application visualiseur distincte nécessaire

Effort estimé : ~300 lignes (upload de texture egui + boucle d'événements d'entrée).
La crate egui `eframe` est déjà courante dans l'écosystème.

#### Tier 3 : Frontend web via l'API existante (effort le plus important, production)

Evernight dispose déjà de `api-serve --transport ws` (JSON-RPC sur WebSocket).
Un frontend web (shittim-chest / Tauri) se connecte à cette API et :

- Affiche le framebuffer sur un `<canvas>`
- Envoie les événements d'entrée via JSON-RPC
- Il s'agit du chemin de production — les Tiers 1+2 sont destinés au développement/test

Il s'agit de travail frontend (Vue/React/Tauri), pas de code de bibliothèque evernight.

### Quel niveau construire ?

**Commencez par le Tier 1 (capture d'écran headless)** — c'est le meilleur retour sur investissement pour les tests
et cela prend ~1 heure. Il comble la lacune la plus critique : vous pouvez enfin VOIR si
le pipeline bitmap RDP produit des pixels corrects.

Ajoutez ensuite le Tier 2 (egui) lorsque vous avez besoin de tests interactifs — par ex. vérifier
l'entrée clavier, le presse-papiers, la redirection de disque.

Le Tier 3 est le frontend de production, construit lorsque l'interface web sera prête.

---

## Démarrage Rapide : Vérifiez Votre Configuration

```bash
# 1. Build
cargo build --features full --release

# 2. Test all protocols (878 tests)
cargo test --features full

# 3. Probe a host for industrial protocols
evernight probe 192.168.1.20 --ports 502,102,4840,5000

# 4. Connect to an SSH host
evernight connect ssh://user@192.168.1.100

# 5. Poll sensors from a manifest
evernight sensor-poll --manifest corridor.toml

# 6. Check hardware telemetry
evernight hw

# 7. Start the MCP server (for AI agents)
evernight api-serve --transport ws --port 50000
```
