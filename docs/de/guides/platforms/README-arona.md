# Arona
<!-- markdownlint-disable MD033 MD041 MD036 -->
<div align="center">

<img src="../../logo.webp" alt="Arona" width="200"/>


**Gemeinsame Protokolltypen für die celestia-island-Plattform**

[![License](https://img.shields.io/badge/license-BSL--1.1-blue.svg)](https://github.com/celestia-island/arona/blob/main/LICENSE)
[![GitHub](https://img.shields.io/badge/github-celestia--island%2Farona-blue.svg)](https://github.com/celestia-island/arona)

</div>
<!-- markdownlint-enable MD033 MD041 MD036 -->

**[English](https://github.com/celestia-island/docs.celestia.world/blob/master/docs/en/guides/platforms/README-arona.md)** &bull; **[简体中文](https://github.com/celestia-island/docs.celestia.world/blob/master/docs/zhs/guides/platforms/README-arona.md)** &bull; **[繁體中文](https://github.com/celestia-island/docs.celestia.world/blob/master/docs/zht/guides/platforms/README-arona.md)** &bull; **[日本語](https://github.com/celestia-island/docs.celestia.world/blob/master/docs/ja/guides/platforms/README-arona.md)** &bull; **[한국어](https://github.com/celestia-island/docs.celestia.world/blob/master/docs/ko/guides/platforms/README-arona.md)** &bull; **[Français](https://github.com/celestia-island/docs.celestia.world/blob/master/docs/fr/guides/platforms/README-arona.md)** &bull; **[Español](https://github.com/celestia-island/docs.celestia.world/blob/master/docs/es/guides/platforms/README-arona.md)** &bull; **[Русский](https://github.com/celestia-island/docs.celestia.world/blob/master/docs/ru/guides/platforms/README-arona.md)** &bull; **Deutsch** &bull; **[Português](https://github.com/celestia-island/docs.celestia.world/blob/master/docs/pt/guides/platforms/README-arona.md)** &bull; **[العربية](https://github.com/celestia-island/docs.celestia.world/blob/master/docs/ar/guides/platforms/README-arona.md)**

> Teil des [celestia-island](https://github.com/celestia-island) Ökosystems.

JSON-RPC 2.0-Protokolltypen, TypeScript-Bindings und der Dokumentations-Hub. Verwendet von Entelecheia und Shittim Chest.

## Schnellstart

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

Oder verwenden Sie den [just](https://github.com/casey/just) Task-Runner:

```bash
just build
just test
just fmt-check
```

## Dokumentation

Architektur, Design und Anleitungen unter [docs.celestia.world/de/arona](https://github.com/celestia-island/docs.celestia.world/tree/master/docs/en).

Quelle: [arona](https://github.com/celestia-island/arona).
