#!/bin/sh

exists () {
    which "$1" > /dev/null 2> /dev/null
}

init() {
    if exists pacman ; then
	pacman --noconfirm -Syu
    elif exists apt ; then
	apt update ; apt -y upgrade
    elif exists apt-get ; then
	apt-get update ; apt-get -y upgrade
    else
	echo "No known package manager installed."
	exit 1
    fi
}

install() {
    if exists pacman ; then
	pacman --noconfirm -S "$1"
    elif exists apt ; then
	apt install -y "$1"
    elif exists apt-get ; then
	apt-get install -y "$1"
    else
	echo "No known package manager installed."
	exit 1
    fi
}

init
install emacs
install neovim
install bspwm
install polybar
install mc
install tff-inconsolata
install dmenu
install mpv
install tmux
install zathura
install zathura-mupdf
install irssi
install zsh
install zsh-syntax-highlighting
install zsh-autosuggestions
install curl
install compton
install mpv
install pulseaudio
install firefox
install feh
install ffmpeg
install scrot
install xclip
install xsel
install convert
install gcc
install make
install binutils
install xbindkeys
install xorg-xkbcomp
install dunst
install lightdm
