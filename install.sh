#!/bin/bash
set -euo pipefail

workpath="$(cd "$(dirname "$0")"; pwd)"
cd "$workpath"

CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
DATA_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/nvim"
PLUG_PATH="$DATA_DIR/site/autoload/plug.vim"

require_cmd() {
    local cmd="$1"
    if ! command -v "$cmd" > /dev/null 2>&1; then
        echo "Error: required command '$cmd' is not installed." >&2
        exit 1
    fi
}

ensure_repo_layout() {
    if [ ! -f "$workpath/config.lua" ]; then
        echo "Error: install.sh must be run from the repository root." >&2
        exit 1
    fi
}

ensure_config_target() {
    if [ "$workpath" != "$CONFIG_DIR" ]; then
        echo "Error: repository must live at $CONFIG_DIR for this install flow." >&2
        echo "Current location: $workpath" >&2
        echo "Move or clone the repository to $CONFIG_DIR, then rerun ./install.sh." >&2
        exit 1
    fi

    if [ -e "$CONFIG_DIR/init.lua" ] && ! grep -Fq "dofile('$workpath/config.lua')" "$CONFIG_DIR/init.lua"; then
        echo "Error: $CONFIG_DIR/init.lua already exists and is not managed by this repository." >&2
        echo "Back it up before installing." >&2
        exit 1
    fi
}

install_vim_plug() {
    require_cmd curl
    if [ ! -f "$PLUG_PATH" ]; then
        echo "Installing vim-plug..."
        mkdir -p "$(dirname "$PLUG_PATH")"
        curl -fLo "$PLUG_PATH" --create-dirs \
            https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    fi
}

install_with_brew() {
    local packages=(neovim node ripgrep make gcc)
    local missing=()
    local pkg
    for pkg in "${packages[@]}"; do
        if ! brew list -1 "$pkg" > /dev/null 2>&1; then
            missing+=("$pkg")
        fi
    done

    if [ "${#missing[@]}" -gt 0 ]; then
        echo "Installing Homebrew dependencies: ${missing[*]}"
        brew install "${missing[@]}"
    fi
}

install_with_apt() {
    local packages=(neovim nodejs npm ripgrep make gcc git curl python3 python3-pip)
    local missing=()
    local pkg
    for pkg in "${packages[@]}"; do
        if ! dpkg -s "$pkg" > /dev/null 2>&1; then
            missing+=("$pkg")
        fi
    done

    if [ "${#missing[@]}" -eq 0 ]; then
        return
    fi

    if command -v sudo > /dev/null 2>&1; then
        echo "Installing apt dependencies: ${missing[*]}"
        sudo apt-get update
        sudo apt-get install -y "${missing[@]}"
    else
        echo "Error: missing packages: ${missing[*]}" >&2
        echo "Install them manually with apt, then rerun ./install.sh." >&2
        exit 1
    fi
}

install_with_termux() {
    local packages=(neovim nodejs ripgrep make clang git curl python)
    local missing=()
    local pkg
    for pkg in "${packages[@]}"; do
        if ! pkg list-installed "$pkg" 2>/dev/null | grep -q "^$pkg/"; then
            missing+=("$pkg")
        fi
    done

    if [ "${#missing[@]}" -gt 0 ]; then
        echo "Installing Termux dependencies: ${missing[*]}"
        pkg install -y "${missing[@]}"
    fi
}

install_platform_dependencies() {
    case "$(uname)" in
        Darwin)
            if command -v brew > /dev/null 2>&1; then
                install_with_brew
            else
                echo "Error: Homebrew is required on macOS for automatic dependency install." >&2
                echo "Install brew or install dependencies manually: neovim node ripgrep make gcc git curl python3." >&2
                exit 1
            fi
            ;;
        Linux)
            if [ -n "${PREFIX:-}" ] && command -v pkg > /dev/null 2>&1; then
                install_with_termux
            elif command -v apt-get > /dev/null 2>&1 && command -v dpkg > /dev/null 2>&1; then
                install_with_apt
            else
                echo "Automatic dependency install is only supported for apt-based Linux and Termux." >&2
                echo "Please install manually: neovim, nodejs/npm, ripgrep, make, gcc/clang, git, curl, python3, python3-pip." >&2
                exit 1
            fi
            ;;
        *)
            echo "Unsupported platform: $(uname)" >&2
            exit 1
            ;;
    esac
}

install_python_tooling() {
    if command -v pip3 > /dev/null 2>&1; then
        if ! pip3 show pylint > /dev/null 2>&1; then
            echo "Installing pylint..."
            pip3 install pylint
        fi
    else
        echo "Warning: pip3 not found; skipping optional pylint installation."
    fi
}

write_init_file() {
    mkdir -p "$CONFIG_DIR"

    cat <<INITLUA > "$CONFIG_DIR/init.lua"
-- Neovim init.lua
-- Load configuration from repository checkout
vim.opt.runtimepath:prepend('$workpath')
dofile('$workpath/config.lua')
INITLUA

    echo "Created $CONFIG_DIR/init.lua"
}

install_plugins() {
    require_cmd nvim
    echo "Installing Neovim plugins..."
    nvim --headless "+PlugInstall --sync" "+qall"
}

show_post_install_notes() {
    cat <<EOF

==========================================
Installation complete!

Repository: $workpath
Config dir: $CONFIG_DIR

Notes:
- First launch may still download language servers via Mason.
- This setup expects Neovim 0.11+ for built-in LSP support.
- If you previously used $HOME/.vim for this repo, remove or archive that legacy checkout manually.

Run 'nvim' to start using Neovim.
==========================================
EOF
}

ensure_repo_layout
ensure_config_target
install_platform_dependencies
install_vim_plug
install_python_tooling
write_init_file
install_plugins
show_post_install_notes
