# Infraestructura central — Autenticación, RPC y fundamentos

Cada plataforma que usas se asienta sobre la misma base. Lee esto una vez y
las guías de plataforma encajan en su sitio: kirino (autenticación de
confianza cero y RBAC), plana (tipos de protocolo, transporte JSON-RPC,
medición, motor de sincronización) y hikari (la biblioteca de componentes de
UI).

## Autenticación y autorización (kirino)

- **Identidad**: hash de contraseñas con Argon2id; tokens de acceso/refresco
  JWT (`TokenManager`, `kirino-session`); limitación de frecuencia en el
  inicio de sesión y bloqueo de cuentas.
- **RBAC**: permisos jerárquicos (agent.*, system.*, knowledge.*, …)
  resueltos por un `GrantResolver`; los roles agrupan permisos (admin lo ve
  todo, viewer es de solo lectura). Las asignaciones persisten en Postgres.
- **Delegación**: scepter confía en el id de usuario de la llamada
  suministrado por la pasarela de chest (`X-User-Id` / `user_id`) y lo usa
  únicamente para el aislamiento de espacios de trabajo — la capa que
  autentica está siempre en una capa superior.
- **Superficie de administración**: los endpoints de administración del
  panel requieren un `ARONA_ADMIN_TOKEN` dedicado y fallan cerrados (fail
  closed) sin él.

## Protocolo y RPC (plana)

- Todo el tráfico de la plataforma es **JSON-RPC 2.0 sobre WebSocket** (y
  petición/respuesta vía HTTP POST `/api/rpc`). Los métodos se nombran
  `<Dominio>.<Acción>` — p. ej. `Sync.MemoryQueryRequest`, `Cli.Search`,
  `Mcp.CallTool`.
- Los tipos del protocolo viven en plana (`plana-state-sync` /
  `plana-types`): una única fuente de verdad para el protocolo; los
  repositorios descendentes fijan un tag publicado.
- Las notificaciones (sin `id`) envían eventos como fragmentos de streaming
  y actualizaciones del panel; las peticiones llevan un `id` que se repite
  en la respuesta.
- El motor de sincronización (`plana-sync`) es un árbol de estado con
  autoridad del servidor: los clientes declaran viewports, el servidor
  difunde diffs con instantáneas completas periódicas.

## Medición y precios (plana)

El uso se mide por clave de API y se tarifica a partir de una tabla canónica
(medición de `plana-llm-provider`): los tokens de prompts/completions, la
estimación de coste y la aplicación de cuotas se comparten entre servicios.

## Componentes de UI (hikari)

La biblioteca de componentes Vue (`@celestia-island/hikari`) proporciona
botones, insignias, tablas, modales y diálogos de confirmación usados por
todas las webui; las páginas de las plataformas los componen con el shell de
UI de plana. Los componentes compartidos deben subirse aquí (upstream) en
lugar de reimplementarse en cada repositorio.

## Reglas de dependencia

- Capa 0: kirino (autenticación) → Capa 1: plana (protocolo/fundamentos) →
  Capa 2: hikari (UI) → Capa 3: servicios (arona, chest, entelecheia,
  evernight).
- Los servicios implementan solo lógica de negocio; las capacidades
  compartidas provienen de las capas superiores. Las dependencias entre
  repositorios usan referencias git o tags fijados — nunca dependencias de
  ruta local.
