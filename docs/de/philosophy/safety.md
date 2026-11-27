# Sicherheitsprinzipien

Industrielle Steuerung ist sicherheitskritisch: Ein Fehler kann physische
Anlagen bewegen. Sicherheit wird daher in die Architektur hineinentworfen,
nicht am Ende aufgesetzt.

## 1. Das Modell berührt die Welt nie direkt

Ein Modell ist ein Planer, kein Aktuator. Es kann Arbeit anfordern; ausführen
kann es sie nicht. Zwischen dem Modell und der Anlage stehen eine Sandbox, eine
Richtlinienprüfung und — bei irreversiblen Aktionen — ein Mensch. Das Modell
kann kein Verhalten erfinden, das außerhalb der Primitive liegt, die die
Plattform bereitstellt.

## 2. Sicherheit in mehreren Schichten

Jede Operation, die die physische Welt beeinflussen kann, durchläuft der Reihe
nach die vollständige Kette:

1. **Anweisungsprüfung** — was dem Modell aufgetragen wurde
2. **Sandbox-Ausführung** — Code läuft isoliert, mit Richtlinieneinschränkungen
3. **Richtlinienprüfung** — die Schreibsperre: entspricht die Operation der Richtlinie?
4. **Menschliche Bestätigung** — das letzte Wort bei irreversiblen Aktionen
5. **Prüfprotokoll** — alles wird aufgezeichnet, nichts ist still

Keine Schicht vertraut der vorherigen. Eine zu überspringen ist ein Defekt,
keine Abkürzung.

## 3. Gemischte Kritikalität: Echtzeit hängt nie vom Modell ab

Das System ist nach Antwortzeit getrennt, und **je schneller eine Schicht ist,
desto weniger hängt sie davon ab, dass ein Modell online ist**:

| Schicht | Was sie tut | LLM-Abhängigkeit |
| --- | --- | --- |
| Kognition | Planung, Konversation, Orchestrierung | primärer Konsument |
| Weltzustand | was gerade jetzt gilt, nicht was gesagt wurde | optional |
| Reaktiv | lokale Reaktionen auf der Maschine selbst | keine |
| Echtzeit-Steuerung | Verriegelungen und die schnelle Schleife | nie |

Fällt das Modell offline, degradiert die Plattform kontrolliert: entweder in
einen sicheren Zustand oder in die Fortführung einer bereits genehmigten
Trajektorie. Steuerung wartet nie auf einen Netzwerkaufruf.

## 4. Zero Trust, fail closed

- Authentifizierung und Autorisierung kommen aus
  [kirino](https://github.com/celestia-island/kirino), der Zero-Trust-Auth-Schicht
  des Ökosystems. Nichts wird vertraut, nur weil es im Netzwerk liegt.
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
