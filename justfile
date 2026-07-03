# docs.celestia.world — centralized documentation hub (lagrange).

set shell := ["bash", "-c"]
set dotenv-load := false

default:
    @just --list

# Build all language docs with lagrange.
build:
    lagrange build --src docs --out target/docs

# Serve docs on a local port.
serve port="3000":
    lagrange dev --src docs --out target/docs --port {{ port }}

# Clean all built docs.
clean:
    rm -rf target/docs/

# Watch and rebuild (like serve but without browser).
watch:
    lagrange dev --src docs --out target/docs

# Lint all Markdown files with markdownlint.
lint:
    @command -v markdownlint >/dev/null 2>&1 && markdownlint 'docs/**/*.md' --config .markdownlint.json || echo "(markdownlint not installed; skipping)"
