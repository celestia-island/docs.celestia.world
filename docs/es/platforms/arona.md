# Arona — Pasarela de modelos, memoria y clúster

Arona es el plano de control de la plataforma: pasarela de modelos, gestor
del runtime de autodespliegue y panel web. El problema que resuelve es
convertir «un modelo descargado en alguna máquina» en algo que toda la
plataforma pueda enrutar, medir y recordar. Esta guía se organiza por
capacidad: enrutado de modelos, memoria a largo plazo y clústeres
multinodo.

## Arquitectura de un vistazo

```text
shittim-chest / cualquier cliente OpenAI
        │  /v1/chat/completions (clave de API Bearer)
        ▼
   Pasarela Arona (node-2:8420)
   ├─ Router: alias → balanceo de carga por recuento mínimo entre backends
   ├─ Pasarela de memoria: inyección de recuerdo → chat → reescritura (episodios)
   └─ Plano de control de agentes (/ws/agent) ──► arona-agent en nodos GPU
        │
        ▼
   Backends: ollama · external (compatible con OpenAI) · motores desplegados por agentes
```

Todo el tráfico de gestión (panel, agentes, memoria) corre sobre WebSocket
con mensajes JSON-RPC 2.0; la única superficie REST son los endpoints
`/v1/*` compatibles con OpenAI.

## 1. Modelos

### Registrar un backend

Los backends se registran como `ollama` o `external` (cualquier servidor
compatible con OpenAI — vLLM, TGI, LMDeploy, el router de TileRT, …):

```bash
POST /api/admin/backends        # Bearer ADMIN_TOKEN
  {"type": "ollama", "name": "node3-ollama", "url": "http://host:11434"}
  {"type": "external", "name": "my-vllm", "url": "http://host:8000",
   "api_key": "...", "models": ["qwen2.5-72b"]}
```

Los backends registrados persisten entre reinicios (tabla
`backend_configs`) y se sondea su salud de forma continua: los backends
`external` operan en modo fail-closed hasta que su primera sonda
`/v1/models` tiene éxito, y su lista de modelos se refresca dinámicamente.

### Autodesplegar un modelo en un nodo

El binario `arona-agent` se ejecuta en máquinas con GPU y se conecta de
vuelta al panel. Despliega un modelo desde la página **Agents** del panel
(o vía `agents.deploy` con un `agent_id` vacío para elegir automáticamente
el nodo menos cargado). El agente descarga el modelo (registro de
HuggingFace u Ollama), arranca el motor (llama.cpp / vLLM / Ollama) y
reporta el endpoint del motor — el panel lo registra automáticamente como
un backend enrutable `agent-{model}` y lo retira cuando se detiene.

Dirección de enlace del motor: define `ARONA_AGENT_BIND_ADDR=0.0.0.0` en
los nodos que deban servir tráfico al panel. Nota: los puertos de los
motores no están autenticados — despliega solo en redes de confianza.

### Afinidad de conversación

Las conversaciones se fijan a un backend (afinidad de sesión), lo que
permite reutilizar las cachés KV del runtime. Si un backend fijado pierde
salud, el router recurre a otro y vuelve a fijar.

## 2. Memoria a largo plazo

Arona es una **pasarela de memoria**: no entrena modelos — orquesta un
servicio de memoria (el agente PhiLia de entelecheia) alrededor de tu
modelo existente.

### Activar

```bash
ARONA_MEMORY_URL=ws://<scepter-host>:8424/ws
ARONA_MEMORY_TOKEN=<token de conexión de scepter>
ARONA_MEMORY_WRITEBACK=1        # activado por defecto; 0 desactiva la reescritura
```

### Qué ocurre en cada chat

1. **Recuerdo** — el último mensaje del usuario se embebe y se consulta
   contra el servicio de memoria; las memorias relevantes se inyectan como
   sección de sistema `## Relevant Long-Term Memories` (idempotente).
2. **Chat** — el contexto ensamblado se enruta al modelo.
3. **Reescritura** — el turno completado se extrae de forma heurística
   (`User: … / Assistant: …`, cero llamadas LLM) y se guarda como episodio
   en el grafo de memoria (respaldado por pgvector, sobrevive a los
   reinicios).
4. **Estado** — cada respuesta reporta `memory: enabled | disabled |
   offline`; la superficie REST añade una cabecera `X-Arona-Memory`. Los
   fallos nunca bloquean el chat; `offline` significa que el servicio de
   memoria es inalcanzable y siempre es visible en la UI.

Anulación por llamada: `chat.send` acepta `memory: true|false`.

### Gestionar

La página **Memory** del panel muestra la actividad de
recuerdo/reescritura/borrado y permite borrar los nodos almacenados. Las
sesiones persisten en el servidor: pasa `conversation_id` a `chat.send` y
el servidor ensambla el historial en lugar del cliente.

## 3. Operaciones

- **Autenticación**: el registro se bloquea tras el primer arranque del
  administrador (`ARONA_REGISTRATION_OPEN=1` lo reabre). Los endpoints de
  administración requieren `ARONA_ADMIN_TOKEN`; fallan cerrados sin él.
- **Medición**: el uso y el coste se registran por clave de API
  (`usage.list`, niveles de facturación con cuotas y límites de tasa).
- **Salud**: `/api/health` y `/v1/health` reportan la versión y el hash de
  compilación.

## Referencia de variables de entorno

| Variable | Propósito |
|---|---|
| `DATABASE_URL` | Postgres (obligatorio) |
| `JWT_SECRET` | Firma de tokens (obligatorio fuera del modo mock) |
| `ARONA_HOST` / `ARONA_PORT` | Dirección de enlace (por defecto `0.0.0.0:8420`) |
| `ARONA_ADMIN_TOKEN` | Token Bearer para `/api/admin/*` |
| `ARONA_REGISTRATION_OPEN` | Reabrir el auto-registro |
| `ARONA_MEMORY_URL` / `ARONA_MEMORY_TOKEN` / `ARONA_MEMORY_WRITEBACK` | Pasarela de memoria |
| `ARONA_AGENT_NAME` / `ARONA_PANEL_URL` / `ARONA_AGENT_BIND_ADDR` | Nodo agente |
