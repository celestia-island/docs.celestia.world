<!-- markdownlint-disable MD033 MD041 MD036 -->
<p align="center"><img src="https://raw.githubusercontent.com/celestia-island/plana/master/docs/logo.webp" alt="Arona" width="200" /></p>

<h1 align="center">Arona</h1>

<p align="center"><strong>celestia-island 平台的共享协议类型</strong></p>

<div align="center">

[![License](https://img.shields.io/badge/license-BSL--1.1-blue.svg)](https://github.com/celestia-island/plana/blob/main/LICENSE)
[![GitHub](https://img.shields.io/badge/github-celestia--island%2Farona-blue.svg)](https://github.com/celestia-island/plana)

</div>

<div align="center">

**[English](https://github.com/celestia-island/docs.celestia.world/blob/master/docs/en/guides/platforms/README-plana.md)** &bull; **简体中文** &bull; **[繁體中文](https://github.com/celestia-island/docs.celestia.world/blob/master/docs/zht/guides/platforms/README-plana.md)** &bull; **[日本語](https://github.com/celestia-island/docs.celestia.world/blob/master/docs/ja/guides/platforms/README-plana.md)** &bull; **[한국어](https://github.com/celestia-island/docs.celestia.world/blob/master/docs/ko/guides/platforms/README-plana.md)** &bull; **[Français](https://github.com/celestia-island/docs.celestia.world/blob/master/docs/fr/guides/platforms/README-plana.md)** &bull; **[Español](https://github.com/celestia-island/docs.celestia.world/blob/master/docs/es/guides/platforms/README-plana.md)** &bull; **[Русский](https://github.com/celestia-island/docs.celestia.world/blob/master/docs/ru/guides/platforms/README-plana.md)** &bull; **[Deutsch](https://github.com/celestia-island/docs.celestia.world/blob/master/docs/de/guides/platforms/README-plana.md)** &bull; **[Português](https://github.com/celestia-island/docs.celestia.world/blob/master/docs/pt/guides/platforms/README-plana.md)** &bull; **[العربية](https://github.com/celestia-island/docs.celestia.world/blob/master/docs/ar/guides/platforms/README-plana.md)**

</div>
<!-- markdownlint-enable MD033 MD041 MD036 -->

JSON-RPC 2.0 协议类型、TypeScript 绑定以及文档中心。由 entelecheia 和 shittim-chest 使用。

## 快速开始

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

或使用 [just](https://github.com/casey/just) 任务运行器：

```bash
just build
just test
just fmt-check
```

## Documentation

架构、设计与指南位于 [docs.celestia.world/en/arona](https://github.com/celestia-island/docs.celestia.world/tree/master/docs/en)。

源码：[arona](https://github.com/celestia-island/plana)。
