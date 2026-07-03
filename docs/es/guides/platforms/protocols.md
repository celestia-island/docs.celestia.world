# Integración de Protocolos Industriales — Evernight

Evernight es el **broker obligatorio de capacidades de hardware** para el
ecosistema celestia-island. Ningún crate de nivel superior importa
`aoba` / `rust7` / etc. directamente — toda la E/S física se enruta a través de
los módulos de protocolo de evernight.

## Niveles de protocolo

No todos los protocolos son iguales. Evernight los clasifica en tres niveles
(tiers):

| Nivel | Qué | Integrado? | En la imagen aris? | Ejemplos |
|-------|-----|------------|--------------------|----------|
| **Tier 1** | Estándares abiertos — siempre disponibles | ✅ Sí | ✅ Sí | OPC UA, Modbus TCP/RTU, CAN, EtherCAT |
| **Tier 2** | Específicos de fabricante — crates oficiales, opt-in | Función opcional | ❌ No | S7comm, MC Protocol, EtherNet/IP |
| **Tier 3** | Plugins de terceros — cargados en tiempo de ejecución | ❌ Proceso externo | ❌ No | Cualquiera que usted escriba |

### ¿Por qué niveles?

**Tier 1 (estándares abiertos)** es la ruta principal. Los PLC modernos de todos
los grandes fabricantes (Siemens S7-1500, Mitsubishi iQ-R, Rockwell ControlLogix
5580) se entregan con servidores OPC UA integrados. Si un dispositivo habla OPC
UA, úselo — no se necesita código específico de fabricante.

**Tier 2 (específicos de fabricante)** cubre la base instalada heredada. Millones
de PLC en el campo (S7-300/1200, MELSEC Q, Allen-Bradley antiguos) no tienen OPC
UA y solo hablan su protocolo propietario. Estos protocolos están:

- Implementados como **crates independientes** (no incrustados en el núcleo de evernight)
- Compilados solo cuando la función de Cargo está habilitada
- **No incluidos** en la imagen del sistema operativo del gateway aris por defecto
- Cada crate sirve además como **implementación de referencia** para los autores de plugins de Tier 3

**Tier 3 (plugins de terceros)** permite a cualquiera añadir soporte de protocolo
sin tocar el código fuente de evernight. Un plugin es un proceso externo que
habla JSON-RPC (usando tipos de [arona](https://github.com/celestia-island/arona))
sobre WebSocket o socket de dominio Unix. La configuración TOML del gateway
declara dónde reside cada plugin.

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

## Tier 1: Estándares abiertos

### Modbus (RTU sobre serie / TCP)

Modbus es el caballo de batalla de la comunicación industrial. Es un estándar
abierto (IEC 61158) soportado por prácticamente todo PLC, sensor y variador del
mercado.

**Siempre compilado.** No se necesitan feature flags.

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

OPC UA (IEC 62541) es el estándar universal de comunicación industrial. Los PLC
modernos de Siemens, Mitsubishi, Rockwell y otros incluyen servidores OPC UA
integrados. Si un dispositivo soporta OPC UA, esta es la ruta preferida — no se
necesita ningún protocolo específico de fabricante.

```toml
[dependencies]
evernight = { version = "0.1", features = ["opcua"] }
```

### CAN 2.0B / EtherCAT

Estándares abiertos para comunicación de fieldbus (pilas de combustible,
variadores servo, control de movimiento). Se habilitan mediante las funciones
`can` y `ethercat`.

---

## Tier 2: Protocolos específicos de fabricante

Cada protocolo de Tier 2 es un **crate independiente** que implementa los traits
`ProtocolBackend` y `ProtocolProbe`. Son opt-in — habilite la función de Cargo
para compilarlos, o déjelos fuera para mantener el binario pequeño.

> **Los crates de Tier 2 NO se incluyen en la imagen del sistema operativo del
> gateway aris por defecto.** La imagen se entrega solo con Tier 1. Si necesita
> un protocolo específico de fabricante en el gateway, puede:
> 1. Construir una imagen aris personalizada con la función habilitada, o
> 2. Ejecutar el protocolo como un plugin de Tier 3 (ver más abajo).

### S7comm (Siemens S7-1200/1500/300/400)

```toml
[dependencies]
evernight = { version = "0.1", features = ["s7comm"] }
```

S7comm es el protocolo nativo de Siemens sobre ISO-on-TCP (puerto 102). Este es
el **protocolo de fabricante de mayor prioridad** — Siemens tiene la mayor base
instalada en los mercados objetivo (energía de hidrógeno, química, farma).

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

**Validación:** Verificado contra la implementación de referencia en C de Snap7
(estándar de la industria de código abierto con 15 años de antigüedad). Pruebas
diferenciales a nivel de byte confirman la conformidad del formato de red. 19
pruebas de integración pasan en CI.

### MC Protocol (Mitsubishi MELSEC)

```toml
[dependencies]
evernight = { version = "0.1", features = ["mc"] }
```

MC Protocol (trama binaria 3E) cubre las series Mitsubishi MELSEC Q/L/iQ-R. Es
la **prioridad más baja** de los protocolos de fabricante — el ecosistema de
Mitsubishi es de código cerrado y no existe ninguna implementación de servidor
de referencia. Sin embargo, los PLC modernos de Mitsubishi (iQ-R, iQ-F) tienen
OPC UA integrado, así que **OPC UA es la ruta preferida para dispositivos
Mitsubishi**.

**Validación:** Contrastado contra seis fuentes independientes (manual oficial
de Mitsubishi, driver de Beijer Electronics, documentación de Neuron, emulador
Sym3, cliente pymcprotocol, capturas de trama probadas en campo).

### EtherNet/IP (Rockwell/Allen-Bradley)

```toml
[dependencies]
evernight = { version = "0.1", features = ["enip"] }
```

EtherNet/IP + CIP cubre los PLC de Rockwell Automation / Allen-Bradley,
principalmente en el mercado norteamericano.

---

## Tier 3: Protocolo por plugin — JSON-RPC sobre WebSocket / IPC

Tier 3 permite a **cualquiera** añadir soporte de protocolo a evernight sin
modificar el código fuente de evernight. Un plugin es un proceso externo que:

1. Escucha en un WebSocket (`ws://host:puerto`) o en un socket de dominio Unix (`ipc:///ruta`)
2. Habla JSON-RPC 2.0 usando tipos de [arona](https://github.com/celestia-island/arona)
3. Implementa la misma interfaz `connect` / `read` / `write` / `ping` que los backends integrados

### Declaración de plugins en el TOML del gateway

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

Al iniciar, evernight lee este archivo, instancia un `RemotePluginBackend` por
cada entrada y lo registra en el `ProtocolRegistry`. A partir de ese momento,
el plugin participa en la auto-detección y en la E/S de datos exactamente igual
que un backend integrado.

### Interfaz JSON-RPC (tipos de arona)

El plugin debe responder a estos métodos JSON-RPC (definidos en arona):

| Método | Parámetros | Devuelve |
|--------|-----------|---------|
| `protocol.connect` | `{ transport: TransportInfo }` | `{ connected: bool }` |
| `protocol.read` | `{ address: DataAddress }` | `{ raw: [u8], latency_us: u64 }` |
| `protocol.write` | `{ address: DataAddress, data: [u8] }` | `{ confirmed: bool }` |
| `protocol.ping` | `{}` | `{ reachable: bool }` |
| `protocol.probe` | `{ transport: TransportInfo }` | `{ protocol: string, confidence: float }` |

Consulte el [crate arona](https://github.com/celestia-island/arona) para ver las
definiciones completas de tipos y los bindings de TypeScript.

### Escribir un plugin de Tier 3

Un crate de Tier 2 (p. ej. `evernight-s7comm`) sirve además como
**implementación de referencia**. Los autores de plugins pueden estudiar su
código fuente para entender el contrato del trait `ProtocolBackend`, y luego
implementar la misma lógica en cualquier lenguaje (Python, Go, C, Node.js)
detrás de un servidor JSON-RPC.

Ejemplo mínimo de plugin en Python:

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

## Arquitectura

Cada protocolo — independientemente de su nivel — implementa los mismos dos
traits:

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

## Prioridad de auto-detección

Al sondear un dispositivo desconocido, las sondas de estándares abiertos de
Tier 1 se ejecutan primero:

| Prioridad | Protocolo | Puerto |
|-----------|-----------|--------|
| 10 | OPC UA | 4840 |
| 20 | Modbus TCP | 502 |
| 30 | EtherCAT | — |
| 40 | CAN | — |
| 50 | S7comm (Tier 2) | 102 |
| 60 | MC Protocol (Tier 2) | 5000 |
| 70 | EtherNet/IP (Tier 2) | 44818 |
| 100+ | Plugins de Tier 3 | varía |

Los estándares abiertos reciben los números de prioridad más bajos (sondeados
primero) porque si un dispositivo habla OPC UA, esa es la ruta que usted quiere
—independientemente del fabricante.

## Referencia de comandos CLI

| Comando | Descripción |
|---------|-------------|
| `evernight probe <host> [--ports 502,102,...]` | Sondear un host en busca de protocolos (todos los niveles) |
| `evernight sensor-poll [--manifest X.toml]` | Sondar sensores, emitir alarmas |
| `evernight api-serve --transport ws` | Iniciar el servidor de API JSON-RPC |

## Tipos de datos de campo S7

| Tipo | Tamaño | Formato de offset | Decodificación |
|------|--------|-------------------|----------------|
| `BOOL` | 1 bit | `8.0` (byte 8, bit 0) | test de bit |
| `BYTE` | 1 byte | `8` | `u8` |
| `WORD` | 2 bytes | `8` | `u16::from_be_bytes` |
| `INT` | 2 bytes | `8` | `i16::from_be_bytes` |
| `DWORD` | 4 bytes | `8` | `u32::from_be_bytes` |
| `DINT` | 4 bytes | `8` | `i32::from_be_bytes` |
| `REAL` | 4 bytes | `0` | `f32::from_be_bytes` |
| `STRING` | var | `20` | ASCII con prefijo de longitud |

> La parte fraccionaria de `offset` codifica el **índice de bit** para los campos BOOL.

## Enrutamiento de alarmas

Las lecturas de sensores fluyen a través de una tubería de alarmas compartida.
Cada protocolo obtiene su propio espacio de nombres de topic:

| Protocolo | Topic de disparo | Id de origen |
|-----------|------------------|--------------|
| Modbus | `modbus.{station}.{field}.{level}` | `evernight.modbus.{station}` |
| S7comm | `s7comm.{station}.{field}.{level}` | `evernight.s7comm.{station}` |
| OPC UA | `opcua.{node}.{field}.{level}` | `evernight.opcua.{node}` |

Los niveles de alarma siguen ISA-18.2: `ll` / `l` / `h` / `hh` / `roc`.
