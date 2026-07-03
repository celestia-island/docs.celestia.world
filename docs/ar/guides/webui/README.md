# Shittim Chest (什亭之匣)
<!-- markdownlint-disable MD033 MD041 MD036 -->
<div align="center">

<img src="../../logo.webp" alt="Shittim Chest logo" width="200"/>

**الصدفة المواجهة للمستخدم لمنصة [entelecheia](https://github.com/celestia-island/entelecheia) متعددة الوكلاء**

[![License](https://img.shields.io/badge/license-BSL--1.1-blue.svg)](../../meta/license.md)
[![Rust](https://img.shields.io/badge/rust-1.85%2B-orange.svg)](https://www.rust-lang.org/)
[![GitHub](https://img.shields.io/badge/github-celestia--island%2Fshittim--chest-blue.svg)](https://github.com/celestia-island/shittim-chest)

</div>
<!-- markdownlint-enable MD033 MD041 MD036 -->

> **الإصدار 0.1.0** — قيد التطوير النشط.

واجهة الويب (Webui)، والواجهة الخلفية، و CLI لمنصة [Entelecheia](https://github.com/celestia-island/entelecheia) متعددة الوكلاء. تشمل الدردشة، ولوحة الإدارة، والمصادقة، وتكاملات القنوات المتعددة، وإدارة الأجهزة.

## البدء السريع

```bash
git clone https://github.com/celestia-island/shittim-chest.git
cd shittim-chest
cp .env.example .env
just dev    # backend on :3000, frontend on :5173
```

**المتطلبات الأساسية**: Rust 1.85+، Node 20+، pnpm 9+، [just](https://github.com/casey/just)، PostgreSQL 18+.

**[البنية](../../designs/webui/architecture.md)** · **[المساهمة](CONTRIBUTING.md)** · **[الأمان](../../meta/security.md)**

## الترخيص

Business Source License 1.1 — يتطلب الاستخدام التجاري ترخيصًا. الاستخدام غير التجاري تحت رخصة المصدر الاصطناعي (SySL-1.0)؛ يتحول بالكامل إلى SySL-1.0 بتاريخ 2030-01-01.
