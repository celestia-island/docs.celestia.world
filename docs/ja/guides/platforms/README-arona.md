<!-- markdownlint-disable MD033 MD041 MD036 -->
<p align="center"><img src="https://raw.githubusercontent.com/celestia-island/arona/master/docs/logo.webp" alt="Arona" width="200" /></p>

<h1 align="center">Arona</h1>

<p align="center"><strong>celestia-island プラットフォーム向けの共有プロトコル型</strong></p>

<div align="center">

[![License](https://img.shields.io/badge/license-BSL--1.1-blue.svg)](https://github.com/celestia-island/arona/blob/main/LICENSE)
[![GitHub](https://img.shields.io/badge/github-celestia--island%2Farona-blue.svg)](https://github.com/celestia-island/arona)

</div>

<div align="center">

**[English](https://github.com/celestia-island/docs.celestia.world/blob/master/docs/en/guides/platforms/README-arona.md)** &bull; **[简体中文](https://github.com/celestia-island/docs.celestia.world/blob/master/docs/zhs/guides/platforms/README-arona.md)** &bull; **[繁體中文](https://github.com/celestia-island/docs.celestia.world/blob/master/docs/zht/guides/platforms/README-arona.md)** &bull; **日本語** &bull; **[한국어](https://github.com/celestia-island/docs.celestia.world/blob/master/docs/ko/guides/platforms/README-arona.md)** &bull; **[Français](https://github.com/celestia-island/docs.celestia.world/blob/master/docs/fr/guides/platforms/README-arona.md)** &bull; **[Español](https://github.com/celestia-island/docs.celestia.world/blob/master/docs/es/guides/platforms/README-arona.md)** &bull; **[Русский](https://github.com/celestia-island/docs.celestia.world/blob/master/docs/ru/guides/platforms/README-arona.md)** &bull; **[Deutsch](https://github.com/celestia-island/docs.celestia.world/blob/master/docs/de/guides/platforms/README-arona.md)** &bull; **[Português](https://github.com/celestia-island/docs.celestia.world/blob/master/docs/pt/guides/platforms/README-arona.md)** &bull; **[العربية](https://github.com/celestia-island/docs.celestia.world/blob/master/docs/ar/guides/platforms/README-arona.md)**

</div>
<!-- markdownlint-enable MD033 MD041 MD036 -->

JSON-RPC 2.0 プロトコル型、TypeScript バインディング、およびドキュメントハブ。entelecheia と shittim-chest で利用されます。

## クイックスタート

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

または [just](https://github.com/casey/just) タスクランナーを使用：

```bash
just build
just test
just fmt-check
```

## Documentation

Architecture, design, and guides live at [docs.celestia.world/en/arona](https://github.com/celestia-island/docs.celestia.world/tree/master/docs/en).

Source: [arona](https://github.com/celestia-island/arona).
