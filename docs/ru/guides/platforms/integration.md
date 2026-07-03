# Руководство по интеграции — Evernight

Как подключить evernight к каждому поддерживаемому протоколу, какое серверное ПО использовать и как проверить работоспособность соединения сквозным (end-to-end) способом.

## Архитектура

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

## 1. Modbus RTU (последовательный)

### Серверная сторона
- **Устройство**: любой подчинённый узел Modbus RTU (ПЛК, датчик, инвертор)
- **Тест без сервера**: `socat PTY,raw,echo=0,link=/tmp/vcom_a PTY,raw,echo=0,link=/tmp/vcom_b &`
  — создаёт виртуальную последовательную пару; запустите `tests/modbus_slave_sim.rs` для 6 станций.

### Сторона Evernight
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

### Серверная сторона
- **Устройство**: ПЛК S7-1200/1500/300/400
- **Предварительное требование**: TIA Portal → включить "Permit PUT/GET" + отключить "Optimized block access"
- **Тест без оборудования**: `cargo test --features full --test s7comm_integration` (использует внутрипроцессный snap7-сервер)

### Сторона Evernight
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

### Серверная сторона
- **Устройство**: ПЛК MELSEC FX/Q/L/iQ-R
- **Тест без оборудования**: `tests/mc_test_server.rs` (внутрипроцессный mock MC-сервер)

### Сторона Evernight
```rust
use evernight::protocol::mc_protocol::{McProtocolClient, McDevice};

let client = McProtocolClient::new("192.168.1.5", 5000);
client.connect().await?;
let words = client.read_devices(McDevice::D, 0, 10).await?;
println!("D0-D9: {:?}", words);
```

-----------------------------------------------------------------------------

## 4. EtherNet/IP (Rockwell)

### Серверная сторона
- **Устройство**: Allen-Bradley CompactLogix / ControlLogix
- **Тест без оборудования**: модульные тесты со вручную собранными кадрами (без живого симулятора)

### Сторона Evernight
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

### Серверная сторона
- **Устройство/ПО**: любой OPC UA-сервер (KEPServerEX, Ignition, CODESYS и т. д.)
- **Self-hosted**: сам evernight может выступать в роли OPC UA-сервера:

```rust
use evernight::protocol::opcua_server::OpcUaSensorServer;

let mut server = OpcUaSensorServer::new("opc.tcp://0.0.0.0:4840", 4840)?;
let node = server.add_sensor_variable("temperature", 25.5)?;
// server.run();  // blocks — run in a separate thread
```

### Клиентская сторона Evernight
```rust
use evernight::protocol::opcua_client::{OpcUaClient, OpcUaEndpoint, OpcUaSecurity};

let endpoint = OpcUaEndpoint::new_anonymous("opc.tcp://192.168.1.50:4840");
let client = OpcUaClient::connect(&endpoint).await?;
let value = client.read_node("ns=2;s=Temperature").await?;
println!("Temperature: {}", value);
```

-----------------------------------------------------------------------------

## 6. SSH

### Серверная сторона
- Любой SSH-сервер (OpenSSH, Dropbear и т. д.)
- **Управление ключами**: `evernight vault init ~/.config/evernight/vault "passphrase"`
  затем добавьте учётные данные.

### Сторона Evernight
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

### Серверная сторона
- **ПО**: TigerVNC, x11vnc, RealVNC и т. д.
- **Установка**: `apt install tigervnc-standalone-server && vncserver :1`
- **Доступ через браузер**: evernight может проксировать VNC в WebSocket:

```bash
# Start a VNC-to-WebSocket proxy (noVNC-compatible)
# (programmatically via evernight::vnc::ws::serve_vnc_websocket)
```

### Сторона Evernight
```bash
# CLI one-shot — handshake + server info + one frame capture
evernight connect vnc://192.168.1.100:5901
```

-----------------------------------------------------------------------------

## 8. RDP

### Серверная сторона
- **Windows**: нативный RDP (Settings → Remote Desktop → Enable)
- **Linux**: `apt install xrdp`
  - Для TLS: задайте `security_layer=tls` в `/etc/xrdp/xrdp.ini`
  - Сгенерируйте сертификат: `openssl req -x509 -newkey rsa:2048 -nodes -keyout key.pem -out cert.pem -days 365 -subj "/CN=localhost"`
  - Скопируйте в `/etc/xrdp/cert.pem` + `/etc/xrdp/key.pem`

### Сторона Evernight
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

### Текущее состояние RDP
- ✅ Транспорт: X.224 + повышение до TLS (проверено против реального xrdp)
- ✅ MCS: Connect-Initial/Response + Attach-User (проверено)
- ✅ Bitmap: декодирование несжатого + Interleaved RLE → RGBA
- ✅ Ввод: скан-коды клавиатуры + события мыши
- ✅ Каналы: CLIPRDR + RDPDR + RDPSND + DVC
- ✅ NLA: NTLMv2 + CredSSP (для Kerberos требуется KDC)
- ◐ Сессия: требуется Channel-Join → обмен возможностями → непрерывный цикл framebuffer

-----------------------------------------------------------------------------

## 9. Kubernetes

### Серверная сторона
- Любой кластер k8s (minikube, kind, EKS, GKE и т. д.)
- Аутентификация: `~/.kube/config` или внутрикластерный service account

### Сторона Evernight
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

### Серверная сторона
- `apt install libvirt-daemon-system libvirt-dev`
- Запуск libvirtd: `systemctl start libvirtd`

### Сторона Evernight
```rust
use evernight::cloud::libvirt_client::LibvirtClient;

let client = LibvirtClient::open_read_only("qemu:///system")?;
let domains = client.list_domains()?;
for d in &domains {
    println!("{}: {:?}", d.name, d.state);
}
```

-----------------------------------------------------------------------------

## Вопрос о клиенте: стоит ли создавать вьюер (viewer)?

### Проблема

Evernight декодирует RDP-битмапы в RGBA-буферы, а VNC-кадры — в пиксели, но **их негде отображать**. Без рендерера:

- Невозможно визуально проверить корректность декодирования битмапов (можно лишь убедиться, что не происходит падения)
- Невозможно «dogfood» — evernight должен быть «универсальным менеджером подключений уровня XPipe», а XPipe показывает удалённые рабочие столы
- Ручное тестирование требует внешнего вьюера (mstsc.exe / xfreerdp / vinagre)

### Рекомендация: ДА — создайте минимальный встроенный вьюер

Три уровня усилий, от простейшего к наиболее полезному:

#### Уровень 1: Скриншот в headless-режиме (минимум усилий, максимальная ценность для тестирования)

```text
evernight connect rdp://host --screenshot out.png
```

Захватывает ОДИН кадр после настройки сессии и записывает его в PNG. GUI не требуется.
Использует существующий `bitmap::decode_to_rgba` + простой PNG-кодировщик (или PPM, не требующий зависимостей). Это даёт:

- **Автоматизированную визуальную регрессию**: сравнение скриншотов между коммитами
- **Корректность протокола**: можно ВИДЕТЬ, правильно ли декодируется RDP-битмап
- **Совместимость с CI**: дисплейный сервер не требуется

Оценка усилий: ~100 строк (PNG-кодирование + цикл разового захвата).

#### Уровень 2: окно egui (умеренные усилия, полное ручное тестирование)

```text
evernight connect rdp://host --gui
```

Открывает окно [egui](https://github.com/emilk/egui), показывающее живой RDP-framebuffer. Ввод с клавиатуры/мыши отправляется обратно через существующий входной кодек. Это даёт:

- **Полный замкнутый цикл**: ввод → вывод → проверка взаимодействия
- **Без внешних зависимостей**: egui — чистый Rust, кроссплатформенный
- **Единый бинарник**: отдельное приложение-вьюер не требуется

Оценка усилий: ~300 строк (загрузка текстуры egui + цикл событий ввода).
Крейт `eframe` из egui уже широко распространён в экосистеме.

#### Уровень 3: Веб-фронтенд через существующий API (наибольшие усилия, продакшен)

В evernight уже есть `api-serve --transport ws` (JSON-RPC поверх WebSocket).
Веб-фронтенд (shittim-chest / Tauri) подключается к этому API и:

- Рендерит framebuffer на `<canvas>`
- Отправляет события ввода через JSON-RPC
- Это продакшен-путь — Уровни 1+2 предназначены для разработки/тестирования

Это фронтенд-работа (Vue/React/Tauri), а не код библиотеки evernight.

### Какой уровень строить?

**Начните с Уровня 1 (headless-скриншот)** — это максимальная отдача (ROI) для тестирования, занимает ~1 час. Он закрывает наиболее критичный пробел: наконец-то можно ВИДЕТЬ, выдаёт ли RDP-конвейер битмапов корректные пиксели.

Затем добавьте Уровень 2 (egui), когда потребуется интерактивное тестирование — напр., проверка ввода с клавиатуры, буфера обмена, перенаправления дисков.

Уровень 3 — это продакшен-фронтенд, создаваемый, когда веб-UI будет готов.

-----------------------------------------------------------------------------

## Быстрый старт: проверка вашей настройки

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
