# Principios de seguridad

El control industrial es crítico para la seguridad: un fallo puede mover equipos
físicos. Por eso la seguridad se diseña dentro de la arquitectura, no se añade
al final.

## 1. El modelo nunca toca el mundo directamente

Un modelo es un planificador, no un actuador. Puede pedir que se haga un
trabajo; no puede realizarlo. Entre el modelo y el equipo hay un sandbox, una
comprobación de políticas y — para acciones irreversibles — un humano. El modelo
no puede inventar comportamiento fuera de las primitivas que la plataforma
expone.

## 2. Profundidad de seguridad en múltiples capas

Toda operación que pueda afectar al mundo físico atraviesa la cadena completa,
en orden:

1. **Revisión de instrucciones** — lo que se le dijo al modelo que hiciera
2. **Ejecución aislada** — el código se ejecuta de forma aislada, con restricciones de políticas
3. **Validación de políticas** — la compuerta de escritura: ¿la operación coincide con la política?
4. **Confirmación humana** — la última palabra para acciones irreversibles
5. **Pista de auditoría** — todo queda registrado, nada es silencioso

Ninguna capa confía en la anterior. Saltarse una es un defecto, no un atajo.

## 3. Criticidad mixta: el tiempo real nunca depende del modelo

El sistema se divide por tiempo de respuesta, y **cuanto más rápida es una capa,
menos depende de que un modelo esté en línea**:

| Capa | Qué hace | Dependencia del LLM |
| --- | --- | --- |
| Cognición | planificación, conversación, orquestación | consumidor principal |
| Estado del mundo | lo que es cierto ahora mismo, no lo que se dijo | opcional |
| Reactiva | reacciones locales en la propia máquina | ninguna |
| Control en tiempo real | interbloqueos y bucle rápido | nunca |

Si el modelo se desconecta, la plataforma se degrada con elegancia: o un estado
seguro, o la ejecución continuada de una trayectoria ya aprobada. El control
nunca espera a una llamada de red.

## 4. Confianza cero, fallo cerrado

- La autenticación y la autorización provienen de
  [kirino](https://github.com/celestia-island/kirino), la capa de autenticación
  de confianza cero del ecosistema. Nada es de confianza por estar dentro de la
  red.
- El registro está cerrado con invitación por defecto; el primer usuario de un
  despliegue se convierte en el administrador, y después el auto-registro se
  bloquea.
- Todo lo que no esté explícitamente permitido se deniega. Cuando un servicio
  tiene un modo *mock*, el modo mock está desactivado por defecto y se niega a
  ejecutarse en despliegues de producción sin una bandera explícita.

## 5. Los fallos son ruidosos

La degradación silenciosa se trata como un fallo de seguridad. Si el recuerdo de
memoria falla, un backend es inalcanzable o un despliegue falla, la respuesta de
la API y la UI deben decirlo explícitamente — sin éxito falso, sin recurrir a
datos simulados. Esta regla existe porque incidentes reales han demostrado que
los fallos invisibles son los peligrosos.

## Para profundizar

- [El bucle cerrado](./closed-loop.md) — dónde se sitúan las compuertas de seguridad en el flujo.
- [Arquitectura en capas](./layered-architecture.md) — las capas que la seguridad atraviesa.
- [Documentación de kirino](https://kirino.docs.celestia.world) — el modelo de autenticación en detalle.
