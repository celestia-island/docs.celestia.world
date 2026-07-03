# Arona
<!-- markdownlint-disable MD033 MD041 MD036 -->
<div align="center">

<img src="../../logo.webp" alt="Arona" width="200"/>


**Общие типы протоколов для платформы celestia-island**

[![License](https://img.shields.io/badge/license-BSL--1.1-blue.svg)](https://github.com/celestia-island/arona/blob/main/LICENSE)
[![GitHub](https://img.shields.io/badge/github-celestia--island%2Farona-blue.svg)](https://github.com/celestia-island/arona)

</div>
<!-- markdownlint-enable MD033 MD041 MD036 -->

**[English](https://github.com/celestia-island/docs.celestia.world/blob/master/docs/en/guides/platforms/README-arona.md)** &bull; **[简体中文](https://github.com/celestia-island/docs.celestia.world/blob/master/docs/zhs/guides/platforms/README-arona.md)** &bull; **[繁體中文](https://github.com/celestia-island/docs.celestia.world/blob/master/docs/zht/guides/platforms/README-arona.md)** &bull; **[日本語](https://github.com/celestia-island/docs.celestia.world/blob/master/docs/ja/guides/platforms/README-arona.md)** &bull; **[한국어](https://github.com/celestia-island/docs.celestia.world/blob/master/docs/ko/guides/platforms/README-arona.md)** &bull; **[Français](https://github.com/celestia-island/docs.celestia.world/blob/master/docs/fr/guides/platforms/README-arona.md)** &bull; **[Español](https://github.com/celestia-island/docs.celestia.world/blob/master/docs/es/guides/platforms/README-arona.md)** &bull; **Русский** &bull; **[Deutsch](https://github.com/celestia-island/docs.celestia.world/blob/master/docs/de/guides/platforms/README-arona.md)** &bull; **[Português](https://github.com/celestia-island/docs.celestia.world/blob/master/docs/pt/guides/platforms/README-arona.md)** &bull; **[العربية](https://github.com/celestia-island/docs.celestia.world/blob/master/docs/ar/guides/platforms/README-arona.md)**

> Part of the [celestia-island](https://github.com/celestia-island) ecosystem.

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

Source: [arona](https://github.com/celestia-island/arona).
