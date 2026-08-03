# Arona — Model Gateway, Memory and Cluster

Arona is the platform control plane: an OpenAI-compatible model gateway, a
self-deployment runtime manager, and a web dashboard. This guide covers the
three capabilities that matter day to day: routing models, long-term memory,
and multi-node clusters.

## Architecture at a glance

```text
shittim-chest / any OpenAI client
        │  /v1/chat/completions (Bearer API key)
        ▼
   Arona gateway (node-2:8420)
   ├─ Router: aliases → least-count load balancing across backends
   ├─ Memory Gateway: recall inject → chat → writeback (episodes)
   └─ Agent control plane (/ws/agent) ──► arona-agent on GPU nodes
        │
        ▼
   Backends: ollama · external (OpenAI-compatible) · agent-deployed engines
```bash

All management traffic (dashboard, agents, memory) runs over WebSocket with
JSON-RPC 2.0 messages; the only REST surface is the OpenAI-compatible
`/v1/*` endpoints.

## 1. Models

### Register a backend

Backends are registered as `ollama` or `external` (any OpenAI-compatible
server — vLLM, TGI, LMDeploy, TileRT's router, …):

```bash
POST /api/admin/backends        # Bearer ADMIN_TOKEN
  {"type": "ollama", "name": "node3-ollama", "url": "http://host:11434"}
  {"type": "external", "name": "my-vllm", "url": "http://host:8000",
   "api_key": "...", "models": ["qwen2.5-72b"]}
```

Registered backends persist across restarts (`backend_configs` table) and are
health-probed continuously: external backends are fail-closed until their
first successful `/v1/models` probe, and their model list is refreshed
dynamically.

### Self-deploy a model on a node

The `arona-agent` binary runs on GPU machines and connects back to the panel.
Deploy a model from the dashboard **Agents** page (or via `agents.deploy` with
an empty `agent_id` to auto-target the least-loaded node). The agent downloads
the model (HuggingFace or Ollama registry), starts the engine (llama.cpp /
vLLM / Ollama), and reports the engine endpoint — the panel automatically
registers it as a routable `agent-{model}` backend and removes it on stop.

Engine bind address: set `ARONA_AGENT_BIND_ADDR=0.0.0.0` on nodes that must
serve traffic to the panel. Note: engine ports are unauthenticated — deploy
only on trusted networks.

### Conversation affinity

Conversations are pinned to one backend (session affinity), which lets
runtime KV caches be reused. If a pinned backend goes unhealthy, the router
falls back and re-pins.

## 2. Long-term memory

Arona is a **memory gateway**: it does not train models — it orchestrates a
memory service (entelecheia's PhiLia agent) around your existing model.

### Enable

```bash
ARONA_MEMORY_URL=ws://<scepter-host>:8424/ws
ARONA_MEMORY_TOKEN=<scepter connection token>
ARONA_MEMORY_WRITEBACK=1        # default on; 0 disables writeback
```bash

### What happens per chat

1. **Recall** — the last user message is embedded and queried against the
   memory service; relevant memories are injected as a
   `## Relevant Long-Term Memories` system section (idempotent).
2. **Chat** — the assembled context is routed to the model.
3. **Writeback** — the completed turn is extracted heuristically
   (`User: … / Assistant: …`, zero LLM calls) and stored as an episode in the
   memory graph (pgvector-backed, survives restarts).
4. **State** — every response reports `memory: enabled | disabled | offline`;
   the REST surface adds an `X-Arona-Memory` header. Failures never block the
   chat; `offline` means the memory service is unreachable and is always
   visible in the UI.

Per-call override: `chat.send` accepts `memory: true|false`.

### Manage

The dashboard **Memory** page shows recall/writeback/delete activity and lets
you delete stored nodes. Sessions persist server-side: pass `conversation_id`
to `chat.send` and the server assembles history instead of the client.

## 3. Operations

- **Auth**: registration locks after the first admin bootstrap
  (`ARONA_REGISTRATION_OPEN=1` re-opens). Admin endpoints require
  `ARONA_ADMIN_TOKEN`; they fail closed without it.
- **Metering**: usage and cost are recorded per API key (`usage.list`,
  billing tiers with quota and rate limits).
- **Health**: `/api/health` and `/v1/health` report version and build hash.

## Env reference

| Variable | Purpose |
|---|---|
| `DATABASE_URL` | Postgres (required) |
| `JWT_SECRET` | Token signing (required outside mock mode) |
| `ARONA_HOST` / `ARONA_PORT` | Bind address (default `0.0.0.0:8420`) |
| `ARONA_ADMIN_TOKEN` | Bearer token for `/api/admin/*` |
| `ARONA_REGISTRATION_OPEN` | Re-open self-registration |
| `ARONA_MEMORY_URL` / `ARONA_MEMORY_TOKEN` / `ARONA_MEMORY_WRITEBACK` | Memory gateway |
| `ARONA_AGENT_NAME` / `ARONA_PANEL_URL` / `ARONA_AGENT_BIND_ADDR` | Agent node |
