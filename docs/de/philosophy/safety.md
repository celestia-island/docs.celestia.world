# Sicherheitsprinzipien

Industrielle Steuerung ist sicherheitskritisch: Ein Fehler kann physische
Anlagen bewegen. Sicherheit wird daher in die Architektur hineinentworfen,
nicht am Ende aufgesetzt.

## 1. Das LLM berührt die Welt nie direkt

In [entelecheia](https://github.com/celestia-island/entelecheia) sieht das
Modell nur eine Handvoll primitiver Werkzeuge (`exec`, `write_to_var`). Alle
echte Arbeit geschieht in einer sandboxed Ausführungspipeline, in der
Agentencode über eine große Fläche von MCP-Tools auf mehrere Agenten
verteilt wird. Das Modell kann kein Verhalten erfinden; es kann nur die
Primitive aufrufen, die die Plattform bereitstellt.

## 2. Sicherheit in mehreren Schichten

Jede Operation, die die physische Welt beeinflussen kann, durchläuft der Reihe
nach die vollständige Kette:

1. **Anweisungsprüfung** — was dem Modell aufgetragen wurde
2. **Sandbox-Ausführung** — Code läuft isoliert, mit Richtlinieneinschränkungen
3. **Richtlinienprüfung** — die Schreibsperre: entspricht die Operation der Richtlinie?
4. **Menschliche Bestätigung** — das letzte Wort bei irreversiblen Aktionen
5. **Prüfprotokoll** — alles wird aufgezeichnet, nichts ist still

## 3. Gemischte Kritikalität: Echtzeit hängt nie vom LLM ab

Die Systeme sind nach Antwortzeit getrennt, und **die schnelleren Schichten
hängen nie davon ab, dass ein Modell online ist**:

| Schicht | Takt | Läuft auf | LLM-Abhängigkeit |
| --- | --- | --- | --- |
| L3 — Kognition | Sekunden–Minuten | arona, shittim-chest, entelecheia (Linux) | primärer Konsument |
| L2 — Weltmodell | 10–50 Hz | Plattform-Dienste | optional |
| L1 — Reaktiv / Edge | 10–100 Hz | evernight auf SBCs; kleine lokale Modelle | keine |
| L0 — Echtzeit-Steuerung | 100 Hz–1 kHz | MCU-Schnellschleife, lokale Verriegelungen | nie |

Fällt das LLM offline, degradiert die Plattform kontrolliert: entweder in
einen sicheren Zustand oder in die Fortführung einer bereits genehmigten
Trajektorie. Hardware-Watchdogs verankern diese Semantik — Steuerung wartet nie
auf einen Netzwerkaufruf.

## 4. Zero Trust, fail closed

- Authentifizierung und Autorisierung kommen aus
  [kirino](https://github.com/celestia-island/kirino): JWT mit kurzlebigen
  Sitzungen, Argon2id-Passwort-Hashing, Login-Ratenbegrenzung und eine
  RBAC-Engine.
- Die Registrierung ist standardmäßig einladungsbasiert; der erste Nutzer
  einer Bereitstellung wird zum Admin, danach sperrt sich die
  Selbstregistrierung.
- Alles, was nicht explizit erlaubt ist, wird verweigert. Wo ein Dienst einen
  *Mock*-Modus hat, ist der Mock-Modus standardmäßig aus und weigert sich, in
  Produktionsbereitstellungen ohne explizites Flag zu laufen.

## 5. Fehler sind laut

Stille Degradation gilt als Sicherheitsfehler. Wenn der Speicherabruf
fehlschlägt, ein Backend nicht erreichbar ist oder eine Bereitstellung
fehlschlägt, müssen die API-Antwort und die UI das explizit sagen — kein
vorgetäuschter Erfolg, kein Rückfall auf erfundene Daten. Diese Regel existiert,
weil reale Vorfälle gezeigt haben, dass unsichtbare Fehler die gefährlichen
sind.

## Weiterführendes

- [Der Geschlossene Regelkreis](./closed-loop.md) — wo die Sicherheitssperren im Ablauf sitzen.
- [Geschichtete Architektur](./layered-architecture.md) — die Schichten, die Sicherheit durchzieht.
- [kirino-Dokumentation](https://kirino.docs.celestia.world) — das Auth-Modell im Detail.
- [evernight-Dokumentation](https://evernight.docs.celestia.world) — Protokoll-Vermittlung und Schreibsperren.
