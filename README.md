<!-- markdownlint-disable MD033 MD041 MD036 -->
<div align="center">

<img src="res/logo/entelecheia.webp" alt="docs.celestia.world logo" width="200"/>

# docs.celestia.world

**Centralized documentation & blog hub for the celestia-island ecosystem**

[![License](https://img.shields.io/badge/license-BSL--1.1-blue.svg)](LICENSE)
[![GitHub](https://img.shields.io/badge/github-celestia--island%2Fdocs.celestia.world-blue.svg)](https://github.com/celestia-island/docs.celestia.world)

</div>
<!-- markdownlint-enable MD033 MD041 MD036 -->

> **Status:** early — content migration in progress. Site framework to be
> chosen (Docusaurus / VitePress / MkDocs); content is plain Markdown for now.

`docs.celestia.world` is the single home for all documentation of the
celestia-island projects. It supersedes the per-repo `docs/` directories and
the former `arona` docs hub, and will be published as a multilingual
documentation + blog site at
[docs.celestia.world](https://docs.celestia.world).

## Projects covered

| Folder name | Project |
| --- | --- |
| `core` | [entelecheia](https://github.com/celestia-island/entelecheia) — multi-agent collaboration platform |
| `webui` | [shittim-chest](https://github.com/celestia-island/shittim-chest) — user-facing shell |
| `router` | [evernight](https://github.com/celestia-island/evernight) — remote control & protocol broker |
| `arona` | [arona](https://github.com/celestia-island/arona) — shared protocol types |
| `plana` | [plana](https://github.com/celestia-island/plana) — service supervision toolkit |
| `platform` | cross-project (applies to all of the above) |

## Structure

Documentation is organized language-first, mirroring the former `arona/docs`
layout:

```text
docs/<lang>/<category>/<project>/
```

- **`<lang>`** — `en` (canonical), `zhs`, `zht`, `ja`, `ko`, `fr`, `es`, `ru`
- **`<category>`** — `architecture`, `design`, `guides`, `meta` (and `blog`
  for the blog section, once the framework is in place)
- **`<project>`** — one of the table above

## Source repos

Each project keeps only a minimal root `README.md`, `CLA.md`, and `LICENSE`
(non-markdown). Everything documentary lives here. See the project table for
links.

## License

Business Source License 1.1 (BSL-1.1); converts to Apache-2.0 / MIT on
2030-01-01. See [LICENSE](LICENSE).
