#!/bin/sh

# Idea of script: sit suspended until SIGUSR1,
# then read a file of urls and download them.

ionice -c 3 -p $$
renice +12 -p $$

# User agent must be set to this for some description bug
USERAGT="Mozilla/5.0 (compatible; Googlebot/2.1;+http://www.google.com/bot.html)"
FORMAT="bestvideo[height<=1080]+bestaudio/best[height<=1080]/bestvideo+bestaudio/best"

# arguments are: done file, url
function queuedl () {
  [ -z "$2" ] && return 1
  [ "$#" -le 1 ] && return 1
  [ "$#" -ge 3 ] && return 1

  url="$(echo "$line" | cut -f1)"
  direc="$(echo "$line" | cut -f2)"

  [ "$direc" = "." ] && direc="$HOME/Downloads"

  pushd "$direc" >/dev/null 2>&1

  local title="$(youtube-dl --get-title "$url" 2>/dev/null | sed -n 1p | sed 's@/@_@g')"
  local id="$(youtube-dl --get-id "$url" 2>/dev/null | sed -n 1p)"
  notify-send "YDL Queue" "Downloading $url ($title) to $direc"

  if youtube-dl -f "$FORMAT" --user-agent "$USERAGT" -icq -o "${title}_$id.%(ext)s" --add-metadata "$url"  2>/dev/null ; then
    name="$(find . -name "${title}_$id.*" | sed -n 1p)"
    name="${name##*/}"
    notify-send "YDL Queue" "Finished downloading $direc/$name"
    echo "$2" >> "$1"
  else
    notify-send -u critical "YDL Queue" "Error downloading $title"
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
  rm "$diffed"
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
    # This: adds a failsafe \t. in case no move dir is specifieda
    # translates nitter links to twitter
    # paste doesn't quit if I use `yes $'\t.'`, the lines must be right
    sed "c ." "$XDG_RUNTIME_DIR/ydlqueue" | paste "$XDG_RUNTIME_DIR/ydlqueue" - |\
      sed 's@^\(https\{0,1\}://\)nitter.net@\1twitter.com@' > "$XDG_CACHE_HOME/ydlqueue"
    rm "$XDG_RUNTIME_DIR/ydlqueue"
    echo >> "$XDG_CACHE_HOME/ydlqueue" # add trailing newline for read
    while IFS= read -r line; do
      (echo "$line" | grep -v '^[[:space:]]\+$' -q) && queuedl "$XDG_CACHE_HOME/ydlqueue_finished" "$line"
    done < "$XDG_CACHE_HOME/ydlqueue"
    rm -f "$XDG_CACHE_HOME/ydlqueue" "$XDG_CACHE_HOME/ydlqueue_finished"
  fi
done

