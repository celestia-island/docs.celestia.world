# Erzählung & Horizont

## Latenz ist Schicksal

Eine Signal-Rundstrecke dauert **2,6 Sekunden** zum Mond und **6 bis 44
Minuten** zum Mars. Maschinen, die so weit von der Erde entfernt sind, können
nicht auf Anweisungen eines Menschen warten. Sie müssen Entscheidungen
**lokal, sicher und vorhersehbar** treffen — mit der Befugnis zu handeln und
der Disziplin, abzulehnen.

Das ist der Horizont, auf den dieses Ökosystem zubaut. Alles, was wir heute
für die industrielle Steuerung bauen, ist so gewählt, dass es die *gleiche
Form* hat, die ein autonomer Mond- oder Marsroboter brauchen wird:

- eine **Agenten-Entscheidungsebene**, die plant und orchestriert
- ein **Weltmodell**, das weiß, was gerade jetzt passiert
- eine **Sicherheitssperre**, die Nein sagen kann, gestützt auf
  Echtzeit-Steuerung, die nie vom Netzwerk abhängt

Der Mond ist keine Marketingstory: Er ist der Grund, warum die Schichtung
existiert.

## Der Fahrplan

Das Ökosystem schreitet über Tore voran — eine Phase wird nur freigeschaltet,
wenn die vorherige ihre Austrittskriterien erfüllt:

| Phase | Ziel | Austrittskriterien |
| --- | --- | --- |
| **Interne Beta** | jetzt | Null P0-Sicherheitsprobleme; der gesamte Regelkreis besteht die Integrationstests; ein neuer Nutzer schafft Registrierung → Key → Chat in 30 Minuten |
| **Öffentliche Beta** | 2026 | Offene Registrierung; öffentliche Doku, Downloads und Rechtsseiten; unabhängiges Sicherheits-Review |
| **J1 — Industrieanlagen** | 2027-08 | Reale PLC- + MCU-Produktionsliniendemo: 100-Hz-Messung, 10-Hz-Regelkreis, Bereitstellungspakete, Abnahmetests |
| **J3 — Verkörperte Einrichtungen** | 2029-08 | Reproduzierbares Paket für verkörperte Einrichtungen (Weltzustand + Richtlinienebene + Referenzstandort), festgelegt auf die Form *industrial embodied* |
| **J5 — Luft- und Raumfahrt** | 2031-08 | Vollständiger Software-/Hardware-Vorschlag plus mindestens ein In-Orbit- oder Flugnachweis — kein Erbe, keine Versprechen |
| **J5+ — Mond/Mars** | 2031+ | Autonomie-Erzählung, Forschungspartnerschaften, White Paper |

## Vier Tracks teilen sich eine gemeinsame Basis

1. **Track B — Industrielle Steuerung** ([evernight](https://github.com/celestia-island/evernight) Hauptbühne): Sensor-Pipelines, Aufzeichnung/Wiedergabe, schnelle Schleifen, eingebettete Knoten.
2. **Track E — Verkörperte Intelligenz**: ein Weltzustandsdienst, eine Richtlinienebene mit kleinen lokalen Modellen, Digital-Twin-Visualisierung.
3. **Track K — kei-Echtzeitkern**: ein deterministischer Kernel mit einer Linux-ABI-Persönlichkeitsschicht — die langfristige Antwort für begrenzte, vorhersehbare Ausführung.
4. **Track S — Luft- und Raumfahrt**: systemweite dreifache modulare Redundanz, Flugerbe, Zertifizierungspfad.

Eine Disziplin hält alle Tracks zusammen: **Drahtprotokoll, Weltzustand,
Sicherheitssperren und die Aufzeichnungspipeline sind gemeinsame Assets.** Jeder
Track, der ein neues startet, muss eine Architekturprüfung durchlaufen. Und die
Produktlinien hängen nie von kei ab: Wenn kei rutscht, rutscht nicht der
Umsatz.

## Weiterführendes

- [Warum celestia-island](./why.md) — die Problemstellung hinter dem Horizont.
- [Sicherheitsprinzipien](./safety.md) — die Echtzeit-Semantik, auf der die Erzählung aufbaut.
- [Projektübersicht](../ecosystem/projects.md) — wo die Arbeit jedes Tracks heute lebt.
