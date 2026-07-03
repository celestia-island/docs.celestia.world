# Identificación de Agentes de IA y Estrategia de Coautoría de Commits

## Descripción general

`evernight` participa en la estrategia de coautoría de celestia-island de dos formas:

1. **Como host de commits**: cuando un agente de IA orquesta un commit a través de evernight (agente en el host A → SSH/exec de evernight → host B → `git commit`), el hook `commit-msg` del lado del host (instalado por `noa`) se dispara localmente y estampa el commit con metadatos de procedencia.
2. **Como proveedor de tránsito**: cuando evernight retransmite el tráfico del modelo, puede aparecer en el email del autor como la plataforma servidora, haciendo auditable el salto de transporte.

Este documento especifica el rol de evernight. El mecanismo autoritativo se define en el documento de diseño de `noa`; aquí se cubre la integración específica de evernight.

## Modelo de identidad del proveedor

El email del autor usa el espacio de nombres de confianza `celestia.world`:

```
Display Name <provider-or-platform-id@celestia.world>
```

Cuando evernight retransmite un modelo, el id del proveedor refleja la retransmisión:

```
GLM 5 <evernight.celestia.world@celestia.world>   # GLM 5 relayed via evernight
```

Los proveedores de primera parte conservan su propio dominio (`anthropic.com`, `deepseek.com`, `zhipuai.cn`, ...); las retransmisiones de terceros conservan el suyo (`opencode.ai`, `jdcloud.com`, `openrouter.ai`, ...). Esto hace visible la cadena "qué modelo, a través de quién" en cada commit.

## Trailer de coautoría

- Clave del trailer: `Co-authored-by` (reconocida por git).
- Un trailer por cada modelo distinto, en orden de uso.
- Una ejecución de cadena completamente bajo el control de crucero de YOLO recibe además: `Co-authored-by: Entelecheia <demiurge@celestia.world>`.

## Uso de tokens incrustado

Se añade después de los trailers de coautoría (separado por una línea en blanco):

```
Co-authored-by: Claude Opus 4.8 (↑ 12.5k ↓ 8.3k ●45.2k) <anthropic.com@celestia.world>
Co-authored-by: Deepseek V4 Pro (↑ 5.1k ↓ 3.2k) <deepseek.com@celestia.world>
```

- `Upload` = tokens de entrada; `Download` = tokens de salida.
- `Cache` aparece solo cuando se reportaron tokens de entrada en caché y son > 0.
- Los recuentos en miles (`k`), un decimal, sin ceros a la derecha.

## Puntos de integración de evernight

### Hook del lado del host

Los commits realizados a través del JSON-RPC `Command.Exec` de `evernight` (usado por el pipeline de cirugía de entelecheia y por el bucle `KaLos:auto_fix`) invocan el `git` del sistema, de modo que el hook `.git/hooks/commit-msg` instalado por `noa hook install` se aplica sin cambios. No hace falta modificar el código de evernight para los commits hechos en un host donde el hook está instalado.

### Identidad del proveedor de tránsito

Cuando evernight hace de proxy del tráfico LLM (p. ej., al enrutar una llamada de modelo hacia la inferencia local de un host remoto), se puede indicar al resolvedor de coautores el endpoint de la retransmisión para que el id del proveedor pase a ser `evernight.celestia.world`. Esto se configura mediante la misma lista de proveedores de `aporia.toml` que lee `noa co-author resolve`.

## Ejemplo completo de mensaje de commit

```
perf(screen): cache X11 connection to avoid per-frame reconnect

X11CaptureBackend previously called x11rb::connect on every capture_frame.
Cache the connection in a Mutex<Option<..>>, reusing it across frames.

Co-authored-by: Entelecheia <demiurge@celestia.world>
Co-authored-by: Deepseek V4 Pro (↑ 18.2k ↓ 2.1k) <deepseek.com@celestia.world>
```

## Consideraciones de seguridad

- Los trailers de coautoría son procedencia autodeclarada, no una prueba criptográfica.
- El resolvedor se degrada de forma segura: si falta `noa` o hay un error de análisis, se obtiene un bloque vacío y el commit prosigue intacto.
- Los identificadores de proveedor provienen del `aporia.toml` local, reflejando los proveedores configurados.

## Referencia de identificadores de proveedor (registro inicial)

| Id de proveedor | Marca | Pista de endpoint |
| --- | --- | --- |
| `zhipuai.cn` | GLM | `open.bigmodel.cn` |
| `deepseek.com` | Deepseek | `api.deepseek.com` |
| `anthropic.com` | Claude | `api.anthropic.com` |
| `openai.com` | GPT / OpenAI | `api.openai.com` |
| `evernight.celestia.world` | (relay) | evernight proxy |
| `opencode.ai` | (relay) | `opencode.ai` |
| `jdcloud.com` | (relay) | `jdcloud.com` |
