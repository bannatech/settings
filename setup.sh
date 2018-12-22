#!/bin/sh

REALUSER="$USER"
if test "$REALUSER" = "" || test "$REALUSER" = "root"; then
    if test "$SUDO_USER" = ""; then
	echo '$SUDO_USER must be set.'
	exit 1
    fi
    REALUSER="$SUDO_USER"
fi

if test "$(whoami)" != "root"; then
    echo "Must be run as root."
    exit 1
fi

printf "Running under user %s\n" "$REALUSER"

test "$?" != "0" && exit 1

cpr () {
	SRC="$1"
	if [ -d "$1" ] ; then
		SRC=$(printf '%s' "$1" | sed 's/\/\{0,1\}$/\/./')
	fi
	
	rsync -au "$SRC" "$2"
}

fixuser () {
    chown -R -h "$REALUSER" "$1"
}

./setup/install.sh

INSTDIR="/home/$REALUSER"
CONFDIR="$INSTDIR/.config"

cpr .stylelintrc "$INSTDIR/.stylelintrc"
fixuser "$INSTDIR/.stylelintrc"
cpr bspwm "$CONFDIR/bspwm"
fixuser "$CONFDIR/bspwm"
cpr .emoji "$CONFDIR/.emoji"
fixuser "$CONFIR/.emoji"
cpr systemd "$CONFDIR/systemd"
fixuser "$CONFDIR/systemd"
cpr compton "$CONFDIR/compton"
fixuser "$CONFDIR/compton"
cpr weechat "$INSTDIR/.weechat"
fixuser "$INSTDIR/.weechat"
cpr mpv "$CONFDIR/mpv"
fixuser "$CONFDIR/mpv"
cpr mpd "$CONFDIR/mpd"
fixuser "$CONFDIR/mpd"
cpr emacs/.emacs "$INSTDIR/.emacs"
fixuser "$INSTDIR/.emacs"
cpr emacs "$INSTDIR/.emacs.d"
fixuser "$INSTDIR/.emacs.d"
cpr vim/.vimrc "$INSTDIR/.vimrc"
fixuser "$INSTDIR/.vimrc"
cpr vim/.vim "$INSTDIR/.vim"
fixuser "$INSTDIR/.vim"
cpr polybar "$CONFDIR/polybar"
fixuser "$CONFDIR/polybar"
cpr sxhkd "$CONFDIR/sxhkd"
fixuser "$CONFDIR/sxhkd"
cpr zsh/.zshrc "$INSTDIR/.zshrc"
fixuser "$INSTDIR/.zshrc"
cpr dmenurc "$CONFDIR/demenurc"
fixuser "$CONFDIR/dmenurc"
cpr mc "$CONFDIR/mc"
fixuser "$CONFDIR/mc"
cpr dunst "$CONFDIR/dunst"
fixuser "$CONFDIR/dunst"
cpr zathura "$CONFDIR/zathura"
fixuser "$CONFDIR/zathura"
mv "$CONFDIR/zathura/zathura.desktop" /usr/local/share/applications/.
cpr xorg/.xprofile "$INSTDIR/.xprofile"
fixuser "$INSTDIR/.xprofile"
cpr xorg/.xbindkeysrc "$INSTDIR/.xbindkeysrc"
fixuser "$INSTDIR/.xbindkeysrc"
cpr xorg/.Xresources "$INSTDIR/.Xresources"
fixuser "$INSTDIR/.Xresources"
cpr xorg/.XCompose "$INSTDIR/.XCompose"
fixuser "$INSTDIR/.XCompose"
cpr xorg/.Xkbmap "$INSTDIR/.Xkbmap"
fixuser "$INSTDIR/.Xkbmap"
cpr lightdm/lightdm.conf "/etc/lightdm/lightdm.conf"
cpr tmux/.tmux.conf "$INSTDIR/.tmux.confd"
mkdir -p "$INSTDIR/etc/"
cpr tmux "$INSTDIR/etc/tmux"
fixuser "$INSTDIR/etc"
cpr nvim "$CONFDIR/nvim"
fixuser "$CONFDIR/nvim"

mkdir tmp
fixuser tmp
cd tmp
# If the system uses pacman use the PKGBUILD
if which makepkg>/dev/null && which pacman >/dev/null ; then
  cp ../../st/PKGBUILD .
  cp ../../st/st-0.8.1-myconfig.diff .
  fixuser PKGBUILD
  fixuser st-0.8.1-myconfig.diff
  sudo -u $REALUSER makepkg -s
  pacman --noconfirm -Rn st
  pacman --noconfirm -U $(find . -maxdepth 1 -name "*.tar.xz")
else
  curl -s "http://dl.suckless.org/st/st-0.8.1.tar.gz" > st.tar.gz
  tar xzf st.tar.gz
  cd st-0.8.1
  cp ../../st/st-alpha-20180616-0.8.1.diff .
  patch <st-alpha-20180616-0.8.1.diff
  cp ../../st/st-0.8.1-myconfig.diff .
  patch <st-0.8.1-myconfig.diff
  make
  make install
fi

cd ../..
rm -rf tmp/

sudo -u "$REALUSER" ./setup/defaults.sh
