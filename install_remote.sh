#!/bin/bash
set -euo pipefail

REPO_URL="https://github.com/ninjatao/vim.git"
TARGET_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
LEGACY_DIR="$HOME/.vim"

require_cmd() {
    local cmd="$1"
    if ! command -v "$cmd" > /dev/null 2>&1; then
        echo "Error: required command '$cmd' is not installed." >&2
        exit 1
    fi
}

ensure_target_available() {
    if [ -d "$TARGET_DIR/.git" ]; then
        local remote_url
        remote_url=$(git -C "$TARGET_DIR" remote get-url origin 2>/dev/null || true)
        if [ "$remote_url" != "$REPO_URL" ]; then
            echo "Error: $TARGET_DIR already exists but is not this repository." >&2
            echo "Move it aside or install manually." >&2
            exit 1
        fi
        return
    fi

    if [ -e "$TARGET_DIR" ]; then
        echo "Error: $TARGET_DIR already exists and is not a git checkout." >&2
        echo "Move it aside or install manually." >&2
        exit 1
    fi

    if [ -d "$LEGACY_DIR/.git" ]; then
        local legacy_remote
        legacy_remote=$(git -C "$LEGACY_DIR" remote get-url origin 2>/dev/null || true)
        if [ "$legacy_remote" = "$REPO_URL" ]; then
            echo "Found legacy checkout at $LEGACY_DIR." >&2
            echo "Please migrate it manually to $TARGET_DIR or remove it before running quick install." >&2
            exit 1
        fi
    fi
}

require_cmd git
require_cmd curl
ensure_target_available

mkdir -p "$(dirname "$TARGET_DIR")"

if [ -d "$TARGET_DIR/.git" ]; then
    echo "Updating existing checkout in $TARGET_DIR..."
    git -C "$TARGET_DIR" pull --ff-only
else
    echo "Cloning repository into $TARGET_DIR..."
    git clone "$REPO_URL" "$TARGET_DIR"
fi

cd "$TARGET_DIR"
./install.sh
