# Downloads

Was Sie installieren, hängt von Ihrem Platz im geschlossenen Regelkreis ab.
Während der internen Beta brauchen die meisten Teilnehmer nur die Desktop-App;
alles andere hostet Ihr Administrator oder ist optional.

## Desktop-App (shittim-chest)

Die shittim-chest-Desktop-App wird von jedem `v*`-Tag zu
[GitHub Releases](https://github.com/celestia-island/shittim-chest/releases)
veröffentlicht. Installers sind **nicht signiert** — rechnen Sie bei der ersten
Ausführung mit einer Sicherheitswarnung des Betriebssystems. Die Seite bleibt
leer, bis der erste Beta-Tag gepusht wird.

| Plattform | Artefakt |
| --- | --- |
| Linux | `.AppImage` oder `.deb` |
| Windows 10+ | `.exe` (NSIS) oder `.msi` |
| macOS | noch nicht veröffentlicht |

Release-Builds decken nur Linux und Windows ab; macOS ist nicht Teil der
Release-Pipeline. Bis zum ersten Release (oder wenn Sie gar nicht installieren
wollen) nutzen Sie die shittim-chest-[WebUI](https://shittim-chest.docs.celestia.world).

## Admin-Panel (arona)

Arona wird auf dem Server gehostet — lokal ist nichts zu installieren. Öffnen
Sie die Panel-URL, die Ihr Administrator bereitstellt
(`https://arona.celestia.world` in einer öffentlichen Bereitstellung oder
`http://<host>:8420` intern), und melden Sie sich mit Ihrer Einladung an.

## Agenten-Runtime (entelecheia/scepter, optional)

Für fortgeschrittene Nutzer, die selbst Agenten betreiben, schreibt
entelecheias README den Unified Installer aus dem plana-Repository vor
([Linux/macOS](https://github.com/celestia-island/plana/blob/master/scripts/install/celestia-install.sh),
[Windows](https://github.com/celestia-island/plana/blob/master/scripts/install/celestia-install.ps1)):

```bash
git clone https://github.com/celestia-island/plana.git
# Zusätzlich entelecheia, evernight, scriptum und shittim-chest neben arona/ klonen
cd arona/scripts/install
bash celestia-install.sh --source-root ../../..
```

Windows-Entsprechung (WSL2): `.\celestia-install.ps1 -SourceRoot ..\..\..`

Um entelecheia selbst aus dem Quellcode zu bauen: `just bootstrap` installiert
den Workspace, danach startet `just dev` die TUI. Voraussetzungen sind
Rust 1.85+, Docker und der Task-Runner `just`.

## Weiterführendes

- [Schnellstart](./quickstart.md) — der 30-Minuten-Weg durch den Regelkreis.
- [Leitfaden zur geschlossenen Beta](./beta-guide.md) — was die Beta abdeckt und wie Sie Bugs melden.
- [Projektübersicht](../ecosystem/projects.md) — die vollständige Projektliste.
