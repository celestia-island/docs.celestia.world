# Core Infrastructure — Auth, RPC and Foundations

Everything above sits on a shared foundation: kirino (zero-trust auth and
RBAC), plana (protocol types, JSON-RPC transport, metering, sync engine),
and hikari (UI component library). This guide explains the common concepts
you will meet in every platform.

## Authentication and authorization (kirino)

- **Identity**: password hashing with Argon2id; JWT access/refresh tokens
  (`TokenManager`, `kirino-session`); login rate limiting and account
  locking.
- **RBAC**: hierarchical permissions (agent.*, system.*, knowledge.*, …)
  resolved by a `GrantResolver`; roles bundle permissions (admin sees all,
  viewer is read-only). Assignments persist in Postgres.
- **Delegation**: scepter trusts the caller user id supplied by the chest
  gateway (`X-User-Id` / `user_id`) and uses it only for workspace
  isolation — the authenticating layer is always upstream.
- **Admin surface**: panel admin endpoints require a dedicated
  `ARONA_ADMIN_TOKEN` and fail closed without it.

## Protocol and RPC (plana)

- All platform traffic is **JSON-RPC 2.0 over WebSocket** (and
  request/response via HTTP POST `/api/rpc`). Methods are named
  `<Domain>.<Action>` — e.g. `Sync.MemoryQueryRequest`, `Cli.Search`,
  `Mcp.CallTool`.
- Wire types live in plana (`plana-state-sync` / `plana-types`): one source
  of truth for the protocol; downstream repos pin a released tag.
- Notifications (no `id`) push events like streaming chunks and panel
  updates; requests carry an `id` echoed in the response.
- The sync engine (`plana-sync`) is a server-authoritative state tree:
  clients declare viewports, the server broadcasts diffs with periodic full
  snapshots.

## Metering and pricing (plana)

Usage is metered per API key and priced from a canonical table
(`plana-llm-provider` metering): prompts/completions tokens, cost
estimation and quota enforcement are shared across services.

## UI components (hikari)

The Vue component library (`@celestia-island/hikari`) provides buttons,
badges, tables, modals and confirm dialogs used by every webui; platform
pages compose them with the plana UI shell. Shared components must be
upstreamed here rather than re-implemented per repo.

## Dependency rules

- Layer 0: kirino (auth) → Layer 1: plana (protocol/foundations) → Layer 2:
  hikari (UI) → Layer 3: services (arona, chest, entelecheia, evernight).
- Services implement business logic only; shared capabilities come from
  upstream. Cross-repo dependencies use git references or pinned tags —
  never local path deps.
