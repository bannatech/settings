#!/bin/bash
function prompt_git() {
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
    output="$flags:$output"
  fi
  echo "$output"
}
prompt_git
