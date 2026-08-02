# Sites & Ownership

Documentation in this ecosystem follows one rule: **the hub explains why and
where; every project site explains how.** This keeps the hub small and the
project sites authoritative.

## Who owns what

| Site | Owns | Content |
| --- | --- | --- |
| [docs.celestia.world](https://docs.celestia.world) | the ecosystem | Philosophy, ecosystem map, getting started, governance (license, CLA, CoC, security, contributing) |
| `<name>.docs.celestia.world` | each project | Guides, architecture, designs, references — built from the project's own repository |
| [celestia-island.github.io](https://celestia-island.github.io) | the organization | Presence, links, brand assets |
| [e.celestia.world](https://e.celestia.world) | the public face | Landing page, pricing, blog, call-to-action |
| [dev.celestia.world](https://dev.celestia.world) | developers | Developer portal and status |

## The one rule: no duplication

- The hub **never copies** project documentation. If a topic belongs to a
  project (how a protocol works, how to configure a service), the hub links to
  the project site instead of summarizing it.
- Project sites **may link back** to the hub for philosophy and cross-project
  context.
- When a project is substantial enough to maintain its own documentation, the
  hub reduces its coverage to a map entry plus links.

## How sites are built

Every docs site (this one included) is built with
[lagrange](https://github.com/celestia-island/lagrange) from Markdown in the
project's repository, with a shared language switcher. Content is authored in
English; translations follow the same structure and are marked when partial.

## Where to go deeper

- [Projects Map](./projects.md) — which sites exist and for which projects.
- [Contributing](../meta/CONTRIBUTING.md) — how to contribute to documentation.
