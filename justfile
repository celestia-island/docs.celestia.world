# docs.celestia.world — centralized documentation & blog hub.
# Site framework (Docusaurus / VitePress / MkDocs) is TBD; until then this is
# plain Markdown and these tasks are placeholders.

set shell := ["bash", "-c"]

default:
    @just --list

# Lint all Markdown files with markdownlint (if available).
lint:
    @command -v markdownlint >/dev/null 2>&1 && markdownlint '**/*.md' || echo "(markdownlint not installed; skipping)"

# Placeholder for the future site dev server (framework-dependent).
serve:
    @echo "Site framework not chosen yet. Pick Docusaurus / VitePress / MkDocs first."
