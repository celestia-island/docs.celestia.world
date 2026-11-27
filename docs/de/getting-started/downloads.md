# Downloads

Was Sie installieren, hängt von Ihrem Platz im geschlossenen Regelkreis ab.
Während der internen Beta brauchen die meisten Teilnehmer nur die Desktop-App;
alles andere hostet Ihr Administrator oder ist optional.

## Desktop-App (shittim-chest)

Die shittim-chest-Desktop-App wird von jedem `v*`-Tag veröffentlicht.
Installer sind **nicht signiert** — rechnen Sie bei der ersten Ausführung mit
einer Sicherheitswarnung des Betriebssystems. Die Download-Seite bleibt leer,
bis der erste Beta-Tag gepusht wird.

| Plattform | Artefakt |
| --- | --- |
| Linux | `.AppImage` oder `.deb` |
| Windows 10+ | `.exe` (NSIS) oder `.msi` |
| macOS | noch nicht veröffentlicht |

Release-Builds decken nur Linux und Windows ab; macOS ist nicht Teil der
Release-Pipeline. Bis zum ersten Release (oder wenn Sie gar nicht installieren
wollen) nutzen Sie die shittim-chest-[WebUI](https://dev.celestia.world).

## Admin-Panel (arona)

Arona wird auf dem Server gehostet — lokal ist nichts zu installieren. Öffnen
Sie die Panel-URL, die Ihr Administrator bereitstellt, und melden Sie sich mit
Ihrer Einladung an.

## Agenten-Runtime (optional)

Nutzer, die die Agenten-Plattform selbst betreiben, verwenden den einheitlichen
Installer in
[plana](https://github.com/celestia-island/plana/tree/master/scripts/install)
([Linux/macOS](https://github.com/celestia-island/plana/blob/master/scripts/install/celestia-install.sh),
[Windows](https://github.com/celestia-island/plana/blob/master/scripts/install/celestia-install.ps1)).
Alles wird aus den Repositories des Ökosystems selbst gebaut; die
Voraussetzungen sind daher eine Rust-Toolchain, Docker und der Task-Runner
`just`.

## Weiterführendes

- [Schnellstart](./quickstart.md) — der 30-Minuten-Weg durch den Regelkreis.
- [Leitfaden zur geschlossenen Beta](./beta-guide.md) — was die Beta abdeckt und wie Sie Bugs melden.
- [Projektübersicht](../ecosystem/projects.md) — die vollständige Projektliste.
