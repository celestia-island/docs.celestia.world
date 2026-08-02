# Narrative & Horizon

## Latency is destiny

A signal round-trip takes **2.6 seconds** to the Moon and **6 to 44 minutes**
to Mars. Machines that far from Earth cannot wait for instructions from a
human. They must make decisions **locally, safely, and predictably** — with
the authority to act and the discipline to refuse.

That is the horizon this ecosystem is built toward. Everything we build for
industrial control today is chosen so that it is the *same shape* an
autonomous lunar or Martian robot will need:

- an **agent decision layer** that plans and orchestrates
- a **world model** that knows what is happening right now
- a **safety gate** that can say no, backed by real-time control that never
  depends on the network

The Moon is not a marketing story: it is the reason the layering exists.

## The road

The ecosystem advances through gates — a phase is unlocked only when the
previous one meets its exit criteria:

| Phase | Target | Exit criteria |
| --- | --- | --- |
| **Internal beta** | now | Zero P0 security issues; the full loop passes integration tests; a new user walks register → key → chat in 30 minutes |
| **Public beta** | 2026 | Open registration; public docs, downloads, and legal pages; independent security review |
| **Y1 — Industrial lines** | 2027-08 | Real PLC + MCU production-line demo: 100 Hz sensing, 10 Hz closed loop, deployment packages, acceptance tests |
| **Y3 — Embodied facilities** | 2029-08 | Replicable embodied facility package (world state + policy layer + reference site), locked to the *industrial embodied* form |
| **Y5 — Aerospace** | 2031-08 | Full software/hardware proposal plus at least one in-orbit or flight proof — no heritage, no sales |
| **Y5+ — Lunar/Martian** | 2031+ | Autonomy narrative, research partnerships, white paper |

## Four tracks share one asset base

1. **Track B — Industrial control** ([evernight](https://github.com/celestia-island/evernight) main stage): sensor pipelines, recording/replay, fast loops, embedded nodes.
2. **Track E — Embodied intelligence**: a world-state service, a policy layer with small local models, digital-twin visualization.
3. **Track K — kei real-time core**: a deterministic kernel with a Linux ABI personality layer — the long-term answer for bounded, predictable execution.
4. **Track S — Aerospace**: system-level triple-modular redundancy, flight heritage, certification track.

One discipline holds all tracks together: **wire protocol, world state, safety
gates, and the recording pipeline are shared assets.** Any track that starts a
new one must pass architecture review. And the product lines never depend on
kei: if kei slips, revenue does not.

## Where to go deeper

- [Why celestia-island](./why.md) — the problem statement behind the horizon.
- [Safety Principles](./safety.md) — the real-time semantics the narrative builds on.
- [Projects Map](../ecosystem/projects.md) — where each track's work lives today.
