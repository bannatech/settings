#!/bin/env zsh
#
# ZSH profile

# Add ~/.local/bin to path
export PATH="$PATH:$(du "$HOME/.local/bin/" | cut -f2 | paste -sd ':'):$HOME/.cargo/bin"

# Defaults
export EDITOR="nvim"
export VISUAL="nvim"
export TERM="xterm"
export TERMINAL="xterm"
export BROWSER="firefox"
export READER="zathura"
export PAGER="less"

# Directory and file locations
[ -z "$XDG_CONFIG_HOME" ] && export XDG_CONFIG_HOME="$HOME/.config"
[ -z "$XDG_DATA_HOME" ] && export XDG_DATA_HOME="$HOME/.local/share"
[ -z "$XDG_CACHE_HOME" ] && export XDG_CACHE_HOME="$HOME/.cache"
[ -z "$XDG_RUNTIME_DIR" ] && export XDG_RUNTIME_DIR="/run/user/$EUID"
export LESSHISTFILE="-"
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
export WINEPREFIX="$XDG_DATA_HOME/wineprefixes/default"
export PASSWORD_STORE_DIR="$XDG_DATA_HOME/password-store"
export GOPATH="$XDG_DATA_HOME/go"
export WEECHAT_HOME="$XDG_CONFIG_HOME/weechat"
export ABDUCO_SOCKET_DIR="$XDG_RUNTIME_DIR/abduco"
export GNUPGHOME="$XDG_DATA_HOME/gnupg"
export NOTMUCH_CONFIG="$XDG_CONFIG_HOME/notmuch/config"

# Make sure paths exist
mkdir -p "$XDG_CONFIG_HOME"
mkdir -p "$XDG_DATA_HOME"
mkdir -p "$XDG_CACHE_HOME"
mkdir -p "$ZDOTDIR"
mkdir -p "$WINEPREFIX"
mkdir -p "$PASSWORD_STORE_DIR"
mkdir -p "$GOPATH"
mkdir -p "$HOME/.local/bin"
mkdir -p "$ABDUCO_SOCKET_DIR"

# Other defaults
export FZF_DEFAULT_OPTS="--layout=reverse --height 40%"
