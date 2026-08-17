# Shittim Chest — Chat, paneles e integraciones

Shittim Chest es la cara del usuario: chat, paneles e integraciones
multicanal — la capa que convierte las capacidades de modelos y agentes en
algo que usas a diario. Toma modelos y memoria de Arona, y agentes,
paneles y flujos de trabajo industriales del scepter de entelecheia. Esta
guía se organiza por capacidad: chat, paneles, canales, búsqueda y
autenticación.

## Arquitectura de un vistazo

```text
Tú
 │  aplicación de escritorio · web UI · 12+ canales de IM (discord/slack/matrix/lark/…)
 ▼
Núcleo de Shittim Chest (node-2:8425)
 ├─ Chat: conversaciones persistidas en Postgres, streaming SSE/WS
 ├─ Paneles: cuadrícula de datos / canalización de medios / gemelo 3D (motor de paneles)
 ├─ Canalización de medios: revisión de visión LLM, generación de imágenes, gen 3D (stub)
 ├─ Puente de canales: IM ↔ núcleo bidireccional (webhooks + WS)
 └─ Puente RPC → scepter (agentes, búsqueda semántica, base de conocimiento)
        │
        ▼
   Arona (modelos, memoria) · scepter (agentes, paneles, búsqueda)
```

## 1. Chat

- Las conversaciones y los mensajes persisten en Postgres (tablas
  `conversations` / `messages`). El historial completo se ensambla en el
  servidor.
- Streaming vía SSE con repetición de fragmentos; el shell de escritorio
  muestra los fragmentos de pensamiento y las llamadas a herramientas de
  los agentes de scepter.
- `chat.send` admite id de conversación, anulación de modelo y flags de
  memoria (consulta la [guía de Arona](./arona.md) para la semántica de la
  pasarela de memoria).

## 2. Paneles

Los paneles se crean a partir de un solo prompt: el motor genera la
disposición y los widgets, y luego los persiste en el almacén de espacios
de trabajo de scepter (`.amphoreus/workspace.toml` +
`.noa/views/*.view.toml`). La edición es estructurada, no una caja negra:
la vinculación cruda de la fuente de datos, la lista de widgets y el
estado de la conexión son visibles, con un diálogo de edición profunda por
fila y una caja plegada de ajuste en lenguaje natural.

Tres tipos de paneles:

- **Cuadrícula de datos** — vistas de tabla con campos tipados,
  ordenar/filtrar/agrupar; las escrituras pasan por los tipos de edición
  `table.*` con validación y reversión reales.
- **Canalización de medios** — un grafo de nodos al estilo Dify (nodos
  LLM, generación de imágenes, HTTP, recuperación de conocimiento,
  ramificación); las canalizaciones se ejecutan en el servidor con
  progreso en streaming y los agentes pueden invocarlas como
  herramientas.
- **Gemelo 3D** — árboles de modelos de dispositivos con coordenadas del
  mundo, configuración de escena y marcadores de cámara.

## 3. Integraciones multicanal

El puente de canales conecta el núcleo con las plataformas de IM (Discord,
Slack, Matrix, Lark, …). Los mensajes entrantes se convierten en turnos de
chat; las respuestas salientes vuelven en streaming por el mismo canal.
Cada canal requiere su aplicación OAuth aprobada para uso en producción.

## 4. Búsqueda semántica y conocimiento

- `search.semantic` tiende un puente hacia la búsqueda vectorial de
  scepter (índice de espacios de trabajo de ApoRia + memorias a largo
  plazo de PhiLia fusionadas en una sola lista clasificada).
- Las bases de conocimiento (crear / añadir documentos / suscribirse)
  persisten en Postgres y se pueden buscar a través de la misma superficie
  RPC.
- Los informes de agentes se indexan automáticamente, de modo que los
  informes pasados son recuperables semánticamente.

## 5. Autenticación

La autenticación es delegada: scepter confía en el id de usuario de la
llamada suministrado por la pasarela de chest (`X-User-Id` / `user_id`),
que chest obtiene de Arona o del flujo de invitación. Los roles RBAC
(admin / operator / viewer / agent) gobiernan las operaciones de escritura
sobre paneles y espacios de trabajo.

## Referencia de variables de entorno (subconjunto)

| Variable | Propósito |
|---|---|
| `DATABASE_URL` | Postgres (obligatorio) |
| `ENTELECHEIA_SCEPTER_URL` / `WS_URL` | Endpoints RPC/WS del motor de agentes |
| `LLM_DEFAULT_PROVIDER_ENDPOINT` / `_API_KEY` / `_MODELS` | Proveedor de modelos de chat (normalmente Arona) |
| `BIGMODEL_API_KEY*` | Canalización de medios (visión GLM / generación de imágenes CogView) |
| `CHANNEL_*` | Credenciales de canales de IM por plataforma |
