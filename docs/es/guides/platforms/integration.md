# Guía de Integración — Evernight

Cómo conectar evernight a cada protocolo soportado, qué software de servidor usar y cómo verificar que la conexión funciona de extremo a extremo.

## Arquitectura

```text
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

-----------------------------------------------------------------------------

## 1. Modbus RTU (Serial)

### Lado del servidor
- **Dispositivo**: cualquier esclavo Modbus RTU (PLC, sensor, inversor)
- **Prueba sin servidor**: `socat PTY,raw,echo=0,link=/tmp/vcom_a PTY,raw,echo=0,link=/tmp/vcom_b &`
  — crea un par serie virtual; ejecute `tests/modbus_slave_sim.rs` para 6 estaciones.

### Lado de evernight
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

-----------------------------------------------------------------------------

## 2. S7comm (Siemens)

### Lado del servidor
- **Dispositivo**: PLC S7-1200/1500/300/400
- **Requisito previo**: TIA Portal → activar "Permit PUT/GET" + desactivar "Optimized block access"
- **Prueba sin hardware**: `cargo test --features full --test s7comm_integration` (usa un servidor snap7 en proceso)

### Lado de evernight
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

-----------------------------------------------------------------------------

## 3. MC Protocol (Mitsubishi)

### Lado del servidor
- **Dispositivo**: PLC MELSEC FX/Q/L/iQ-R
- **Prueba sin hardware**: `tests/mc_test_server.rs` (servidor MC simulado en proceso)

### Lado de evernight
```rust
use evernight::protocol::mc_protocol::{McProtocolClient, McDevice};

let client = McProtocolClient::new("192.168.1.5", 5000);
client.connect().await?;
let words = client.read_devices(McDevice::D, 0, 10).await?;
println!("D0-D9: {:?}", words);
```

-----------------------------------------------------------------------------

## 4. EtherNet/IP (Rockwell)

### Lado del servidor
- **Dispositivo**: Allen-Bradley CompactLogix / ControlLogix
- **Prueba sin hardware**: pruebas unitarias con tramas construidas a mano (sin simulador en vivo)

### Lado de evernight
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

-----------------------------------------------------------------------------

## 5. OPC UA

### Lado del servidor
- **Dispositivo/Software**: cualquier servidor OPC UA (KEPServerEX, Ignition, CODESYS, etc.)
- **Autoalojado**: el propio evernight puede actuar como servidor OPC UA:

```rust
use evernight::protocol::opcua_server::OpcUaSensorServer;

let mut server = OpcUaSensorServer::new("opc.tcp://0.0.0.0:4840", 4840)?;
let node = server.add_sensor_variable("temperature", 25.5)?;
// server.run();  // blocks — run in a separate thread
```

### Lado cliente de evernight
```rust
use evernight::protocol::opcua_client::{OpcUaClient, OpcUaEndpoint, OpcUaSecurity};

let endpoint = OpcUaEndpoint::new_anonymous("opc.tcp://192.168.1.50:4840");
let client = OpcUaClient::connect(&endpoint).await?;
let value = client.read_node("ns=2;s=Temperature").await?;
println!("Temperature: {}", value);
```

-----------------------------------------------------------------------------

## 6. SSH

### Lado del servidor
- Cualquier servidor SSH (OpenSSH, Dropbear, etc.)
- **Gestión de claves**: `evernight vault init ~/.config/evernight/vault "passphrase"`
  y luego añadir credenciales.

### Lado de evernight
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

-----------------------------------------------------------------------------

## 7. VNC

### Lado del servidor
- **Software**: TigerVNC, x11vnc, RealVNC, etc.
- **Instalación**: `apt install tigervnc-standalone-server && vncserver :1`
- **Acceso por navegador**: evernight puede hacer de proxy de VNC a WebSocket:

```bash
# Start a VNC-to-WebSocket proxy (noVNC-compatible)
# (programmatically via evernight::vnc::ws::serve_vnc_websocket)
```

### Lado de evernight
```bash
# CLI one-shot — handshake + server info + one frame capture
evernight connect vnc://192.168.1.100:5901
```

-----------------------------------------------------------------------------

## 8. RDP

### Lado del servidor
- **Windows**: RDP nativo (Configuración → Escritorio remoto → Activar)
- **Linux**: `apt install xrdp`
  - Para TLS: establecer `security_layer=tls` en `/etc/xrdp/xrdp.ini`
  - Generar certificado: `openssl req -x509 -newkey rsa:2048 -nodes -keyout key.pem -out cert.pem -days 365 -subj "/CN=localhost"`
  - Copiar a `/etc/xrdp/cert.pem` + `/etc/xrdp/key.pem`

### Lado de evernight
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

### Estado actual de RDP
- ✅ Transporte: X.224 + actualización TLS (verificado contra xrdp real)
- ✅ MCS: Connect-Initial/Response + Attach-User (verificado)
- ✅ Bitmap: decodificación sin compresión + Interleaved RLE → RGBA
- ✅ Entrada: scancodes de teclado + eventos de ratón
- ✅ Canales: CLIPRDR + RDPDR + RDPSND + DVC
- ✅ NLA: NTLMv2 + CredSSP (Kerberos necesita KDC)
- ◐ Sesión: necesita Channel-Join → intercambio de capacidades → bucle continuo de framebuffer

-----------------------------------------------------------------------------

## 9. Kubernetes

### Lado del servidor
- Cualquier clúster k8s (minikube, kind, EKS, GKE, etc.)
- Autenticación: `~/.kube/config` o cuenta de servicio dentro del clúster

### Lado de evernight
```rust
use evernight::cloud::k8s::K8sClient;

let client = K8sClient::from_kubeconfig("default").await?;
let pods = client.list_pods().await?;
for pod in &pods {
    println!("{}: {} ({} containers)", pod.name, pod.phase, pod.containers.len());
}
```

-----------------------------------------------------------------------------

## 10. libvirt

### Lado del servidor
- `apt install libvirt-daemon-system libvirt-dev`
- Iniciar libvirtd: `systemctl start libvirtd`

### Lado de evernight
```rust
use evernight::cloud::libvirt_client::LibvirtClient;

let client = LibvirtClient::open_read_only("qemu:///system")?;
let domains = client.list_domains()?;
for d in &domains {
    println!("{}: {:?}", d.name, d.state);
}
```

-----------------------------------------------------------------------------

## La cuestión del cliente: ¿Debería construir un visor?

### El problema

Evernight decodifica los bitmaps de RDP a búferes RGBA y los fotogramas de VNC a píxeles, pero **no hay dónde mostrarlos**. Sin un renderizador:

- No se puede verificar visualmente que la decodificación del bitmap sea correcta (solo se puede comprobar que no falle)
- No se puede hacer dogfooding — se supone que evernight es un "gestor de conexiones universal de clase XPipe", y XPipe muestra escritorios remotos
- Las pruebas manuales requieren un visor externo (mstsc.exe / xfreerdp / vinagre)

### Recomendación: SÍ — construir un visor mínimo integrado

Tres niveles de esfuerzo, del más simple al más útil:

#### Nivel 1: Captura de pantalla headless (menor esfuerzo, mayor valor de prueba)

```text
evernight connect rdp://host --screenshot out.png
```

Captura UN fotograma tras el establecimiento de la sesión y lo escribe en un PNG. No necesita GUI. Usa el `bitmap::decode_to_rgba` existente + un codificador PNG sencillo (o PPM, que no requiere dependencias). Esto proporciona:

- **Regresión visual automatizada**: comparar capturas entre commits
- **Corrección del protocolo**: se PUEDE VER si la decodificación del bitmap de RDP es correcta
- **Apto para CI**: no requiere servidor de pantalla

Esfuerzo estimado: ~100 líneas (codificación PNG + bucle de captura de una sola toma).

#### Nivel 2: ventana egui (esfuerzo moderado, pruebas manuales completas)

```text
evernight connect rdp://host --gui
```

Abre una ventana de [egui](https://github.com/emilk/egui) que muestra el framebuffer de RDP en vivo. La entrada de teclado/ratón se envía de vuelta mediante el códec de entrada existente. Esto proporciona:

- **Bucle cerrado completo**: escribir → ver la salida → verificar la interacción
- **Sin dependencias externas**: egui es Rust puro, multiplataforma
- **Binario único**: no hace falta una aplicación de visor aparte

Esfuerzo estimado: ~300 líneas (subida de textura a egui + bucle de eventos de entrada). El crate `eframe` de egui ya es común en el ecosistema.

#### Nivel 3: Frontend web mediante la API existente (mayor esfuerzo, producción)

Evernight ya dispone de `api-serve --transport ws` (JSON-RPC sobre WebSocket). Un frontend web (shittim-chest / Tauri) se conecta a esta API y:

- Renderiza el framebuffer en un `<canvas>`
- Envía eventos de entrada vía JSON-RPC
- Esta es la ruta de producción — los Niveles 1+2 son para desarrollo/pruebas

Este es trabajo de frontend (Vue/React/Tauri), no código de la librería evernight.

### ¿Qué nivel construir?

**Empiece por el Nivel 1 (captura headless)** — es el de mayor ROI para pruebas y lleva ~1 hora. Cierra la brecha más crítica: por fin se puede VER si el pipeline de bitmaps de RDP produce píxeles correctos.

Luego añada el Nivel 2 (egui) cuando necesite pruebas interactivas — p. ej., verificar la entrada de teclado, el portapapeles, la redirección de unidades.

El Nivel 3 es el frontend de producción, que se construye cuando la interfaz web esté lista.

-----------------------------------------------------------------------------

## Inicio rápido: verifique su configuración

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
