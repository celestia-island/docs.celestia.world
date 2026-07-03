# Arona
<!-- markdownlint-disable MD033 MD041 MD036 -->
<div align="center">

<img src="../../logo.webp" alt="Arona" width="200"/>


**Tipos de protocolo compartilhados para a plataforma celestia-island**

[![License](https://img.shields.io/badge/license-BSL--1.1-blue.svg)](https://github.com/celestia-island/arona/blob/main/LICENSE)
[![GitHub](https://img.shields.io/badge/github-celestia--island%2Farona-blue.svg)](https://github.com/celestia-island/arona)

</div>
<!-- markdownlint-enable MD033 MD041 MD036 -->

**[English](https://github.com/celestia-island/docs.celestia.world/blob/master/docs/en/guides/platforms/README-arona.md)** &bull; **[简体中文](https://github.com/celestia-island/docs.celestia.world/blob/master/docs/zhs/guides/platforms/README-arona.md)** &bull; **[繁體中文](https://github.com/celestia-island/docs.celestia.world/blob/master/docs/zht/guides/platforms/README-arona.md)** &bull; **[日本語](https://github.com/celestia-island/docs.celestia.world/blob/master/docs/ja/guides/platforms/README-arona.md)** &bull; **[한국어](https://github.com/celestia-island/docs.celestia.world/blob/master/docs/ko/guides/platforms/README-arona.md)** &bull; **[Français](https://github.com/celestia-island/docs.celestia.world/blob/master/docs/fr/guides/platforms/README-arona.md)** &bull; **[Español](https://github.com/celestia-island/docs.celestia.world/blob/master/docs/es/guides/platforms/README-arona.md)** &bull; **[Русский](https://github.com/celestia-island/docs.celestia.world/blob/master/docs/ru/guides/platforms/README-arona.md)** &bull; **[Deutsch](https://github.com/celestia-island/docs.celestia.world/blob/master/docs/de/guides/platforms/README-arona.md)** &bull; **Português** &bull; **[العربية](https://github.com/celestia-island/docs.celestia.world/blob/master/docs/ar/guides/platforms/README-arona.md)**

> Parte do ecossistema [celestia-island](https://github.com/celestia-island).

Tipos de protocolo JSON-RPC 2.0, bindings TypeScript e o hub de documentação. Consumido por entelecheia e shittim-chest.

## Início Rápido

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

Ou use o executor de tarefas [just](https://github.com/casey/just):

```bash
just build
just test
just fmt-check
```

## Documentação

Arquitetura, design e guias em [docs.celestia.world/pt/arona](https://github.com/celestia-island/docs.celestia.world/tree/master/docs/en).

Fonte: [arona](https://github.com/celestia-island/arona).
