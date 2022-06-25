[ -f ~/.zprofile ] && source ~/.zprofile

# locale
export LC_ALL="en_US.UTF-8"

# completion
zstyle ':completion:*' list-colors "${(@s.:.)LS_COLORS}"
zstyle ':completion:*' menu select
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
export NNN_PLUG='a:-_anipv $nnn*'


# Fix gpg entry
export GPG_TTY=$(tty)

# Kitty auto complete
kitty + complete setup zsh | source /dev/stdin

# Kitty aliases
alias icat="kitty +kitten icat"
alias kdiff="kitty +kitten diff"

export DOCKER_HOST=unix://$XDG_RUNTIME_DIR/docker.sock
export RUSTC_WRAPPER=sccache

eval "$(starship init zsh)"
