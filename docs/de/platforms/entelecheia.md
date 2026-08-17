# Entelecheia — Agenten-Plattform und Speicher

Entelecheia ist die Agenten-Plattform: die scepter-Runtime, die spezialisierte
Agenten (die „Seelen") orchestriert, Langzeitspeicher (PhiLia) pflegt,
semantische Suche bereitstellt und die industrielle Integrationsschicht
hostet. Hinter den Fähigkeiten von Arona und Chest steht diese Plattform.
Diese Anleitung ist nach Fähigkeiten gegliedert: Agenten, Speicher, Suche,
Wissen und Verbindungen.

## Architektur auf einen Blick

```text
Clients: Arona (Gateway) · Shittim Chest (Chat/Panels) · TUI/CLI
        │  JSON-RPC 2.0 über WebSocket (Token oder API key)
        ▼
   scepter-Runtime (node-3:8424)
   ├─ Agenten-Manager: L1-Seelen (PhiLia, Skopeo, Hubris, Kalos, …)
   ├─ Skill-Ketten: Pipelines aus LLM- und Tool-Aufrufen mit RAG-Prefetch
   ├─ PhiLia: Langzeitspeicher (Vektor + Graph, pgvector-gestützt)
   ├─ ApoRia: Wissensbasis + Workspace-Index (semantische Suche)
   ├─ OreXis: Policy-/Safety-Gates auf der Tool-Ausführung
   └─ Reflexion: Lesson-Store, erneut in Prompts injiziert
```

## 1. Agenten (Seelen)

Jede Seele ist ein spezialisierter Agent mit eigenem Identitätsdokument, Tools
(MCP-Stil) und Skills. Skill-Ketten verketten LLM-Aufrufe mit der
Tool-Ausführung; vor jedem Aufruf werden relevante Langzeiterinnerungen und
Wissensbasen-Inhalte vorab geladen und in den System-Prompt injiziert.

Sicherheit: Die Tool-Ausführung durchläuft die Policy-Gates von OreXis, und
industrielle Schreiboperationen verlangen explizite Freigabe-Flows.

## 2. Langzeitspeicher (PhiLia)

PhiLia ist der Speicherdienst hinter Aronas Memory-Gateway:

- **Speichern** — Episoden, Entitäten und Artefakte werden als Knoten in einem
  Speichergraphen abgelegt, eingebettet und nach pgvector gespiegelt
  (`philia_chunks`).
- **Abfragen** — semantisches Retrieval kombiniert Vektorähnlichkeit,
  Graph-Traversierung und Recency-Abfall (14-Tage-Halbwertszeit).
- **Konsolidieren** — periodisches Zusammenführen verknüpft verwandte Knoten.
- **Wire-Oberfläche** — erstklassige Methoden `Sync.MemoryStoreRequest` /
  `MemoryQueryRequest` / `MemoryDeleteRequest` (RBAC: SystemWrite / SystemRead)
  neben der generischen `Mcp.CallTool`-Route.

Embedding: konfiguriert über `OLLAMA_HOST` + `OLLAMA_EMBED_MODEL` (z. B.
`nomic-embed-text`) oder eine Remote-API, mit Fallback auf ein lokales
ONNX-Modell.

## 3. Semantische Suche

`Sync.SearchRequest` fusioniert zwei Stores zu einer gerankten Liste:

- **ApoRia** — Workspace-Index, Agentenberichte und Wissensbasen-Dokumente
  (hybrid Vektor + Stichwort mit RRF).
- **PhiLia** — Langzeiterinnerungen (Quelle `philia_memory`).

## 4. Wissensbasis

Legen Sie Wissensbasen an, fügen Sie Dokumente hinzu und abonnieren Sie
RAG-Subscriptions — alles wird in Postgres persistiert. Dokumente werden in
den ApoRia-Store eingebettet und sind über dieselbe Suchoberfläche abrufbar.

## 5. Reflexion

Gelernte Lektionen werden in einem Lesson-Store (pgvector) gespeichert und in
künftige Prompts reinjiziert — ein zweites, leichtgewichtiges persistentes
Gedächtnis neben PhiLia.

## 6. Clients verbinden

- WebSocket `ws://<host>:8424/ws` — authentifizieren Sie sich beim Upgrade mit
  `?token=<Verbindungstoken>` (oder Bearer); danach
  `Sync.ConnectHandshake`.
- HTTP-JSON-RPC `POST /api/rpc?token=…` für die Request/Response-Nutzung.
- Verbindungstoken: `~/.config/entelecheia/scepter.token` auf dem
  scepter-Knoten.

## Env-Referenz (Auszug)

| Variable | Zweck |
|---|---|
| `SERVER_BIND_ADDRESS` | Bind-Adresse (Standard 127.0.0.1; für Remote-Clients 0.0.0.0:8424 setzen) |
| `DATABASE_URL` | Postgres (config.toml oder env) |
| `OLLAMA_HOST` / `OLLAMA_EMBED_MODEL` | Embedding-Backend |
| `JWT_SECRET` | Persistente Auth-Tokens (ohne Wert zufällig pro Sitzung) |
| `connection_token` | Datei mit dem scepter-Verbindungstoken |
