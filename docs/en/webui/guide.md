# Web UI Guide

Two web interfaces ship with the platform: **Arona** (the admin dashboard —
models, keys, usage, billing, memory) and **Shittim Chest** (the working
surface — chat, panels, visualizations, and a deep admin backend). This
guide walks through what each screen does.

## Arona — the admin dashboard

Open `http://<host>:8420`. Login or register (registration locks after the
first admin; `ARONA_REGISTRATION_OPEN=1` re-opens it).

### Dashboard
Overview page: request volume, online GPU nodes, deployed models and recent
usage at a glance.

### Models
The model catalogue. Lists everything routable through the gateway — the
HuggingFace registry quick-start set plus backends you registered — and shows
which model is served by which backend.

### Agents
GPU node management. Each row is an `arona-agent` node: status (online from
heartbeats), host, GPU summary and loaded models. **Deploy** / **Stop**
buttons push commands to the node over the agent control plane; with an
empty model field the least-loaded node is auto-targeted.

### Providers
The provider catalogue (registry entries + your custom providers). This is
metadata about model sources; actual routing backends are managed via the
admin API.

### API Keys
Create and revoke API keys per user (optionally scoped to a project). Keys
are the identity used by `curl` and by chest when it talks to the gateway.

### Usage
Per-key usage records: prompt/completion tokens, model, backend, cost.

### Billing
Billing tiers (free/pro/enterprise seeds) with monthly quota in USD and
token quotas, plus per-tier rate limits.

### Memory
The memory gateway status page: whether recall/writeback are enabled, and
the activity log (recall / writeback / delete events). Delete a stored node
from its writeback entry.

### Playground
A chat testbed against any routed model. Pick a model, use or create a
conversation, and chat — the memory badge shows the memory state of each
turn (`Memory on` / `Memory offline`).

### Settings
Account settings (profile, credentials).

## Shittim Chest — the working surface

Open `http://<host>:8425`. The UI has three areas: chat, panels, and the
admin backend (`/backend#…`).

### Chat
The chat product: conversations persist server-side, streaming responses,
and agent tool calls / thinking chunks visible in the message stream.

### Panels
Prompt-created workspaces rendered as panels — data grid, media pipeline
and 3D twin. Each panel's raw data-source binding and widget list are
editable (structured edit view), not a black box.

### Visualizations
- **Topology** — the device/network topology view with per-device details.
- **Holographic** — the 3D twin view (device models with world coordinates).
- **Demiurge** — the agent overview and per-agent detail (status, skills,
  tools).
- **Reports** — agent report archive with semantic search.

### Admin backend (`/backend`)
Grouped by domain:

- **Resources** — Workspaces, Devices, Stations, Groups, Manifests, Device
  Models (with deep-edit modal), Resource Quotas.
- **Agents** — Agents list + detail (tools, MCP, skills, containers),
  Layer-2 agents, MCP Tools, Skills.
- **Access** — Invitations, RBAC (roles/permissions/assignments), OAuth
  providers, Webhooks.
- **Integration** — Channels (IM platforms + webhooks), Bridge Network,
  Voice service.
- **Operations** — Alarms, Token Usage, System.
- **Preferences** — UI preferences and panel defaults.

## Common flows

- **First login**: chest admin → Settings/Setup → connect the provider
  (usually Arona) with an API key → chat.
- **Trying a model**: Arona Playground → pick model → chat; then give the
  same model to chest via its provider config.
- **Giving someone access**: chest admin → Invitations → send invite;
  assign a role in RBAC.
