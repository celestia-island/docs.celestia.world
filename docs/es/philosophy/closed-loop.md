# El bucle cerrado

El producto es el bucle, no un proyecto individual:

> descubrir → instalar → autenticar → desplegar un modelo → chatear y ejecutar agentes → controlar equipos industriales → verificar y dar soporte

Cada segmento pertenece a un conjunto específico de proyectos. Si un segmento está roto, la plataforma no está terminada.

## Segmento por segmento

| # | Segmento | Qué ocurre | Proyectos |
| --- | --- | --- | --- |
| 1 | **Descubrir** | Un usuario potencial encuentra el ecosistema, entiende su filosofía y elige un punto de entrada | [docs.celestia.world](https://docs.celestia.world) (este sitio), [celestia-island.github.io](https://celestia-island.github.io), [e.celestia.world](https://e.celestia.world) |
| 2 | **Instalar** | El usuario obtiene un sistema en funcionamiento: panel de administración, shell de escritorio/web, servicios supervisados | [arona](https://github.com/celestia-island/arona) (panel de administración de API en la nube), [shittim-chest](https://github.com/celestia-island/shittim-chest) (chat de escritorio/webUI), [malkuth](https://github.com/celestia-island/malkuth) (supervisión de servicios) |
| 3 | **Autenticar** | Identidad de confianza cero: registro (con invitación), inicio de sesión con limitación de frecuencia, claves de API, RBAC | [kirino](https://github.com/celestia-island/kirino) (primitivas de autenticación y motor RBAC) |
| 4 | **Desplegar un modelo** | Elegir un runtime de modelo, desplegarlo en un nodo, vincularlo a un backend de chat, medir el uso | [arona](https://github.com/celestia-island/arona) (panel + backends), [entelecheia](https://github.com/celestia-island/entelecheia) (runtime scepter), [plana](https://github.com/celestia-island/plana) (medición y precios) |
| 5 | **Chat y agentes** | Hablar con modelos, ejecutar colaboración multi-agente, conservar conversaciones, gestionar memoria | [shittim-chest](https://github.com/celestia-island/shittim-chest) (UI y chat), [entelecheia](https://github.com/celestia-island/entelecheia) (orquestación de agentes), [noa](https://github.com/celestia-island/noa) (control de versiones nativo en IA) |
| 6 | **Control industrial** | Operaciones remotas e intermediación de protocolos: Modbus, S7comm, OPC UA; telemetría y compuertas de escritura | [evernight](https://github.com/celestia-island/evernight) (broker de protocolos), [aoba](https://github.com/celestia-island/aoba) (CLI Modbus y de fuentes de datos) |
| 7 | **Verificar y dar soporte** | Pruebas de integración en hardware real, supervisión y autocuración, registros de uso, canales de retroalimentación | [celestia-integration](https://github.com/celestia-island/celestia-integration), [malkuth](https://github.com/celestia-island/malkuth), [plana](https://github.com/celestia-island/plana) (registros de uso) |

## Cómo se comporta el bucle

- **Cada paso es comprobable.** Cada segmento tiene una prueba de aceptación definida en [celestia-integration](https://github.com/celestia-island/celestia-integration); un lanzamiento no está en verde hasta que todo el bucle pasa en nodos reales.
- **Cada paso es observable.** La supervisión, los endpoints de salud y los registros de uso hacen visible el estado de cada segmento en lugar de asumirlo.
- **Sin degradación silenciosa.** Cuando un segmento se degrada (por ejemplo, memoria fuera de línea o un backend inalcanzable), la respuesta de la API y la UI lo dicen explícitamente. Los fallos son ruidosos por diseño.
- **La seguridad no es un segmento.** Las compuertas de escritura, la validación de políticas y la confirmación humana están entretejidas en los segmentos 5 y 6, no añadidas al final. Consulta [Principios de seguridad](./safety.md).

## Para profundizar

- [Por qué celestia-island](./why.md) — el problema que define el bucle.
- [Arquitectura en capas](./layered-architecture.md) — cómo se mantienen ordenadas las piezas.
- [Mapa de proyectos](../ecosystem/projects.md) — el inventario completo de repositorios.
- [Inicio rápido](../getting-started/quickstart.md) — recorre el bucle en 30 minutos.
