# Mapa de proyectos

El inventario de los repositorios y productos de la plataforma celestia-island,
agrupados por capa. Un nombre con enlace es un repositorio público que puedes
leer hoy; un nombre sin enlace es un producto que se distribuye con la
plataforma pero cuyo código fuente aún no es público. Los repositorios marcados
con un sitio de documentación llevan sus propias guías del *cómo*; todo lo demás
se documenta dentro del propio repositorio, lo que exige acceso a él.

## Capa 0 — Autenticación

| Proyecto | Rol | Docs |
| --- | --- | --- |
| [kirino](https://github.com/celestia-island/kirino) | Autenticación y autorización de confianza cero: sesiones, permisos, limitación de frecuencia | [kirino.docs.celestia.world](https://kirino.docs.celestia.world) |

## Capa 1 — Plataforma

| Proyecto | Rol | Docs |
| --- | --- | --- |
| [plana](https://github.com/celestia-island/plana) | Tipos de protocolo compartidos, transporte, medición y las facilidades que consume cada servicio | repositorio |
| [provider-registry](https://github.com/celestia-island/provider-registry) | Catálogo de modelos y proveedores compartido entre productos | repositorio |

## Capa 2 — UI

| Proyecto | Rol | Docs |
| --- | --- | --- |
| [hikari](https://github.com/celestia-island/hikari) | La biblioteca de componentes de UI compartida por todas las webUI | repositorio |

## Capa 3 — Servicios

| Proyecto | Rol | Docs |
| --- | --- | --- |
| arona | Pasarela de modelos y panel de despliegue: claves, backends, enrutado, uso | [Arona](../platforms/arona.md) |
| shittim-chest | Chat, paneles e integraciones — la superficie de banco de trabajo | [Shittim Chest](../platforms/chest.md) |
| entelecheia | Plataforma de agentes: agentes, memoria a largo plazo, búsqueda semántica, integración industrial | [Entelecheia](../platforms/entelecheia.md) |
| evernight | Broker de protocolos industriales: protocolos de campo, alarmas, grabación, inferencia en el borde | [Evernight](../platforms/evernight.md) |
| [malkuth](https://github.com/celestia-island/malkuth) | Supervisión de servicios: actualizaciones progresivas, sondeos de salud, proxy inverso, recuperación tras caídas | [malkuth.docs.celestia.world](https://malkuth.docs.celestia.world) |
| [lagrange](https://github.com/celestia-island/lagrange) | El motor de documentación que impulsa este sitio y cada sitio de documentación de proyectos | [lagrange.docs.celestia.world](https://lagrange.docs.celestia.world) |
| celestia-erp | Gestión empresarial: organizaciones, facturación, facturas | — |
| electrode_recon | Motor de cálculo de microestructura de electrodos — la primera instancia externa sobre el tejido de motores | — |

## Herramientas y bibliotecas

| Proyecto | Rol | Docs |
| --- | --- | --- |
| [noa](https://github.com/celestia-island/noa) | Control de versiones distribuido nativo para agentes con espacios de trabajo aislados | [repositorio](https://github.com/celestia-island/noa) |
| [seia](https://github.com/celestia-island/seia) | Búsqueda web multimotor | [seia.docs.celestia.world](https://seia.docs.celestia.world) |
| [aoba](https://github.com/celestia-island/aoba) | CLI multiprotocolo de depuración y simulación (Modbus RTU y similares) | [aoba.docs.celestia.world](https://aoba.docs.celestia.world) |
| [ichika](https://github.com/celestia-island/ichika) | Canalizaciones con pool de hilos sobre tuberías de mensajes | repositorio |
| [yuuka](https://github.com/celestia-island/yuuka) | Macros para estructuras anidadas compuestas y fusión/parcheo de JSON | repositorio |
| [kou](https://github.com/celestia-island/kou) | Motor de terminal virtual: PTY, VT100/ANSI, gráficos en línea | repositorio |
| [hifumi](https://github.com/celestia-island/hifumi) | Serialización para migrar datos entre versiones | repositorio |
| [lacrymira](https://github.com/celestia-island/lacrymira) | Acceso tipado a datos para SQL y KV tras una única superficie de comandos | repositorio |
| [himari](https://github.com/celestia-island/himari) | Representación intermedia de fórmulas con dimensiones | repositorio |
| [kotama](https://github.com/celestia-island/kotama) | Kit de ingeniería inversa: disección, descompilación, referencias cruzadas | repositorio |
| [ayane](https://github.com/celestia-island/ayane) | Servicio de correo: plano de control, webmail y protección | repositorio |
| [aris](https://github.com/celestia-island/aris) | Un motor de navegador en Rust puro derivado de servo, embebible como biblioteca | repositorio |
| [shirabe](https://github.com/celestia-island/shirabe) | Automatización y depuración de navegadores sin interfaz | repositorio |
| [tairitsu](https://github.com/celestia-island/tairitsu) | Framework full-stack sobre el modelo de componentes WASM | repositorio |
| [akivili](https://github.com/celestia-island/akivili) | Host y SDK de plugins para extensiones de agentes | repositorio |
| [celestia-plugin](https://github.com/celestia-island/celestia-plugin) | SDK de plugins y motores para Python | repositorio |
| [shun](https://github.com/celestia-island/shun) | Instaladores, flasheadores y entrega de cargas en modo portable | repositorio |
| arcaea | Biblioteca del protocolo de persona | — |
| scriptum | Interfaz de terminal para la plataforma de agentes | — |
| official-plugins | Los paquetes de plugins de primera parte | — |

## Borde y hardware

| Proyecto | Rol | Docs |
| --- | --- | --- |
| [kei](https://github.com/celestia-island/kei) | Kernel Rust para pasarelas de borde ARM64 y RISC-V | repositorio |
| [hare](https://github.com/celestia-island/hare) | Biblioteca puente `no_std` para nodos industriales embebidos | repositorio |
| evernight-appliance | La distribución del dispositivo: firmware de arranque, flasheador, contrato de drivers | — |

## Infraestructura y herramientas de desarrollo

| Proyecto | Rol | Docs |
| --- | --- | --- |
| [celestia-devtools](https://github.com/celestia-island/celestia-devtools) | Cadena de herramientas de desarrollo compartida: recetas de compilación, linting, puertas de publicación | repositorio |
| [cherino](https://github.com/celestia-island/cherino) | Abstracción de contenedores aislados para la ejecución de agentes | repositorio |
| [celestia-artifacts](https://github.com/celestia-island/celestia-artifacts) | Alojamiento público de binarios e imágenes para las publicaciones | repositorio |
| celestia-integration | Pruebas de integración entre repositorios para todo el bucle | — |
| fuuka | Plano de ejecución de CI autoalojada | — |
| [sysl](https://github.com/celestia-island/sysl) | La licencia Synthetic Source que usa la mayor parte de este código | repositorio |

## Presencia web

| Propiedad | Rol | Docs |
| --- | --- | --- |
| [celestia-island.github.io](https://celestia-island.github.io) | Presencia de la organización | repositorio |
| [docs.celestia.world](https://docs.celestia.world) | Este sitio — filosofía, mapa, primeros pasos | repositorio |
| [e.celestia.world](https://e.celestia.world) | Página de aterrizaje pública | repositorio |
| [dev.celestia.world](https://dev.celestia.world) | Panel y portal de desarrolladores (acceso por invitación durante la beta) | repositorio |
| [celestia.ac.cn](https://celestia.ac.cn) | Sitio de la empresa y de los servicios empresariales | repositorio |

## Para profundizar

- [Arquitectura en capas](../philosophy/layered-architecture.md) — por qué existen estas capas.
- [El bucle cerrado](../philosophy/closed-loop.md) — cómo cooperan los proyectos a lo largo del bucle.
- [Sitios y propiedad](./sites.md) — quién documenta qué y dónde.
