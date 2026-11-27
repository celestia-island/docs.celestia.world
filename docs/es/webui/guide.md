# Interfaz web — el viaje desde tu primera frase

Una cuenta, una clave, una conversación. Esta página recorre el mismo camino
que el producto — un modelo pasa a estar disponible, una clave lo autentica, un
turno se ejecuta con memoria y un panel lo convierte en algo que puedes operar.

![El panel](https://raw.githubusercontent.com/celestia-island/docs.celestia.world/master/res/screenshots/arona-dashboard.png)

## Modelos: del origen a la invocación

Un modelo viaja de «existir» a «listo para el chat» en cuatro etapas: **origen**
(el catálogo de proveedores — metadatos, no inferencia) → **registro** (un
backend, ya sea un runtime local o cualquier servicio compatible con OpenAI;
sobrevive a los reinicios) → **despliegue** (se entrega un ID de modelo a un
nodo, que lo descarga y arranca el runtime) → **enrutado** (balanceo por mínimas
solicitudes en vuelo con afinidad de sesión). Un backend que no ha pasado su
primera sonda de salud se rechaza en lugar de probarse.

## Identidad y medición

![Claves de API](https://raw.githubusercontent.com/celestia-island/docs.celestia.world/master/res/screenshots/arona-apikeys.png)

![Uso y facturación](https://raw.githubusercontent.com/celestia-island/docs.celestia.world/master/res/screenshots/arona-billing.png)

Las **claves de API** son tu identidad — la pasarela autentica con un token
Bearer, y tanto `curl` como el banco de trabajo presentan una en la entrada. El
**uso** es un registro contable por llamada y por clave: tokens, modelo,
backend, coste. Los niveles de **facturación** fijan cuotas; alcanzar uno es un
rechazo tajante, no una ralentización.

## Chat y memoria

![Chat](https://raw.githubusercontent.com/celestia-island/docs.celestia.world/master/res/screenshots/arona-playground.png)

Cada turno pasa por el servicio de memoria — la insignia de cada turno te dice
si así fue. `Memory on` significa que se inyectaron memorias relevantes a largo
plazo antes del enrutado; `Memory offline` significa que el servicio de memoria
es inaccesible (una señal de honestidad, no un error del programa); `disabled`
significa que no se encontró nada relevante. Los turnos completados se extraen y
se guardan de forma persistente, de modo que la memoria sobrevive a los
reinicios — y las entradas de reescritura pueden borrarse directamente desde la
página de Memory.

## Paneles y control industrial

![Agentes](https://raw.githubusercontent.com/celestia-island/docs.celestia.world/master/res/screenshots/arona-agents.png)

Un solo prompt crea un panel; el motor genera la disposición y la persiste en el
espacio de trabajo. La edición es estructural — vinculaciones de fuentes de
datos, listas de componentes, estados de conexión — no una caja negra. Topology
y Holographic son dos vistas de la misma flota; Reports añade búsqueda semántica
sobre el historial. Las escrituras industriales pasan la validación de políticas
y la **aprobación humana** antes de que algo se mueva: el final del bucle
cerrado, y su paso más pesado.

![Inicio de sesión](https://raw.githubusercontent.com/celestia-island/docs.celestia.world/master/res/screenshots/arona-login.png)

## Para profundizar

- [Arona](../platforms/arona.md) — la pasarela y el panel de despliegue.
- [Shittim Chest](../platforms/chest.md) — el banco de trabajo y sus paneles.
- [Entelecheia](../platforms/entelecheia.md) — agentes, espacios de trabajo y la compuerta de escritura industrial.
