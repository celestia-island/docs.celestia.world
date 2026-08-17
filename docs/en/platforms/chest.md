# Shittim Chest — Chat, Panels and Integrations

Shittim Chest is the user face: chat, panels and multi-channel
integrations — the layer that turns model and agent capabilities into
something you use every day. It takes models and memory from Arona, and
agents, panels and industrial workflows from entelecheia's scepter. This
guide is organized by capability: chat, panels, channels, search and auth.

## Architecture at a glance

```text
You
 │  desktop app · web UI · 12+ IM channels (discord/slack/matrix/lark/…)
 ▼
Shittim Chest core (node-2:8425)
 ├─ Chat: conversations persisted in Postgres, streamed SSE/WS
 ├─ Panels: data grid / media pipeline / 3D twin (panel engine)
 ├─ Media pipeline: LLM vision review, image generation, 3D gen (stub)
 ├─ Channel bridge: bidirectional IM ↔ core (webhooks + WS)
 └─ RPC bridge → scepter (agents, semantic search, knowledge base)
        │
        ▼
Arona (models, memory) · scepter (agents, panels, search)
```

## 1. Chat

- Conversations and messages persist in Postgres (`conversations` /
  `messages` tables). The full history is assembled server-side.
- Streaming via SSE with chunk replay; the desktop shell shows thinking
  chunks and tool calls from scepter agents.
- `chat.send` supports conversation id, model override and memory flags
  (see the [Arona guide](./arona.md) for the memory gateway semantics).

## 2. Panels

Panels are created from a single prompt: the engine generates the layout and
widgets, then persists them to scepter's workspace store
(`.amphoreus/workspace.toml` + `.noa/views/*.view.toml`). Editing is
structured, not black-box: the raw data-source binding, widget list and
connection state are visible, with a per-row deep-edit dialog and a
collapsed natural-language tuning box.

Three panel kinds:

- **Data grid** — table views with typed fields, sort/filter/group, writes
  go through `table.*` edit kinds with real validation and rollback.
- **Media pipeline** — a Dify-style node graph (LLM nodes, image
  generation, HTTP, knowledge retrieval, branching); pipelines run
  server-side with streaming progress and can be invoked as tools by
  agents.
- **3D twin** — device model trees with world coordinates, scene
  configuration and camera bookmarks.

## 3. Multi-channel integrations

The channel bridge connects core to IM platforms (Discord, Slack, Matrix,
Lark, …). Inbound messages become chat turns; outbound responses stream
back over the same channel. Each channel requires its OAuth application
approved for production use.

## 4. Semantic search and knowledge

- `search.semantic` bridges to scepter's vector search (ApoRia workspace
  index + PhiLia long-term memories fused into one ranked list).
- Knowledge bases (create / add documents / subscribe) persist in Postgres
  and are searchable through the same RPC surface.
- Agent reports are indexed automatically, so past reports are
  semantically retrievable.

## 5. Auth

Authentication is delegated: scepter trusts the caller user id supplied by
the chest gateway (`X-User-Id` / `user_id`), which chest obtains from Arona
or the invitation flow. RBAC roles (admin / operator / viewer / agent)
gate write operations on panels and workspaces.

## Env reference (subset)

| Variable | Purpose |
|---|---|
| `DATABASE_URL` | Postgres (required) |
| `ENTELECHEIA_SCEPTER_URL` / `WS_URL` | Agent engine RPC/WS endpoints |
| `LLM_DEFAULT_PROVIDER_ENDPOINT` / `_API_KEY` / `_MODELS` | Chat model provider (usually Arona) |
| `BIGMODEL_API_KEY*` | Media pipeline (GLM vision / CogView image gen) |
| `CHANNEL_*` | IM channel credentials per platform |
