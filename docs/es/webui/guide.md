# Web UI — el viaje desde tu primera frase

Dos superficies, un flujo: **arona** es el plano de control sin interfaz
(modelos, claves, registro contable, memoria); **shittim-chest** es el banco
de trabajo que realmente miras (chat, paneles, ver el mundo). Cada pantalla
de abajo es una vista de chest — chest habla con arona a través de su
superficie RPC; arona en sí no incluye ninguna UI.

![Chest backend console](https://raw.githubusercontent.com/celestia-island/docs.celestia.world/master/res/screenshots/arona-dashboard.png)

## Modelos: del origen a la invocación

Un modelo viaja de «existir» a «listo para el chat» en cuatro etapas:
**origen** (el catálogo de Providers — metadatos, no inferencia) → **registro**
(un backend `ollama` o `external` compatible con OpenAI, persistido entre
reinicios) → **despliegue** (la página de Agents entrega un ID de modelo a un
nodo `arona-agent`; un nombre vacío elige automáticamente el nodo menos
ocupado) → **enrutado** (la página de Models; balanceo por mínimas solicitudes
en vuelo con afinidad de sesión). Los backends externos operan en modo
fail-closed hasta que la primera sonda tiene éxito. La API exacta de cada paso
vive en los [arona docs](https://arona.docs.celestia.world).

## Identidad y medición

![Chest API keys](https://raw.githubusercontent.com/celestia-island/docs.celestia.world/master/res/screenshots/arona-apikeys.png)

![Chest billing](https://raw.githubusercontent.com/celestia-island/docs.celestia.world/master/res/screenshots/arona-billing.png)

Las **claves API** son tu identidad — la pasarela autentica `/v1/*` con
tokens Bearer, y tanto `curl` como chest presentan una a la entrada.
**Usage** es un registro contable por clave y llamada: tokens, modelo,
backend, coste. Los niveles de **Billing** fijan cuotas (USD / tokens /
límites de tasa); alcanzar una es un rechazo tajante, no una ralentización.

## Chat y memoria

![Chest chat](https://raw.githubusercontent.com/celestia-island/docs.celestia.world/master/res/screenshots/arona-playground.png)

Cada turno de chat pasa por el servicio de memoria — la insignia de cada
turno te dice si así fue. `Memory on` significa que se inyectaron memorias
relevantes a largo plazo antes del enrutado; `Memory offline` significa que
el servicio de memoria es inaccesible (una señal de honestidad, no un bug);
`disabled` significa que no se encontró nada relevante. Los turnos
completados se extraen en episodios y se guardan de forma persistente, de
modo que la memoria sobrevive a los reinicios — y las entradas de
reescritura pueden borrarse directamente desde la página de Memory.

## Paneles y control industrial

![Chest agents](https://raw.githubusercontent.com/celestia-island/docs.celestia.world/master/res/screenshots/arona-agents.png)

Un solo prompt crea un panel; el motor genera la disposición y la persiste
en el almacenamiento del espacio de trabajo de scepter. La edición es
estructural — vinculaciones de fuentes de datos, listas de componentes,
estados de conexión — no una caja negra. Topology y Holographic son dos
vistas de la misma flota; Reports añade búsqueda semántica sobre el
historial. Las escrituras industriales pasan la validación de políticas y
la **aprobación humana** antes de que algo se mueva: el final del bucle
cerrado, y su paso más pesado.

![Chest login](https://raw.githubusercontent.com/celestia-island/docs.celestia.world/master/res/screenshots/arona-login.png)

## Para profundizar

- La referencia completa de la plataforma arona — [arona docs](https://arona.docs.celestia.world)
- El banco de trabajo chest y sus paneles — [shittim-chest docs](https://shittim-chest.docs.celestia.world)
- Agentes, espacios de trabajo y la compuerta de escritura industrial — [entelecheia docs](https://entelecheia.docs.celestia.world)
