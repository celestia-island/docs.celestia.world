# docs.celestia.world — centralized documentation hub (mdBook).

set shell := ["bash", "-c"]
set dotenv-load := false

LANGS := "en zhs zht ja ko fr es ru de pt ar"

default:
    @just --list

# Build all language books into target/docs/.
build:
    @for lang in {{LANGS}}; do \
        echo "Building $lang…"; \
        mdbook build docs/$lang 2>/dev/null || echo "  (skipped $lang — missing content)"; \
    done

# Build a single language book.
build-lang lang:
    mdbook build docs/{{lang}}

# Serve a single language book on http://localhost:3000 (or specified port).
serve lang port="3000":
    mdbook serve docs/{{lang}} --port {{port}} --open

# Serve the English book on the default port.
serve-en:
    mdbook serve docs/en --open

# Clean all built docs.
clean:
    rm -rf target/docs/

# Watch and rebuild a single language book (like serve but without browser).
watch lang:
    mdbook watch docs/{{lang}}

# Lint all Markdown files with markdownlint (if available).
lint:
    @command -v markdownlint >/dev/null 2>&1 && markdownlint 'docs/**/*.md' || echo "(markdownlint not installed; skipping)"
