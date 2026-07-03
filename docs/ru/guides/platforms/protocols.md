# Интеграция промышленных протоколов — Evernight

Evernight — **обязательный брокер аппаратных возможностей** для экосистемы
celestia-island. Ни один вышестоящий крейт не импортирует `aoba` / `rust7` / и
т.п. напрямую — весь физический ввод-вывод проходит через протокольные модули
evernight.

## Уровни протоколов

Не все протоколы одинаковы. Evernight классифицирует их по трём уровням:

| Уровень | Что | Встроенный? | В образе aris? | Примеры |
|---------|-----|-------------|----------------|---------|
| **Tier 1** | Открытые стандарты — всегда доступны | ✅ Да | ✅ Да | OPC UA, Modbus TCP/RTU, CAN, EtherCAT |
| **Tier 2** | Вендорские — официальные крейты, опционально | Optional feature | ❌ Нет | S7comm, MC Protocol, EtherNet/IP |
| **Tier 3** | Сторонние плагины — загрузка во время выполнения | ❌ Внешний процесс | ❌ Нет | Что угодно, что вы напишете |

### Зачем нужно разделение на уровни?

**Tier 1 (открытые стандарты)** — это основной путь. Современные ПЛК всех
крупных производителей (Siemens S7-1500, Mitsubishi iQ-R, Rockwell ControlLogix
5580) поставляются со встроенными OPC UA серверами. Если устройство поддерживает
OPC UA, используйте его — никакого вендорского кода не требуется.

**Tier 2 (вендорские)** покрывает устаревший установленный парк. Миллионы ПЛК в
эксплуатации (S7-300/1200, MELSEC Q, старые Allen-Bradley) не имеют OPC UA и
говорят только на своих проприетарных протоколах. Эти протоколы:

- Реализованы как **самостоятельные крейты** (не встроены в ядро evernight)
- Компилируются только при включении соответствующей Cargo feature
- **Не входят** в образ ОС шлюза aris по умолчанию
- Каждый крейт также служит **эталонной реализацией** для авторов плагинов Tier 3

**Tier 3 (сторонние плагины)** позволяет любому добавить поддержку протокола, не
затрагивая исходный код evernight. Плагин — это внешний процесс, говорящий на
JSON-RPC (с использованием типов
[arona](https://github.com/celestia-island/arona)) поверх WebSocket или
Unix-доменного сокета. TOML-конфиг шлюза объявляет, где находится каждый плагин.

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

## Tier 1: Открытые стандарты

### Modbus (RTU поверх serial / TCP)

Modbus — рабочая лошадка промышленной связи. Это открытый стандарт (IEC 61158),
поддерживаемый практически каждым ПЛК, датчиком и приводом на рынке.

**Всегда компилируется.** Никаких feature-флагов не требуется.

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

OPC UA (IEC 62541) — универсальный стандарт промышленной связи. Современные ПЛК
от Siemens, Mitsubishi, Rockwell и других поставляются со встроенными OPC UA
серверами. Если устройство поддерживает OPC UA, это предпочтительный путь —
никакого вендорского протокола не требуется.

```toml
[dependencies]
evernight = { version = "0.1", features = ["opcua"] }
```

### CAN 2.0B / EtherCAT

Открытые стандарты для полевой шины (топливные элементы, сервоприводы, управление
движением). Включаются через features `can` и `ethercat`.

---

## Tier 2: Вендорские протоколы

Каждый протокол Tier 2 — это **самостоятельный крейт**, реализующий трейты
`ProtocolBackend` и `ProtocolProbe`. Они опциональны — включите Cargo feature,
чтобы скомпилировать их, или оставьте выключенными, чтобы уменьшить размер
бинарника.

> **Крейты Tier 2 НЕ входят в образ ОС шлюза aris по умолчанию.**
> Образ содержит только Tier 1. Если вам нужен вендорский протокол на шлюзе,
> либо:
> 1. Соберите кастомный образ aris с включённой feature, либо
> 2. Запустите протокол как плагин Tier 3 (см. ниже).

### S7comm (Siemens S7-1200/1500/300/400)

```toml
[dependencies]
evernight = { version = "0.1", features = ["s7comm"] }
```

S7comm — нативный протокол Siemens поверх ISO-on-TCP (порт 102). Это
**приоритетный вендорский протокол** — у Siemens крупнейший установленный парк
на целевых рынках (водородная энергетика, химия, фармацевтика).

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

**Валидация:** Проверен относительно эталонной C-реализации Snap7 (15-летний
открытый отраслевой стандарт). Побайтовое дифференциальное тестирование
подтверждает соответствие wire-формату. В CI проходят 19 интеграционных тестов.

### MC Protocol (Mitsubishi MELSEC)

```toml
[dependencies]
evernight = { version = "0.1", features = ["mc"] }
```

MC Protocol (кадр 3E binary) охватывает серии Mitsubishi MELSEC Q/L/iQ-R.
**Низший приоритет** среди вендорских протоколов — экосистема Mitsubishi
закрытая, без эталонной реализации сервера. Однако современные ПЛК Mitsubishi
(iQ-R, iQ-F) имеют встроенный OPC UA, поэтому **OPC UA — предпочтительный путь
для устройств Mitsubishi**.

**Валидация:** Сверён с шестью независимыми источниками (официальное руководство
Mitsubishi, драйвер Beijer Electronics, документация Neuron, эмулятор Sym3,
клиент pymcprotocol, снятые в поле кадры).

### EtherNet/IP (Rockwell/Allen-Bradley)

```toml
[dependencies]
evernight = { version = "0.1", features = ["enip"] }
```

EtherNet/IP + CIP охватывает ПЛК Rockwell Automation / Allen-Bradley,
преимущественно на североамериканском рынке.

---

## Tier 3: Плагинный протокол — JSON-RPC поверх WebSocket / IPC

Tier 3 позволяет **любому** добавить поддержку протокола в evernight без
изменения исходного кода evernight. Плагин — это внешний процесс, который:

1. Слушает на WebSocket (`ws://host:port`) или Unix-доменном сокете (`ipc:///path`)
2. Говорит на JSON-RPC 2.0, используя типы
   [arona](https://github.com/celestia-island/arona)
3. Реализует тот же интерфейс `connect` / `read` / `write` / `ping`, что и
   встроенные бэкенды

### Объявление плагинов в TOML шлюза

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

При запуске evernight читает этот файл, создаёт `RemotePluginBackend` для каждой
записи и регистрирует его в `ProtocolRegistry`. С этого момента плагин участвует
в автоопределении и вводе-выводе данных точно так же, как встроенный бэкенд.

### JSON-RPC интерфейс (типы arona)

Плагин должен отвечать на следующие JSON-RPC методы (определены в arona):

| Метод | Параметры | Возвращает |
|-------|-----------|------------|
| `protocol.connect` | `{ transport: TransportInfo }` | `{ connected: bool }` |
| `protocol.read` | `{ address: DataAddress }` | `{ raw: [u8], latency_us: u64 }` |
| `protocol.write` | `{ address: DataAddress, data: [u8] }` | `{ confirmed: bool }` |
| `protocol.ping` | `{}` | `{ reachable: bool }` |
| `protocol.probe` | `{ transport: TransportInfo }` | `{ protocol: string, confidence: float }` |

См. [крейт arona](https://github.com/celestia-island/arona) для полных
определений типов и TypeScript-биндингов.

### Написание плагина Tier 3

Крейт Tier 2 (напр. `evernight-s7comm`) также служит **эталонной реализацией**.
Авторы плагинов могут изучить его исходники, чтобы понять контракт трейта
`ProtocolBackend`, затем реализовать ту же логику на любом языке (Python, Go, C,
Node.js) за JSON-RPC сервером.

Минимальный пример плагина на Python:

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

## Архитектура

Каждый протокол — независимо от уровня — реализует одни и те же два трейта:

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

## Приоритет автоопределения

При зондировании неизвестного устройства сначала запускаются пробы открытых
стандартов Tier 1:

| Приоритет | Протокол | Порт |
|-----------|----------|------|
| 10 | OPC UA | 4840 |
| 20 | Modbus TCP | 502 |
| 30 | EtherCAT | — |
| 40 | CAN | — |
| 50 | S7comm (Tier 2) | 102 |
| 60 | MC Protocol (Tier 2) | 5000 |
| 70 | EtherNet/IP (Tier 2) | 44818 |
| 100+ | Плагины Tier 3 | варьируется |

Открытые стандарты получают наименьшие номера приоритета (проверяются первыми),
потому что если устройство говорит на OPC UA — это и есть нужный путь,
независимо от вендора.

## Справочник команд CLI

| Команда | Описание |
|---------|----------|
| `evernight probe <host> [--ports 502,102,...]` | Зондировать хост на наличие протоколов (все уровни) |
| `evernight sensor-poll [--manifest X.toml]` | Опрашивать датчики, генерировать тревоги |
| `evernight api-serve --transport ws` | Запустить JSON-RPC API сервер |

## Типы данных полей S7

| Тип | Размер | Формат смещения | Декодирование |
|-----|--------|-----------------|---------------|
| `BOOL` | 1 бит | `8.0` (байт 8, бит 0) | проверка бита |
| `BYTE` | 1 байт | `8` | `u8` |
| `WORD` | 2 байта | `8` | `u16::from_be_bytes` |
| `INT` | 2 байта | `8` | `i16::from_be_bytes` |
| `DWORD` | 4 байта | `8` | `u32::from_be_bytes` |
| `DINT` | 4 байта | `8` | `i32::from_be_bytes` |
| `REAL` | 4 байта | `0` | `f32::from_be_bytes` |
| `STRING` | перем. | `20` | ASCII с префиксом длины |

> Дробная часть `offset` кодирует **индекс бита** для полей BOOL.

## Маршрутизация тревог

Показания датчиков проходят через общий конвейер тревог. Каждый протокол
получает собственное пространство имён топиков:

| Протокол | Топик триггера | Source id |
|----------|----------------|-----------|
| Modbus | `modbus.{station}.{field}.{level}` | `evernight.modbus.{station}` |
| S7comm | `s7comm.{station}.{field}.{level}` | `evernight.s7comm.{station}` |
| OPC UA | `opcua.{node}.{field}.{level}` | `evernight.opcua.{node}` |

Уровни тревог следуют ISA-18.2: `ll` / `l` / `h` / `hh` / `roc`.
