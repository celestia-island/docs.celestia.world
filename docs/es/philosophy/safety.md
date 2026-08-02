# Principios de seguridad

El control industrial es crítico para la seguridad: un fallo puede mover equipos físicos. Por eso la seguridad se diseña dentro de la arquitectura, no se añade al final.

## 1. El LLM nunca toca el mundo directamente

En [entelecheia](https://github.com/celestia-island/entelecheia), el modelo solo ve un puñado de herramientas primitivas (`exec`, `write_to_var`). Todo el trabajo real ocurre dentro de una canalización de ejecución aislada donde el código de los agentes despacha a una amplia superficie de herramientas MCP entre agentes. El modelo no puede inventar comportamiento; solo puede llamar a las primitivas que la plataforma expone.

## 2. Profundidad de seguridad en múltiples capas

Toda operación que pueda afectar al mundo físico atraviesa la cadena completa, en orden:

1. **Revisión de instrucciones** — lo que se le dijo al modelo que hiciera
2. **Ejecución aislada** — el código se ejecuta de forma aislada, con restricciones de políticas
3. **Validación de políticas** — la compuerta de escritura: ¿la operación coincide con la política?
4. **Confirmación humana** — la última palabra para acciones irreversibles
5. **Pista de auditoría** — todo queda registrado, nada es silencioso

## 3. Criticidad mixta: el tiempo real nunca depende del LLM

Los sistemas se dividen por tiempo de respuesta, y **las capas más rápidas nunca dependen de que un modelo esté en línea**:

| Capa | Cadencia | Se ejecuta en | Dependencia del LLM |
| --- | --- | --- | --- |
| L3 — Cognición | segundos–minutos | arona, shittim-chest, entelecheia (Linux) | consumidor principal |
| L2 — Modelo del mundo | 10–50 Hz | servicios de plataforma | opcional |
| L1 — Reactiva / borde | 10–100 Hz | evernight en SBCs; pequeños modelos locales | ninguna |
| L0 — Control en tiempo real | 100 Hz–1 kHz | bucle rápido en MCU, interbloqueos locales | nunca |

Si el LLM se desconecta, la plataforma se degrada con elegancia: o un estado seguro, o la ejecución continuada de una trayectoria ya aprobada. Los watchdogs de hardware anclan esta semántica — el control nunca espera a una llamada de red.

## 4. Confianza cero, fallo cerrado

- La autenticación y la autorización provienen de [kirino](https://github.com/celestia-island/kirino): JWT con sesiones de corta duración, hash de contraseñas Argon2id, limitación de frecuencia en el inicio de sesión y un motor RBAC.
- El registro está cerrado con invitación por defecto; el primer usuario de un despliegue se convierte en el administrador, y después el auto-registro se bloquea.
- Todo lo que no esté explícitamente permitido se deniega. Cuando un servicio tiene un modo *mock*, el modo mock está desactivado por defecto y se niega a ejecutarse en despliegues de producción sin una bandera explícita.

## 5. Los fallos son ruidosos

La degradación silenciosa se trata como un fallo de seguridad. Si el recuerdo de memoria falla, un backend es inalcanzable o un despliegue falla, la respuesta de la API y la UI deben decirlo explícitamente — sin éxito falso, sin recurrir a datos simulados. Esta regla existe porque incidentes reales han demostrado que los fallos invisibles son los peligrosos.

## Para profundizar

- [El bucle cerrado](./closed-loop.md) — dónde se sitúan las compuertas de seguridad en el flujo.
- [Arquitectura en capas](./layered-architecture.md) — las capas que la seguridad atraviesa.
- [Documentación de kirino](https://kirino.docs.celestia.world) — el modelo de autenticación en detalle.
- [Documentación de evernight](https://evernight.docs.celestia.world) — intermediación de protocolos y compuertas de escritura.
