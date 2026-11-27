# Core Infrastructure — Auth, RPC and Foundations

Every platform you use sits on the same foundation. Read this once and the
platform guides click into place: kirino (zero-trust auth and RBAC), plana
(protocol types and platform facilities) and hikari (the UI component library).

## Authentication and authorization (kirino)

- **Identity**: password hashing, session tokens with short lifetimes, login
  rate limiting and account locking. The algorithms and their parameters are
  documented in [kirino's own docs](https://kirino.docs.celestia.world), not
  here.
- **RBAC**: permissions are hierarchical and resolved per caller; roles bundle
  permissions (an admin sees everything, a viewer is read-only). Assignments
  persist in the platform database.
- **Delegation**: a service that sits behind another authenticates nobody
  itself — the authenticating layer is always upstream, and the caller identity
  is passed through for workspace isolation only.

## Protocol and RPC (plana)

- Platform traffic is **JSON-RPC 2.0**, over WebSocket for streaming and over
  HTTP POST for request/response. Method names are `<Domain>.<Action>`.
- The wire types are the single source of truth for the protocol and live in
  plana; downstream repositories pin a released version rather than forking a
  copy.
- Notifications have no `id` and push events such as streaming chunks and panel
  updates; requests carry an `id` that the response echoes.
- State-heavy surfaces follow the same pattern everywhere: the server is
  authoritative, clients declare what they are looking at, and the server
  streams the difference.

## Metering and pricing (plana)

Usage is metered per API key and priced from one canonical table shared by
every service: prompt and completion tokens, cost estimation and quota
enforcement are the same computation in every product.

## UI components (hikari)

The component library provides the buttons, badges, tables, modals and confirm
dialogs that every webUI uses, so that a screen looks and behaves the same
wherever it is mounted. Shared components are upstreamed here rather than
re-implemented per repository.

## Dependency rules

- Layer 0: kirino (auth) → Layer 1: plana (protocol/foundations) → Layer 2:
  hikari (UI) → Layer 3: services (arona, chest, entelecheia, evernight).
- Services implement business logic only; shared capabilities come from
  upstream. Cross-repo dependencies use git references or pinned tags —
  never local path deps.
