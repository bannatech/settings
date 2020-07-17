#!/bin/sh
[ "$1" = "nitter" ] && (xsel -ob | sed --posix -e 's@\(https\{0,1\}://\)nitter.net@\1twitter.com@g' | xsel -ib)
[ "$1" = "nitter" ] || (xsel -ob | sed --posix -e 's@\(https\{0,1\}://\)twitter.com@\1nitter.net@g' | xsel -ib)
