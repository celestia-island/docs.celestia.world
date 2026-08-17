# Descargas

Lo que instalas depende de tu lugar en el bucle cerrado. Durante la beta
interna, la mayoría de los participantes solo necesitan la aplicación de
escritorio; todo lo demás lo aloja tu administrador o es opcional.

## Aplicación de escritorio (shittim-chest)

La aplicación de escritorio de shittim-chest se publica en
[GitHub Releases](https://github.com/celestia-island/shittim-chest/releases)
desde cada tag `v*`. Los instaladores están **sin firmar** — espera una
advertencia de seguridad del sistema operativo en el primer inicio. La
página permanece vacía hasta que se publique el primer tag de la beta.

| Plataforma | Recurso |
| --- | --- |
| Linux | `.AppImage` o `.deb` |
| Windows 10+ | `.exe` (NSIS) o `.msi` |
| macOS | todavía no publicado |

Las builds de lanzamiento cubren solo Linux y Windows; macOS no forma parte
de la canalización de lanzamientos. Hasta el primer lanzamiento (o si
prefieres no instalar nada), usa la
[webUI](https://shittim-chest.docs.celestia.world) de shittim-chest.

## Panel de administración (arona)

Arona está alojado en el servidor — no hay nada que instalar localmente.
Abre la URL del panel que te proporcione tu administrador
(`https://arona.celestia.world` en un despliegue público, o
`http://<host>:8420` de forma interna) e inicia sesión con tu invitación.

## Runtime de agentes (entelecheia/scepter, opcional)

Para usuarios avanzados que ejecutan agentes por su cuenta, el README de
entelecheia prescribe el instalador unificado del repositorio plana
([Linux/macOS](https://github.com/celestia-island/plana/blob/master/scripts/install/celestia-install.sh),
[Windows](https://github.com/celestia-island/plana/blob/master/scripts/install/celestia-install.ps1)):

```bash
git clone https://github.com/celestia-island/plana.git
# Clona también entelecheia, evernight, scriptum, shittim-chest junto a arona/
cd arona/scripts/install
bash celestia-install.sh --source-root ../../..
```

Equivalente en Windows (WSL2): `.\celestia-install.ps1 -SourceRoot ..\..\..`

Para compilar entelecheia desde el código fuente: `just bootstrap` instala
el workspace, y después `just dev` lanza la TUI. Los prerrequisitos son
Rust 1.85+, Docker y el ejecutor de tareas `just`.

## Para profundizar

- [Inicio rápido](./quickstart.md) — el recorrido de 30 minutos por el bucle.
- [Guía de beta cerrada](./beta-guide.md) — qué cubre la beta y cómo informar de errores.
- [Mapa de proyectos](../ecosystem/projects.md) — la lista completa de proyectos.
