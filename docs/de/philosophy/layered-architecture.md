# Geschichtete Architektur

Das Ökosystem bleibt beherrschbar, weil es streng geschichtet ist.
Abhängigkeiten zeigen nur in eine Richtung: **Downstream-Dienste konsumieren
upstream-Fähigkeiten; generische Fähigkeiten werden nie neu implementiert.**

## Die vier Schichten

| Schicht | Projekte | Was sie bereitstellen |
| --- | --- | --- |
| **Schicht 0 — Auth** | [kirino](https://github.com/celestia-island/kirino) | Zero-Trust-Primitive: JWT-Signierung und -Erneuerung, Argon2id-Passwort-Hashing, Login-Ratenbegrenzung, RBAC-Engine, Einladungsspeicher, Sitzungen |
| **Schicht 1 — Plattform** | [plana](https://github.com/celestia-island/plana) | Gemeinsame Grundlagen: JSON-RPC-2.0-Typen und -Routing, Dienst-DTOs, Netzwerkerkennung, SSE-Sitzungen, Circuit Breaker, LLM-Messung und -Preisgestaltung |
| **Schicht 2 — UI** | [hikari](https://github.com/celestia-island/hikari) | UI-Komponentenbibliothek (Vue/TS + Rust), die von jeder WebUI geteilt wird |
| **Schicht 3 — Dienste** | [arona](https://github.com/celestia-island/arona), [shittim-chest](https://github.com/celestia-island/shittim-chest), [entelecheia](https://github.com/celestia-island/entelecheia), [evernight](https://github.com/celestia-island/evernight), [malkuth](https://github.com/celestia-island/malkuth), [lagrange](https://github.com/celestia-island/lagrange) | Nur Geschäftslogik. Sie konsumieren die Schichten 0–2 und ergänzen das Verhalten, das jedes Produkt real macht |

## Die Doktrin

1. **Nie doppelt implementieren.** Bevor Sie Code schreiben, fragen Sie: hat
   kirino das? hat plana das? hat hikari das? Beispiel: JSON-RPC-Typen kommen
   aus plana, JWT aus kirino, Login-Ratenbegrenzung aus kirino, Circuit Breaker
   aus plana, Health-DTOs aus plana, Preisgestaltung aus plana.
2. **Generische Fähigkeiten gehen upstream.** Eine Funktion, die zwei oder
   mehr Dienste wiederverwenden, wird zuerst in kirino, plana oder hikari
   gebaut und dann konsumiert.
3. **Keine Rückwärtsabhängigkeiten.** Dienste hängen von kirino/plana/hikari
   ab; plana darf von kirino abhängen; kirino hängt nie von plana oder hikari
   ab.
4. **Upstream erweitern, bevor konsumiert wird.** Fehlt upstream eine benötigte
   Fähigkeit, erweitern Sie upstream und konsumieren dann. Neue Fähigkeiten
   werden nie in einem Dienst prototypisiert und später neu implementiert.
5. **Cross-Repo-Abhängigkeiten sind Git-Referenzen.** Alle Repositories
   konsumieren upstream über Git-Referenzen auf den `master`-Zweig (oder
   gepinnte Versionen), nie über lokale Pfadabhängigkeiten. Jedes Repository
   baut auf jeder Maschine identisch.

## Warum das wichtig ist

- **Ein Fix breitet sich aus.** Ein Sicherheitsfix in kirino erreicht jeden
  Dienst mit einem Abhängigkeits-Bump, statt einer Jagd durch
  Neuimplementierungen.
- **Review steht im Verhältnis zum Risiko.** Änderungen in Schicht 3 sind
  Produktlogik; Änderungen in Schicht 0 sind Infrastruktur — der
  Review-Maßstab bildet das ab.
- **Die Karte bleibt lesbar.** Neue Ingenieure lesen diese Seite und wissen,
  wo jede Fähigkeit lebt. Die [Projektübersicht](../ecosystem/projects.md) ist
  das vollständige Inventar.

## Weiterführendes

- [Warum celestia-island](./why.md) — das Problem hinter der Schichtung.
- [Sicherheitsprinzipien](./safety.md) — die Doktrin, die auf den Schichten sitzt.
- [Projektübersicht](../ecosystem/projects.md) — jedes Repository, nach Schicht.
