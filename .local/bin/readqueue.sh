#!/bin/sh

# Idea of script: sit suspended until SIGUSR1,
# then read a file of urls and download them.
# Note that my downloads is a tmpfs, but I assume
# I'll want to keep these videos after reboot
# (for example queueing up videos for a trip)
# so they go in ~/video/downloads so my video folder doesn't get cluttered

# bestvideo,bestaudio DL'd two files
YDLOPT='-icq -f best[width<=1080]'

# arguments are: done file, url
function queuedl () {
  [ -z "$2" ] && return 1
  [ "$#" -le 1 ] && return 1
  [ "$#" -ge 3 ] && return 1

  pushd ~/Downloads >/dev/null 2>&1
  mkdir -p ~/video/download
  local title="$(youtube-dl $YDLOPT --get-title "$2" 2>/dev/null | sed -n 1p)"
  local id="$(youtube-dl $YDLOPT --get-id "$2" 2>/dev/null | sed -n 1p)"
  notify-send "YDL Queue" "Downloading $2 ($title) to ~/Downloads"

  if youtube-dl $YDLOPT -o "${title}_$id.%(ext)s" "$2" 2>/dev/null ; then
    echo "title: $title"
    name="$(find . -name "${title}_$id.*" | sed -n 1p)"
    find . -name "${title}_$id.*"
    name="${name##*/}"
    notify-send "YDL Queue" "Finished downloading ~/Downloads/$name, moving to ~/video/download/$name"
    mv "$HOME/Downloads/$name" "$HOME/video/download/$name"
    echo "$2" >> "$1"
  else
    notify-send -u critical "YDL Queue" "Error downloading $2"
  fi

  popd >/dev/null 2>&1
  return 0
}

# check for things left over
if [ -s "$XDG_CACHE_HOME/ydlqueue" ] ; then
  diffed="$(mktemp "$XDG_RUNTIME_DIR/tmp.XXXXXX")"
  diff -N "$XDG_CACHE_HOME/ydlqueue" "$XDG_CACHE_HOME/ydlqueue_finished" \
    | grep "^<" | sed "s/^< //" | grep -v '^[[:space:]]+$' \
  | while IFS= read -r line; do
    queuedl "$XDG_CACHE_HOME/ydlqueue_finished" "$line"
  done
fi

rm -f "$XDG_CACHE_HOME/ydlqueue" "$XDG_CACHE_HOME/ydlqueue_finished"

# Make a random fifo and hope reading from it just suspends the proc
tmp="$(mktemp -u "$XDG_RUNTIME_DIR/tmp.XXXXXXXXXXX")"
mkfifo -m 600 "$tmp"

trap "rm $tmp ; exit 1" TERM

while /bin/true; do
  # I think the read on a fifo isn't a spinlock and the process is suspendend
  # try to read from fifo, killing the read on USR1
  quit=0
  # Hopefully, the read is idle, the wait suspends, so this is not a spinlock
  # the inner while makes writing to the fifo not fatal
  while [ "$quit" != "1" ]; do
    [ -p "$tmp" ]|| (rm -f "$tmp" ; mkfifo -m 600 "$tmp")
    # Do this to change the process name
    sh -c "exec read < \"$tmp\"" & PID=$!
    trap "quit=1 ; kill $PID" USR1
    wait # wait for read to be killed
  done

  if [ -s "$XDG_RUNTIME_DIR/ydlqueue" ]; then
    # My RSS feeder uses nitter to get tweets, but ydl fails to download them currently.
    # Luckily, the use the same path after the URL
    sed 's@^\(https\{0,1\}://\)nitter.net@\1twitter.com@' "$XDG_RUNTIME_DIR/ydlqueue" > "$XDG_CACHE_HOME/ydlqueue"
    rm "$XDG_RUNTIME_DIR/ydlqueue"
    echo >> "$XDG_CACHE_HOME/ydlqueue" # add trailing newline for read
    while IFS= read -r line; do
      (echo "$line" | grep -v '^[[:space:]]\+$' -q) && queuedl "$XDG_CACHE_HOME/ydlqueue_finished" "$line"
    done < "$XDG_CACHE_HOME/ydlqueue"
    rm -f "$XDG_CACHE_HOME/ydlqueue" "$XDG_CACHE_HOME/ydlqueue_finished"
  fi
done

