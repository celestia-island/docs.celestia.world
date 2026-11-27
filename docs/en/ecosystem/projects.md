# Projects Map

The inventory of the celestia-island platform repositories and products, grouped
by layer. A name with a link is a public repository you can read today; a name
without one is a product that ships with the platform but whose source is not
public yet. Repositories marked with a documentation site carry their own *how*
docs; the rest are documented in their repository, which needs access to the
repository itself.

## Layer 0 — Auth

| Project | Role | Docs |
| --- | --- | --- |
| [kirino](https://github.com/celestia-island/kirino) | Zero-trust authentication and authorization: sessions, permissions, rate limiting | [kirino.docs.celestia.world](https://kirino.docs.celestia.world) |

## Layer 1 — Platform

| Project | Role | Docs |
| --- | --- | --- |
| [plana](https://github.com/celestia-island/plana) | Shared protocol types, transport, metering and the facilities every service consumes | repository |
| [provider-registry](https://github.com/celestia-island/provider-registry) | Model and provider catalogue shared across products | repository |

## Layer 2 — UI

| Project | Role | Docs |
| --- | --- | --- |
| [hikari](https://github.com/celestia-island/hikari) | The UI component library shared by every webUI | repository |

## Layer 3 — Services

| Project | Role | Docs |
| --- | --- | --- |
| arona | Model gateway and deployment panel: keys, backends, routing, usage | [Arona](../platforms/arona.md) |
| shittim-chest | Chat, panels and integrations — the workbench surface | [Shittim Chest](../platforms/chest.md) |
| entelecheia | Agent platform: agents, long-term memory, semantic search, industrial integration | [Entelecheia](../platforms/entelecheia.md) |
| evernight | Industrial protocol broker: field protocols, alarms, recording, edge inference | [Evernight](../platforms/evernight.md) |
| [malkuth](https://github.com/celestia-island/malkuth) | Service supervision: rolling updates, health probes, reverse proxy, crash recovery | [malkuth.docs.celestia.world](https://malkuth.docs.celestia.world) |
| [lagrange](https://github.com/celestia-island/lagrange) | The documentation engine behind this site and every project docs site | [lagrange.docs.celestia.world](https://lagrange.docs.celestia.world) |
| celestia-erp | Business back office: organizations, billing, invoices | — |
| electrode_recon | Electrode microstructure compute engine — the first external instance on the engine fabric | — |

## Tools & libraries

| Project | Role | Docs |
| --- | --- | --- |
| [noa](https://github.com/celestia-island/noa) | Agent-native distributed version control with isolated workspaces | [repository](https://github.com/celestia-island/noa) |
| [seia](https://github.com/celestia-island/seia) | Multi-engine web search | [seia.docs.celestia.world](https://seia.docs.celestia.world) |
| [aoba](https://github.com/celestia-island/aoba) | Multi-protocol debugging and simulation CLI (Modbus RTU and friends) | [aoba.docs.celestia.world](https://aoba.docs.celestia.world) |
| [ichika](https://github.com/celestia-island/ichika) | Thread-pool pipelines over message pipes | repository |
| [yuuka](https://github.com/celestia-island/yuuka) | Macros for composed nested structures and JSON merge/patch | repository |
| [kou](https://github.com/celestia-island/kou) | Virtual terminal engine: PTY, VT100/ANSI, inline graphics | repository |
| [hifumi](https://github.com/celestia-island/hifumi) | Serialization for migrating data between versions | repository |
| [lacrymira](https://github.com/celestia-island/lacrymira) | Typed data access for SQL and KV behind one command surface | repository |
| [himari](https://github.com/celestia-island/himari) | Dimensioned formula intermediate representation | repository |
| [kotama](https://github.com/celestia-island/kotama) | Reverse-engineering toolkit: dissection, decompilation, cross-references | repository |
| [ayane](https://github.com/celestia-island/ayane) | Mail service: control plane, webmail and protection | repository |
| [aris](https://github.com/celestia-island/aris) | A pure-Rust browser engine derived from servo, embeddable as a library | repository |
| [shirabe](https://github.com/celestia-island/shirabe) | Headless browser automation and debugging | repository |
| [tairitsu](https://github.com/celestia-island/tairitsu) | Full-stack framework on the WASM Component Model | repository |
| [akivili](https://github.com/celestia-island/akivili) | Plugin host and SDK for agent extensions | repository |
| [celestia-plugin](https://github.com/celestia-island/celestia-plugin) | Python plugin and engine SDK | repository |
| [shun](https://github.com/celestia-island/shun) | Installers, flashers and portable-mode payload delivery | repository |
| [ratatui-markdown](https://github.com/celestia-island/ratatui-markdown) | Markdown rendering inside terminal UIs | repository |
| arcaea | Persona protocol library | — |
| scriptum | Terminal interface for the agent platform | — |
| official-plugins | The first-party plugin packages | — |

## Edge & hardware

| Project | Role | Docs |
| --- | --- | --- |
| [kei](https://github.com/celestia-island/kei) | Rust kernel for ARM64 and RISC-V edge gateways | repository |
| [hare](https://github.com/celestia-island/hare) | `no_std` bridge library for embedded industrial nodes | repository |
| evernight-appliance | The appliance distribution: boot firmware, flasher, driver contract | — |

## Infrastructure & tooling

| Project | Role | Docs |
| --- | --- | --- |
| [celestia-devtools](https://github.com/celestia-island/celestia-devtools) | Shared development toolchain: build recipes, linting, release gates | repository |
| [cherino](https://github.com/celestia-island/cherino) | Sandboxed container abstraction for agent execution | repository |
| [celestia-artifacts](https://github.com/celestia-island/celestia-artifacts) | Public binary and image artifact hosting for releases | repository |
| celestia-integration | Cross-repo integration tests for the whole loop | — |
| fuuka | Self-hosted CI execution plane | — |
| [sysl](https://github.com/celestia-island/sysl) | The Synthetic Source License most of this code uses | repository |

## Web presence

| Property | Role | Docs |
| --- | --- | --- |
| [celestia-island.github.io](https://celestia-island.github.io) | Organization presence | repository |
| [docs.celestia.world](https://docs.celestia.world) | This site — philosophy, map, getting started | repository |
| [e.celestia.world](https://e.celestia.world) | Public landing page | repository |
| [dev.celestia.world](https://dev.celestia.world) | Panel and developer dashboard (invite-gated during the beta) | repository |
| [celestia.ac.cn](https://celestia.ac.cn) | Company and enterprise services site | repository |

## Where to go deeper

- [Layered Architecture](../philosophy/layered-architecture.md) — why these layers exist.
- [The Closed Loop](../philosophy/closed-loop.md) — how projects cooperate along the loop.
- [Sites & Ownership](./sites.md) — who documents what, and where.
