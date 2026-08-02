# Guía de beta cerrada

La **beta cerrada interna** cubre el bucle completo del producto, desde el registro de la cuenta hasta el control industrial. La participación es solo con invitación.

## Qué cubre la beta

1. **Registra una cuenta y crea una clave de API** en el panel de administración de API en la nube de [Arona](https://github.com/celestia-island/arona). El panel es solo interno durante la beta (`arona:8420` en el host de despliegue).
2. **Despliega un modelo** y vincúlalo a un backend de chat a través del panel.
3. **Chatea y ejecuta agentes** desde la aplicación de escritorio de [shittim-chest](https://github.com/celestia-island/shittim-chest); la orquestación de agentes la proporciona el runtime **scepter** de entelecheia.
4. **Control industrial**: las operaciones remotas y la intermediación de protocolos pasan por [evernight](https://github.com/celestia-island/evernight).

## Cómo obtener acceso

- El acceso se basa en **invitaciones**. El auto-registro público está cerrado por defecto.
- Las invitaciones las emiten los mantenedores y están vinculadas a una sola cuenta.
- Para dudas sobre el acceso, contacta a través de los canales indicados en [Contribuir](../meta/CONTRIBUTING.md).

## Informar de errores

Informa de los problemas en GitHub, un issue por error, usando las plantillas de issue:

| Producto | Repositorio |
| --- | --- |
| Chat de escritorio/web — shittim-chest | [celestia-island/shittim-chest](https://github.com/celestia-island/shittim-chest/issues) |
| Orquestación de agentes — entelecheia/scepter | [celestia-island/entelecheia](https://github.com/celestia-island/entelecheia/issues) |
| Control industrial — evernight | [celestia-island/evernight](https://github.com/celestia-island/evernight/issues) |
| Panel de administración y plataforma — arona/plana | [celestia-island/arona](https://github.com/celestia-island/arona/issues) |

Incluye siempre: información del entorno (SO, versiones de producto), pasos para reproducir, comportamiento esperado frente al real y cualquier registro relevante.

## Limitaciones conocidas

- El panel de Arona es **solo interno** y no se expone públicamente durante la beta.
- El registro está cerrado por defecto; el registro abierto aún no está disponible.
- El relé de dispositivos WebRTC y la telemetría SCADA en vivo requieren una instancia de scepter en ejecución; sin ella, la UI recurre a datos simulados de demo.
- Las aplicaciones móviles y los plugins de IDE no forman parte de esta beta.
- Algunos idiomas de la documentación son traducciones parciales.

## Para profundizar

- [Inicio rápido](./quickstart.md) — el camino de 30 minutos a través del bucle.
- [Por qué celestia-island](../philosophy/why.md) — la filosofía detrás de la beta.
