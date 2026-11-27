# Narrative & Horizon

## The shape of the problem

We are not building a chatbot with a control panel bolted on, and we are not
building a control system with a language model bolted on. The two halves have
to be one system, because the moment a model can move physical equipment,
every nice-to-have of a chat product becomes a constraint of a control system:
deterministic behavior, bounded latency, an audit trail, and a way to say no.

The full argument is on [Why celestia-island](./why.md). This page is the
trajectory that follows from it.

## Where it goes

**Closer to the machine.** Today the loop runs from an operator's web browser
to a protocol broker to a controller. Each step closer to the hardware has less
model in it and less network in it, ending at a loop that runs locally and does
not wait for a round trip. That ordering is the point: the parts that must not
fail are the parts that never call out.

**Local autonomy as an outlook.** The same ordering generalizes wherever a
round trip is expensive — a remote site, an intermittent link, a plant whose
operator is not on the floor. Machines that cannot wait for a human must decide
locally, safely, and predictably: with the authority to act and the discipline
to refuse. That is a long-term direction, not a dated plan, and it is why the
decision layer, the world model, and the safety gate are built as separate
things rather than one monolith.

**Reusable by construction.** Whatever the next deployment looks like, it
should be assembled from the same asset base rather than rebuilt: the wire
protocol, the world state, the safety gates and the recording pipeline are
shared assets. A track that starts a new one has to pass architecture review.
And no product line ever depends on an unreleased core — if the core slips,
revenue does not.

## What stays fixed

Whatever the horizon, three things do not move:

- **Safety before autonomy.** An autonomous system that cannot refuse is not
  autonomous, it is unguarded. See [Safety Principles](./safety.md).
- **The loop stays whole.** Every capability is only as real as the closed loop
  it belongs to — see [The Closed Loop](./closed-loop.md).
- **Structure comes first.** Order across dozens of repositories comes from
  layering, not from discipline in the moment — see
  [Layered Architecture](./layered-architecture.md).

## Where to go deeper

- [Why celestia-island](./why.md) — the problem statement behind the horizon.
- [Safety Principles](./safety.md) — the real-time semantics the narrative builds on.
- [Projects Map](../ecosystem/projects.md) — where each track's work lives today.
