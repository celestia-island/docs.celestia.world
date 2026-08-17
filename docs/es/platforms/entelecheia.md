# Entelecheia — Plataforma de agentes y memoria

Entelecheia es la plataforma de agentes: el runtime scepter que orquesta
agentes especializados (las «almas»), mantiene la memoria a largo plazo
(PhiLia), proporciona búsqueda semántica y aloja la capa de integración
industrial. Detrás de las capacidades de Arona y Chest está esta
plataforma. Esta guía se organiza por capacidad: agentes, memoria,
búsqueda, conocimiento y conexiones.

## Arquitectura de un vistazo

```text
Clientes: Arona (pasarela) · Shittim Chest (chat/paneles) · TUI/CLI
        │  JSON-RPC 2.0 sobre WebSocket (token o clave de API)
        ▼
   runtime scepter (node-3:8424)
   ├─ Gestor de agentes: almas L1 (PhiLia, Skopeo, Hubris, Kalos, …)
   ├─ Cadenas de habilidades: canalizaciones de LLM + llamadas a herramientas con precarga RAG
   ├─ PhiLia: memoria a largo plazo (vectorial + grafo, respaldada por pgvector)
   ├─ ApoRia: base de conocimiento + índice de espacios de trabajo (búsqueda semántica)
   ├─ OreXis: compuertas de política / seguridad sobre la ejecución de herramientas
   └─ Reflexión: almacén de lecciones reinyectado en los prompts
```

## 1. Agentes (almas)

Cada alma es un agente especializado con su propio documento de identidad,
herramientas (al estilo MCP) y habilidades. Las cadenas de habilidades
componen llamadas LLM con ejecución de herramientas; antes de cada llamada
se precargan e inyectan en el prompt del sistema las memorias a largo
plazo relevantes y el contenido de la base de conocimiento.

Seguridad: la ejecución de herramientas pasa por las compuertas de
políticas de OreXis, y las escrituras industriales requieren flujos de
aprobación explícitos.

## 2. Memoria a largo plazo (PhiLia)

PhiLia es el servicio de memoria detrás de la pasarela de memoria de
Arona:

- **Almacenar** — los episodios, entidades y artefactos se guardan como
  nodos en un grafo de memoria, embebidos y replicados a pgvector
  (`philia_chunks`).
- **Consultar** — la recuperación semántica combina similitud vectorial,
  recorrido del grafo y decaimiento por antigüedad (vida media de 14
  días).
- **Consolidar** — la fusión periódica enlaza nodos relacionados.
- **Superficie del protocolo** — métodos de primera clase
  `Sync.MemoryStoreRequest` / `MemoryQueryRequest` / `MemoryDeleteRequest`
  (RBAC: SystemWrite / SystemRead) junto a la ruta genérica `Mcp.CallTool`.

Embebido: se configura mediante `OLLAMA_HOST` + `OLLAMA_EMBED_MODEL` (p.
ej. `nomic-embed-text`), o una API remota, recurriendo a un modelo ONNX
local como respaldo.

## 3. Búsqueda semántica

`Sync.SearchRequest` fusiona dos almacenes en una sola lista clasificada:

- **ApoRia** — índice de espacios de trabajo, informes de agentes y
  documentos de la base de conocimiento (híbrido vectorial + palabras
  clave con RRF).
- **PhiLia** — memorias a largo plazo (fuente `philia_memory`).

## 4. Base de conocimiento

Crea bases de conocimiento, añade documentos y suscríbete a las
suscripciones rag — todo persiste en Postgres. Los documentos se embeben
en el almacén de ApoRia y se recuperan a través de la misma superficie de
búsqueda.

## 5. Reflexión

Las lecciones aprendidas se guardan en un almacén de lecciones (pgvector)
y se reinyectan en los prompts futuros — una segunda memoria persistente,
ligera, junto a PhiLia.

## 6. Conectar clientes

- WebSocket `ws://<host>:8424/ws` — autentica en el upgrade con
  `?token=<connection token>` (o Bearer); después
  `Sync.ConnectHandshake`.
- JSON-RPC por HTTP `POST /api/rpc?token=…` para uso de
  petición/respuesta.
- Token de conexión: `~/.config/entelecheia/scepter.token` en el nodo
  scepter.

## Referencia de variables de entorno (subconjunto)

| Variable | Propósito |
|---|---|
| `SERVER_BIND_ADDRESS` | Dirección de enlace (por defecto 127.0.0.1; define 0.0.0.0:8424 para clientes remotos) |
| `DATABASE_URL` | Postgres (config.toml o env) |
| `OLLAMA_HOST` / `OLLAMA_EMBED_MODEL` | Backend de embebido |
| `JWT_SECRET` | Tokens de autenticación persistentes (aleatorios por sesión si no se define) |
| `connection_token` | Archivo de token de conexión de scepter |
