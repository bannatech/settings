#!/bin/sh

setd () {
    xdg-mime default "$1".desktop "$2"
}

setd zathura application/pdf
setd zathura application/x-pdf
setd zathura application/epub
setd feh image/png
setd feh image/tiff
setd feh image/jpg
setd mpv image/gif
setd mpv video/mp4
setd mpv video/avi
setd mpv video/mkv
setd mpv video/webm
setd mpv audio/flac
setd mpv audio/ogg
setd mpv audio/mp3
setd firefox x-scheme-handler/http
setd firefox x-scheme-handler/https
setd firefox x-scheme-handler/ftp
