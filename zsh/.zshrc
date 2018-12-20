# locale
export LC_ALL="en_US.UTF-8"

# Editor
export EDITOR='nvim'

# neat aliases
if [ $(uname) = "Linux" ]; then
	alias ls="ls --color=always -F -H"
else
	alias ls="ls -G"
fi
alias ll="ls -l -F -H"
alias la="ls -a"
alias emacs="emacs -nw"
[ -f ~/.shrc ] && source ~/.shrc

# completion
zstyle ':completion:*' list-colors "${(@s.:.)LS_COLORS}"
zstyle ':completion:*' menu select
autoload -U compinit
compinit
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

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
bindkey -e
bindkey "^[[3~" delete-char
bindkey "^[[1;5C" forward-word
bindkey "^[[OC" forward-word
bindkey "^[[1;5D" backward-word
bindkey "^[[OD" backward-word
bindkey "^[[3;5~" kill-word
bindkey "\x08" backward-kill-word
bindkey '^[[A' up-line-or-search
bindkey '^[[B' down-line-or-search
WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'

# I don't want to have to import weird terminfos to all systems I SSH into
case "$TERM" in
	xterm-termite) export TERM="xterm";;
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
alias p="sudo pacman"
alias t="trizen"
alias sy="sudo systemctl"
alias sys="systemctl"
alias sysu="systemctl --user"
alias TT="trizen -Syu"
alias mkd="mkdir -pv"
alias e="nvim"
alias E="sudo nvim"
alias bt="btfs"
alias m="sudo mount"
alias u="sudo umount"
alias k="make"
alias c="./configure"
alias f="fusermount"
alias F="fusermount -u"
alias g="git"
alias mpvf="mpv --fs"
alias anipv="mpv --slang=en --fs --alang=jpn"
alias s="sed"
alias G="grep --color=auto"
alias a="awk"

# Path
PATH=$PATH:$HOME/bin:$HOME/.scripts
