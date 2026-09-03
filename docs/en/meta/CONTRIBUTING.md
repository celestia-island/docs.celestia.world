# Contributing to Celestia Island

Thank you for your interest in contributing! Celestia Island is a family of projects spanning the whole platform — kirino (auth), plana (platform), hikari (UI), the service layer, and the webuis and sites around them. This guide covers the contribution policy shared by the entire project group; build and development instructions for an individual project live in that project's own repository and documentation site.

## Contribution policy (read this first)

The group is built as mixed-criticality layers — Layer 0 (kirino, auth), Layer 1 (plana, platform), Layer 2 (hikari, UI), and the Layer 3 services on top — so **correctness, backward compatibility, and stability outweigh contribution throughput**. Please read this section before opening a pull request.

- **High merge bar, not a public roadmap.** Opening a PR does not imply it will be merged. We accept a deliberately small number of changes, and only when they fit the architecture and pass review. This is by design, not rudeness.
- **What we welcome:** bug reports, focused fixes, additive (non-breaking) features and protocol fields, improved documentation, and design discussions before code.
- **What we generally will not merge:** large unsolicited rewrites, breaking changes to shared contracts and protocol surfaces (for example the JSON-RPC 2.0 protocol types shared across the Entelecheia platform), architectural changes without a prior design discussion, bulk "vibe-coded" PRs, and anything that lowers the compatibility, safety, or security bar of a lower layer.
- **Core vs. periphery.** The zero-trust auth core, the shared platform types, and the shared UI component library are held to the strictest bar and maintained by the core team; proposed changes there should start as a design discussion.
- **CLA required.** Every accepted contribution requires a signed Contributor License Agreement. See [`CLA.md`](cla.md). Commits must carry a `Signed-off-by` line (`git commit -s`).

> **The license may open; the merge bar will not.** On **2030-01-01** the group's projects convert from BUSL-1.1 to the Change License stated in each repository's [`LICENSE`](../../../LICENSE) — today SySL-1.0 for most projects. That broadens *what you may do with the code*; it does **not** lower the review bar, remove the CLA, or mean we accept more PRs. The contribution policy is unchanged before and after the change date.

## Security

Do **not** open public issues for security vulnerabilities. Report them privately via GitHub Security Advisories on the affected repository, or by emailing <security@celestia.world>. See [`SECURITY.md`](security.md).

## Code of Conduct

Be respectful, constructive, and inclusive. We follow the [Contributor Covenant Code of Conduct](code-of-conduct.md).

## Getting started

Pick the repository you want to work on and follow its README and documentation site. Rust projects verify with `cargo fmt`, `cargo clippy -D warnings`, and `cargo test`; web projects with `pnpm lint`, `pnpm build`, and `pnpm test`. The [ecosystem map](../ecosystem/sites.md) lists every project and where its documentation lives.

## Pull request process

1. Fork and branch from the repository's default branch.
1. Discuss large or shared-contract changes in an issue first.
1. Make atomic commits: each subject is a single gitmoji followed by one capitalized English sentence ending with a period, with details in the commit body.
1. Ensure the project's checks pass before pushing.
1. Sign the CLA and add `Signed-off-by` to each commit.
1. Address review feedback; keep force-pushes to rebase only.

## License & CLA

The projects in this group are licensed under the **Business Source License 1.1 (BUSL-1.1)** with a **Change Date of 2030-01-01**, on which each converts to the Change License stated in its LICENSE — today **SySL-1.0** for most projects. For internal, academic, government, educational, and non-commercial use they are already equivalent to Apache-2.0 or MIT today (see the Additional Use Grant in each repository's [`LICENSE`](../../../LICENSE)). Restricted commercial uses (hosting, resale, or rebranding as a service) require a separate commercial license until the Change Date.

By contributing, you agree that your contributions are licensed under the project's license and that you sign the CLA ([`CLA.md`](cla.md)). The CLA grants the project a permissive license **including the right to relicense**, so the projects can keep their planned licensing path and adapt their licensing in the future.

## Where to go deeper

- [CLA](cla.md) — the Contributor License Agreement you sign.
- [Security policy](security.md) — how to report vulnerabilities privately.
- [Code of Conduct](code-of-conduct.md) — the behavior we hold each other to.
- [Ecosystem map](../ecosystem/sites.md) — every project, site, and where its documentation lives.
