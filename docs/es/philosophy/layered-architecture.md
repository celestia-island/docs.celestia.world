# Arquitectura en capas

El ecosistema sigue siendo manejable porque está estrictamente estratificado. Las dependencias solo apuntan en una dirección: **los servicios posteriores consumen capacidad de las capas superiores; la capacidad genérica nunca se reimplementa.**

## Las cuatro capas

| Capa | Proyectos | Qué proporcionan |
| --- | --- | --- |
| **Capa 0 — Autenticación** | [kirino](https://github.com/celestia-island/kirino) | Primitivas de confianza cero: firma y renovación de JWT, hash de contraseñas Argon2id, limitación de frecuencia en el inicio de sesión, motor RBAC, almacén de invitaciones, sesiones |
| **Capa 1 — Plataforma** | [plana](https://github.com/celestia-island/plana) | Facilidades compartidas: tipos y enrutamiento JSON-RPC 2.0, DTOs de servicios, detección de red, sesiones SSE, disyuntores (circuit breakers), medición y precios de LLM |
| **Capa 2 — UI** | [hikari](https://github.com/celestia-island/hikari) | Biblioteca de componentes de UI (Vue/TS + Rust) compartida por todas las webUI |
| **Capa 3 — Servicios** | [arona](https://github.com/celestia-island/arona), [shittim-chest](https://github.com/celestia-island/shittim-chest), [entelecheia](https://github.com/celestia-island/entelecheia), [evernight](https://github.com/celestia-island/evernight), [malkuth](https://github.com/celestia-island/malkuth), [lagrange](https://github.com/celestia-island/lagrange) | Solo lógica de negocio. Consumen las capas 0–2 y añaden el comportamiento que hace real cada producto |

## La doctrina

1. **Nunca implementar dos veces.** Antes de escribir código, pregúntate: ¿lo tiene kirino? ¿lo tiene plana? ¿lo tiene hikari? Ejemplo: los tipos JSON-RPC provienen de plana, el JWT de kirino, la limitación de frecuencia del inicio de sesión de kirino, los disyuntores de plana, los DTOs de salud de plana, los precios de plana.
2. **La capacidad genérica va hacia las capas superiores.** Una característica que dos o más servicios reutilizarán se construye primero en kirino, plana o hikari, y luego se consume.
3. **Sin dependencias inversas.** Los servicios dependen de kirino/plana/hikari; plana puede depender de kirino; kirino nunca depende de plana ni de hikari.
4. **Extender lo upstream antes de consumir.** Si a las capas superiores les falta una capacidad necesaria, extiéndelas primero y luego consume. Una capacidad nueva nunca se prototipa en un servicio para reimplementarla después.
5. **Las dependencias entre repositorios son referencias git.** Todos los repositorios consumen las capas superiores mediante referencias git a la rama `master` (o versiones fijadas), nunca dependencias de ruta local. Cada repositorio se compila de forma idéntica en cualquier máquina.

## Por qué importa

- **Una corrección se propaga.** Una corrección de seguridad en kirino llega a todos los servicios con una actualización de dependencia, no con una búsqueda entre reimplementaciones.
- **La revisión es proporcional al riesgo.** Los cambios de la capa 3 son lógica de producto; los cambios de la capa 0 son infraestructura — el estándar de revisión lo refleja.
- **El mapa sigue siendo legible.** Los ingenieros nuevos leen esta página y saben dónde vive cada capacidad. El [mapa de proyectos](../ecosystem/projects.md) es el inventario completo.

## Para profundizar

- [Por qué celestia-island](./why.md) — el problema que hay detrás de la estratificación.
- [Principios de seguridad](./safety.md) — la doctrina que se asienta sobre las capas.
- [Mapa de proyectos](../ecosystem/projects.md) — cada repositorio, por capa.
