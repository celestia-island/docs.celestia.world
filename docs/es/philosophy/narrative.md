# Narrativa y horizonte

## La forma del problema

No estamos construyendo un chatbot con un panel de control atornillado, ni un
sistema de control con un modelo de lenguaje atornillado. Las dos mitades tienen
que ser un solo sistema, porque en el momento en que un modelo puede mover
equipos físicos, cada detalle agradable de un producto de chat se convierte en
una restricción de un sistema de control: comportamiento determinista, latencia
acotada, una pista de auditoría y una forma de decir que no.

El argumento completo está en [Por qué celestia-island](./why.md). Esta página
es la trayectoria que se deriva de él.

## Hacia dónde va

**Más cerca de la máquina.** Hoy el bucle va del navegador de un operador a un
broker de protocolos y de ahí a un controlador. Cada paso más cerca del hardware
lleva menos modelo y menos red, hasta terminar en un bucle que se ejecuta
localmente y no espera a un viaje de ida y vuelta. Ese orden es lo importante:
las partes que no deben fallar son las que nunca llaman al exterior.

**La autonomía local como horizonte.** Ese mismo orden se generaliza allí donde
un viaje de ida y vuelta es caro — una sede remota, un enlace intermitente, una
planta cuyo operador no está en la nave. Las máquinas que no pueden esperar a un
humano deben decidir localmente, de forma segura y predecible: con la autoridad
para actuar y la disciplina para negarse. Es una dirección a largo plazo, no un
plan con fechas, y es la razón por la que la capa de decisión, el modelo del
mundo y la compuerta de seguridad se construyen como cosas separadas en lugar de
un monolito.

**Reutilizable por construcción.** Sea cual sea el aspecto del próximo
despliegue, debería ensamblarse a partir de la misma base de activos en lugar de
reconstruirse: el protocolo de red, el estado del mundo, las compuertas de
seguridad y la canalización de grabación son activos compartidos. Cualquier
cosa que empiece uno nuevo debe pasar la revisión de arquitectura. Y ninguna
línea de producto depende nunca de un núcleo sin publicar: si el núcleo se
retrasa, los ingresos no.

## Lo que permanece fijo

Sea cual sea el horizonte, tres cosas no se mueven:

- **La seguridad antes que la autonomía.** Un sistema autónomo que no puede
  negarse no es autónomo, está sin vigilancia. Consulta
  [Principios de seguridad](./safety.md).
- **El bucle sigue entero.** Cada capacidad es tan real como el bucle cerrado al
  que pertenece — consulta [El bucle cerrado](./closed-loop.md).
- **La estructura va primero.** El orden entre docenas de repositorios viene de
  la estratificación, no de la disciplina del momento — consulta
  [Arquitectura en capas](./layered-architecture.md).

## Para profundizar

- [Por qué celestia-island](./why.md) — el planteamiento del problema detrás del horizonte.
- [Principios de seguridad](./safety.md) — la semántica de tiempo real sobre la que se asienta la narrativa.
- [Mapa de proyectos](../ecosystem/projects.md) — dónde vive hoy el trabajo.
