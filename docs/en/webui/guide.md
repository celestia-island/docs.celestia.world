# Web UI — the journey from your first sentence

Two surfaces, one flow: **arona** is the headless control plane (models, keys,
ledger, memory); **shittim-chest** is the workbench you actually look at
(chat, panels, seeing the world). Every screen below is a chest view — chest
talks to arona over its RPC surface; arona itself ships no UI.

![Chest backend console](https://raw.githubusercontent.com/celestia-island/docs.celestia.world/master/res/screenshots/arona-dashboard.png)

## Models: from source to invocation

A model travels from "existing" to "chat-ready" in four stages: **source**
(the Providers catalogue — metadata, not inference) → **registration** (an
`ollama` or OpenAI-compatible `external` backend, persisted across restarts)
→ **deployment** (the Agents page hands a model ID to an `arona-agent` node;
an empty model name auto-picks the idlest node) → **routing** (the Models
page; least-in-flight load balancing with session affinity). External
backends are fail-closed until the first probe succeeds. The exact API for
each step lives in the [arona docs](https://arona.docs.celestia.world).

## Identity and metering

![Chest API keys](https://raw.githubusercontent.com/celestia-island/docs.celestia.world/master/res/screenshots/arona-apikeys.png)

![Chest billing](https://raw.githubusercontent.com/celestia-island/docs.celestia.world/master/res/screenshots/arona-billing.png)

**API keys** are your identity — the gateway authenticates `/v1/*` with
Bearer tokens, and both `curl` and chest present one at the door. **Usage**
is a per-call ledger per key: tokens, model, backend, cost. **Billing** tiers
set quotas (USD / tokens / rate limits); hitting one is a hard refusal, not a
slow-down.

## Chat and memory

![Chest chat](https://raw.githubusercontent.com/celestia-island/docs.celestia.world/master/res/screenshots/arona-playground.png)

Every chat turn passes through the memory service — the badge on each turn
tells you whether it did. `Memory on` means relevant long-term memories were
injected before routing; `Memory offline` means the memory service is
unreachable (an honesty signal, not a bug); `disabled` means nothing relevant
was found. Completed turns are extracted into episodes and persisted, so
memory survives restarts — and write-back entries can be deleted directly
from the Memory page.

## Panels and industrial control

![Chest agents](https://raw.githubusercontent.com/celestia-island/docs.celestia.world/master/res/screenshots/arona-agents.png)

One prompt creates a panel; the engine generates the layout and persists it
into scepter's workspace storage. Editing is structural — data-source
bindings, component lists, connection states — not a black box. Topology and
Holographic are two views of the same fleet; Reports adds semantic search
over history. Industrial writes pass policy validation and **human approval**
before anything moves: the end of the closed loop, and its heaviest step.

![Chest login](https://raw.githubusercontent.com/celestia-island/docs.celestia.world/master/res/screenshots/arona-login.png)

## Where to go deeper

- The full arona platform reference — [arona docs](https://arona.docs.celestia.world)
- The chest workbench and its panels — [shittim-chest docs](https://shittim-chest.docs.celestia.world)
- Agents, workspaces and the industrial write gate — [entelecheia docs](https://entelecheia.docs.celestia.world)
