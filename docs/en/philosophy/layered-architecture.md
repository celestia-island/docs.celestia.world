# Layered Architecture

The ecosystem stays manageable because it is strictly layered. Dependencies
only point one way: **downstream services consume upstream capability; generic
capability never gets reimplemented.**

## The four layers

| Layer | Projects | What they provide |
| --- | --- | --- |
| **Layer 0 — Auth** | [kirino](https://github.com/celestia-island/kirino) | Zero-trust identity: authentication, sessions, permissions |
| **Layer 1 — Platform** | [plana](https://github.com/celestia-island/plana) | Shared protocol types, transport, and the facilities every service needs |
| **Layer 2 — UI** | [hikari](https://github.com/celestia-island/hikari) | The component library shared by every webUI |
| **Layer 3 — Services** | arona, shittim-chest, entelecheia, evernight, [malkuth](https://github.com/celestia-island/malkuth), [lagrange](https://github.com/celestia-island/lagrange) | Business logic only. They consume Layers 0–2 and add the behavior that makes each product real |

## The doctrine

1. **Never implement twice.** Before writing code, ask: does kirino have it?
   does plana have it? does hikari have it? A service that reimplements an
   upstream capability is a defect, not a feature.
2. **Generic capability goes upstream.** A feature that two or more services
   will reuse is built into kirino, plana, or hikari first, then consumed.
3. **No reverse dependencies.** Services depend on kirino/plana/hikari; plana
   may depend on kirino; kirino never depends on plana or hikari.
4. **Extend upstream before consuming.** If upstream lacks a needed capability,
   extend upstream, then consume. New capability is never prototyped in a
   service and reimplemented later.
5. **Cross-repo dependencies are git references.** All repositories consume
   upstream via git references to the `master` branch (or pinned versions),
   never local path dependencies. Every repository builds identically on every
   machine.

## Why it matters

- **One fix propagates.** A security fix in kirino reaches every service with a
  dependency bump, not a hunt through reimplementations.
- **Review is proportional to risk.** Layer 3 changes are product logic;
  Layer 0 changes are infrastructure — the review bar reflects that.
- **The map stays readable.** New engineers read this page and know where any
  capability lives. The [Projects Map](../ecosystem/projects.md) is the full
  inventory.

## Where to go deeper

- [Why celestia-island](./why.md) — the problem behind the layering.
- [Safety Principles](./safety.md) — the doctrine that sits on top of the layers.
- [Projects Map](../ecosystem/projects.md) — every repository, by layer.
