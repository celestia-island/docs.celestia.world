# Web UI — the journey from your first sentence

One account, one key, one conversation. This page walks the same path the
product does — a model becomes available, a key authenticates it, a turn runs
with memory, and a panel turns it into something you can operate.

![The dashboard](https://raw.githubusercontent.com/celestia-island/docs.celestia.world/master/res/screenshots/arona-dashboard.png)

## Models: from source to invocation

A model travels from "existing" to "chat-ready" in four stages: **source** (the
provider catalogue — metadata, not inference) → **registration** (a backend,
either a local runtime or any OpenAI-compatible service; it survives restarts)
→ **deployment** (a model ID is handed to a node, which downloads it and starts
the runtime) → **routing** (least-in-flight load balancing with session
affinity). A backend that has not passed its first health probe is refused
rather than tried.

## Identity and metering

![API keys](https://raw.githubusercontent.com/celestia-island/docs.celestia.world/master/res/screenshots/arona-apikeys.png)

![Usage and billing](https://raw.githubusercontent.com/celestia-island/docs.celestia.world/master/res/screenshots/arona-billing.png)

**API keys** are your identity — the gateway authenticates with a Bearer token,
and both `curl` and the workbench present one at the door. **Usage** is a
per-call ledger per key: tokens, model, backend, cost. **Billing** tiers set
quotas; hitting one is a hard refusal, not a slow-down.

## Chat and memory

![Chat](https://raw.githubusercontent.com/celestia-island/docs.celestia.world/master/res/screenshots/arona-playground.png)

Every turn passes through the memory service — the badge on each turn tells you
whether it did. `Memory on` means relevant long-term memories were injected
before routing; `Memory offline` means the memory service is unreachable (an
honesty signal, not a bug); `disabled` means nothing relevant was found.
Completed turns are extracted and persisted, so memory survives restarts — and
write-back entries can be deleted directly from the Memory page.

## Panels and industrial control

![Agents](https://raw.githubusercontent.com/celestia-island/docs.celestia.world/master/res/screenshots/arona-agents.png)

One prompt creates a panel; the engine generates the layout and persists it in
the workspace. Editing is structural — data-source bindings, component lists,
connection states — not a black box. Topology and Holographic are two views of
the same fleet; Reports adds semantic search over history. Industrial writes
pass policy validation and **human approval** before anything moves: the end of
the closed loop, and its heaviest step.

![Sign-in](https://raw.githubusercontent.com/celestia-island/docs.celestia.world/master/res/screenshots/arona-login.png)

## Where to go deeper

- [Arona](../platforms/arona.md) — the gateway and the deployment panel.
- [Shittim Chest](../platforms/chest.md) — the workbench and its panels.
- [Entelecheia](../platforms/entelecheia.md) — agents, workspaces and the industrial write gate.
