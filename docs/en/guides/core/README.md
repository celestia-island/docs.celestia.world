# Entelecheia
<!-- markdownlint-disable MD033 MD041 MD036 -->
<div align="center">

<img src="../../logo.webp" alt="Entelecheia logo" width="200"/>


**A Rust-based multi-agent collaboration platform**

[![License](https://img.shields.io/badge/license-BSL--1.1-blue.svg)](../../meta/license.md)
[![Rust](https://img.shields.io/badge/rust-1.85%2B-orange.svg)](https://www.rust-lang.org/)
[![GitHub](https://img.shields.io/badge/github-celestia--island%2Fentelecheia-blue.svg)](https://github.com/celestia-island/entelecheia)

</div>
<!-- markdownlint-enable MD033 MD041 MD036 -->

> **Version 0.2.0** — Early development stage. The TUI is the primary interface; the WebUI is located at [shittim-chest](https://github.com/celestia-island/shittim-chest).

An exec-only microkernel multi-agent platform — the LLM can only invoke 3 tools (`exec`, `write_to_var`, `write_to_var_json`). 12 Layer1 agents, container-isolated task execution, and an IEPL TypeScript pipeline.

## Quick Start

**Linux / macOS:**

```bash
curl -fsSL https://raw.githubusercontent.com/celestia-island/entelecheia/main/scripts/deploy/install.sh | bash
```

**Windows (WSL2):**

```powershell
irm https://raw.githubusercontent.com/celestia-island/entelecheia/main/scripts/deploy/install.ps1 | iex
```

**[Architecture](../../designs/core/architecture.md)** · **[Building](building.md)** · **[Security](../../meta/security.md)**

## License

Business Source License 1.1 — commercial use requires an authorization license. Non-commercial use follows the SySL-1.0 protocol.
