# Startup Initialization Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Attach LSP clients to files opened during Neovim startup without changing one-time config loading or installer mode.

**Architecture:** A headless regression script opens a Python file with the worktree's `init.lua` and asserts that `pyright` attaches. Runtime services that must register before `FileType` move out of the `VimEnter` callback; directory UI and cursor animation remain deferred.

**Tech Stack:** Neovim 0.12, Lua, POSIX shell.

---

### Task 1: Capture the startup LSP regression

**Files:**
- Create: `tests/startup_lsp.sh`

- [ ] Add a shell regression script that creates `probe.py`, opens it with `nvim -u "$repo_root/init.lua" --headless`, waits 2.5 seconds, and asserts `#vim.lsp.get_clients({ bufnr = 0 }) > 0`.
- [ ] Run `sh tests/startup_lsp.sh`; it must fail with `pyright did not attach during startup` before the configuration change.
- [ ] Commit the test with `git add tests/startup_lsp.sh && git commit -m "test: cover startup LSP attachment"`.

### Task 2: Register runtime services before the initial FileType event

**Files:**
- Modify: `config.lua:35-46`
- Modify: `tests/startup_lsp.sh`

- [ ] Call `ui.setup_telescope(keymaps)`, `lsp.setup()`, `completion.setup()`, and `integrations.setup_gitsigns()` directly inside the existing non-installer branch.
- [ ] Keep only `ui.setup_nvim_tree(keymaps)` and `ui.setup_smear_cursor()` in the `VimEnter` callback.
- [ ] Run `sh tests/startup_lsp.sh`; it must exit 0 without replaying `FileType`.
- [ ] Run Neovim with `g:nvim_install_mode=1` and assert that every `VimEnter` autocmd belongs to the plugin-owned `mti_start` group; the application callback has no group and must therefore be absent.
- [ ] Commit with `git add config.lua tests/startup_lsp.sh && git commit -m "fix: initialize LSP before startup filetype"`.
