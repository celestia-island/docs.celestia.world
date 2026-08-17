# Arona — Modell-Gateway, Speicher und Cluster

Arona ist die Kontrollebene der Plattform: Modell-Gateway, Runtime-Manager für
Selbstbereitstellung und Web-Dashboard. Gelöst wird damit das Problem, aus
„einem auf irgendeiner Maschine heruntergeladenen Modell" etwas zu machen, das
die gesamte Plattform routen, messen und erinnern kann. Diese Anleitung ist
nach Fähigkeiten gegliedert: Modell-Routing, Langzeitspeicher und
Multi-Knoten-Cluster.

## Architektur auf einen Blick

```text
shittim-chest / jeder OpenAI-Client
        │  /v1/chat/completions (Bearer API key)
        ▼
   Arona-Gateway (node-2:8420)
   ├─ Router: Aliase → Least-Count-Lastverteilung über Backends
   ├─ Memory-Gateway: Recall-Injektion → Chat → Writeback (Episoden)
   └─ Agenten-Kontrollebene (/ws/agent) ──► arona-agent auf GPU-Knoten
        │
        ▼
   Backends: ollama · external (OpenAI-kompatibel) · agenten-bereitgestellte Engines
```

Der gesamte Verwaltungsdatenverkehr (Dashboard, Agenten, Speicher) läuft über
WebSocket mit JSON-RPC-2.0-Nachrichten; die einzige REST-Oberfläche sind die
OpenAI-kompatiblen `/v1/*`-Endpunkte.

## 1. Modelle

### Ein Backend registrieren

Backends werden als `ollama` oder `external` registriert (jeder
OpenAI-kompatible Server — vLLM, TGI, LMDeploy, TileRTs Router, …):

```bash
POST /api/admin/backends        # Bearer ADMIN_TOKEN
  {"type": "ollama", "name": "node3-ollama", "url": "http://host:11434"}
  {"type": "external", "name": "my-vllm", "url": "http://host:8000",
   "api_key": "...", "models": ["qwen2.5-72b"]}
```

Registrierte Backends überstehen Neustarts (`backend_configs`-Tabelle) und
werden laufend per Health-Probe geprüft: Externe Backends bleiben bis zu ihrer
ersten erfolgreichen `/v1/models`-Probe geschlossen (fail closed), und ihre
Modellliste wird dynamisch aktualisiert.

### Ein Modell selbst auf einem Knoten bereitstellen

Das Binärprogramm `arona-agent` läuft auf GPU-Maschinen und verbindet sich
zurück zum Panel. Stellen Sie ein Modell über die Dashboard-Seite **Agents**
bereit (oder per `agents.deploy` mit leerem `agent_id`, um automatisch den am
wenigsten ausgelasteten Knoten zu wählen). Der Agent lädt das Modell herunter
(HuggingFace- oder Ollama-Registry), startet die Engine (llama.cpp / vLLM /
Ollama) und meldet den Engine-Endpunkt — das Panel registriert ihn automatisch
als routbares `agent-{model}`-Backend und entfernt ihn beim Stopp.

Engine-Bind-Adresse: Setzen Sie `ARONA_AGENT_BIND_ADDR=0.0.0.0` auf Knoten, die
Datenverkehr an das Panel ausliefern müssen. Hinweis: Engine-Ports sind
unauthentifiziert — stellen Sie Engines nur in vertrauenswürdigen Netzwerken
bereit.

### Gesprächs-Affinität

Gespräche werden an genau ein Backend gepinnt (Sitzungs-Affinität), wodurch
Laufzeit-KV-Caches wiederverwendet werden können. Wird ein gepinntes Backend
fehlerhaft, fällt der Router zurück und pinnt neu.

## 2. Langzeitspeicher

Arona ist ein **Memory-Gateway**: Es trainiert keine Modelle — es orchestriert
einen Speicherdienst (entelecheias PhiLia-Agent) um Ihr bestehendes Modell
herum.

### Aktivieren

```bash
ARONA_MEMORY_URL=ws://<scepter-host>:8424/ws
ARONA_MEMORY_TOKEN=<scepter connection token>
ARONA_MEMORY_WRITEBACK=1        # Standard: an; 0 deaktiviert den Writeback
```

### Was pro Chat passiert

1. **Recall** — die letzte Nutzernachricht wird eingebettet und gegen den
   Speicherdienst abgefragt; relevante Erinnerungen werden als Systemabschnitt
   `## Relevant Long-Term Memories` injiziert (idempotent).
2. **Chat** — der zusammengestellte Kontext wird zum Modell geroutet.
3. **Writeback** — die abgeschlossene Runde wird heuristisch extrahiert
   (`User: … / Assistant: …`, keine LLM-Aufrufe) und als Episode im
   Speichergraphen gespeichert (pgvector-gestützt, übersteht Neustarts).
4. **Status** — jede Antwort meldet `memory: enabled | disabled | offline`;
   die REST-Oberfläche fügt einen `X-Arona-Memory`-Header hinzu. Fehler
   blockieren niemals den Chat; `offline` bedeutet, dass der Speicherdienst
   nicht erreichbar ist, und ist in der UI immer sichtbar.

Override pro Aufruf: `chat.send` akzeptiert `memory: true|false`.

### Verwalten

Die Dashboard-Seite **Memory** zeigt Recall-/Writeback-/Lösch-Aktivität und
lässt Sie gespeicherte Knoten löschen. Sitzungen werden serverseitig
persistiert: Übergeben Sie `conversation_id` an `chat.send`, und der Server
stellt die Historie zusammen — nicht der Client.

## 3. Betrieb

- **Auth**: Die Registrierung sperrt sich nach dem ersten Admin-Bootstrap
  (`ARONA_REGISTRATION_OPEN=1` öffnet sie erneut). Admin-Endpunkte verlangen
  `ARONA_ADMIN_TOKEN`; ohne ihn verweigern sie den Dienst (fail closed).
- **Messung**: Nutzung und Kosten werden pro API key erfasst (`usage.list`,
  Abrechnungsstufen mit Quota und Rate-Limits).
- **Health**: `/api/health` und `/v1/health` melden Version und Build-Hash.

## Env-Referenz

| Variable | Zweck |
|---|---|
| `DATABASE_URL` | Postgres (erforderlich) |
| `JWT_SECRET` | Token-Signierung (erforderlich außerhalb des Mock-Modus) |
| `ARONA_HOST` / `ARONA_PORT` | Bind-Adresse (Standard `0.0.0.0:8420`) |
| `ARONA_ADMIN_TOKEN` | Bearer-Token für `/api/admin/*` |
| `ARONA_REGISTRATION_OPEN` | Selbstregistrierung erneut öffnen |
| `ARONA_MEMORY_URL` / `ARONA_MEMORY_TOKEN` / `ARONA_MEMORY_WRITEBACK` | Memory-Gateway |
| `ARONA_AGENT_NAME` / `ARONA_PANEL_URL` / `ARONA_AGENT_BIND_ADDR` | Agenten-Knoten |
