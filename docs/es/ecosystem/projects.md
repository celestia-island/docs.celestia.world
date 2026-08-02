# Mapa de proyectos

El inventario completo de repositorios de celestia-island, agrupados por capa. Los repositorios marcados con un sitio de documentación llevan sus propios documentos de *cómo* en `<name>.docs.celestia.world`; todo lo demás se documenta en su repositorio.

## Capa 0 — Autenticación

| Proyecto | Rol | Docs |
| --- | --- | --- |
| [kirino](https://github.com/celestia-island/kirino) | Autenticación de confianza cero y RBAC: sesiones JWT, hash Argon2id, limitación de frecuencia en el inicio de sesión, motor de permisos | [kirino.docs.celestia.world](https://kirino.docs.celestia.world) |

## Capa 1 — Plataforma

| Proyecto | Rol | Docs |
| --- | --- | --- |
| [plana](https://github.com/celestia-island/plana) | Tipos compartidos, cliente y servidor JSON-RPC, sesiones SSE, disyuntores, medición y precios de LLM, shell de UI de administración | repositorio |
| [provider-registry](https://github.com/celestia-island/provider-registry) | Registro de modelos y proveedores (formato TOML de punto de entrada) | repositorio |

## Capa 2 — UI

| Proyecto | Rol | Docs |
| --- | --- | --- |
| [hikari](https://github.com/celestia-island/hikari) | Biblioteca de componentes de UI (Vue/TS + Rust) compartida por todas las webUI | repositorio |

## Capa 3 — Servicios

| Proyecto | Rol | Docs |
| --- | --- | --- |
| [arona](https://github.com/celestia-island/arona) | Panel de administración de API en la nube: cuentas, claves de API, despliegue de modelos, backends, registros de uso | repositorio |
| [shittim-chest](https://github.com/celestia-island/shittim-chest) | Chat de escritorio/webUI y shell | [shittim-chest.docs.celestia.world](https://shittim-chest.docs.celestia.world) |
| [entelecheia](https://github.com/celestia-island/entelecheia) | Plataforma de colaboración multi-agente: microkernel de solo exec, servidor de orquestación scepter, canalización de ejecución IEPL | [entelecheia.docs.celestia.world](https://entelecheia.docs.celestia.world) |
| [evernight](https://github.com/celestia-island/evernight) | Broker de protocolos industriales: Modbus, S7comm, OPC UA; operaciones remotas, telemetría, compuertas de escritura | [evernight.docs.celestia.world](https://evernight.docs.celestia.world) |
| [malkuth](https://github.com/celestia-island/malkuth) | Kit de herramientas de supervisión de servicios: actualizaciones progresivas, sondeos de salud, proxy inverso, recuperación de bucles de caída | [malkuth.docs.celestia.world](https://malkuth.docs.celestia.world) |
| [lagrange](https://github.com/celestia-island/lagrange) | Motor de documentación Markdown que impulsa este sitio y cada sitio de documentación de proyectos | [lagrange.docs.celestia.world](https://lagrange.docs.celestia.world) |

## Herramientas y bibliotecas

| Proyecto | Rol | Docs |
| --- | --- | --- |
| [noa](https://github.com/celestia-island/noa) | Control de versiones distribuido nativo en IA: aislamiento de espacio de trabajo por agente, registros de solo anexado JSONL, historial de instantáneas | [noa.docs.celestia.world](https://noa.docs.celestia.world) |
| [seia](https://github.com/celestia-island/seia) | Biblioteca y CLI de búsqueda web multimotor | [seia.docs.celestia.world](https://seia.docs.celestia.world) |
| [ichika](https://github.com/celestia-island/ichika) | Macros de canalización con pool de hilos (tuberías de mensajes basadas en flume) | [ichika.docs.celestia.world](https://ichika.docs.celestia.world) |
| [yuuka](https://github.com/celestia-island/yuuka) | Proc-macro para generar estructuras anidadas complejas a partir de una macro simple | [yuuka.docs.celestia.world](https://yuuka.docs.celestia.world) |
| [aoba](https://github.com/celestia-island/aoba) | CLI Modbus y de fuentes de datos | [aoba.docs.celestia.world](https://aoba.docs.celestia.world) |
| [kou](https://github.com/celestia-island/kou) | Motor de terminal virtual independiente: gestión de PTY, VT100/ANSI | repositorio |
| [hifumi](https://github.com/celestia-island/hifumi) | Biblioteca de serialización para migrar datos entre versiones | repositorio |
| [aris](https://github.com/celestia-island/aris) | Motor de navegador derivado de servo, embebible como biblioteca (WebGL para gemelos digitales) | repositorio |
| [shirabe](https://github.com/celestia-island/shirabe) | Biblioteca ligera de automatización y depuración de navegadores nativa en Rust | repositorio |
| [tairitsu](https://github.com/celestia-island/tairitsu) | Framework full-stack impulsado por el modelo de componentes WASM | repositorio |
| [ratatui-markdown](https://github.com/celestia-island/ratatui-markdown) | Renderizado de Markdown para TUIs de ratatui | repositorio |
| [arcaea](https://github.com/celestia-island/arcaea) | Biblioteca Rust para el protocolo de persona de celestia | repositorio |
| [scriptum](https://github.com/celestia-island/scriptum) | Interfaz de terminal (TUI) para entelecheia: una "pantalla tonta" que habla con el servidor scepter | repositorio |

## Borde y hardware

| Proyecto | Rol | Docs |
| --- | --- | --- |
| [kei](https://github.com/celestia-island/kei) | Kernel de SO Rust para dispositivos de borde ARM64/RISC-V; núcleo de tiempo real determinista para el horizonte largo | repositorio |

## Infraestructura y herramientas de desarrollo

| Proyecto | Rol | Docs |
| --- | --- | --- |
| [celestia-devtools](https://github.com/celestia-island/celestia-devtools) | Cadena de herramientas de desarrollo compartida: recetas justfile, registro de parches, linting | repositorio |
| [celestia-integration](https://github.com/celestia-island/celestia-integration) | Suites de pruebas de integración en hardware real para todo el bucle | repositorio |
| [sysl](https://github.com/celestia-island/sysl) | Licencia de código fuente sintética (SySL): una licencia diseñada para código generado por IA | repositorio |

## Presencia web

| Propiedad | Rol | Docs |
| --- | --- | --- |
| [celestia-island.github.io](https://celestia-island.github.io) | Presencia de la organización | repositorio |
| [docs.celestia.world](https://docs.celestia.world) | Este sitio — filosofía, mapa, primeros pasos | repositorio |
| [e.celestia.world](https://e.celestia.world) | Página de aterrizaje pública | repositorio |
| [dev.celestia.world](https://dev.celestia.world) | Portal de desarrolladores | repositorio |
| [arona.celestia.world](https://arona.celestia.world) | Panel de administración de API en la nube (producto) | — |

## Para profundizar

- [Arquitectura en capas](../philosophy/layered-architecture.md) — por qué existen estas capas.
- [El bucle cerrado](../philosophy/closed-loop.md) — cómo cooperan los proyectos a lo largo del bucle.
- [Sitios y propiedad](./sites.md) — quién documenta qué y dónde.
