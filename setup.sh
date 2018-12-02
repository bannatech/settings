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
    rm -rf "$2"
    cp -r "$1" "$2"
}

fixuser () {
    chown -R -h "$REALUSER" "$1"
}

./setup/install.sh

INSTDIR="/home/$REALUSER"
CONFDIR="$INSTDIR/.config"

cpr bspwm "$CONFDIR/bspwm"
fixuser "$CONFDIR/bspwm"
cpr systemd "$CONFDIR/systemd"
fixuser "$CONFDIR/systemd"
cpr compton "$CONFDIR/compton"
fixuser "$CONFDIR/compton"
cpr irssi "$INSTDIR/.irssi"
fixuser "$INSTDIR/.irssi"
cpr mpv "$CONFDIR/mpv"
fixuser "$CONFDIR/mpv"
cpr mpd "$CONFDIR/mpd"
fixuser "$CONFDIR/mpd"
cpr emacs/.emacs "$INSTDIR/.emacs"
fixuser "$INSTDIR/.emacs"
cpr emacs "$INSTDIR/.emacs.d"
fixuser "$INSTDIR/.emacs.d"
rm "$INSTDIR/.emacs.d/.emacs"
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
cpr dunst "$CONFDIR/dunst"
fixuser "$CONFDIR/dunst"
cpr zathura "$CONFDIR/zathura"
fixuser "$CONFDIR/zathura"
cpr xorg/.xinitrc "$INSTDIR/.xinitrc"
fixuser "$INSTDIR/.xinitrc"
cpr xorg/.xbindkeysrc "$INSTDIR/.xbindkeysrc"
fixuser "$INSTDIR/.xbindkeysrc"
cpr xorg/.Xresources "$INSTDIR/.Xresources"
fixuser "$INSTDIR/.Xresources"
cpr xorg/.XCompose "$INSTDIR/.XCompose"
fixuser "$INSTDIR/.XCompose"
cpr tmux/.tmux.conf "$INSTDIR/.tmux.confd"
mkdir -p "$INSTDIR/etc/"
cpr tmux "$INSTDIR/etc/tmux"
rm "$INSTDIR/etc/tmux/.tmux.conf"
fixuser "$INSTDIR/etc"
mkdir tmp
cd tmp
curl -s "http://dl.suckless.org/st/st-0.8.1.tar.gz" > st.txz
tar xzf st.txz
cd st-0.8.1
cp ../../st/st-alpha-20180616-0.8.1.diff .
patch <st-alpha-20180616-0.8.1.diff
make
rm config.h
cp ../../st/config.h .
make
make install
cd ../..
rm -rf tmp/

sudo -u "$REALUSER" ./setup/defaults.sh
