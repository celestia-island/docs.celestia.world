# Downloads

What you install depends on your place in the closed loop. During the internal
beta most participants only need the desktop app; everything else is hosted by
your administrator or optional.

## Desktop app (shittim-chest)

The shittim-chest desktop app is published from every `v*` tag. Installers are
**unsigned** — expect an OS security warning on first launch. The download page
stays empty until the first beta tag is pushed.

| Platform | Asset |
| --- | --- |
| Linux | `.AppImage` or `.deb` |
| Windows 10+ | `.exe` (NSIS) or `.msi` |
| macOS | not published yet |

Release builds cover Linux and Windows only; macOS is not part of the release
pipeline. Until the first release (or if you prefer no install), use the
shittim-chest [webUI](https://dev.celestia.world).

## Admin panel (arona)

Arona is server-hosted — there is nothing to install locally. Open the panel
URL your administrator provides and sign in with your invitation.

## Agent runtime (optional)

Users who run the agent platform themselves use the unified installer in
[plana](https://github.com/celestia-island/plana/tree/master/scripts/install)
([Linux/macOS](https://github.com/celestia-island/plana/blob/master/scripts/install/celestia-install.sh),
[Windows](https://github.com/celestia-island/plana/blob/master/scripts/install/celestia-install.ps1)).
Everything is built from the ecosystem's own repositories, so the prerequisites
are a Rust toolchain, Docker, and the `just` task runner.

## Where to go deeper

- [Quickstart](./quickstart.md) — the 30-minute path through the loop.
- [Closed Beta Guide](./beta-guide.md) — what the beta covers and how to report bugs.
- [Projects Map](../ecosystem/projects.md) — the full project list.
