# Sitios y propiedad

La documentación de este ecosistema sigue una sola regla: **el centro explica el porqué y el dónde; cada sitio de proyecto explica el cómo.** Esto mantiene el centro pequeño y los sitios de proyecto autoritativos.

## Quién posee qué

| Sitio | Posee | Contenido |
| --- | --- | --- |
| [docs.celestia.world](https://docs.celestia.world) | el ecosistema | Filosofía, mapa del ecosistema, primeros pasos, gobernanza (licencia, CLA, CoC, seguridad, contribución) |
| `<name>.docs.celestia.world` | cada proyecto | Guías, arquitectura, diseños, referencias — construidos desde el propio repositorio del proyecto |
| [celestia-island.github.io](https://celestia-island.github.io) | la organización | Presencia, enlaces, activos de marca |
| [e.celestia.world](https://e.celestia.world) | la cara pública | Página de aterrizaje, precios, blog, llamada a la acción |
| [dev.celestia.world](https://dev.celestia.world) | desarrolladores | Portal de desarrolladores y estado |

## La única regla: sin duplicación

- El centro **nunca copia** la documentación de los proyectos. Si un tema pertenece a un proyecto (cómo funciona un protocolo, cómo configurar un servicio), el centro enlaza al sitio del proyecto en lugar de resumirlo.
- Los sitios de proyecto **pueden enlazar de vuelta** al centro para filosofía y contexto entre proyectos.
- Cuando un proyecto es lo bastante sustancial como para mantener su propia documentación, el centro reduce su cobertura a una entrada en el mapa más enlaces.

## Cómo se construyen los sitios

Cada sitio de documentación (este incluido) se construye con [lagrange](https://github.com/celestia-island/lagrange) a partir del Markdown del repositorio del proyecto, con un selector de idioma compartido. El contenido se redacta en inglés; las traducciones siguen la misma estructura y se marcan cuando están parciales.

## Para profundizar

- [Mapa de proyectos](./projects.md) — qué sitios existen y para qué proyectos.
- [Contribuir](../meta/CONTRIBUTING.md) — cómo contribuir a la documentación.
