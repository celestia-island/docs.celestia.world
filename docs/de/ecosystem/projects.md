# Projektübersicht

Das Inventar der Repositories und Produkte der celestia-island-Plattform,
gruppiert nach Schicht. Ein Name mit Link ist ein öffentliches Repository, das
Sie heute lesen können; ein Name ohne Link ist ein Produkt, das mit der
Plattform ausgeliefert wird, dessen Quelle aber noch nicht öffentlich ist.
Repositories mit einer Dokumentationsseite tragen ihre eigenen
*Wie*-Dokumente; alles andere ist im Repository selbst dokumentiert, was Zugriff auf das Repository voraussetzt.

## Schicht 0 — Auth

| Projekt | Rolle | Doku |
| --- | --- | --- |
| [kirino](https://github.com/celestia-island/kirino) | Zero-Trust-Authentifizierung und -Autorisierung: Sitzungen, Berechtigungen, Ratenbegrenzung | [kirino.docs.celestia.world](https://kirino.docs.celestia.world) |

## Schicht 1 — Plattform

| Projekt | Rolle | Doku |
| --- | --- | --- |
| [plana](https://github.com/celestia-island/plana) | Gemeinsame Protokolltypen, Transport, Messung und die Grundlagen, die jeder Dienst konsumiert | Repository |
| [provider-registry](https://github.com/celestia-island/provider-registry) | Modell- und Provider-Katalog, von allen Produkten geteilt | Repository |

## Schicht 2 — UI

| Projekt | Rolle | Doku |
| --- | --- | --- |
| [hikari](https://github.com/celestia-island/hikari) | Die UI-Komponentenbibliothek, die jede WebUI teilt | Repository |

## Schicht 3 — Dienste

| Projekt | Rolle | Doku |
| --- | --- | --- |
| arona | Modell-Gateway und Bereitstellungs-Panel: Keys, Backends, Routing, Nutzung | [Arona](../platforms/arona.md) |
| shittim-chest | Chat, Panels und Integrationen — die Werkbank-Oberfläche | [Shittim Chest](../platforms/chest.md) |
| entelecheia | Agenten-Plattform: Agenten, Langzeitspeicher, semantische Suche, industrielle Integration | [Entelecheia](../platforms/entelecheia.md) |
| evernight | Industrieller Protokoll-Broker: Feldprotokolle, Alarme, Aufzeichnung, Edge-Inferenz | [Evernight](../platforms/evernight.md) |
| [malkuth](https://github.com/celestia-island/malkuth) | Dienstüberwachung: Rolling Updates, Health-Probes, Reverse Proxy, Crash-Recovery | [malkuth.docs.celestia.world](https://malkuth.docs.celestia.world) |
| [lagrange](https://github.com/celestia-island/lagrange) | Die Dokumentations-Engine hinter dieser Seite und jeder Projektdoku-Seite | [lagrange.docs.celestia.world](https://lagrange.docs.celestia.world) |
| celestia-erp | Kaufmännisches Backoffice: Organisationen, Abrechnung, Rechnungen | — |
| electrode_recon | Rechen-Engine für Elektroden-Mikrostruktur — die erste externe Instanz auf dem Engine-Fabric | — |

## Werkzeuge & Bibliotheken

| Projekt | Rolle | Doku |
| --- | --- | --- |
| [noa](https://github.com/celestia-island/noa) | Agentennative verteilte Versionskontrolle mit isolierten Workspaces | [Repository](https://github.com/celestia-island/noa) |
| [seia](https://github.com/celestia-island/seia) | Multi-Engine-Websuche | [seia.docs.celestia.world](https://seia.docs.celestia.world) |
| [aoba](https://github.com/celestia-island/aoba) | Multi-Protokoll-Debugging- und Simulations-CLI (Modbus RTU und Verwandte) | [aoba.docs.celestia.world](https://aoba.docs.celestia.world) |
| [ichika](https://github.com/celestia-island/ichika) | Thread-Pool-Pipelines über Nachrichtenpipes | Repository |
| [yuuka](https://github.com/celestia-island/yuuka) | Makros für zusammengesetzte verschachtelte Strukturen und JSON-Merge/Patch | Repository |
| [kou](https://github.com/celestia-island/kou) | Virtual-Terminal-Engine: PTY, VT100/ANSI, Inline-Grafik | Repository |
| [hifumi](https://github.com/celestia-island/hifumi) | Serialisierung für die Migration von Daten zwischen Versionen | Repository |
| [lacrymira](https://github.com/celestia-island/lacrymira) | Typisierter Datenzugriff für SQL und KV hinter einer Befehlsoberfläche | Repository |
| [himari](https://github.com/celestia-island/himari) | Dimensionierte Zwischendarstellung für Formeln | Repository |
| [kotama](https://github.com/celestia-island/kotama) | Reverse-Engineering-Toolkit: Zerlegung, Dekompilierung, Querverweise | Repository |
| [ayane](https://github.com/celestia-island/ayane) | Mail-Dienst: Kontrollebene, Webmail und Schutz | Repository |
| [aris](https://github.com/celestia-island/aris) | Eine reine Rust-Browser-Engine, von servo abgeleitet, als Bibliothek einbettbar | Repository |
| [shirabe](https://github.com/celestia-island/shirabe) | Headless-Browser-Automatisierung und -Debugging | Repository |
| [tairitsu](https://github.com/celestia-island/tairitsu) | Full-Stack-Framework auf dem WASM Component Model | Repository |
| [akivili](https://github.com/celestia-island/akivili) | Plugin-Host und SDK für Agenten-Erweiterungen | Repository |
| [celestia-plugin](https://github.com/celestia-island/celestia-plugin) | Python-Plugin- und Engine-SDK | Repository |
| [shun](https://github.com/celestia-island/shun) | Installer, Flasher und Auslieferung von Portable-Mode-Payloads | Repository |
| [ratatui-markdown](https://github.com/celestia-island/ratatui-markdown) | Markdown-Rendering in Terminal-UIs | Repository |
| arcaea | Persona-Protokollbibliothek | — |
| scriptum | Terminal-Oberfläche für die Agenten-Plattform | — |
| official-plugins | Die First-Party-Plugin-Pakete | — |

## Edge & Hardware

| Projekt | Rolle | Doku |
| --- | --- | --- |
| [kei](https://github.com/celestia-island/kei) | Rust-Kernel für ARM64- und RISC-V-Edge-Gateways | Repository |
| [hare](https://github.com/celestia-island/hare) | `no_std`-Bridge-Bibliothek für eingebettete industrielle Knoten | Repository |
| evernight-appliance | Die Appliance-Distribution: Boot-Firmware, Flasher, Treibervertrag | — |

## Infrastruktur & Tooling

| Projekt | Rolle | Doku |
| --- | --- | --- |
| [celestia-devtools](https://github.com/celestia-island/celestia-devtools) | Gemeinsame Entwicklungstoolchain: Build-Rezepte, Linting, Release-Gates | Repository |
| [cherino](https://github.com/celestia-island/cherino) | Sandbox-Container-Abstraktion für Agentenausführung | Repository |
| [celestia-artifacts](https://github.com/celestia-island/celestia-artifacts) | Öffentliches Hosting von Binär- und Image-Artefakten für Releases | Repository |
| celestia-integration | Repo-übergreifende Integrationstests für den gesamten Regelkreis | — |
| fuuka | Selbst gehostete CI-Ausführungsebene | — |
| [sysl](https://github.com/celestia-island/sysl) | Die Synthetic Source License, unter der der meiste Code hier steht | Repository |

## Web-Präsenz

| Eigenschaft | Rolle | Doku |
| --- | --- | --- |
| [celestia-island.github.io](https://celestia-island.github.io) | Präsenz der Organisation | Repository |
| [docs.celestia.world](https://docs.celestia.world) | Diese Seite — Philosophie, Karte, Erste Schritte | Repository |
| [e.celestia.world](https://e.celestia.world) | Öffentliche Landingpage | Repository |
| [dev.celestia.world](https://dev.celestia.world) | Panel und Entwickler-Dashboard (während der Beta einladungsbasiert) | Repository |
| [celestia.ac.cn](https://celestia.ac.cn) | Website des Unternehmens und der Enterprise-Services | Repository |

## Weiterführendes

- [Geschichtete Architektur](../philosophy/layered-architecture.md) — warum diese Schichten existieren.
- [Der Geschlossene Regelkreis](../philosophy/closed-loop.md) — wie Projekte entlang des Regelkreises kooperieren.
- [Sites & Verantwortlichkeiten](./sites.md) — wer dokumentiert was, und wo.
