# Projektübersicht

Das vollständige Inventar der celestia-island-Repositories, gruppiert nach
Schicht. Repositories mit einer Dokumentationsseite tragen ihre eigenen
*Wie*-Dokumente unter `<name>.docs.celestia.world`; alles andere ist in seinem
Repository dokumentiert.

## Schicht 0 — Auth

| Projekt | Rolle | Doku |
| --- | --- | --- |
| [kirino](https://github.com/celestia-island/kirino) | Zero-Trust-Authentifizierung und RBAC: JWT-Sitzungen, Argon2id-Hashing, Login-Ratenbegrenzung, Berechtigungs-Engine | [kirino.docs.celestia.world](https://kirino.docs.celestia.world) |

## Schicht 1 — Plattform

| Projekt | Rolle | Doku |
| --- | --- | --- |
| [plana](https://github.com/celestia-island/plana) | Gemeinsame Typen, JSON-RPC-Client und -Server, SSE-Sitzungen, Circuit Breaker, LLM-Messung und -Preisgestaltung, Admin-UI-Shell | Repository |
| [provider-registry](https://github.com/celestia-island/provider-registry) | Modell- und Provider-Registry (Entrypoint-TOML-Format) | Repository |

## Schicht 2 — UI

| Projekt | Rolle | Doku |
| --- | --- | --- |
| [hikari](https://github.com/celestia-island/hikari) | UI-Komponentenbibliothek (Vue/TS + Rust), von allen WebUIs geteilt | Repository |

## Schicht 3 — Dienste

| Projekt | Rolle | Doku |
| --- | --- | --- |
| [arona](https://github.com/celestia-island/arona) | Cloud-API-Admin-Panel: Konten, API keys, Modellbereitstellung, Backends, Nutzungsprotokolle | Repository |
| [shittim-chest](https://github.com/celestia-island/shittim-chest) | Chat-Desktop/WebUI und Shell | [shittim-chest.docs.celestia.world](https://shittim-chest.docs.celestia.world) |
| [entelecheia](https://github.com/celestia-island/entelecheia) | Multi-Agenten-Kollaborationsplattform: Exec-only-Microkernel, scepter-Orchestrierungsserver, IEPL-Ausführungspipeline | [entelecheia.docs.celestia.world](https://entelecheia.docs.celestia.world) |
| [evernight](https://github.com/celestia-island/evernight) | Industrieller Protokoll-Broker: Modbus, S7comm, OPC UA; Fernoperation, Telemetrie, Schreibsperren | [evernight.docs.celestia.world](https://evernight.docs.celestia.world) |
| [malkuth](https://github.com/celestia-island/malkuth) | Dienstüberwachungs-Toolkit: Rolling Updates, Health-Probes, Reverse Proxy, Crash-Loop-Recovery | [malkuth.docs.celestia.world](https://malkuth.docs.celestia.world) |
| [lagrange](https://github.com/celestia-island/lagrange) | Markdown-Dokumentations-Engine, die diese Seite und jede Projektdoku-Seite betreibt | [lagrange.docs.celestia.world](https://lagrange.docs.celestia.world) |

## Werkzeuge & Bibliotheken

| Projekt | Rolle | Doku |
| --- | --- | --- |
| [noa](https://github.com/celestia-island/noa) | AI-native verteilte Versionskontrolle: Workspace-Isolation pro Agent, JSONL-Append-only-Protokolle, Snapshot-Verlauf | [noa.docs.celestia.world](https://noa.docs.celestia.world) |
| [seia](https://github.com/celestia-island/seia) | Multi-Engine-Websuchbibliothek und CLI | [seia.docs.celestia.world](https://seia.docs.celestia.world) |
| [ichika](https://github.com/celestia-island/ichika) | Thread-Pool-Pipeline-Makros (flume-basierte Nachrichtenpipes) | [ichika.docs.celestia.world](https://ichika.docs.celestia.world) |
| [yuuka](https://github.com/celestia-island/yuuka) | Proc-Makro zur Erzeugung komplexer verschachtelter Strukturen aus einem einfachen Makro | [yuuka.docs.celestia.world](https://yuuka.docs.celestia.world) |
| [aoba](https://github.com/celestia-island/aoba) | Modbus- und Datenquellen-CLI | [aoba.docs.celestia.world](https://aoba.docs.celestia.world) |
| [kou](https://github.com/celestia-island/kou) | Eigenständige Virtual-Terminal-Engine: PTY-Verwaltung, VT100/ANSI | Repository |
| [hifumi](https://github.com/celestia-island/hifumi) | Serialisierungsbibliothek für die Migration von Daten zwischen Versionen | Repository |
| [aris](https://github.com/celestia-island/aris) | Von servo abgeleitete Browser-Engine, als Bibliothek einbettbar (WebGL für Digital Twins) | Repository |
| [shirabe](https://github.com/celestia-island/shirabe) | Leichte Rust-native Browser-Automatisierungs- und Debug-Bibliothek | Repository |
| [tairitsu](https://github.com/celestia-island/tairitsu) | Full-Stack-Framework auf Basis des WASM Component Model | Repository |
| [ratatui-markdown](https://github.com/celestia-island/ratatui-markdown) | Markdown-Rendering für ratatui-TUIs | Repository |
| [arcaea](https://github.com/celestia-island/arcaea) | Rust-Bibliothek für das celestia-Persona-Protokoll | Repository |
| [scriptum](https://github.com/celestia-island/scriptum) | Terminal-Interface (TUI) für entelecheia: ein „dumb display", das mit dem scepter-Server spricht | Repository |

## Edge & Hardware

| Projekt | Rolle | Doku |
| --- | --- | --- |
| [kei](https://github.com/celestia-island/kei) | Rust-OS-Kernel für ARM64/RISC-V-Edge-Geräte; deterministischer Echtzeitkern für den langen Horizont | Repository |

## Infrastruktur & Tooling

| Projekt | Rolle | Doku |
| --- | --- | --- |
| [celestia-devtools](https://github.com/celestia-island/celestia-devtools) | Gemeinsame Entwicklungstoolchain: justfile-Rezepte, Patch-Registrierung, Linting | Repository |
| [celestia-integration](https://github.com/celestia-island/celestia-integration) | Integrationstestsuiten auf echter Hardware für den gesamten Regelkreis | Repository |
| [sysl](https://github.com/celestia-island/sysl) | Synthetic Source License (SySL): eine Lizenz, die für KI-generierten Code entworfen wurde | Repository |

## Web-Präsenz

| Eigenschaft | Rolle | Doku |
| --- | --- | --- |
| [celestia-island.github.io](https://celestia-island.github.io) | Präsenz der Organisation | Repository |
| [docs.celestia.world](https://docs.celestia.world) | Diese Seite — Philosophie, Karte, Erste Schritte | Repository |
| [e.celestia.world](https://e.celestia.world) | Öffentliche Landingpage | Repository |
| [dev.celestia.world](https://dev.celestia.world) | Entwicklerportal | Repository |
| [arona.celestia.world](https://arona.celestia.world) | Cloud-API-Admin-Panel (Produkt) | — |

## Weiterführendes

- [Geschichtete Architektur](../philosophy/layered-architecture.md) — warum diese Schichten existieren.
- [Der Geschlossene Regelkreis](../philosophy/closed-loop.md) — wie Projekte entlang des Regelkreises kooperieren.
- [Sites & Verantwortlichkeiten](./sites.md) — wer dokumentiert was, und wo.
