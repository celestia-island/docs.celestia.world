<!-- markdownlint-disable MD033 MD041 MD036 -->
<p align="center"><img src="https://raw.githubusercontent.com/celestia-island/docs.celestia.world/master/docs/logo.webp" alt="docs.celestia.world" width="200" /></p>

<h1 align="center">docs.celestia.world</h1>

<p align="center"><strong>Centralized documentation hub</strong></p>

<div align="center">

[![License](https://img.shields.io/badge/license-CC0%201.0-blue.svg)](LICENSE)
[![GitHub](https://img.shields.io/badge/github-celestia--island%2Fdocs.celestia.world-blue.svg)](https://github.com/celestia-island/docs.celestia.world)

</div>
<!-- markdownlint-enable MD033 MD041 MD036 -->

`docs.celestia.world` is the single home for all documentation of the
celestia-island projects. It supersedes the per-repo `docs/` directories and
the former `arona` docs hub, and is published as a multilingual documentation
site at [docs.celestia.world](https://docs.celestia.world).

Built with [mdBook](https://rust-lang.github.io/mdBook/) and a custom
language switcher supporting 11 languages.

## Projects covered

| Group | Repositories |
| --- | --- |
| `core` | [entelecheia](https://github.com/celestia-island/entelecheia) — multi-agent collaboration platform |
| `webui` | [shittim-chest](https://github.com/celestia-island/shittim-chest) — user-facing shell |
| `platforms` | [arona](https://github.com/celestia-island/plana) (protocol types) · [evernight](https://github.com/celestia-island/evernight) (remote control & protocols) |
| `tool` | [yuuka](https://github.com/celestia-island/yuuka) · [kirino](https://github.com/celestia-island/kirino) · [noa](https://github.com/celestia-island/noa) · [malkuth](https://github.com/celestia-island/malkuth) · [seia](https://github.com/celestia-island/seia) · [lagrange](https://github.com/celestia-island/lagrange) · [ichika](https://github.com/celestia-island/ichika) · [aoba](https://github.com/celestia-island/aoba) — standalone Rust libraries; each has its own docs at `<name>.docs.celestia.world` |

## Structure

```text
docs/
├── logo.webp                    # Hub logo
├── theme/                       # Shared lang-switcher JS/CSS
│   ├── lang-switcher.js
│   └── lang-switcher.css
└── <lang>/                      # Per-language mdBook
    ├── book.toml                # mdBook configuration
    ├── SUMMARY.md               # Table of contents
    ├── intro.md                 # Welcome page
    ├── meta/                    # License, CLA, CoC, Security
    ├── guides/{core,webui,platforms}/   # Practical guides
    └── designs/{core,webui,platforms}/  # Architecture & design docs
```

### Languages

`en` (canonical) · `zhs` · `zht` · `ja` · `ko` · `fr` · `es` · `ru` · `de` · `pt` · `ar`

> `de`, `pt`, and `ar` are partial translations (meta/legal documents only).

## Building

```bash
# Install mdBook
cargo install mdbook

# Build all languages
just build

# Build a single language
just build-lang en

# Serve locally (with live reload)
just serve en
```

## License

CC0 1.0 Universal (public domain dedication). See [LICENSE](LICENSE).
