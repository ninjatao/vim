#!/bin/bash
set -e

REPO_URL="https://github.com/ninjatao/vim.git"
TARGET_DIR="$HOME/.vim"

if [ -d "$TARGET_DIR" ]; then
    echo "Directory $TARGET_DIR already exists. Pulling latest changes..."
    cd "$TARGET_DIR"
    git pull
else
    echo "Cloning repository..."
    git clone "$REPO_URL" "$TARGET_DIR"
    cd "$TARGET_DIR"
fi

./install.sh
