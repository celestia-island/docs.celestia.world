# Safety Principles

Industrial control is safety-critical: a failure can move physical equipment.
Safety is therefore designed into the architecture, not layered on at the end.

## 1. The LLM never touches the world directly

In [entelecheia](https://github.com/celestia-island/entelecheia), the model
sees only a handful of primitive tools (`exec`, `write_to_var`). All real work
happens inside a sandboxed execution pipeline where agent code dispatches to a
large surface of MCP tools across agents. The model cannot invent behavior;
it can only call the primitives the platform exposes.

## 2. Multi-layer safety depth

Every operation that can affect the physical world passes through the full
chain, in order:

1. **Instruction review** — what the model was told to do
2. **Sandboxed execution** — code runs isolated, with policy constraints
3. **Policy validation** — the write gate: does the operation match policy?
4. **Human confirmation** — the final say for irreversible actions
5. **Audit trail** — everything is recorded, nothing is silent

## 3. Mixed-criticality: real-time never depends on the LLM

Systems are split by response time, and **the faster layers never depend on a
model being online**:

| Layer | Cadence | Runs on | LLM dependency |
| --- | --- | --- | --- |
| L3 — Cognition | seconds–minutes | arona, shittim-chest, entelecheia (Linux) | primary consumer |
| L2 — World model | 10–50 Hz | platform services | optional |
| L1 — Reactive / edge | 10–100 Hz | evernight on SBCs; small local models | none |
| L0 — Real-time control | 100 Hz–1 kHz | MCU fast loop, local interlocks | never |

If the LLM drops offline, the platform degrades gracefully: either a safe
state, or continued execution of an already-approved trajectory. Hardware
watchdogs anchor this semantics — control never waits on a network call.

## 4. Zero trust, fail closed

- Authentication and authorization come from
  [kirino](https://github.com/celestia-island/kirino): JWT with short-lived
  sessions, Argon2id password hashing, login rate limiting, and an RBAC engine.
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
- [evernight documentation](https://evernight.docs.celestia.world) — protocol brokering and write gates.
