# locale
export LC_ALL="en_US.UTF-8"

# Editor
export EDITOR='nvim'

# neat aliases
if [ $(uname) = "Linux" ]; then
	alias ls="ls --color=auto -F -H -h"
else
	alias ls="ls -G"
fi
alias ll="ls -l -F -H -h"
alias la="ls -A"
alias emacs="emacs -nw"
[ -f ~/.shrc ] && source ~/.shrc

export TERMINAL="kitty"

# completion
zstyle ':completion:*' list-colors "${(@s.:.)LS_COLORS}"
zstyle ':completion:*' menu select
autoload -U compinit
compinit
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=3"

# gem
PATH="$PATH:$HOME/.gem/ruby/2.3.0/bin"

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

# binds
# bindkey -e
# bindkey "^[[3~" delete-char
# bindkey "^[[1;5C" forward-word
# bindkey "^[[OC" forward-word
# bindkey "^[[1;5D" backward-word
# bindkey "^[[OD" backward-word
# bindkey "^[[3;5~" kill-word
# bindkey "\x08" backward-kill-word
# bindkey '^[[A' up-line-or-search
# bindkey '^[[B' down-line-or-search
# WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'

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
setopt PROMPT_SUBST

if [ "$USER" = root ]; then
	PROMPT_USER="%{$reset_color%}%{${fg[red]}%}$USER%{$reset_color%}@"
else
	PROMPT_USER=""
fi

prompt_git() {
	if prompt_current_branch="$(git rev-parse --abbrev-ref HEAD 2>/dev/null)"; then
		local space=0
		if [ "$prompt_current_branch" != master ]; then
			printf "%s" "%{${fg_bold[red]}%}$prompt_current_branch"
			space=1
		fi
		if ! [ -z "$(git status --porcelain)" ]; then
			printf "%s" "%{${fg_bold[yellow]}%}*"
			space=1
		fi
		if [ $space = 1 ]; then
			printf " "
		fi
	fi
}

PROMPT_GIT='$(prompt_git)'

if [ -z "$SSH_CLIENT" ]; then
	PROMPT_HOST="$PROMPT_USER%{${fg_bold[cyan]}%}%m "
else
	PROMPT_HOST="%{${fg_bold[green]}%}∞ $PROMPT_USER%{${fg_bold[red]}%}%m "
fi
PROMPT_CWD="%{${fg_bold[yellow]}%}%~ "
PROMPT_ARROW="%(?:%{$fg_bold[green]%}$ :%{$fg_bold[red]%}$ %s)"
PS1="$PROMPT_HOST$PROMPT_CWD$PROMPT_GIT$PROMPT_ARROW%{$reset_color%}"
PS2="%{${fg_bold[green]}%}>%{$reset_color%}"
BASEPS1=$PS1
BASEPS2=$PS2

# print out normal mode thing
function zle-line-init zle-keymap-select {
  VIM_PROMPT="%{$fg_bold[yellow]%} [% N]% %{$reset_color%}"
  if [[ "$KEYMAP" == "vicmd" ]] ; then
    PS1="$VIM_PROMPT $BASEPS1"
  else
    PS1="$BASEPS1"
  fi
  zle reset-prompt
}

zle -N zle-line-init
zle -N zle-keymap-select

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
alias p="doas pacman"
alias P="pacman"
alias t="trizen"
alias sy="doas systemctl"
alias sys="systemctl"
alias sysu="systemctl --user"
alias TT="trizen -Syu"
alias mkd="mkdir -pv"
alias e="$EDITOR"
alias E="doas $EDITOR"
alias bt="btfs"
alias m="doas mount"
alias u="doas umount"
alias k="make -j$(nproc)"
alias kd="make DEBUG=yes -j$(nproc)"
alias c="./configure"
alias f="fusermount"
alias F="fusermount -u"
alias g="git"
alias gua="git remote | grep -v "^upstream$" | xargs -l git push"
alias gum="git remote | grep -v "^upstream$" | xargs -I _ git push _ master"
alias mpvf="mpv --fs"
alias anipv="mpv --slang=en,eng --fs --alang=jpn"
alias s="sed --posix"
alias G="grep --color=auto"
alias a="awk"
alias pl="plzip -n4"
alias ed="ed -vp '*'"
alias ydl="youtube-dl --add-metadata -ic -o '%(title)s.%(ext)s'"
alias df='df -h'
alias mv='mv -iv'
alias cp='cp -iv'
alias du='du -h'
alias rfcdate="date \"+%a, %d %b %Y %H:%M:%S %z\""
alias xz="xz --threads=0"
alias gzip="pigz"
alias bzip2="pbzip2"
alias ssh="ssh -o'VisualHostKey=yes'"

# Email
alias mutt='neomutt'
alias em='neomutt'
alias abook='abook -C $XDG_CONFIG_HOME/abook/abookrc --datafile $XDG_DATA_HOME/abook/addressbook'
alias mbsync='mbsync -c $XDG_CONFIG_HOME/isync/mbsyncrc'

# Fix gpg entry
export GPG_TTY=$(tty)

# Kitty auto complete
kitty + complete setup zsh | source /dev/stdin

# Kitty aliases
alias icat="kitty +kitten icat"
alias kdiff="kitty +kitten diff"
