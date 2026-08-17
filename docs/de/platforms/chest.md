# Shittim Chest — Chat, Panels und Integrationen

Shittim Chest ist die Nutzerseite: Chat, Panels und Multi-Kanal-Integrationen —
die Schicht, die Modell- und Agenten-Fähigkeiten in etwas verwandelt, das Sie
täglich nutzen. Es bezieht Modelle und Speicher von Arona sowie Agenten, Panels
und industrielle Workflows von entelecheias scepter. Diese Anleitung ist nach
Fähigkeiten gegliedert: Chat, Panels, Kanäle, Suche und Auth.

## Architektur auf einen Blick

```text
Sie
 │  Desktop-App · Web-UI · 12+ IM-Kanäle (discord/slack/matrix/lark/…)
 ▼
Shittim-Chest-Kern (node-2:8425)
 ├─ Chat: in Postgres persistierte Gespräche, Streaming über SSE/WS
 ├─ Panels: Datengitter / Medien-Pipeline / 3D-Zwilling (Panel-Engine)
 ├─ Medien-Pipeline: LLM-Vision-Review, Bildgenerierung, 3D-Gen (Stub)
 ├─ Kanal-Bridge: bidirektional IM ↔ Kern (Webhooks + WS)
 └─ RPC-Bridge → scepter (Agenten, semantische Suche, Wissensbasis)
        │
        ▼
Arona (Modelle, Speicher) · scepter (Agenten, Panels, Suche)
```

## 1. Chat

- Gespräche und Nachrichten werden in Postgres persistiert (Tabellen
  `conversations` / `messages`). Die vollständige Historie wird serverseitig
  zusammengestellt.
- Streaming über SSE mit Chunk-Wiederholung; die Desktop-Shell zeigt
  Thinking-Chunks und Tool-Aufrufe von scepter-Agenten.
- `chat.send` unterstützt Gesprächs-ID, Modell-Override und Memory-Flags
  (siehe die [Arona-Anleitung](./arona.md) zur Semantik des Memory-Gateways).

## 2. Panels

Panels entstehen aus einem einzigen Prompt: Die Engine erzeugt Layout und
Widgets und persistiert sie dann im Workspace-Store von scepter
(`.amphoreus/workspace.toml` + `.noa/views/*.view.toml`). Die Bearbeitung ist
strukturiert, keine Blackbox: Die rohe Datenquellen-Bindung, die Widget-Liste
und der Verbindungszustand sind sichtbar, mit einem Deep-Edit-Dialog pro Zeile
und einer eingeklappten Tuning-Box in natürlicher Sprache.

Drei Panel-Arten:

- **Datengitter** — Tabellenansichten mit typisierten Feldern,
  Sortieren/Filtern/Gruppieren; Schreiboperationen laufen über `table.*`
  Edit-Arten mit echter Validierung und Rollback.
- **Medien-Pipeline** — ein Knotengraph im Dify-Stil (LLM-Knoten,
  Bildgenerierung, HTTP, Wissens-Retrieval, Verzweigungen); Pipelines laufen
  serverseitig mit Streaming-Fortschritt und können von Agenten als Tools
  aufgerufen werden.
- **3D-Zwilling** — Gerätemodellbäume mit Weltkoordinaten, Szenenkonfiguration
  und Kamera-Lesezeichen.

## 3. Multi-Kanal-Integrationen

Die Kanal-Bridge verbindet den Kern mit IM-Plattformen (Discord, Slack, Matrix,
Lark, …). Eingehende Nachrichten werden zu Chat-Runden; ausgehende Antworten
streamen über denselben Kanal zurück. Jeder Kanal verlangt eine für den
Produktionseinsatz freigegebene OAuth-Anwendung.

## 4. Semantische Suche und Wissen

- `search.semantic` bridgt zur Vektorsuche von scepter (ApoRia-Workspace-Index
  + PhiLia-Langzeiterinnerungen, fusioniert zu einer gerankten Liste).
- Wissensbasen (anlegen / Dokumente hinzufügen / abonnieren) werden in Postgres
  persistiert und sind über dieselbe RPC-Oberfläche durchsuchbar.
- Agentenberichte werden automatisch indiziert, sodass frühere Berichte
  semantisch abrufbar sind.

## 5. Auth

Die Authentifizierung ist delegiert: scepter vertraut der Nutzernummer, die das
Chest-Gateway mitgibt (`X-User-Id` / `user_id`) und die chest von Arona oder
dem Einladungsfluss bezieht. RBAC-Rollen (admin / operator / viewer / agent)
schützen Schreiboperationen auf Panels und Workspaces.

## Env-Referenz (Auszug)

| Variable | Zweck |
|---|---|
| `DATABASE_URL` | Postgres (erforderlich) |
| `ENTELECHEIA_SCEPTER_URL` / `WS_URL` | RPC-/WS-Endpunkte der Agenten-Engine |
| `LLM_DEFAULT_PROVIDER_ENDPOINT` / `_API_KEY` / `_MODELS` | Chat-Modell-Provider (meist Arona) |
| `BIGMODEL_API_KEY*` | Medien-Pipeline (GLM Vision / CogView-Bildgenerierung) |
| `CHANNEL_*` | IM-Kanal-Credentials je Plattform |
