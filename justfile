# docs.celestia.world — centralized documentation hub (lagrange).

set shell := ["bash", "-c"]
# Windows: PowerShell (the 5.1 floor ships with every Windows; pwsh 7 is
# NOT assumed). Linewise recipes must stay PS-5.1-safe: no `&&` chains,
# `cd X; cmd` instead of `cd X && cmd`. Bash-only recipes use
# [script('bash')] and need Git Bash (or WSL) when actually run.
set windows-shell := ["powershell.exe", "-NoLogo", "-NoProfile", "-Command", "[Console]::OutputEncoding=[System.Text.Encoding]::UTF8; $PSDefaultParameterValues['*:Encoding']='utf8';"]
set unstable
set lists

# Repo definitions override the shared template's (imported above).
set allow-duplicate-recipes
set allow-duplicate-variables

# Shared celestia-devtools recipes — NOT in git. Stage with: just fetch.
# `import?` silently skips when absent, so this justfile parses pre-fetch.
import? "./.just/git-bash-interop.just"
import? "./.just/celestia-devtools.just"

# Stage shared celestia-devtools recipes into .just/ (gitignored).
# Source order: explicit URL arg → local pip bundle (offline) → GitHub raw.
# curl honors HTTP_PROXY/HTTPS_PROXY/ALL_PROXY env vars automatically.
fetch URL='':
    {{ if os_family() == "windows" { "python" } else { "python3" } }} -c "import os; os.makedirs('.just', exist_ok=True)"
    {{ if URL != "" { "curl -fsSL " + URL + " -o .just/celestia-devtools.just" } else if which("celestia-devtools") != "" { "celestia-devtools fetch-just" } else { "curl -fsSL https://raw.githubusercontent.com/celestia-island/celestia-devtools/dev/src/celestia_devtools/common.just -o .just/celestia-devtools.just" } }}
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
    @{{ if which("markdownlint") != "" { "markdownlint 'docs/**/*.md' --config .markdownlint.json" } else { "echo '(markdownlint not installed; skipping)'" } }}
