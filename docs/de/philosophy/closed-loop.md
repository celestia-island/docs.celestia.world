# Der Geschlossene Regelkreis

Das Produkt ist der Regelkreis, nicht ein einzelnes Projekt:

> entdecken → installieren → authentifizieren → Modell bereitstellen → chatten
> und Agenten ausführen → Industrieanlagen steuern → verifizieren und
> unterstützen

Jedes Segment gehört zu einer bestimmten Gruppe von Projekten. Wenn ein Segment
unterbrochen ist, ist die Plattform nicht fertig.

## Segment für Segment

| # | Segment | Was passiert | Projekte |
| --- | --- | --- | --- |
| 1 | **Entdecken** | Ein potenzieller Nutzer findet das Ökosystem, versteht seine Philosophie und wählt einen Einstiegspunkt | [docs.celestia.world](https://docs.celestia.world) (diese Seite), [celestia-island.github.io](https://celestia-island.github.io), [e.celestia.world](https://e.celestia.world) |
| 2 | **Installieren** | Der Nutzer bekommt ein lauffähiges System: Admin-Panel, Desktop-/Web-Shell, überwachte Dienste | [arona](https://github.com/celestia-island/arona) (Cloud-API-Admin-Panel), [shittim-chest](https://github.com/celestia-island/shittim-chest) (Chat-Desktop/WebUI), [malkuth](https://github.com/celestia-island/malkuth) (Dienstüberwachung) |
| 3 | **Authentifizieren** | Zero-Trust-Identität: Registrierung (einladungsbasiert), Login mit Ratenbegrenzung, API keys, RBAC | [kirino](https://github.com/celestia-island/kirino) (Auth-Primitive und RBAC-Engine) |
| 4 | **Modell bereitstellen** | Modell-Runtime wählen, auf einem Knoten bereitstellen, an ein Chat-Backend binden, Nutzung messen | [arona](https://github.com/celestia-island/arona) (Panel + Backends), [entelecheia](https://github.com/celestia-island/entelecheia) (scepter-Runtime), [plana](https://github.com/celestia-island/plana) (Messung und Preisgestaltung) |
| 5 | **Chatten & Agenten** | Mit Modellen sprechen, Multi-Agenten-Kollaboration ausführen, Gespräche speichern, Speicher verwalten | [shittim-chest](https://github.com/celestia-island/shittim-chest) (UI und Chat), [entelecheia](https://github.com/celestia-island/entelecheia) (Agenten-Orchestrierung), [noa](https://github.com/celestia-island/noa) (AI-native Versionskontrolle) |
| 6 | **Industrielle Steuerung** | Fernoperation und Protokoll-Vermittlung: Modbus, S7comm, OPC UA; Telemetrie und Schreibsperren | [evernight](https://github.com/celestia-island/evernight) (Protokoll-Broker), [aoba](https://github.com/celestia-island/aoba) (Modbus- und Datenquellen-CLI) |
| 7 | **Verifizieren & unterstützen** | Integrationstests auf echter Hardware, Überwachung und Selbstheilung, Nutzungsprotokolle, Feedback-Kanäle | [celestia-integration](https://github.com/celestia-island/celestia-integration), [malkuth](https://github.com/celestia-island/malkuth), [plana](https://github.com/celestia-island/plana) (Nutzungsprotokolle) |

## Wie sich der Regelkreis verhält

- **Jeder Schritt ist testbar.** Jedes Segment hat einen definierten
  Abnahmetest in
  [celestia-integration](https://github.com/celestia-island/celestia-integration);
  ein Release ist erst grün, wenn der gesamte Regelkreis auf echten Knoten
  besteht.
- **Jeder Schritt ist beobachtbar.** Überwachung, Health-Endpunkte und
  Nutzungsprotokolle machen den Zustand jedes Segments sichtbar statt
  angenommen.
- **Keine stille Degradation.** Wenn ein Segment schwächer wird (zum Beispiel
  Speicher offline oder ein Backend nicht erreichbar), sagen das die
  API-Antwort und die UI explizit. Fehler sind mit Absicht laut.
- **Sicherheit ist kein Segment.** Schreibsperren, Richtlinienprüfung und
  menschliche Bestätigung sind durch die Segmente 5 und 6 verwoben, nicht am
  Ende angeklebt. Siehe [Sicherheitsprinzipien](./safety.md).

## Weiterführendes

- [Warum celestia-island](./why.md) — das Problem, das den Regelkreis definiert.
- [Geschichtete Architektur](./layered-architecture.md) — wie die Teile geordnet bleiben.
- [Projektübersicht](../ecosystem/projects.md) — das vollständige Inventar der Repositories.
- [Schnellstart](../getting-started/quickstart.md) — den Regelkreis in 30 Minuten durchlaufen.
