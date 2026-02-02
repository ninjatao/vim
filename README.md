# Neovim Configuration

## What is this?

Modern Neovim configuration with native LSP, Telescope, and Lua-based setup.

## Tested Platforms

- Mac
- Ubuntu
- Termux

## Prerequisite

- Neovim >= 0.9
- Python3 & pip3
- node.js >= 18 (for Copilot)
- ripgrep (for Telescope search)
- make & gcc (for telescope-fzf-native)

## Features

- **Native LSP**: Built-in language server support with Mason
- **Modern UI**: Telescope fuzzy finder, nvim-tree file explorer
- **Smart Completion**: nvim-cmp with LSP, buffer, and path sources
- **Syntax Highlighting**: Tree-sitter based highlighting
- **Git Integration**: Fugitive and Gitsigns
- **AI Assistance**: GitHub Copilot and CopilotChat

## Plugin Manager

[vim-plug](http://github.com/junegunn/vim-plug)

## Installation

### Quick Install (Recommended)

```bash
curl -sSL https://raw.githubusercontent.com/ninjatao/vim/main/install_remote.sh | bash
```

### Manual Install

1. Install Neovim (>= 0.9)
2. Clone this repo: `git clone https://github.com/ninjatao/vim.git ~/.vim`
3. Run install script: `cd ~/.vim && ./install.sh`

The install script will:
- Install vim-plug
- Install system dependencies (neovim, node, ripgrep, make, gcc)
- Create `~/.config/nvim/init.lua` that loads `~/.vim/config.lua`
- Install all plugins

## Key Mappings

- `<Space>` - Leader key
- `<leader>n` - Toggle file tree
- `<leader>s` - Search in files (live grep)
- `<leader>f` - Find files
- `<leader>w` - Search word under cursor
- `<leader>d` - Go to definition
- `<leader>r` - Show references
- `<leader>i` - Go to implementation
- `<leader>cc` - Toggle Copilot Chat
- `gd` - Go to definition
- `gr` - Show references
- `gn` - Rename symbol
- `[g` / `]g` - Navigate diagnostics
- `<C-c>` - Copy to system clipboard
- `<C-v>` - Paste from system clipboard
