# Kerninfrastruktur — Auth, RPC und Grundlagen

Jede Plattform, die Sie nutzen, steht auf derselben Grundlage. Lesen Sie diese
Seite einmal, und die Plattform-Anleitungen fügen sich von selbst zusammen:
kirino (Zero-Trust-Auth und RBAC), plana (Protokolltypen, JSON-RPC-Transport,
Messung, Sync-Engine) und hikari (die UI-Komponentenbibliothek).

## Authentifizierung und Autorisierung (kirino)

- **Identität**: Passwort-Hashing mit Argon2id; JWT-Access-/Refresh-Tokens
  (`TokenManager`, `kirino-session`); Login-Ratenbegrenzung und Kontosperrung.
- **RBAC**: hierarchische Berechtigungen (agent.*, system.*, knowledge.*, …),
  aufgelöst durch einen `GrantResolver`; Rollen bündeln Berechtigungen (admin
  sieht alles, viewer ist rein lesend). Zuweisungen werden in Postgres
  persistiert.
- **Delegation**: scepter vertraut der Nutzernummer, die das Chest-Gateway
  mitgibt (`X-User-Id` / `user_id`), und nutzt sie nur zur Workspace-Isolation —
  die authentifizierende Schicht liegt immer upstream.
- **Admin-Oberfläche**: Admin-Endpunkte des Panels verlangen ein dediziertes
  `ARONA_ADMIN_TOKEN` und verweigern ohne ihn den Dienst (fail closed).

## Protokoll und RPC (plana)

- Der gesamte Plattformdatenverkehr läuft als **JSON-RPC 2.0 über WebSocket**
  (und Request/Response über HTTP-POST `/api/rpc`). Methoden heißen
  `<Domain>.<Action>` — z. B. `Sync.MemoryQueryRequest`, `Cli.Search`,
  `Mcp.CallTool`.
- Wire-Typen leben in plana (`plana-state-sync` / `plana-types`): eine einzige
  Wahrheitsquelle für das Protokoll; Downstream-Repos pinnen einen
  Release-Tag.
- Benachrichtigungen (ohne `id`) pushen Ereignisse wie Streaming-Chunks und
  Panel-Updates; Requests tragen eine `id`, die in der Antwort zurückkommt.
- Die Sync-Engine (`plana-sync`) ist ein server-autoritativer Zustandsbaum:
  Clients deklarieren Viewports, der Server broadcastet Diffs mit periodischen
  Voll-Snapshots.

## Messung und Preisgestaltung (plana)

Die Nutzung wird pro API key gemessen und anhand einer kanonischen Tabelle
bepreist (`plana-llm-provider`-Messung): Prompt-/Completion-Tokens,
Kostenschätzung und Quota-Durchsetzung werden über alle Dienste hinweg
geteilt.

## UI-Komponenten (hikari)

Die Vue-Komponentenbibliothek (`@celestia-island/hikari`) stellt Buttons,
Badges, Tabellen, Modals und Bestätigungsdialoge bereit, die jede WebUI nutzt;
Plattform-Seiten komponieren sie mit der plana-UI-Shell. Geteilte Komponenten
müssen stattdessen hier upstream eingereicht werden, statt pro Repo neu
implementiert zu werden.

## Abhängigkeitsregeln

- Schicht 0: kirino (Auth) → Schicht 1: plana (Protokoll/Grundlagen) →
  Schicht 2: hikari (UI) → Schicht 3: Dienste (arona, chest, entelecheia,
  evernight).
- Dienste implementieren nur Geschäftslogik; geteilte Fähigkeiten kommen aus
  dem Upstream. Cross-Repo-Abhängigkeiten nutzen Git-Referenzen oder gepinnte
  Tags — niemals lokale Pfadabhängigkeiten.
