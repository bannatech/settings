#!/bin/sh

clock=$(date '+%I')

case "$clock" in
	"00") icon="🕛" ;;
	"01") icon="🕐" ;;
	"02") icon="🕑" ;;
	"03") icon="🕒" ;;
	"04") icon="🕓" ;;
	"05") icon="🕔" ;;
	"06") icon="🕕" ;;
	"07") icon="🕖" ;;
	"08") icon="🕗" ;;
	"09") icon="🕘" ;;
	"10") icon="🕙" ;;
	"11") icon="🕚" ;;
	"12") icon="🕛" ;;
esac

echo -n "$icon"

case $BLOCK_BUTTON in
  1) notify-send "gettime.sh" "value 1" ;;
  2) notify-send "gettime.sh" "value 2" ;;
  3) notify-send "gettime.sh" "value 3" ;;
  6) notify-send "gettime.sh" "value 6" ;;
esac

date "+%a %d %b %y, %H:%M"
