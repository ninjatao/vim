#!/bin/sh
set -eu

repo_root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
tmpdir=$(mktemp -d)
trap 'rm -rf "$tmpdir"' EXIT

printf 'x = 1\n' > "$tmpdir/probe.py"
nvim -u "$repo_root/init.lua" --headless "$tmpdir/probe.py" \
    '+sleep 2500m' \
    '+lua assert(#vim.lsp.get_clients({ bufnr = 0 }) > 0, "pyright did not attach during startup")' \
    '+qa'
