# Contribuir a Celestia Island

¡Gracias por tu interés en contribuir! Celestia Island es una familia de proyectos que abarca toda la plataforma — kirino (autenticación), plana (plataforma), hikari (interfaz), la capa de servicios y las webuis y sitios que los rodean. Esta guía cubre la política de contribución compartida por todo el grupo de proyectos; las instrucciones de compilación y desarrollo de cada proyecto viven en el repositorio y el sitio de documentación del propio proyecto.

## Política de contribución (lee esto primero)

El grupo se construye como capas de criticidad mixta — capa 0 (kirino, autenticación), capa 1 (plana, plataforma), capa 2 (hikari, interfaz) y los servicios de capa 3 encima — por eso **la corrección, la compatibilidad hacia atrás y la estabilidad pesan más que el volumen de contribuciones**. Lee esta sección antes de abrir un pull request.

- **Listón de fusión alto, no una hoja de ruta pública.** Abrir un PR no implica que se fusione. Aceptamos deliberadamente un número pequeño de cambios, y solo cuando encajan en la arquitectura y superan la revisión. Es de diseño, no grosería.
- **Lo que bienvenimos:** informes de defectos, correcciones focalizadas, funciones y campos de protocolo aditivos (no disruptivos), documentación mejorada y discusiones de diseño antes del código.
- **Lo que generalmente no fusionaremos:** reescrituras grandes no solicitadas, cambios disruptivos en contratos compartidos y superficies de protocolo (por ejemplo los tipos de protocolo JSON-RPC 2.0 compartidos en la plataforma Entelecheia), cambios arquitectónicos sin discusión de diseño previa, lotes de PR «vibe-coded» y cualquier cosa que baje el listón de compatibilidad, fiabilidad o seguridad de una capa inferior.
- **Núcleo vs. periferia.** El núcleo de autenticación de confianza cero, los tipos de plataforma compartidos y la biblioteca de componentes de interfaz compartida se rigen por el listón más estricto y los mantiene el equipo central; los cambios propuestos allí deben empezar como una discusión de diseño.
- **CLA obligatorio.** Toda contribución aceptada requiere un Acuerdo de Licencia de Colaborador firmado. Véase [`CLA.md`](cla.md). Los commits deben llevar una línea `Signed-off-by` (`git commit -s`).

> **La licencia puede abrirse; el listón de fusión no.** El **2030-01-01** los proyectos del grupo convierten de BUSL-1.1 a la Licencia de Cambio declarada en el [`LICENSE`](../../../LICENSE) de cada repositorio — hoy SySL-1.0 para la mayoría de los proyectos. Eso amplía *lo que puedes hacer con el código*; **no** baja el listón de revisión, no elimina el CLA ni significa que aceptemos más PR. La política de contribución no cambia antes ni después de la fecha de cambio.

## Seguridad

**No** abras issues públicos para vulnerabilidades de seguridad. Repórtalas en privado vía GitHub Security Advisories en el repositorio afectado, o escribiendo a <security@celestia.world>. Véase [`SECURITY.md`](security.md).

## Código de Conducta

Sé respetuoso, constructivo e inclusivo. Seguimos el [Código de Conducta del Contributor Covenant](code-of-conduct.md).

## Para empezar

Elige el repositorio en el que quieras trabajar y sigue su README y su sitio de documentación. Los proyectos Rust se verifican con `cargo fmt`, `cargo clippy -D warnings` y `cargo test`; los proyectos web con `pnpm lint`, `pnpm build` y `pnpm test`. El [mapa del ecosistema](../ecosystem/sites.md) lista cada proyecto y dónde vive su documentación.

## Proceso de pull request

1. Haz fork y crea tu rama desde la rama por defecto del repositorio.
1. Discute antes, en un issue, los cambios grandes o que afecten a contratos compartidos.
1. Haz commits atómicos: cada asunto es un único gitmoji seguido de una frase en inglés que empieza con mayúscula y termina en punto, con los detalles en el cuerpo del commit.
1. Asegúrate de que las comprobaciones del proyecto pasan antes de hacer push.
1. Firma el CLA y añade `Signed-off-by` a cada commit.
1. Atiende los comentarios de revisión; reserva los force-push para rebases únicamente.

## Licencia y CLA

Los proyectos de este grupo se licencian bajo la **Business Source License 1.1 (BUSL-1.1)** con una **Fecha de Cambio del 2030-01-01**, en la que cada uno se convierte en la Licencia de Cambio declarada en su LICENSE — hoy es **SySL-1.0** para la mayoría de los proyectos. Para uso interno, académico, gubernamental, educativo y no comercial ya hoy equivalen a Apache-2.0 o MIT (véase la Concesión de Uso Adicional en el [`LICENSE`](../../../LICENSE) de cada repositorio). Los usos comerciales restringidos (alojamiento, reventa o rebranding como servicio) requieren una licencia comercial independiente hasta la Fecha de Cambio.

Al contribuir, aceptas que tus contribuciones se licencian bajo la licencia del proyecto y que firmas el CLA ([`CLA.md`](cla.md)). El CLA otorga al proyecto una licencia permisiva **incluido el derecho a relicenciar**, para que los proyectos puedan mantener su trayectoria de licenciamiento prevista y adaptar su licenciamiento en el futuro.

## Dónde profundizar

- [CLA](cla.md) — el Acuerdo de Licencia de Colaborador que firmas.
- [Política de seguridad](security.md) — cómo reportar vulnerabilidades en privado.
- [Código de Conducta](code-of-conduct.md) — el comportamiento que nos exigimos.
- [Mapa del ecosistema](../ecosystem/sites.md) — cada proyecto, sitio y dónde vive su documentación.
