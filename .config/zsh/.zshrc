[ -f ~/.zprofile ] && source ~/.zprofile

# locale
export LC_ALL="en_US.UTF-8"

# completion
zstyle ':completion:*' list-colors "${(@s.:.)LS_COLORS}"
zstyle ':completion:*' menu select
fpath=(
	$ZDOTDIR/completions
	$fpath
)
autoload -U compinit
compinit
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=3"

# history
HISTFILE=~/.zhistory
HISTSIZE=10000
SAVEHIST=10000
setopt append_history
setopt extended_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_verify
setopt inc_append_history

# VI mode
bindkey -v
bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line
bindkey "^[[3~" delete-char
autoload edit-command-line
zle -N edit-command-line
bindkey -v "^X^E" edit-command-line
export KEYTIMEOUT=1

# I don't want to have to import weird terminfos to all systems I SSH into
case "$TERM" in
	xterm-termite) export TERM="xterm";;
  xterm-kitty) export TERM="xterm";;
esac

# prompt
autoload -U colors && colors

# Useful bash keys in vimode
bindkey '^P' up-history
bindkey '^N' down-history
bindkey '^?' backward-delete-char
bindkey '^h' backward-delete-char
bindkey '^w' backward-kill-word
bindkey '^r' history-incremental-search-backward

# Highlight
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)
highlighted=0
for hlpath in /usr{,/local}/share{,/zsh/plugins}/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
do
	if [ $highlighted = 0 ] && [ -f "$hlpath" ]; then
		source "$hlpath"
		highlighted=1
	fi
done

# Suggestions
suggested=0
for sugpath in /usr{,/local}/share{,/zsh/plugins}/zsh-autosuggestions/zsh-autosuggestions.zsh
do
	if [ $suggested = 0 ] && [ -f "$sugpath" ]; then
		source "$sugpath"
		suggested=1
	fi
done

# Disable ^S and ^Q
stty -ixon

# Nice aliases
[ -f "$XDG_CONFIG_HOME/aliasrc" ] && source "$XDG_CONFIG_HOME/aliasrc"

# Get bookmarks
[ -f "$XDG_CONFIG_HOME/bookmarks" ] && \
  source <(grep -ve "^$" -e "^#" $XDG_CONFIG_HOME/bookmarks \
  | cut -f1,2 | sed 's/^/alias b/ ; s/\t/="cd / ; s/$/"/')
[ -f "$XDG_CONFIG_HOME/bookmarks" ] && \
  source <(grep -ve "^$" -e "^#" $XDG_CONFIG_HOME/bookmarks \
  | cut -f1,2 | sed 's/^/alias e/ ; s/\t/="echo / ; s/$/"/')

# NNN
export NNN_FIFO=$XDG_RUNTIME_DIR/nnn.fifo

# Fix gpg entry
export GPG_TTY=$(tty)

# Kitty aliases
alias icat="kitty +kitten icat"
alias kdiff="kitty +kitten diff"

export RUSTC_WRAPPER=sccache

export VAULT_ADDR="https://vault.sw.cirrus.com:8200"

eval "$(starship init zsh)"
[ -f /opt/miniconda3/etc/profile.d/conda.sh ] && source /opt/miniconda3/etc/profile.d/conda.sh

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/opt/homebrew/Caskroom/miniforge/base/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/opt/homebrew/Caskroom/miniforge/base/etc/profile.d/conda.sh" ]; then
        . "/opt/homebrew/Caskroom/miniforge/base/etc/profile.d/conda.sh"
    else
        export PATH="/opt/homebrew/Caskroom/miniforge/base/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

