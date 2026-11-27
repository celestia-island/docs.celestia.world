# Kerninfrastruktur — Auth, RPC und Grundlagen

Jede Plattform, die Sie nutzen, steht auf derselben Grundlage. Lesen Sie diese
Seite einmal, und die Plattform-Anleitungen fügen sich zusammen: kirino
(Zero-Trust-Auth und RBAC), plana (Protokolltypen und Plattform-Grundlagen) und
hikari (die UI-Komponentenbibliothek).

## Authentifizierung und Autorisierung (kirino)

- **Identität**: Passwort-Hashing, Sitzungstokens mit kurzer Lebensdauer,
  Login-Ratenbegrenzung und Kontosperrung. Die Algorithmen und ihre Parameter
  sind in [kirinos eigener Dokumentation](https://kirino.docs.celestia.world)
  dokumentiert, nicht hier.
- **RBAC**: Berechtigungen sind hierarchisch und werden pro Aufrufer
  aufgelöst; Rollen bündeln Berechtigungen (ein Admin sieht alles, ein Viewer
  ist rein lesend). Zuweisungen werden in der Plattformdatenbank persistiert.
- **Delegation**: Ein Dienst, der hinter einem anderen sitzt, authentifiziert
  selbst niemanden — die authentifizierende Schicht liegt immer upstream, und
  die Identität des Aufrufers wird nur zur Workspace-Isolation
  durchgereicht.

## Protokoll und RPC (plana)

- Der Plattformdatenverkehr ist **JSON-RPC 2.0**, über WebSocket für Streaming
  und über HTTP POST für Request/Response. Methoden heißen
  `<Domain>.<Action>`.
- Die Wire-Typen sind die einzige Wahrheitsquelle für das Protokoll und leben
  in plana; Downstream-Repositories pinnen eine veröffentlichte Version,
  statt eine Kopie zu forken.
- Benachrichtigungen haben keine `id` und pushen Ereignisse wie
  Streaming-Chunks und Panel-Updates; Requests tragen eine `id`, die die
  Antwort zurückgibt.
- Zustandsintensive Oberflächen folgen überall demselben Muster: Der Server
  ist autoritativ, Clients deklarieren, was sie ansehen, und der Server
  streamt die Unterschiede.

## Messung und Preisgestaltung (plana)

Die Nutzung wird pro API key gemessen und anhand einer einzigen kanonischen
Tabelle bepreist, die alle Dienste teilen: Prompt- und Completion-Tokens,
Kostenschätzung und Quota-Durchsetzung sind in jedem Produkt dieselbe
Berechnung.

## UI-Komponenten (hikari)

Die Komponentenbibliothek stellt die Buttons, Badges, Tabellen, Modals und
Bestätigungsdialoge bereit, die jede WebUI nutzt, sodass ein Bildschirm
überall gleich aussieht und sich gleich verhält, wo er auch eingebunden ist.
Geteilte Komponenten werden hier upstream eingereicht, statt pro Repository
neu implementiert zu werden.

## Abhängigkeitsregeln

- Schicht 0: kirino (Auth) → Schicht 1: plana (Protokoll/Grundlagen) →
  Schicht 2: hikari (UI) → Schicht 3: Dienste (arona, chest, entelecheia,
  evernight).
- Dienste implementieren nur Geschäftslogik; geteilte Fähigkeiten kommen aus
  dem Upstream. Cross-Repo-Abhängigkeiten nutzen Git-Referenzen oder gepinnte
  Tags — niemals lokale Pfadabhängigkeiten.
