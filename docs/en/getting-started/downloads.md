# Downloads

What you install depends on your place in the closed loop. During the internal
beta most participants only need the desktop app; everything else is hosted by
your administrator or optional.

## Desktop app (shittim-chest)

The shittim-chest desktop app is published to
[GitHub Releases](https://github.com/celestia-island/shittim-chest/releases)
from every `v*` tag. Installers are **unsigned** — expect an OS security
warning on first launch. The page stays empty until the first beta tag is
pushed.

| Platform | Asset |
| --- | --- |
| Linux | `.AppImage` or `.deb` |
| Windows 10+ | `.exe` (NSIS) or `.msi` |
| macOS | not published yet |

Release builds cover Linux and Windows only; macOS is not part of the release
pipeline. Until the first release (or if you prefer no install), use the
shittim-chest [webUI](https://shittim-chest.docs.celestia.world).

## Admin panel (arona)

Arona is server-hosted — there is nothing to install locally. Open the panel
URL your administrator provides (`https://arona.celestia.world` in a public
deployment, or `http://<host>:8420` internally) and sign in with your
invitation.

## Agent runtime (entelecheia/scepter, optional)

For advanced users who run agents themselves, entelecheia's README prescribes
the unified installer from the plana repo
([Linux/macOS](https://github.com/celestia-island/plana/blob/master/scripts/install/celestia-install.sh),
[Windows](https://github.com/celestia-island/plana/blob/master/scripts/install/celestia-install.ps1)):

```bash
git clone https://github.com/celestia-island/plana.git
# Also clone entelecheia, evernight, scriptum, shittim-chest alongside arona/
cd arona/scripts/install
bash celestia-install.sh --source-root ../../..
```

Windows equivalent (WSL2): `.\celestia-install.ps1 -SourceRoot ..\..\..`

To build entelecheia itself from source: `just bootstrap` installs the
workspace, then `just dev` launches the TUI. Prerequisites are Rust 1.85+,
Docker, and the `just` task runner.

## Where to go deeper

- [Quickstart](./quickstart.md) — the 30-minute path through the loop.
- [Closed Beta Guide](./beta-guide.md) — what the beta covers and how to report bugs.
- [Projects Map](../ecosystem/projects.md) — the full project list.
