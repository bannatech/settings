# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples
 
# If not running interactively, don't do anything
[ -z "$PS1" ] && return
 
# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoredups:ignorespace
 
# append to the history file, don't overwrite it
shopt -s histappend
 
# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000
 
# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize
 
# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"
 
# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.
 
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi
 
# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

# interface

# ANSI CODES - SEPARATE MULTIPLE VALUES WITH ;
#
#  0  reset          4  underline
#  1  bold           7  inverse
#
# FG  BG  COLOR     FG  BG  COLOR
# 30  40  black     34  44  blue
# 31  41  red       35  45  magenta
# 32  42  green     36  46  cyan
# 33  43  yellow    37  47  white

if [[ ! "${prompt_colors[@]}" ]]; then
  prompt_colors=(
    "0;37" # information color
    "1;30" # bracket color
    "0;31" # error color
    "1;31" # git color
  )

  if [[ "$SSH_TTY" ]]; then
    # connected via ssh
    prompt_colors[1]="1;32"
  elif [[ "$USER" == "root" ]]; then
    # logged in as root
    prompt_colors[1]="1;31"
  fi
fi

# Inside a prompt function, run this alias to setup local $c0-$c9 color vars.
alias prompt_getcolors='prompt_colors[9]=; local i; for i in ${!prompt_colors[@]}; do local c$i="\[\e[0;${prompt_colors[$i]}m\]"; done'

# Git status.
function prompt_git() {
  prompt_getcolors
  local status output flags
  status="$(git status 2>/dev/null)"
  [[ $? != 0 ]] && return;
  output="$(echo "$status" | awk '/# Initial commit/ {print "(init)"}')"
  [[ "$output" ]] || output="$(echo "$status" | awk '/# On branch/ {print $4}')"
  [[ "$output" ]] || output="$(git branch | perl -ne '/^\* (.*)/ && print $1')"
  flags="$(
    echo "$status" | awk 'BEGIN {r=""} \
      /Changes to be committed:/        {r=r "+"}\
      /Changes not staged for commit:/  {r=r "!"}\
      /Untracked files:/                {r=r "?"}\
      END {print r}'
  )"
  if [[ "$flags" ]]; then
    output="$output$c1:$c3$flags"
  fi
  echo "$c1-$c3$output$c1$c9"
}

function prompt_command() {
  local exit_code=$?
  local pad=`printf "%03d" $exit_code`
  # If the first command in the stack is prompt_command, no command was run.
  # Set exit_code to 0 and reset the stack.
  [[ "${prompt_stack[0]}" == "prompt_command" ]] && exit_code=0
  prompt_stack=()

  # Manually load z here, after $? is checked, to keep $? from being clobbered.
  [[ "$(type -t _z)" ]] && _z --add "$(pwd -P 2>/dev/null)" 2>/dev/null

  # While the simple_prompt environment var is set, disable the awesome prompt.
  [[ "$simple_prompt" ]] && PS1='\n$ ' && return
  prompt_getcolors
  PS1="\n"
  # misc: [cmd#]
  #PS1="$PS1$c1[$c0#\#$c1]$c9"
  # name: user@host:path
  PS1="$PS1$c1[$c0$pad$c1|$c0\w$c1]$c9"
  # git: [branch:flags]
  PS1="$PS1$(prompt_git)"
  if [[ "$USER" == "root" ]]; then
    PS1="$PS1$c1 #\[\033[0;37m\] "
  else
    PS1="$PS1$c1 \$\[\033[0;37m\] "
  fi
  # Update the title with location
  echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD/$HOME/~}\007"
}

PROMPT_COMMAND='prompt_command'
