# Narrativa y horizonte

## La latencia es el destino

Un viaje de ida y vuelta de la señal tarda **2.6 segundos** hasta la Luna y **de 6 a 44 minutos** hasta Marte. Las máquinas tan lejos de la Tierra no pueden esperar instrucciones de un humano. Deben tomar decisiones **localmente, de forma segura y predecible** — con la autoridad para actuar y la disciplina para negarse.

Ese es el horizonte hacia el que se construye este ecosistema. Todo lo que construimos hoy para el control industrial se elige para que tenga la *misma forma* que necesitará un robot autónomo lunar o marciano:

- una **capa de decisión de agentes** que planifica y orquesta
- un **modelo del mundo** que sabe qué está pasando en este momento
- una **compuerta de seguridad** que pueda decir no, respaldada por un control en tiempo real que nunca depende de la red

La Luna no es una historia de marketing: es la razón por la que existe la estratificación.

## La hoja de ruta

El ecosistema avanza a través de puertas — una fase solo se desbloquea cuando la anterior cumple sus criterios de salida:

| Fase | Objetivo | Criterios de salida |
| --- | --- | --- |
| **Beta interna** | ahora | Cero problemas de seguridad P0; todo el bucle pasa las pruebas de integración; un usuario nuevo recorre registro → clave → chat en 30 minutos |
| **Beta pública** | 2026 | Registro abierto; documentación pública, descargas y páginas legales; revisión de seguridad independiente |
| **Y1 — Líneas industriales** | 2027-08 | Demo de línea de producción real con PLC + MCU: sensado a 100 Hz, bucle cerrado a 10 Hz, paquetes de despliegue, pruebas de aceptación |
| **Y3 — Instalaciones corpóreas** | 2029-08 | Paquete de instalación corpórea replicable (estado del mundo + capa de políticas + sitio de referencia), fijado a la forma *industrial corpórea* |
| **Y5 — Aeroespacial** | 2031-08 | Propuesta completa de software/hardware más al menos una prueba en órbita o en vuelo — sin herencia, sin ventas |
| **Y5+ — Lunar/Marciano** | 2031+ | Narrativa de autonomía, colaboraciones de investigación, white paper |

## Cuatro tracks comparten una base de activos

1. **Track B — Control industrial** ([evernight](https://github.com/celestia-island/evernight) en el escenario principal): canalizaciones de sensores, grabación/reproducción, bucles rápidos, nodos embebidos.
2. **Track E — Inteligencia corpórea**: un servicio de estado del mundo, una capa de políticas con pequeños modelos locales, visualización de gemelo digital.
3. **Track K — Núcleo de tiempo real kei**: un kernel determinista con una capa de personalidad ABI Linux — la respuesta a largo plazo para una ejecución acotada y predecible.
4. **Track S — Aeroespacial**: redundancia modular triple a nivel de sistema, herencia de vuelo, trayectoria de certificación.

Una disciplina mantiene unidos todos los tracks: **el protocolo de red, el estado del mundo, las compuertas de seguridad y la canalización de grabación son activos compartidos.** Cualquier track que empiece uno nuevo debe pasar la revisión de arquitectura. Y las líneas de producto nunca dependen de kei: si kei se retrasa, los ingresos no.

## Para profundizar

- [Por qué celestia-island](./why.md) — el planteamiento del problema detrás del horizonte.
- [Principios de seguridad](./safety.md) — la semántica de tiempo real sobre la que se asienta la narrativa.
- [Mapa de proyectos](../ecosystem/projects.md) — dónde vive hoy el trabajo de cada track.
