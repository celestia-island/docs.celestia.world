# Welcome to celestia-island

**celestia-island** is a suite of projects for industrial AI control: multi-agent
collaboration, remote operations, and safety-critical automation. This site is
its *why* — the philosophy, the ecosystem map, and the entry point. The *how*
lives in per-project documentation sites linked from here.

## Answering three questions

| Question | Where | What you will find |
| --- | --- | --- |
| **Why does this exist?** | [Philosophy](./philosophy/why.md) | The problem we are solving, the closed loop, the safety doctrine, and the long-term horizon |
| **What is inside?** | [Ecosystem](./ecosystem/projects.md) | Every project, its role in the loop, and where its documentation lives |
| **How do I start?** | [Get Started](./getting-started/quickstart.md) | The 30-minute path from account to a working chat agent and industrial control |

## The one-paragraph summary

celestia-island builds the **closed loop** from discovery to verification for
AI-driven industrial control: discover → install → authenticate → deploy a
model → chat and run agents → control industrial equipment → verify everything.
The loop is assembled from small, strictly layered pieces: authentication
primitives ([kirino](https://github.com/celestia-island/kirino)), platform
facilities ([plana](https://github.com/celestia-island/plana)), UI components
([hikari](https://github.com/celestia-island/hikari)), and services that only
implement business logic ([arona](https://github.com/celestia-island/arona),
[shittim-chest](https://github.com/celestia-island/shittim-chest),
[entelecheia](https://github.com/celestia-island/entelecheia),
[evernight](https://github.com/celestia-island/evernight)). Nothing is ever
implemented twice: generic capability is built upstream once, and consumed by
every service downstream.

The reason for all of it is a simple observation: on the Moon a round-trip
takes 2.6 seconds, on Mars 6 to 44 minutes. Robots out there cannot wait for a
human on Earth — they must be locally autonomous. The decision layer, world
model, and safety gates we are building for industrial control today are the
same shape that autonomy will need tomorrow.

## Where everything lives

- **Per-project documentation** — `<name>.docs.celestia.world`, built from each
  repository. Find the full list in [Sites & Ownership](./ecosystem/sites.md).
- **Organization presence** — [celestia-island on GitHub](https://github.com/celestia-island).
- **Product entries (WIP during the beta)** — [arona](https://arona.celestia.world)
  (cloud API admin), [dev](https://dev.celestia.world) (developer portal); the
  live panel runs internally at `arona:8420` until the beta ends.

Use the language switcher (bottom-right) to read this site in another language.
Content is authored in English; translations follow the same structure.
