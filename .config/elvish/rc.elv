use str
use re
use path

# PATH
var cargo_path = (path:clean (path:join $E:HOME .cargo bin))
if (not (has-value [(each {|p| ==s $cargo_path $p} $paths)] 0)) {
  set paths = [$cargo_path $@paths]
}

if (has-external "/opt/homebrew/bin/brew") {
  set paths = [(/opt/homebrew/bin/brew --prefix)"/bin" $@paths]
}

set paths = [$@paths (path:join $E:HOME .local bin)]

# Locale
set-env LC_ALL "en_US.UTF-8"

# ALIASES

fn icat {|@rest| e:kitty +kitten icat $@rest}
fn kdiff {|@rest| e:kitty +kitten diff $@rest}

if (has-external nvim) {
  fn vim {|@a| e:nvim $@a}
  fn vimdiff {|@a| e:nvim -d $@a}
}

if (has-external neomutt) {
  fn mutt {|@a| e:neomutt $@a}
}

# Standard utils with better options
fn mkd {|@a| e:mkdir -pv $@a}
fn s {|@a| e:sed --posix $@a}
fn G {|@a| e:grep --color=auto $@a}
fn a {|@a| e:awk $@a}
fn df {|@a| e:df $@a}
fn mv {|@a| e:mv -iv $@a}
fn cp {|@a| e:cp -iv $@a}
fn du {|@a| e:du -h $@a}
fn ed {|@a| e:ed -vp '*' $@a}
fn diff {|@a| e:diff --color=auto $@a}

# Programs with specific options
fn sysu {|@a| systemctl --user $@a }
fn TT {|@a| trizen -Syu $@a }
if (has-external nproc) {
  fn k {|@a| make -j(e:nproc) $@a }
  fn kd {|@a| make DEBUG=yes -j(e:nproc) $@a }
} else {
  fn k {|@a| make -j4 $@a }
  fn kd {|@a| make DEBUG=yes -j4 $@a }
}
fn mpvf {|@a| mpv --fs $@a }
fn anipv {|@a| mpv --slang=en,eng --fs --alang=jpn,jp $@a }
fn rfcdate {|@a| date --iso-8601="seconds" $@a }
fn emdate {|@a| date -R $@a }
fn xz {|@a| e:xz --threads=0 $@a }
if (has-external kitty) {
  fn ssh {|@a| e:kitty +kitten ssh -o'VisualHostKey=yes' $@a }
}
fn ydl {|@a| yt-dlp -ic -o '%(title)s.%(ext)s' --add-metadata --user-agent 'Mozilla/5.0 (compatible; Googlebot/2.1;+http://www.google.com/bot.html/)' $@a }
fn ls {|@a| ls --color=auto -F -H -h $@a }
fn ll {|@a| ls --color=auto -l -F -H -h $@a }
fn la {|@a| ls --color=auto -F -H -h -A $@a }
fn exal {|@a| e:exa -lhb $@a }
fn exa {|@a| e:exa --icons $@a }
fn exat {|@a| e:exa --tree -lbh $@a }
fn tract {|@a| transmission-remote -F '~l:done' $@a }

# Shortening names
fn trem {|@a| transmission-remote $@a}
fn P {|@a| pacman $@a}
fn t {|@a| trizen $@a}
fn sys {|@a| systemctl $@a}
fn e {|@a| (external $E:EDITOR) $@a}
fn f {|@a| fusermount $@a}
fn F {|@a| fusermount -u $@a}
fn g {|@a| git $@a}
fn c {|@a| ./configure $@a}
fn ka {|@a| killall $@a}
fn z {|@a| zathura $@a}
fn um {|@a| udiskie-mount $@a}
fn ud {|@a| udiskie-umount $@a}
if (has-external hx) {
  fn helix {|@a| e:hx $@a}
} elif (has-external helix) {
  fn hx {|@a| e:helix $@a}
}

# automatically raise to root
if (has-external doas) {
  fn p {|@a| doas pacman $@a}
  fn sy {|@a| doas systemctl $@a}
  fn E {|@a| doas $E:EDITOR $@a}
  fn m {|@a| doas mount $@a}
  fn u {|@a| doas umount $@a}
} else {
  fn p {|@a| sudo pacman $@a}
  fn sy {|@a| sudo systemctl $@a}
  fn E {|@a| sudo $E:EDITOR $@a}
  fn m {|@a| sudo mount $@a}
  fn u {|@a| sudo umount $@a}
}

# Git stuff for all branches
fn gua { git remote | grep -v "^upstream$" | xargs -l git push }
fn gum { git remote | grep -v "^upstream$" | xargs -I _ git push _ master }

# Using better utils
if (has-external pigz) {
  fn gzip {|@a| e:pigz $@a}
}
if (has-external pbzip2) {
  fn bzip2 {|@a| pbzip2 $@a}
}

# Email
fn em { mutt}
fn abook { abook -C (path:join $E:XDG_CONFIG_HOME abook abookrc) --datafile (path:join $E:XDG_DATA_HOME abook addressbook) }
fn mbsync { mbsync -c (path:join $E:XDG_CONFIG_HOME isync mbsyncrc) }

# Some convience functions that are a bit more complex but not script worthy
if (and (has-external ffprobe) (has-external jq)) {
  fn vdesc {
    |file|
    ffprobe -v quiet -print_format json -show_format $file | jq ".format.tags.DESCRIPTION" | sed 's/\\n/\n/g'
  }
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

set-env RUSTC_WRAPPER sccache
set-env VAULT_ADDR "https://vault.sw.cirrus.com:8200"
set-env EDITOR "hx"
set-env VISUAL "hx"
set-env PAGER "bat"

if (not (has-env XDG_CONFIG_HOME)) {
  set-env XDG_CONFIG_HOME (path:join $E:HOME .config)
}

if (not (has-env XDG_DATA_HOME)) {
  set-env XDG_DATA_HOME (path:join $E:HOME .local share)
}

if (not (has-env XDG_CACHE_HOME)) {
  set-env XDG_CACHE_HOME (path:join $E:HOME .cache)
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

eval (^
  brew shellenv |^
  grep -v "PATH" |^
  each {|l| re:replace '^export' 'set-env' $l} |^
  each {|l| re:replace '=' ' ' $l} |^
  each {|l| re:replace '$;' '' $l} |^
  to-terminated " "^
)

set-env FZF_DEFAULT_OPTS "--layout=reverse --height 40%"

mkdir -p $E:XDG_CONFIG_HOME
mkdir -p $E:XDG_DATA_HOME
mkdir -p $E:XDG_CACHE_HOME
mkdir -p $E:WINEPREFIX
mkdir -p $E:PASSWORD_STORE_DIR
mkdir -p $E:GOPATH
mkdir -p (path:join $E:HOME .local bin)

eval (starship init elvish)

