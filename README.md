<!-- markdownlint-disable MD033 MD041 MD036 -->
<div align="center">

<img src="res/logo/entelecheia.webp" alt="docs.celestia.world logo" width="200"/>

# docs.celestia.world

**Centralized documentation & blog hub for the celestia-island ecosystem**

[![License](https://img.shields.io/badge/license-CC0%201.0-blue.svg)](LICENSE)
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

Grouped by function:

| Group | Repositories |
| --- | --- |
| `core` | [entelecheia](https://github.com/celestia-island/entelecheia) — multi-agent collaboration platform |
| `webui` | [shittim-chest](https://github.com/celestia-island/shittim-chest) — user-facing shell |
| `platforms` | [arona](https://github.com/celestia-island/arona) (protocol types) · [evernight](https://github.com/celestia-island/evernight) (remote control & protocols) · [noa](https://github.com/celestia-island/noa) (DVCS) |

## Structure

Organized language-first:

```text
docs/<lang>/{meta,designs,guides}/{core,webui,platforms}/
```

- **`<lang>`** — `en` (canonical), `zhs`, `zht`, `ja`, `ko`, `fr`, `es`, `ru` (+ `ar` / `de` / `pt` for legal translations)
- **`meta`** — shared across projects: license, CLA, code-of-conduct, security, contributing
- **`designs`** — design & architecture docs, grouped by `core` / `webui` / `platforms`
- **`guides`** — guides plus each repo's README at `guides/<group>/README-<repo>.md`

## Source repos

Each project keeps only a minimal root `README.md`, `CLA.md`, and `LICENSE`
(non-markdown). Everything documentary lives here. See the project table for
links.

## License

CC0 1.0 Universal (public domain dedication). The documentation here is
released into the public domain — you may copy, modify, distribute and
perform the work, even for commercial purposes, without asking permission.
See [LICENSE](LICENSE) and
[CC0 1.0](https://creativecommons.org/publicdomain/zero/1.0/).
