#!/bin/sh


mpdcmd() {
  "$HOME/.local/bin/mpd.sh"
}

backupactive() {
  [ -f "/var/run/backupdisk.sh" ] && echo "Backup running | "
}

i3status | while :
do
  read -r line
  mpdstatus="$(mpdcmd)"
  backupstatus="$(backupactive)"

  if [ -n "$mpdstatus" ] ; then
    echo "$backupstatus$mpdstatus | $line" || exit 1
  else
    echo "$backupstatus$line" || exit 1
  fi
done
