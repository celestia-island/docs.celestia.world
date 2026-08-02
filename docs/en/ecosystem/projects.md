# Projects Map

The complete inventory of celestia-island repositories, grouped by layer.
Repositories marked with a documentation site carry their own *how* docs at
`<name>.docs.celestia.world`; everything else is documented in its repository.

## Layer 0 — Auth

| Project | Role | Docs |
| --- | --- | --- |
| [kirino](https://github.com/celestia-island/kirino) | Zero-trust authentication and RBAC: JWT sessions, Argon2id hashing, login rate limiting, permission engine | [kirino.docs.celestia.world](https://kirino.docs.celestia.world) |

## Layer 1 — Platform

| Project | Role | Docs |
| --- | --- | --- |
| [plana](https://github.com/celestia-island/plana) | Shared types, JSON-RPC client and server, SSE sessions, circuit breakers, LLM metering and pricing, admin UI shell | repository |
| [provider-registry](https://github.com/celestia-island/provider-registry) | Model and provider registry (entrypoint TOML format) | repository |

## Layer 2 — UI

| Project | Role | Docs |
| --- | --- | --- |
| [hikari](https://github.com/celestia-island/hikari) | UI component library (Vue/TS + Rust) shared by all webUIs | repository |

## Layer 3 — Services

| Project | Role | Docs |
| --- | --- | --- |
| [arona](https://github.com/celestia-island/arona) | Cloud API admin panel: accounts, API keys, model deployment, backends, usage records | repository |
| [shittim-chest](https://github.com/celestia-island/shittim-chest) | Chat desktop/webUI and shell | [shittim-chest.docs.celestia.world](https://shittim-chest.docs.celestia.world) |
| [entelecheia](https://github.com/celestia-island/entelecheia) | Multi-agent collaboration platform: exec-only microkernel, scepter orchestration server, IEPL execution pipeline | [entelecheia.docs.celestia.world](https://entelecheia.docs.celestia.world) |
| [evernight](https://github.com/celestia-island/evernight) | Industrial protocol broker: Modbus, S7comm, OPC UA; remote operations, telemetry, write gates | [evernight.docs.celestia.world](https://evernight.docs.celestia.world) |
| [malkuth](https://github.com/celestia-island/malkuth) | Service supervision toolkit: rolling updates, health probes, reverse proxy, crash-loop recovery | [malkuth.docs.celestia.world](https://malkuth.docs.celestia.world) |
| [lagrange](https://github.com/celestia-island/lagrange) | Markdown documentation engine powering this site and every project docs site | [lagrange.docs.celestia.world](https://lagrange.docs.celestia.world) |

## Tools & libraries

| Project | Role | Docs |
| --- | --- | --- |
| [noa](https://github.com/celestia-island/noa) | AI-native distributed version control: per-agent workspace isolation, JSONL append-only logs, snapshot history | [noa.docs.celestia.world](https://noa.docs.celestia.world) |
| [seia](https://github.com/celestia-island/seia) | Multi-engine web search library and CLI | [seia.docs.celestia.world](https://seia.docs.celestia.world) |
| [ichika](https://github.com/celestia-island/ichika) | Thread-pool pipeline macros (flume-based message pipes) | [ichika.docs.celestia.world](https://ichika.docs.celestia.world) |
| [yuuka](https://github.com/celestia-island/yuuka) | Proc-macro for generating complex nested structures from a simple macro | [yuuka.docs.celestia.world](https://yuuka.docs.celestia.world) |
| [aoba](https://github.com/celestia-island/aoba) | Modbus and data-source CLI | [aoba.docs.celestia.world](https://aoba.docs.celestia.world) |
| [kou](https://github.com/celestia-island/kou) | Standalone virtual-terminal engine: PTY management, VT100/ANSI | repository |
| [hifumi](https://github.com/celestia-island/hifumi) | Serialization library for migrating data between versions | repository |
| [aris](https://github.com/celestia-island/aris) | Browser engine derived from servo, embeddable as a library (WebGL for digital twins) | repository |
| [shirabe](https://github.com/celestia-island/shirabe) | Lightweight Rust-native browser automation and debug library | repository |
| [tairitsu](https://github.com/celestia-island/tairitsu) | Full-stack framework powered by the WASM Component Model | repository |
| [ratatui-markdown](https://github.com/celestia-island/ratatui-markdown) | Markdown rendering for ratatui TUIs | repository |
| [arcaea](https://github.com/celestia-island/arcaea) | Rust library for the celestia persona protocol | repository |
| [scriptum](https://github.com/celestia-island/scriptum) | Terminal interface (TUI) for entelecheia: a "dumb display" talking to the scepter server | repository |

## Edge & hardware

| Project | Role | Docs |
| --- | --- | --- |
| [kei](https://github.com/celestia-island/kei) | Rust OS kernel for ARM64/RISC-V edge devices; deterministic real-time core for the long horizon | repository |

## Infrastructure & tooling

| Project | Role | Docs |
| --- | --- | --- |
| [celestia-devtools](https://github.com/celestia-island/celestia-devtools) | Shared development toolchain: justfile recipes, patch registration, linting | repository |
| [celestia-integration](https://github.com/celestia-island/celestia-integration) | Real-hardware integration test suites for the full loop | repository |
| [sysl](https://github.com/celestia-island/sysl) | Synthetic Source License (SySL): a license designed for AI-generated code | repository |

## Web presence

| Property | Role | Docs |
| --- | --- | --- |
| [celestia-island.github.io](https://celestia-island.github.io) | Organization presence | repository |
| [docs.celestia.world](https://docs.celestia.world) | This site — philosophy, map, getting started | repository |
| [e.celestia.world](https://e.celestia.world) | Public landing page | repository |
| [dev.celestia.world](https://dev.celestia.world) | Developer portal | repository |
| [arona.celestia.world](https://arona.celestia.world) | Cloud API admin panel (product) | — |

## Where to go deeper

- [Layered Architecture](../philosophy/layered-architecture.md) — why these layers exist.
- [The Closed Loop](../philosophy/closed-loop.md) — how projects cooperate along the loop.
- [Sites & Ownership](./sites.md) — who documents what, and where.
