# Entelecheia
<!-- markdownlint-disable MD033 MD041 MD036 -->
<div align="center">

<img src="../../logo.webp" alt="Entelecheia logo" width="200"/>


**منصة تعاون متعددة الوكلاء مبنية بلغة Rust**

[![License](https://img.shields.io/badge/license-BSL--1.1-blue.svg)](../../meta/license.md)
[![Rust](https://img.shields.io/badge/rust-1.85%2B-orange.svg)](https://www.rust-lang.org/)
[![GitHub](https://img.shields.io/badge/github-celestia--island%2Fentelecheia-blue.svg)](https://github.com/celestia-island/entelecheia)

</div>
<!-- markdownlint-enable MD033 MD041 MD036 -->

> **الإصدار 0.2.0** — مرحلة تطوير مبكرة. واجهة TUI هي الواجهة الأساسية؛ واجهة WebUI موجودة في [shittim-chest](https://github.com/celestia-island/shittim-chest).

منصة متعددة الوكلاء ذات نواة دقيقة للتنفيذ فقط — يستطيع نموذج اللغة الكبير LLM استدعاء 3 أدوات فقط (`exec`، `write_to_var`، `write_to_var_json`). تشتمل على 12 وكيل Layer1، وتنفيذ مهام معزول بالحاويات، وخط أنابيب IEPL مكتوب بلغة TypeScript.

## البدء السريع

**Linux / macOS:**

```bash
curl -fsSL https://raw.githubusercontent.com/celestia-island/entelecheia/main/scripts/deploy/install.sh | bash
```

**Windows (WSL2):**

```powershell
irm https://raw.githubusercontent.com/celestia-island/entelecheia/main/scripts/deploy/install.ps1 | iex
```

**[البنية](../../designs/core/architecture.md)** · **[البناء](building.md)** · **[الأمان](../../meta/security.md)**

## الترخيص

Business Source License 1.1 — يتطلب الاستخدام التجاري ترخيص تفويض. يتبع الاستخدام غير التجاري بروتوكول SySL-1.0.
