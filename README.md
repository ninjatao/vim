# Neovim Configuration

## What Is This?

This repository contains a modular Neovim configuration built around:

- native LSP on Neovim `0.11+`
- Telescope for search and file picking
- `nvim-tree` for file browsing
- `nvim-cmp` for completion
- a custom soft light theme inspired by `gruvbox light`

The config is designed to work in both:

- native Neovim
- VSCode/Kiro with a Neovim extension

## Tested Platforms

- macOS
- Ubuntu

Automatic dependency installation is currently supported on:

- macOS with Homebrew
- Debian/Ubuntu-compatible Linux with `apt`
- Termux

## Prerequisites

- Neovim `>= 0.11`
- Python 3
- Node.js `>= 18`
- `npm`
- `git`
- `curl`
- `ripgrep`
- `make` and a C compiler for `telescope-fzf-native`

## Plugin Manager

The setup uses [vim-plug](https://github.com/junegunn/vim-plug).

## Installation

### Quick Install

```bash
curl -sSL https://raw.githubusercontent.com/ninjatao/vim/main/install_remote.sh | bash
```

This installer:

- clones the repository into `~/.config/nvim` or `$XDG_CONFIG_HOME/nvim`
- refuses to overwrite an unrelated existing Neovim config
- installs `vim-plug`
- installs dependencies only on supported package-manager setups

It requires `git` and `curl` to already be installed.

On apt-based systems, the installer checks for usable commands first. If you installed Node.js from NodeSource or another third-party source and already have a working `npm`, it will not try to force-install Ubuntu's separate `npm` package.

### Manual Install

1. Install the prerequisites above.
2. Back up any existing `~/.config/nvim` if you already use Neovim.
3. Clone this repo to `~/.config/nvim`.
4. Run:

```bash
cd ~/.config/nvim
./install.sh
```

### Existing Configs And Migration

- If `~/.config/nvim` already exists and is not this repository, the installer stops instead of overwriting it.
- If you previously cloned this repo into `~/.vim`, move it to `~/.config/nvim` manually before rerunning the installer.
- The legacy `~/.vim` layout is no longer the default install target.

## Configuration Layout

The entry file is `config.lua`. It loads the following modules:

- `lua/user/options.lua`: core editor options
- `lua/user/theme.lua`: custom light theme and statusline colors
- `lua/user/statusline.lua`: custom statusline rendering
- `lua/user/keymaps.lua`: global, LSP, Telescope, and VSCode keymaps
- `lua/user/autocmds.lua`: save-time cleanup and color-sync autocmds
- `lua/user/plugins.lua`: `vim-plug` plugin declarations
- `lua/user/ui.lua`: `nvim-tree` and Telescope setup
- `lua/user/lsp.lua`: Mason and built-in LSP configuration
- `lua/user/completion.lua`: `nvim-cmp` setup
- `lua/user/integrations.lua`: `Comment.nvim` and `gitsigns.nvim`

## Theme

The current UI theme is a custom soft light palette with:

- warm paper-like background
- muted foreground contrast
- a custom statusline mode block

Statusline mode colors:

- normal: medium green
- insert/replace: light blue
- visual: bright yellow

The theme is defined entirely in `lua/user/theme.lua`, without depending on an external colorscheme plugin.

## Key Mappings

### Core

- `<Space>`: leader key
- `<leader><CR>`: clear search highlight

### LSP

- `gd`: go to definition
- `gD`: go to declaration
- `gi`: go to implementation
- `grr`: list references
- `grn`: rename symbol
- `gra`: code action
- `grt`: go to type definition

When an LSP client is not attached, some mappings fall back to native motions and some show a warning.

### Native Neovim UI

- `<leader>n`: toggle `nvim-tree`
- `<leader>s`: Telescope live grep
- `<leader>f`: Telescope find files
- `<leader>b`: Telescope buffers
- `<leader>w`: grep word under cursor
- `<leader>o`: recent files
- `<leader>r`: resume last Telescope picker
- `<leader>ls`: document symbols

### VSCode / Kiro

- `<leader>n`: focus file explorer
- `<leader>s`: Find in Files
- `<leader>f`: Quick Open
- `q:` / `q/` / `q?`: disabled to avoid command-line window issues

### Plugin Defaults

- `gc`, `gb`: comment toggles from `Comment.nvim`
- `ys`, `ds`, `cs`: surround operations from `vim-surround`
- `:Git`, `:Gdiffsplit`, `:Git blame`: common `vim-fugitive` commands

## Behavior Notes

- `netrw` is disabled early because `nvim-tree` handles directory browsing in native Neovim.
- trailing whitespace is cleaned on save for normal editable files
- `markdown`, `mail`, `gitcommit`, and similar special cases are excluded from aggressive cleanup
- Telescope ignores common generated directories such as `node_modules`, `dist`, `build`, and `.venv`

## Native Neovim vs VSCode

### Native Neovim

You get the full stack:

- custom theme
- native LSP
- completion
- Telescope
- `nvim-tree`
- `gitsigns`

On first launch, Mason may still need a moment to install or finish setting up language servers such as `pyright`, `lua_ls`, and `clangd`.

### VSCode / Kiro

You get a reduced setup:

- shared keymaps where appropriate
- `vim-surround`
- `Comment.nvim`
- `vim-fugitive`
- VSCode-native search, explorer, LSP, and completion

## Notes

- if `vim-plug` is missing, startup stops plugin registration and shows an explicit error directing you to rerun `./install.sh`
- if Neovim is older than `0.11`, built-in LSP setup is skipped and a warning is shown
- automatic package installation is intentionally conservative; unsupported package managers must install prerequisites manually
