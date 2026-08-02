<!-- markdownlint-disable MD033 MD041 MD036 -->
<p align="center"><img src="https://raw.githubusercontent.com/celestia-island/docs.celestia.world/master/docs/logo.webp" alt="docs.celestia.world" width="200" /></p>

<h1 align="center">docs.celestia.world</h1>

<p align="center"><strong>The philosophy and entry point of the celestia-island ecosystem</strong></p>

<div align="center">

[![License](https://img.shields.io/badge/license-CC0%201.0-blue.svg)](LICENSE)
[![GitHub](https://img.shields.io/badge/github-celestia--island%2Fdocs.celestia.world-blue.svg)](https://github.com/celestia-island/docs.celestia.world)

</div>
<!-- markdownlint-enable MD033 MD041 MD036 -->

`docs.celestia.world` is the *why* layer of the celestia-island ecosystem: it
explains the project philosophy (the closed loop, layered architecture, safety
principles, long-term narrative), maps all projects to their repositories and
per-project documentation sites, and guides new users from zero to a working
system. Every *how* document lives in the per-project sites at
`<name>.docs.celestia.world`; this hub links to them and never duplicates them.

Built with [lagrange](https://github.com/celestia-island/lagrange) and a
custom language switcher supporting 11 languages.

## Layout

```text
docs/
├── logo.webp                 # Hub logo
├── lagrange.toml             # Site config and language order
├── theme/                    # Shared lang-switcher JS/CSS
│   ├── lang-switcher.js
│   └── lang-switcher.css
└── <lang>/                   # Per-language content (BCP-47 codes)
    ├── SUMMARY.md            # Table of contents
    ├── intro.md              # Welcome page
    ├── philosophy/           # Why: closed loop, architecture, safety, narrative
    ├── ecosystem/            # Project map and site ownership
    ├── getting-started/      # Quickstart and beta guide
    └── meta/                 # License, CLA, CoC, Security, Contributing
```

### Languages

`en` (canonical) · `zh-Hans` · `zh-Hant` · `ja` · `ko` · `fr` · `es` · `ru` · `de` · `pt` · `ar`

Content is authored in `en` and translated to the other languages. `en` is the
single source of truth; if translations lag, they say so explicitly.

## Building

```bash
just build   # Build all languages with lagrange
just serve   # Serve locally (with live reload)
just lint    # markdownlint over docs/**
```

## License

CC0 1.0 Universal (public domain dedication). See [LICENSE](LICENSE).
