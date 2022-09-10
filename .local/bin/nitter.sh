#!/bin/sh
[ "$1" = "nitter" ] && (xsel -ob | sed --posix -e 's@\(https\{0,1\}://\(www\.\)\{0,1\}\)nitter.net@\1twitter.com@g ; s@\(https\{0,1\}://\(www\.\)\{0,1\}\)invidiou.site@\1youtube.com@g' | xsel -ib)
[ "$1" = "nitter" ] || (xsel -ob | sed --posix -e 's@\(https\{0,1\}://\(www\.\)\{0,1\}\)twitter.com@\1nitter.net@g ; s@\(https\{0,1\}://\(www\.\)\{0,1\}\)youtube.com@\1invidiou.site@g' | xsel -ib)
