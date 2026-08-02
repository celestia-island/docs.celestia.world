# The Closed Loop

The product is the loop, not any single project:

> discover → install → authenticate → deploy a model → chat and run agents →
> control industrial equipment → verify and support

Each segment is owned by a specific set of projects. If a segment is broken,
the platform is not finished.

## Segment by segment

| # | Segment | What happens | Projects |
| --- | --- | --- | --- |
| 1 | **Discover** | A potential user finds the ecosystem, understands its philosophy, and picks an entry point | [docs.celestia.world](https://docs.celestia.world) (this site), [celestia-island.github.io](https://celestia-island.github.io), [e.celestia.world](https://e.celestia.world) |
| 2 | **Install** | The user gets a running system: admin panel, desktop/web shell, supervised services | [arona](https://github.com/celestia-island/arona) (cloud API admin panel), [shittim-chest](https://github.com/celestia-island/shittim-chest) (chat desktop/webUI), [malkuth](https://github.com/celestia-island/malkuth) (service supervision) |
| 3 | **Authenticate** | Zero-trust identity: registration (invite-gated), login with rate limiting, API keys, RBAC | [kirino](https://github.com/celestia-island/kirino) (auth primitives and RBAC engine) |
| 4 | **Deploy a model** | Pick a model runtime, deploy it to a node, bind it to a chat backend, meter usage | [arona](https://github.com/celestia-island/arona) (panel + backends), [entelecheia](https://github.com/celestia-island/entelecheia) (scepter runtime), [plana](https://github.com/celestia-island/plana) (metering and pricing) |
| 5 | **Chat & agents** | Talk to models, run multi-agent collaboration, persist conversations, manage memory | [shittim-chest](https://github.com/celestia-island/shittim-chest) (UI and chat), [entelecheia](https://github.com/celestia-island/entelecheia) (agent orchestration), [noa](https://github.com/celestia-island/noa) (AI-native version control) |
| 6 | **Industrial control** | Remote operations and protocol brokering: Modbus, S7comm, OPC UA; telemetry and write gates | [evernight](https://github.com/celestia-island/evernight) (protocol broker), [aoba](https://github.com/celestia-island/aoba) (Modbus and data-source CLI) |
| 7 | **Verify & support** | Integration tests on real hardware, supervision and self-healing, usage records, feedback channels | [celestia-integration](https://github.com/celestia-island/celestia-integration), [malkuth](https://github.com/celestia-island/malkuth), [plana](https://github.com/celestia-island/plana) (usage records) |

## How the loop behaves

- **Every step is testable.** Each segment has a defined acceptance test in
  [celestia-integration](https://github.com/celestia-island/celestia-integration);
  a release is not green until the whole loop passes on real nodes.
- **Every step is observable.** Supervision, health endpoints, and usage
  records make each segment's state visible rather than assumed.
- **No silent degradation.** When a segment degrades (for example memory
  offline or a backend unreachable), the API response and the UI say so
  explicitly. Failures are loud by design.
- **Safety is not a segment.** Write gates, policy validation, and human
  confirmation are woven through segments 5 and 6, not bolted on at the end.
  See [Safety Principles](./safety.md).

## Where to go deeper

- [Why celestia-island](./why.md) — the problem that defines the loop.
- [Layered Architecture](./layered-architecture.md) — how the pieces stay ordered.
- [Projects Map](../ecosystem/projects.md) — the full inventory of repositories.
- [Quickstart](../getting-started/quickstart.md) — walk the loop in 30 minutes.
