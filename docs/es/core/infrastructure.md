# Infraestructura central — Autenticación, RPC y fundamentos

Cada plataforma que usas se asienta sobre la misma base. Lee esto una vez y las
guías de plataforma encajan en su sitio: kirino (autenticación de confianza cero
y RBAC), plana (tipos de protocolo y facilidades de plataforma) y hikari (la
biblioteca de componentes de UI).

## Autenticación y autorización (kirino)

- **Identidad**: hash de contraseñas, tokens de sesión con vidas cortas,
  limitación de frecuencia en el inicio de sesión y bloqueo de cuentas. Los
  algoritmos y sus parámetros se documentan en la
  [documentación propia de kirino](https://kirino.docs.celestia.world), no aquí.
- **RBAC**: los permisos son jerárquicos y se resuelven por llamador; los roles
  agrupan permisos (un administrador lo ve todo, un visor es de solo lectura).
  Las asignaciones persisten en la base de datos de la plataforma.
- **Delegación**: un servicio que está detrás de otro no autentica a nadie por
  sí mismo — la capa que autentica está siempre por encima, y la identidad del
  llamador se pasa únicamente para el aislamiento de espacios de trabajo.

## Protocolo y RPC (plana)

- El tráfico de la plataforma es **JSON-RPC 2.0**, sobre WebSocket para el
  streaming y sobre HTTP POST para petición/respuesta. Los nombres de método son
  `<Dominio>.<Acción>`.
- Los tipos del protocolo son la única fuente de verdad del protocolo y viven en
  plana; los repositorios posteriores fijan una versión publicada en lugar de
  bifurcar una copia.
- Las notificaciones no llevan `id` y empujan eventos como fragmentos de
  streaming y actualizaciones del panel; las peticiones llevan un `id` que la
  respuesta repite.
- Las superficies con mucho estado siguen el mismo patrón en todas partes: el
  servidor tiene la autoridad, los clientes declaran qué están mirando y el
  servidor transmite la diferencia.

## Medición y precios (plana)

El uso se mide por clave de API y se tarifica a partir de una única tabla
canónica compartida por todos los servicios: los tokens de prompt y de
completion, la estimación de coste y la aplicación de cuotas son el mismo
cálculo en todos los productos.

## Componentes de UI (hikari)

La biblioteca de componentes proporciona los botones, insignias, tablas, modales
y diálogos de confirmación que usa toda webUI, de modo que una pantalla se ve y
se comporta igual allí donde se monte. Los componentes compartidos se suben aquí
(upstream) en lugar de reimplementarse en cada repositorio.

## Reglas de dependencia

- Capa 0: kirino (autenticación) → Capa 1: plana (protocolo/fundamentos) → Capa
  2: hikari (UI) → Capa 3: servicios (arona, chest, entelecheia, evernight).
- Los servicios implementan solo lógica de negocio; las capacidades compartidas
  provienen de las capas superiores. Las dependencias entre repositorios usan
  referencias git o tags fijados — nunca dependencias de ruta local.
