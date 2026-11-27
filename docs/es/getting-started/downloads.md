# Descargas

Lo que instalas depende de tu lugar en el bucle cerrado. Durante la beta
interna, la mayoría de los participantes solo necesitan la aplicación de
escritorio; todo lo demás lo aloja tu administrador o es opcional.

## Aplicación de escritorio (shittim-chest)

La aplicación de escritorio de shittim-chest se publica desde cada tag `v*`. Los
instaladores están **sin firmar** — espera una advertencia de seguridad del
sistema operativo en el primer inicio. La página de descargas permanece vacía
hasta que se publique el primer tag de la beta.

| Plataforma | Recurso |
| --- | --- |
| Linux | `.AppImage` o `.deb` |
| Windows 10+ | `.exe` (NSIS) o `.msi` |
| macOS | todavía no publicado |

Las compilaciones de publicación cubren solo Linux y Windows; macOS no forma
parte de la canalización de publicaciones. Hasta la primera publicación (o si
prefieres no instalar nada), usa la [webUI](https://dev.celestia.world) de
shittim-chest.

## Panel de administración (arona)

Arona está alojado en el servidor — no hay nada que instalar localmente. Abre la
URL del panel que te proporcione tu administrador e inicia sesión con tu
invitación.

## Runtime de agentes (opcional)

Quienes ejecutan la plataforma de agentes por su cuenta usan el instalador
unificado de
[plana](https://github.com/celestia-island/plana/tree/master/scripts/install)
([Linux/macOS](https://github.com/celestia-island/plana/blob/master/scripts/install/celestia-install.sh),
[Windows](https://github.com/celestia-island/plana/blob/master/scripts/install/celestia-install.ps1)).
Todo se compila a partir de los propios repositorios del ecosistema, así que los
requisitos previos son una cadena de herramientas de Rust, Docker y el ejecutor
de tareas `just`.

## Para profundizar

- [Inicio rápido](./quickstart.md) — el recorrido de 30 minutos por el bucle.
- [Guía de beta cerrada](./beta-guide.md) — qué cubre la beta y cómo informar de errores.
- [Mapa de proyectos](../ecosystem/projects.md) — la lista completa de proyectos.
