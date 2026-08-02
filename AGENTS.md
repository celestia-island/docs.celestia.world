# AGENTS.md — docs.celestia.world Authoring Rules

> Repository-local rules for agents and humans editing this documentation hub.
> Workspace-wide rules (worktree/PR/commit conventions) live in
> `/mnt/codespace/AGENTS.md` and apply here as well.

## 1. What this repository is

`docs.celestia.world` is the **why-layer** of the celestia-island ecosystem:
philosophy, ecosystem map, and getting started. Per-project *how* documentation
lives in each project's own site (`<name>.docs.celestia.world`) and must NOT be
copied here.

## 2. Content rules

1. **No duplication.** If a topic belongs to a project (protocols, service
   configuration, API references), link to the project site. Never summarize it.
   The hub only carries: philosophy (why), ecosystem map (what/where), and
   getting-started (how to walk the loop).
2. **One page, one idea.** Pages stay short (≤ ~60 lines). A page that grows
   beyond that should be split, not expanded.
3. **Terminology is fixed.** Use the canonical vocabulary:
   - The **closed loop**: discover → install → authenticate → deploy a model →
     chat and run agents → industrial control → verify and support.
   - **Layer 0** (kirino, auth) / **Layer 1** (plana, platform) / **Layer 2**
     (hikari, UI) / **Layer 3** (services: arona, shittim-chest, entelecheia,
     evernight, malkuth, lagrange).
   - **Mixed-criticality layers** L0–L3 with the rule: L0/L1 never depend on
     the LLM being online.
   - Product phases: **internal beta** / **public beta** / Y1–Y5 tracks.
   Do not invent synonyms for these; reuse them across pages.
4. **Links point where content lives.** Every page ends with a "Where to go
   deeper" section (translated per language) linking to sibling hub pages or
   project sites.
5. **Repository names are proper nouns.** arona, shittim-chest, entelecheia,
   evernight, kirino, plana, hikari, malkuth, lagrange, noa, kei, scepter —
   never translated, never renamed, never linked to the wrong repo.

## 3. Language policy

- English (`en`) is canonical. Every content page is authored in `en` first.
- Language directories use BCP-47 codes: `zh-Hans`, `zh-Hant` (never `zhs`/`zht`).
- Translations mirror the `en` structure exactly: same files, same headings,
  same relative link paths. Links and URLs are byte-identical to `en`.
- A new page in `en` without translations is acceptable only transiently;
  translations follow in the same PR when feasible, otherwise a follow-up PR
  within the same milestone.
- `docs/<lang>/meta/` holds legal/governance pages; touch them only for
  actual policy changes.

## 4. Mechanics

- Site built with **lagrange** (`lagrange build --src docs --out target/docs`);
  config in `docs/lagrange.toml`; language switcher in `docs/theme/`.
- Language list must be kept in sync in **three places**: directory names,
  `docs/lagrange.toml` (`order`), and `docs/theme/lang-switcher.js`
  (`LANGUAGES` + `NOTIFICATION_TEXTS`).
- `just lint` runs markdownlint (`docs/**/*.md`, `.markdownlint.json`). Run it
  and keep it clean; no trailing whitespace; final newline required.
- CI deploys from `master` only (`.github/workflows/ci.yml`).
- Commit messages follow workspace rules: `<gitmoji> <Capitalized English
  summary ending with period.>` — e.g. `📝 Add philosophy layer and restructure hub.`
