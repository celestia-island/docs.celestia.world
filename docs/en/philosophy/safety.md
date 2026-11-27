# Safety Principles

Industrial control is safety-critical: a failure can move physical equipment.
Safety is therefore designed into the architecture, not layered on at the end.

## 1. The model never touches the world directly

A model is a planner, not an actuator. It can ask for work to be done; it
cannot perform it. Between the model and the equipment sit a sandbox, a policy
check, and — for irreversible actions — a human. The model cannot invent
behaviour outside the primitives the platform exposes.

## 2. Multi-layer safety depth

Every operation that can affect the physical world passes through the full
chain, in order:

1. **Instruction review** — what the model was told to do
2. **Sandboxed execution** — code runs isolated, with policy constraints
3. **Policy validation** — the write gate: does the operation match policy?
4. **Human confirmation** — the final say for irreversible actions
5. **Audit trail** — everything is recorded, nothing is silent

No layer trusts the one before it. Skipping one is a defect, not a shortcut.

## 3. Mixed-criticality: real-time never depends on the model

The system is split by response time, and **the faster a layer is, the less it
depends on a model being online**:

| Layer | What it does | LLM dependency |
| --- | --- | --- |
| Cognition | planning, conversation, orchestration | primary consumer |
| World state | what is true right now, not what was said | optional |
| Reactive | local reactions on the machine itself | none |
| Real-time control | interlocks and the fast loop | never |

If the model drops offline, the platform degrades gracefully: either a safe
state, or continued execution of an already-approved trajectory. Control never
waits on a network call.

## 4. Zero trust, fail closed

- Authentication and authorization come from
  [kirino](https://github.com/celestia-island/kirino), the ecosystem's
  zero-trust auth layer. Nothing is trusted because it is inside the network.
- Registration is invite-gated by default; the first user of a deployment
  becomes the admin, after which self-registration locks.
- Anything not explicitly allowed is denied. Where a service has a *mock* mode,
  mock mode is off by default and refuses to run in production deployments
  without an explicit flag.

## 5. Failures are loud

Silent degradation is treated as a safety bug. If memory recall fails, a
backend is unreachable, or a deployment fails, the API response and the UI
must say so explicitly — no fake success, no fallback to pretend data. This
rule exists because real incidents have shown that invisible failures are the
dangerous ones.

## Where to go deeper

- [The Closed Loop](./closed-loop.md) — where safety gates sit in the flow.
- [Layered Architecture](./layered-architecture.md) — the layers safety cuts across.
- [kirino documentation](https://kirino.docs.celestia.world) — the auth model in detail.
