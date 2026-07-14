#!/bin/bash
set -euo pipefail

workpath="$(cd "$(dirname "$0")"; pwd)"
cd "$workpath"

CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
DATA_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/nvim"
PLUG_PATH="$DATA_DIR/site/autoload/plug.vim"
MIN_NVIM_MINOR=11

prepend_path_if_dir() {
    local dir="$1"
    if [ -d "$dir" ]; then
        case ":$PATH:" in
            *:"$dir":*) ;;
            *) export PATH="$dir:$PATH" ;;
        esac
    fi
}

prepend_common_bin_paths() {
    prepend_path_if_dir "$HOME/.local/bin"
    prepend_path_if_dir "/usr/local/bin"
    prepend_path_if_dir "/opt/homebrew/bin"
}

require_cmd() {
    local cmd="$1"
    if ! command -v "$cmd" > /dev/null 2>&1; then
        echo "Error: required command '$cmd' is not installed." >&2
        exit 1
    fi
}

ensure_repo_layout() {
    if [ ! -f "$workpath/config.lua" ] || [ ! -f "$workpath/init.lua" ]; then
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
    local packages=(neovim node ripgrep make)
    local missing=()
    local pkg
    for pkg in "${packages[@]}"; do
        if ! brew list -1 "$pkg" > /dev/null 2>&1; then
            missing+=("$pkg")
        fi
    done

    if ! xcode-select -p > /dev/null 2>&1; then
        echo "Error: Xcode Command Line Tools are required on macOS." >&2
        echo "Run: xcode-select --install" >&2
        exit 1
    fi

    if [ "${#missing[@]}" -gt 0 ]; then
        echo "Installing Homebrew dependencies: ${missing[*]}"
        brew install "${missing[@]}"
    fi
}

install_with_apt() {
    local package_specs=(
        "nvim:neovim"
        "node:nodejs"
        "npm:npm"
        "rg:ripgrep"
        "make:make"
        "gcc:gcc"
        "git:git"
        "curl:curl"
    )
    local missing=()
    local spec
    for spec in "${package_specs[@]}"; do
        local cmd="${spec%%:*}"
        local pkg="${spec#*:}"
        if ! command -v "$cmd" > /dev/null 2>&1; then
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
                echo "Install brew or install dependencies manually: neovim node ripgrep make git curl python3." >&2
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
                echo "Please install manually: neovim, nodejs/npm, ripgrep, make, gcc/clang, git, curl." >&2
                exit 1
            fi
            ;;
        *)
            echo "Unsupported platform: $(uname)" >&2
            exit 1
            ;;
    esac
}

require_minimum_nvim() {
    local version_output
    local minor

    require_cmd nvim
    version_output="$(nvim --version | head -n 1)"
    minor="$(printf '%s\n' "$version_output" | sed -n 's/.*NVIM v0\.\([0-9][0-9]*\).*/\1/p')"

    if [ -z "$minor" ]; then
        echo "Error: could not determine Neovim version from: $version_output" >&2
        exit 1
    fi

    if [ "$minor" -lt "$MIN_NVIM_MINOR" ]; then
        echo "Error: Neovim 0.$MIN_NVIM_MINOR+ is required, found: $version_output" >&2
        echo "Install a newer Neovim release manually, then rerun ./install.sh." >&2
        exit 1
    fi
}

install_python_tooling() {
    if [ "${INSTALL_OPTIONAL_PYTHON_TOOLS:-1}" = "0" ]; then
        echo "Skipping optional Python tooling."
        return
    fi

    if command -v pip3 > /dev/null 2>&1; then
        if ! pip3 show pylint > /dev/null 2>&1; then
            echo "Attempting optional pylint installation..."
            if ! pip3 install pylint; then
                echo "Warning: could not install pylint automatically." >&2
                echo "If you want pylint, install it with pipx, a virtualenv, or your system package manager." >&2
            fi
        fi
    else
        echo "Warning: pip3 not found; skipping optional pylint installation."
    fi
}

install_plugins() {
    require_minimum_nvim
    echo "Installing Neovim plugins..."
    nvim --headless --cmd "let g:nvim_install_mode=1" "+PlugInstall --sync" "+qall"
    echo "Installing Mason-managed tools (this may take a while on first setup)..."
    echo "If this step is slow on a new machine, you can rerun:"
    echo "  ./install.sh"
    # MasonToolsInstallSync may not return in this headless bootstrap flow; call its API directly instead.
    nvim --headless --cmd "let g:nvim_install_mode=1" \
        "+lua require('user.lsp').setup_mason({ run_on_start = false, debounce_hours = 0 })" \
        "+lua require('mason-tool-installer').check_install(false, true)" \
        "+qall"
}

show_post_install_notes() {
    cat <<EOF

==========================================
Installation complete!

Repository: $workpath
Config dir: $CONFIG_DIR

Notes:
- Mason-managed language servers are installed during setup.
- If Mason tool installation is slow on a new machine, rerun:
  ./install.sh
- This setup expects Neovim 0.11+ for built-in LSP support.
- If you previously used $HOME/.vim for this repo, remove or archive that legacy checkout manually.

Run 'nvim' to start using Neovim.
==========================================
EOF
}

ensure_repo_layout
prepend_common_bin_paths
ensure_config_target
install_platform_dependencies
install_vim_plug
install_python_tooling
install_plugins
show_post_install_notes
