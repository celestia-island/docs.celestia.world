# Plattform-Designdokumente

> **Geltungsbereich.** Diese Dokumente sind *plattformübergreifend*: Sie erstrecken sich über `core` (entelecheia), `webui` (shittim-chest) und `router` (evernight). Projektspezifische Designs befinden sich in ihren eigenen Unterkategorien.

## Index

| Dokument | Zusammenfassung |
| --- | --- |
| [Supervision, Rolling Update & Replikation](https://malkuth.docs.celestia.world/en/design/supervision-and-rolling-update.html) | Ein einheitliches Supervision-Tree-Grundgerüst, das von allen drei Projekten gemeinsam genutzt wird: einheitliche Signal-/Drain-Semantik, systemd-Socket-Aktivierung für unterbrechungsfreie Übergabe, ein austauschbares Coordination-Lock-Trait und zwei Fehlertoleranzstrategien (Replica = Lastverteilung ⊃ Rolling Update; Leader/Follower = Edge-HA), aufgebaut auf denselben Worker + Supervisor-Primitiven. |

## Sprachverzeichnisse

| Code | Sprache |
| --- | --- |
| `en/` | English (maßgeblich) |
| `zhs/` | 简体中文 (Vereinfachtes Chinesisch) |
| `zht/` | 繁體中文 (Traditionelles Chinesisch) |
| `ja/` | 日本語 (Japanisch) |
| `ko/` | 한국어 (Koreanisch) |
| `fr/` | Français (Französisch) |
| `es/` | Español (Spanisch) |
| `ru/` | Русский (Russisch) |
