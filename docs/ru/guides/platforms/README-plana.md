<!-- markdownlint-disable MD033 MD041 MD036 -->
<p align="center"><img src="https://raw.githubusercontent.com/celestia-island/plana/master/docs/logo.webp" alt="Arona" width="200" /></p>

<h1 align="center">Arona</h1>

<p align="center"><strong>Общие типы протоколов для платформы celestia-island</strong></p>

<div align="center">

[![License](https://img.shields.io/badge/license-BSL--1.1-blue.svg)](https://github.com/celestia-island/plana/blob/main/LICENSE)
[![GitHub](https://img.shields.io/badge/github-celestia--island%2Farona-blue.svg)](https://github.com/celestia-island/plana)

</div>

<div align="center">

**[English](https://github.com/celestia-island/docs.celestia.world/blob/master/docs/en/guides/platforms/README-plana.md)** &bull; **[简体中文](https://github.com/celestia-island/docs.celestia.world/blob/master/docs/zhs/guides/platforms/README-plana.md)** &bull; **[繁體中文](https://github.com/celestia-island/docs.celestia.world/blob/master/docs/zht/guides/platforms/README-plana.md)** &bull; **[日本語](https://github.com/celestia-island/docs.celestia.world/blob/master/docs/ja/guides/platforms/README-plana.md)** &bull; **[한국어](https://github.com/celestia-island/docs.celestia.world/blob/master/docs/ko/guides/platforms/README-plana.md)** &bull; **[Français](https://github.com/celestia-island/docs.celestia.world/blob/master/docs/fr/guides/platforms/README-plana.md)** &bull; **[Español](https://github.com/celestia-island/docs.celestia.world/blob/master/docs/es/guides/platforms/README-plana.md)** &bull; **Русский** &bull; **[Deutsch](https://github.com/celestia-island/docs.celestia.world/blob/master/docs/de/guides/platforms/README-plana.md)** &bull; **[Português](https://github.com/celestia-island/docs.celestia.world/blob/master/docs/pt/guides/platforms/README-plana.md)** &bull; **[العربية](https://github.com/celestia-island/docs.celestia.world/blob/master/docs/ar/guides/platforms/README-plana.md)**

</div>
<!-- markdownlint-enable MD033 MD041 MD036 -->

Типы протоколов JSON-RPC 2.0, привязки TypeScript и центр документации. Используются проектами entelecheia и shittim-chest.

## Быстрый старт

```bash
# Build
cargo build

# Run all tests (includes TS binding generation)
cargo test --all-features

# Check lint + formatting
cargo clippy --all-targets --all-features -- -D warnings
cargo fmt --all -- --check

# Generate TypeScript bindings only
cargo test --package arona
```

Или используйте [just](https://github.com/casey/just) для запуска задач:

```bash
just build
just test
just fmt-check
```

## Documentation

Architecture, design, and guides live at [docs.celestia.world/en/arona](https://github.com/celestia-island/docs.celestia.world/tree/master/docs/en).

Source: [arona](https://github.com/celestia-island/plana).
