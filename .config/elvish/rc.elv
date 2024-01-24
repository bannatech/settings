use str
use re
use path
use os

# PATH
var cargo_path = (path:clean (path:join $E:HOME .cargo bin))
if (not (has-value [(each {|p| ==s $cargo_path $p} $paths)] 0)) {
  set paths = [$cargo_path $@paths]
}

if (has-external "/opt/homebrew/bin/brew") {
  set paths = [(/opt/homebrew/bin/brew --prefix)"/bin" $@paths]
}

set paths = [$@paths (path:join $E:HOME .local bin)]

if (has-external carapace) {
  eval (e:carapace _carapace | slurp)
}

# Locale
set-env LC_ALL "en_US.UTF-8"

fn upgrade {
  var su = (external sudo)
  if (has-external doas) {
    set su = (external doas)
  }

  if (has-external trizen) {
    trizen -Syu
  } elif (has-external pacman)  {
    $su pacman -Syu
  }
  
  if (has-external rustup) {
    rustup update
  }

  if (has-external cargo-install-update) {
    cargo install-update --all
  }

  cpan -u
  $su cpan -u

  if (has-external pipx) {
    pipx upgrade-all
    $su pipx upgrade-all
  }
}

# ALIASES

fn icat {|@rest| e:kitty +kitten icat $@rest}
fn kdiff {|@rest| e:kitty +kitten diff $@rest}

fn vim {|@a| e:vim $@a}
fn vimdiff {|@a| e:vim -d $@a}

if (has-external nvim) {
  set edit:completion:arg-completer[vim] = $edit:completion:arg-completer[nvim]
  set vim~ = {|@a| e:nvim $@a}
  set vimdiff~ = {|@a| e:nvim -d $@a}
}

fn mutt {|@a| e:mutt $@a}
fn em {|@a| e:mutt $@a}

if (has-external neomutt) {
  set edit:completion:arg-completer[mutt] = $edit:completion:arg-completer[neomutt]
  set edit:completion:arg-completer[em] = $edit:completion:arg-completer[neomutt]
  set mutt~ =  {|@a| e:neomutt $@a}
  set em~ = {|@a| e:neomutt $@a}
} 

# Standard utils with better options
set edit:completion:arg-completer[mkd] = $edit:completion:arg-completer[mkdir]
fn mkd {|@a| e:mkdir -pv $@a}

set edit:completion:arg-completer[s] = $edit:completion:arg-completer[sed]
fn s {|@a| e:sed --posix $@a}

set edit:completion:arg-completer[G] = $edit:completion:arg-completer[grep]
fn G {|@a| e:grep --color=auto $@a}

set edit:completion:arg-completer[a] = $edit:completion:arg-completer[awk]
fn a {|@a| e:awk $@a}

fn df {|@a| e:df $@a}
fn mv {|@a| e:mv -iv $@a}
fn cp {|@a| e:cp -iv $@a}
fn du {|@a| e:du -h $@a}
fn ed {|@a| e:ed -vp '*' $@a}
fn diff {|@a| e:diff --color=auto $@a}

# Programs with specific options
set edit:completion:arg-completer[sysu] = $edit:completion:arg-completer[systemctl]
fn sysu {|@a| systemctl --user $@a }

fn TT {|@a| trizen -Syu $@a }

set edit:completion:arg-completer[k] = $edit:completion:arg-completer[make]
set edit:completion:arg-completer[kd] = $edit:completion:arg-completer[make]
fn k {|@rest| e:make -j4 $@rest}
fn kd {|@rest| e:make DEBUG=yes -j4 $@rest}

if (has-external nproc) {
  set k~ = {|@rest| e:make -j(e:nproc) $@rest}
  set kd~ = {|@rest| e:make DEBUG=yes -j(e:nproc) $@rest}
}

set edit:completion:arg-completer[mpvf] = $edit:completion:arg-completer[mpv]
set edit:completion:arg-completer[anipv] = $edit:completion:arg-completer[mpv]
fn mpvf {|@a| mpv --fs $@a }
fn anipv {|@a| mpv --slang=en,eng --fs --alang=jpn,jp $@a }

set edit:completion:arg-completer[rfcdate] = $edit:completion:arg-completer[date]
set edit:completion:arg-completer[emdate] = $edit:completion:arg-completer[date]
fn rfcdate {|@a| date --iso-8601="seconds" $@a }
fn emdate {|@a| date -R $@a }
fn xz {|@a| e:xz --threads=0 $@a }

fn ssh {|@rest| e:ssh -o 'VisualHostKey=yes' $@rest}

if (has-external kitty) {
  set ssh~ = {|@rest| e:kitty +kitten ssh -o "VisualHostKey=yes" $@rest}
}

set edit:completion:arg-completer[ydl] = $edit:completion:arg-completer[yt-dlp]
fn ydl {|@a| yt-dlp -ic -o '%(title)s.%(ext)s' --add-metadata --user-agent 'Mozilla/5.0 (compatible; Googlebot/2.1;+http://www.google.com/bot.html/)' $@a }

fn ls {|@a| e:ls --color=auto -F -H -h $@a }

set edit:completion:arg-completer[ll] = $edit:completion:arg-completer[ls]
set edit:completion:arg-completer[la] = $edit:completion:arg-completer[ls]
fn ll {|@a| e:ls --color=auto -l -F -H -h $@a }
fn la {|@a| e:ls --color=auto -F -H -h -A $@a }

set edit:completion:arg-completer[exal] = $edit:completion:arg-completer[exa]
set edit:completion:arg-completer[exat] = $edit:completion:arg-completer[exa]
fn exal {|@a| e:exa -lhb $@a }
fn exa {|@a| e:exa --icons $@a }
fn exat {|@a| e:exa --tree -lbh $@a }

fn tract {|@a| transmission-remote -F '~l:done' $@a }

# Shortening names
fn trem {|@a| transmission-remote $@a}

set edit:completion:arg-completer[P] = $edit:completion:arg-completer[pacman]
set edit:completion:arg-completer[t] = $edit:completion:arg-completer[pacman]
fn P {|@a| pacman $@a}
fn t {|@a| trizen $@a}

set edit:completion:arg-completer[sys] = $edit:completion:arg-completer[systemctl]
fn sys {|@a| systemctl $@a}

set edit:completion:arg-completer[e] = $edit:completion:arg-completer[$E:EDITOR]
fn e {|@a| (external $E:EDITOR) $@a}

fn f {|@a| fusermount $@a}
fn F {|@a| fusermount -u $@a}

set edit:completion:arg-completer[g] = $edit:completion:arg-completer[git]
fn g {|@a| git $@a}

fn c {|@a| ./configure $@a}

set edit:completion:arg-completer[ka] = $edit:completion:arg-completer[killall]
fn ka {|@a| killall $@a}

set edit:completion:arg-completer[z] = $edit:completion:arg-completer[zathura]
fn z {|@a| zathura $@a}
fn um {|@a| udiskie-mount $@a}
fn ud {|@a| udiskie-umount $@a}

fn hx {|@rest| e:hx $@rest}
fn helix {|@rest| e:helix $@rest}

if (has-external hx) {
  set helix~ = {|@rest| e:hx $@rest}
} elif (has-external helix) {
  set hx~ = {|@rest| e:helix $@rest}
}

# automatically raise to root
set edit:completion:arg-completer[p] = $edit:completion:arg-completer[pacman]
fn p {|@rest| sudo pacman $@rest}

set edit:completion:arg-completer[sy] = $edit:completion:arg-completer[systemctl]
fn sy {|@rest| sudo systemctl $@rest}

set edit:completion:arg-completer[E] = $edit:completion:arg-completer[$E:EDITOR]
fn E {|@rest| sudo $E:EDITOR $@rest}

set edit:completion:arg-completer[m] = $edit:completion:arg-completer[mount]
set edit:completion:arg-completer[u] = $edit:completion:arg-completer[umount]
fn m {|@rest| sudo mount $@rest}
fn u {|@rest| sudo umount $@rest}

if (has-external doas) {
  set p~ =  {|@rest| doas pacman $@rest}
  set sy~ =  {|@rest| doas systemctl $@rest}
  set E~ =  {|@rest| doas $E:EDITOR $@rest}
  set m~ =  {|@rest| doas mount $@rest}
  set u~ =  {|@rest| doas umount $@rest}
}

# Git stuff for all branches
fn gua { git remote | grep -v "^upstream$" | xargs -l git push }
fn gum { git remote | grep -v "^upstream$" | xargs -I _ git push _ master }

# Using better utils
fn gzip {|@rest| e:gzip $@rest}
fn bzip2 {|@rest| e:bzip2 $@rest}

if (has-external pigz) {
  set gzip~ = {|@rest| e:pigz $@rest}
}

if (has-external pbzip2) {
  set bzip2~ = {|@rest| e:pbzip2 $@rest}
}

# Email
fn abook { abook -C (path:join $E:XDG_CONFIG_HOME abook abookrc) --datafile (path:join $E:XDG_DATA_HOME abook addressbook) }
fn mbsync { mbsync -c (path:join $E:XDG_CONFIG_HOME isync mbsyncrc) }

var bfile = (path:join $E:XDG_CONFIG_HOME bookmarks)
fn parse_bmarks {
  put [(each {
    |line|
    var line = (re:replace '#.*$' '' $line | str:trim-space (all))
    if (!=s $line '') {
      put [(each {
        |match|
        if (>= $match[start] 0) {
          put $match[text]
        }
      } [(re:find "[^\\s\"']+|\"([^\"]*)\"|'([ ^']*)'" $line)])]
    }
  } [(all)])]
}

var bookmarks = (from-lines < $bfile | parse_bmarks)

fn sanitize_location {
  |location|
  echo $location | tr -d "\n" |^
   str:replace $E:XDG_CONFIG_HOME "$XDG_CONFIG_HOME" (slurp) |^
   str:replace $E:XDG_RUNTIME_DIR "$XDG_RUNTIME_DIR" (all) |^
   str:replace $E:XDG_DATA_HOME "$XDG_DATA_HOME" (all) |^
   str:replace $E:XDG_CACHE_HOME "$XDG_CACHE_HOME" (all) |^
   str:replace $E:HOME "$HOME" (all)
}

fn add_bookmark {
  |name @rest|
  var conflicting_name = (each {
    |bmark|
    if (str:equal-fold $bmark[0] $name) {
      put $true
    }
  } $bookmarks | has-value [(all)] $true)
  if $conflicting_name {
    print 'Overwrite bookmark for '$name'? (Y/N) '
    var override_choice = (read-line)
    if (not (re:match '((?i)^y(es)?$)' $override_choice)) {
      echo 'Not overwriting'
      return
    }
  }

  var location = (sanitize_location (pwd))
  
  set bookmarks = [(each {
    |bmark|
    if (not (str:equal-fold $bmark[0] $name)) {
      put $bmark
    }
  } $bookmarks) [$name $location (print $@rest)]]

  each {
    |bmark|
    echo $@bmark
  } $bookmarks > $bfile
}

fn remove_bookmark {
  |name|

  set bookmarks = [(each {
    |bmark|
    if (not (str:equal-fold $bmark[0] $name)) {
      put $bmark
    }
  } $bookmarks)]

  each {
    |bmark|
    echo $@bmark
  } $bookmarks > $bfile
}

fn get_fzf_selection {
  |@rest|
}

set-env FZF_DEFAULT_OPTS "--layout=reverse --height 40%"
if (has-external fzf) {
  set edit:insert:binding[Alt-x] = {
    var selection = (each {
        |item|
        echo $item | re:replace "['\\[\\]\\n]" '' (slurp) | echo (all)
      } $bookmarks | fzf -i -n 1,3.. 2> $os:dev-tty | awk '{print $1}')

    each {
      |bmark|
      if (==s $bmark[0] $selection) {
        cd (eval 'echo '(str:replace '$' '$E:' $bmark[1]))
      }
    } $bookmarks
  }

  set edit:insert:binding[Alt-X] = {
    var selection = (each {
        |item|
        echo $item | re:replace "['\\[\\]\\n]" '' (slurp) | echo (all)
      } $bookmarks | fzf -i -n 1,3.. 2> $os:dev-tty | awk '{print $1}')

    each {
      |bmark|
      if (==s $bmark[0] $selection) {
        edit:insert-at-dot (eval 'echo '(str:replace '$' '$E:' $bmark[1]))
      }
    } $bookmarks
  }
}

# Some convience functions that are a bit more complex but not script worthy
fn vdesc {
  |file|
  ffprobe -v quiet -print_format json -show_format $file | jq ".format.tags.DESCRIPTION" | sed 's/\\n/\n/g'
}

# Disable ^S and ^q
stty -ixon

# Fix gpg entry
set-env GPG_TTY (tty)

if (re:match '^xterm-' $E:TERM) {
  set-env TERM "xterm"
} elif (not (has-env TERM)) {
  set-env TERM "xterm"
} 

set-env TERMINAL $E:TERM

set-env RUSTC_WRAPPER sccache
set-env VAULT_ADDR "https://vault.aftix.xyz"
set-env DOCKER_HOST "unix://"(path:join $E:XDG_RUNTIME_DIR docker.sock)

if (has-external helix) {
  set-env EDITOR "helix"
  set-env VISUAL "helix"
} elif (has-external hx) {
  set-env EDITOR "hx"
  set-env VISUAL "hx"
} elif (has-external nvim) {
  set-env EDITOR "nvim"
  set-env VISUAL "nvim"
} else {
  set-env EDITOR "vim"
  set-env VISUAL "vim"
}

set-env PAGER "less"

if (not (has-env XDG_CONFIG_HOME)) {
  set-env XDG_CONFIG_HOME (path:join $E:HOME .config)
}

if (not (has-env XDG_DATA_HOME)) {
  set-env XDG_DATA_HOME (path:join $E:HOME .local share)
}

if (not (has-env XDG_CACHE_HOME)) {
  set-env XDG_CACHE_HOME (path:join $E:HOME .cache)
}

if (not (has-env XDG_RUNTIME_DIR)) {
  set-env XDG_RUNTIME_DIR (path:join $path:separator run user $E:EUID)
}

if (has-external "/Applications/Firefox.app/Contents/MacOS/firefox") {
  set-env BROWSER "/Applications/Firefox.app/Contents/MacOS/firefox"
} else {
  set-env BROWSER "firefox"
}

set-env LESSHISTFILE "-"
set-env WINEPREFIX (path:join $E:XDG_DATA_HOME wineprefixes default)
set-env PASSWORD_STORE_DIR (path:join $E:XDG_DATA_HOME password-store)
set-env GOPATH (path:join $E:XDG_DATA_HOME go)
set-env WEECHAT_HOME (path:join $E:XDG_CONFIG_HOME weechat)
set-env GNUPGHOME (path:join $E:XDG_DATA_HOME gnupg)
set-env NOTMUCH_CONFIG (path:join $E:XDG_CONFIG_HOME notmuch config)
set-env OBJC_DISABLE_INITIALIZE_FORK_SAFETY "YES"

if (has-external brew) {
  eval (^
    brew shellenv |^
    grep -v "PATH" |^
    each {|l| re:replace '^export' 'set-env' $l} |^
    each {|l| re:replace '=' ' ' $l} |^
    each {|l| re:replace '$;' '' $l} |^
    to-terminated " "^
  )
}

mkdir -p $E:XDG_CONFIG_HOME
mkdir -p $E:XDG_DATA_HOME
mkdir -p $E:XDG_CACHE_HOME
mkdir -p $E:XDG_RUNTIME_DIR
mkdir -p $E:WINEPREFIX
mkdir -p $E:PASSWORD_STORE_DIR
mkdir -p $E:GOPATH
mkdir -p (path:join $E:HOME .local bin)

use mamba
set mamba:cmd = conda
# set mamba:root = 

eval (starship init elvish)
