# Inicio rápido

Recorre el [bucle cerrado](../philosophy/closed-loop.md) en unos 30 minutos. Las direcciones exactas dependen de tu despliegue; pregunta a tu administrador por la URL del panel y tu invitación.

## 1. Obtén una cuenta

El registro está cerrado con invitación: el primer usuario de un despliegue se convierte en el administrador y, después, el auto-registro se bloquea. Contacta con los mantenedores para pedir una invitación y luego regístrate a través del panel de Arona (`https://arona.celestia.world` en un despliegue público, o `http://<host>:8420` de forma interna).

## 2. Crea una clave de API

En el panel de Arona, crea una clave de API para tu cuenta. Esta clave es tu identidad para todo lo siguiente: gestión de modelos, backends de chat y operaciones de agentes.

## 3. Despliega un modelo

Desde el panel, elige un runtime de modelo (por ejemplo, un modelo respaldado por Ollama), despliégalo en un nodo y vincúlalo a un backend de chat. El panel muestra salud y uso; la medición y los precios los gestiona la capa de plataforma.

## 4. Chatea y ejecuta agentes

Abre [shittim-chest](https://shittim-chest.docs.celestia.world) (aplicación de escritorio o webUI), conéctate con tu clave de API y comienza una conversación. Para trabajo multi-agente, el runtime scepter de entelecheia orquesta los agentes detrás de la misma interfaz; los registros de agentes y las llamadas a herramientas son visibles en la UI.

## 5. Controla equipos industriales

Con [evernight](https://evernight.docs.celestia.world) en ejecución, conecta un puente de protocolo (Modbus, S7comm, OPC UA), suscríbete a la telemetría y — tras la validación de políticas y la confirmación humana — emite escrituras. Durante la beta interna, este segmento se ejecuta contra equipos simulados o de laboratorio; la cadena de seguridad es idéntica en ambos casos.

## 6. Verifica

Comprueba el estado de supervisión (servicios gestionados por malkuth), inspecciona los registros de uso e informa de problemas a través de los canales de la [guía de beta](./beta-guide.md). Si algo está roto, el bucle no está terminado — dinos dónde.

## ¿Qué pasa si algo falla?

- **Un servicio está caído** — malkuth debería haberlo reiniciado; comprueba la página de estado del servicio o los registros.
- **El panel no se abre** — verifica que estás en el host/puerto correcto y que el desplegador habilitó la webUI embebida.
- **La memoria o el recuerdo no están disponibles** — la respuesta de la API y la UI lo marcan explícitamente (`memory: "offline"`); el chat sigue funcionando sin ello.

## Para profundizar

- [Guía de beta cerrada](./beta-guide.md) — qué cubre la beta y cómo informar de errores.
- [El bucle cerrado](../philosophy/closed-loop.md) — la filosofía detrás de estos pasos.
