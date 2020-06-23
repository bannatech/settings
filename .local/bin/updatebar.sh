#!/bin/sh

[ -e $HOME/.cache/dwmbar/bar.pid ] || exit 1
pid="$(cat $HOME/.cache/dwmbar/bar.pid)"
kill -ALRM $pid
