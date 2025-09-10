# Amazon Q pre block. Keep at the top of this file.
[[ -f "${HOME}/Library/Application Support/amazon-q/shell/zshrc.pre.zsh" ]] && builtin source "${HOME}/Library/Application Support/amazon-q/shell/zshrc.pre.zsh"

# Path to your Oh My Zsh installation.
export ANDROID_HOME="$HOME/Library/Android/sdk"
export ANDROID_SDK_ROOT="$ANDROID_HOME"
export PATH="$PATH:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$ANDROID_HOME/tools"
export JAVA_HOME=$(/usr/libexec/java_home -v 17)
export JAVA_HOME=$(/usr/libexec/java_home -v 17)

export ZSH="$HOME/.oh-my-zsh"
export DYLD_LIBRARY_PATH="/usr/local/lib:$DYLD_LIBRARY_PATH"
export PATH="/opt/homebrew/bin:$PATH"
export HOMEBREW_API_DOMAIN="https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles/api"
export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles/bottles"
export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git"
export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git"
export PYTHONPATH='.'
export EDITOR='nvim'

alias proxy='export http_proxy=http://127.0.0.1:7890;export https_proxy=http://127.0.0.1:7890'
alias unproxy='unset all_proxy;unset https_proxy;unset http_proxy'
alias vim='nvim'
ulimit -n 2048 # allow open more files

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="ys"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
zstyle ':omz:update' frequency 27

# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(extract vi-mode git z zsh-autosuggestions zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

export EDITOR='nvim'

# conda initialize
export PATH="/Users/duantao/.miniforge3/envs/python310/bin:$PATH"
__conda_setup="$('/Users/duantao/.miniforge3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/duantao/.miniforge3/etc/profile.d/conda.sh" ]; then
# . "/Users/duantao/.miniforge3/etc/profile.d/conda.sh"  # commented out by conda initialize
    else
# export PATH="/Users/duantao/.miniforge3/bin:$PATH"  # commented out by conda initialize
    fi
fi
unset __conda_setup

if [ -f "/Users/duantao/.miniforge3/etc/profile.d/mamba.sh" ]; then
    . "/Users/duantao/.miniforge3/etc/profile.d/mamba.sh"
fi
mamba activate python310

# Amazon Q post block. Keep at the bottom of this file.
[[ -f "${HOME}/Library/Application Support/amazon-q/shell/zshrc.post.zsh" ]] && builtin source "${HOME}/Library/Application Support/amazon-q/shell/zshrc.post.zsh"
