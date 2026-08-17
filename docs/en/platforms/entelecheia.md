# Entelecheia — Agent Platform and Memory

Entelecheia is the agent platform: the scepter runtime that orchestrates
specialized agents (the "souls"), maintains long-term memory (PhiLia),
provides semantic search, and hosts the industrial integration layer.
Behind the capabilities of Arona and Chest stands this platform. This guide
is organized by capability: agents, memory, search, knowledge and
connections.

## Architecture at a glance

```text
Clients: Arona (gateway) · Shittim Chest (chat/panels) · TUI/CLI
        │  JSON-RPC 2.0 over WebSocket (token or API key)
        ▼
   scepter runtime (node-3:8424)
   ├─ Agent manager: L1 souls (PhiLia, Skopeo, Hubris, Kalos, …)
   ├─ Skill chains: pipelines of LLM + tool calls with RAG prefetch
   ├─ PhiLia: long-term memory (vector + graph, pgvector-backed)
   ├─ ApoRia: knowledge base + workspace index (semantic search)
   ├─ OreXis: policy / safety gates on tool execution
   └─ Reflection: lesson store re-injected into prompts
```

## 1. Agents (souls)

Each soul is a specialized agent with its own identity document, tools
(MCP-style), and skills. Skill chains compose LLM calls with tool execution;
before each call, relevant long-term memories and knowledge-base content are
prefetched and injected into the system prompt.

Safety: tool execution passes through OreXis policy gates, and industrial
writes require explicit approval flows.

## 2. Long-term memory (PhiLia)

PhiLia is the memory service behind Arona's memory gateway:

- **Store** — episodes, entities and artifacts are stored as nodes in a
  memory graph, embedded and mirrored to pgvector (`philia_chunks`).
- **Query** — semantic retrieval combines vector similarity, graph traversal
  and recency decay (14-day half-life).
- **Consolidate** — periodic merging links related nodes.
- **Wire surface** — first-class methods `Sync.MemoryStoreRequest` /
  `MemoryQueryRequest` / `MemoryDeleteRequest` (RBAC: SystemWrite / SystemRead)
  alongside the generic `Mcp.CallTool` route.

Embedding: configured via `OLLAMA_HOST` + `OLLAMA_EMBED_MODEL` (e.g.
`nomic-embed-text`), or a remote API, falling back to a local ONNX model.

## 3. Semantic search

`Sync.SearchRequest` fuses two stores into one ranked list:

- **ApoRia** — workspace index, agent reports and knowledge-base documents
  (hybrid vector + keyword with RRF).
- **PhiLia** — long-term memories (`philia_memory` source).

## 4. Knowledge base

Create knowledge bases, add documents and subscribe to rag subscriptions —
all persisted in Postgres. Documents are embedded into the ApoRia store and
retrievable through the same search surface.

## 5. Reflection

Lessons learned are stored in a lesson store (pgvector) and re-injected into
future prompts — a second, lightweight persistent memory alongside PhiLia.

## 6. Connecting clients

- WebSocket `ws://<host>:8424/ws` — authenticate at upgrade with
  `?token=<connection token>` (or Bearer); then `Sync.ConnectHandshake`.
- HTTP JSON-RPC `POST /api/rpc?token=…` for request/response use.
- Connection token: `~/.config/entelecheia/scepter.token` on the scepter node.

## Env reference (subset)

| Variable | Purpose |
|---|---|
| `SERVER_BIND_ADDRESS` | Bind address (default 127.0.0.1; set 0.0.0.0:8424 for remote clients) |
| `DATABASE_URL` | Postgres (config.toml or env) |
| `OLLAMA_HOST` / `OLLAMA_EMBED_MODEL` | Embedding backend |
| `JWT_SECRET` | Persistent auth tokens (random per session when unset) |
| `connection_token` | Scepter connection token file |
