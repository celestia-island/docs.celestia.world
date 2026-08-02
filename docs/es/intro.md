# Bienvenido a celestia-island

**celestia-island** es un conjunto de proyectos para el control industrial con IA: colaboración multi-agente, operaciones remotas y automatización crítica para la seguridad. Este sitio es su *porqué* — la filosofía, el mapa del ecosistema y el punto de entrada. El *cómo* vive en los sitios de documentación de cada proyecto, enlazados desde aquí.

## Respuestas a tres preguntas

| Pregunta | Dónde | Qué encontrarás |
| --- | --- | --- |
| **¿Por qué existe esto?** | [Filosofía](./philosophy/why.md) | El problema que resolvemos, el bucle cerrado, la doctrina de seguridad y el horizonte a largo plazo |
| **¿Qué hay dentro?** | [Ecosistema](./ecosystem/projects.md) | Cada proyecto, su papel en el bucle y dónde vive su documentación |
| **¿Cómo empiezo?** | [Primeros pasos](./getting-started/quickstart.md) | El camino de 30 minutos desde la cuenta hasta un agente de chat funcional y el control industrial |

## El resumen en un párrafo

celestia-island construye el **bucle cerrado** desde el descubrimiento hasta la verificación para el control industrial impulsado por IA: descubrir → instalar → autenticar → desplegar un modelo → chatear y ejecutar agentes → controlar equipos industriales → verificar todo. El bucle se ensambla a partir de piezas pequeñas y estrictamente estratificadas: primitivas de autenticación ([kirino](https://github.com/celestia-island/kirino)), facilidades de plataforma ([plana](https://github.com/celestia-island/plana)), componentes de UI ([hikari](https://github.com/celestia-island/hikari)) y servicios que solo implementan lógica de negocio ([arona](https://github.com/celestia-island/arona), [shittim-chest](https://github.com/celestia-island/shittim-chest), [entelecheia](https://github.com/celestia-island/entelecheia), [evernight](https://github.com/celestia-island/evernight)). Nada se implementa nunca dos veces: la capacidad genérica se construye una sola vez en las capas superiores y la consumen todos los servicios posteriores.

La razón de todo esto es una observación simple: en la Luna un viaje de ida y vuelta tarda 2.6 segundos; en Marte, de 6 a 44 minutos. Los robots de allí no pueden esperar a un humano en la Tierra — deben ser autónomos localmente. La capa de decisión, el modelo del mundo y las compuertas de seguridad que estamos construyendo hoy para el control industrial tienen la misma forma que la autonomía necesitará mañana.

## Dónde vive todo

- **Documentación por proyecto** — `<name>.docs.celestia.world`, construida desde cada repositorio. Encuentra la lista completa en [Sitios y propiedad](./ecosystem/sites.md).
- **Presencia de la organización** — [celestia-island en GitHub](https://github.com/celestia-island).
- **Paneles de producto (WIP durante la beta)** — [arona](https://arona.celestia.world) (administración de API en la nube), [dev](https://dev.celestia.world) (portal de desarrolladores); el panel en vivo se ejecuta internamente en `arona:8420` hasta que termine la beta.

Usa el selector de idioma (abajo a la derecha) para leer este sitio en otro idioma. El contenido se redacta en inglés; las traducciones siguen la misma estructura.
