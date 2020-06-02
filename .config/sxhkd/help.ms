.TL
sxhxd Keybinds - dvorak version
.SH
Movement Commands
.LP
.IP "super  + j"
Go down in the priority stack.
.IP "super + k"
Go up in the priority stack.
.SH
Tag Controls
.LP
.IP "super + shift + c"
Kill active window.
.IP "super + {1-9}"
View the nth tag.
.IP "super + ctrl + {1-9}"
Toggle viewing of the nth tag.
.IP "super + 0"
View all tags.
.IP "super + shift + {1-9}"
Change the active window's tag.
.IP "super + shift + ctrl + {1-9}"
Toggle a tag on the active window.
.IP "super + shift + 0"
Tag the active window with all tags.
.IP "super + tab"
Change the active tag to the previously active tag.
.IP "super + {comma, period}"
Change the active tag to the tag left or right of the current tag.
.IP "super + i"
Increment the number of master windows in this tag.
.IP "super + d"
Decrement the number of master windows in this tag.
.SH
Window Controls
.LP
.IP "super + {l, h}"
Grow/shrink the amount of space the master window occupies.
.IP "super + enter"
Make the active window the master of the tag.
.IP "super + shift + {period, comma}
Move the active window one tag to the left or right.
.IP "super + alt + space"
Toggle the floating modifier on the active window.
.SH
Special WM keys
.LP
.IP "super + b"
Toggle dwm bar visibility.
.IP "super + space"
Run a program.
.IP "super + escape"
Reload hotkey daemon.
.IP "super + alt + q"
Exit xorg.
.IP "super + shift + b"
Reload the wallpapers.
.IP "super + alt + enter"
Launch a terminal.
.IP "super + x"
Swap contents of primary and clipboard x buffers.
.IP "super + F1"
Show this help file.
.IP "super + F2"
Check system info (conky)
.IP "super + e"
Put the window manager into a "Change layout mode"
.IP "t"
In change layout mode, change to a tiling layout.
.IP "n"
In change layout mode, change to no layout.
.IP "d"
In change layout mode, change to a dwindling layout.
.IP "m"
In change layout mode, change to a monocle layout.
.IP "s"
In change layout mode, change to a spiral layout.
.IP "b"
In change layout mode, change to a bottom stack layout.
.IP "h"
In change layout mode, change to a bottom horizontal stack layout.
.IP "e"
In change layout mode, change to a centered master stack layout.
.IP "f"
In change layout mode, change to a floating centered master stack layout.
.IP "c"
In change layout mode, change to a columns master stack layout.
.SH
Convience scripts
.LP
.IP "super + z"
Play a url with mpv.
.IP "super + shift + z"
Open whatever is in the primay clipboard with xdg-open.
.IP "super + -"
Bring up a calculator (uses bc).
.IP "super + shift + alt + enter"
Dmenu emoji select
.SH
Volume Control
.LP
.IP "super + v ; u"
Raise volume by 3%.
.IP "super + v ; d"
Lower volume by 3%.
.IP "super + v ; shift + u"
Raise volume by 10%.
.IP "super + v ; shift + d"
Lower volume by 10%.
.IP "super + v ; e"
Set volume to a specific value.
.IP "super + v ; t"
Toggle the mute state.
.IP "super + v ; m"
Mute all audio.
.IP "super + v ; shift + m"
Unmute all audio.
.IP "super + t"
Toggle MPD playback
.SH
Screenshots
.LP
.IP "super + a ; s"
Take a screenshot of an area and put it in the clipboard.
.IP "super + a ; shift + s"
Take a screenshot of an area and put it in a file.
.IP "super + a ; f"
Take a screenshot of the focused window and put it in the clipboard.
.IP "super + a ; shift + f"
Take a screenshot of the focused window and put it in a file.
.IP "super + a ; z"
Take a screenshot of the x session and put it in the clipboard.
.IP "super + a ; shift + z"
Take a screenshot of the x session and put it in a file.
.SH
Screencasts
.LP
.IP "super + r ; r"
Record a screencast of an area and save it to a specified file.
.IP "super + r ;  shift + r"
Record a screencast of an area and save it to a mp4 file named with the current time.
.IP "super + r ; w"
Record a screencast of a window and save it to a specified file.
.IP "super + r ; shift + w"
Record a screencast of a windov and save it to a mp4 file named with the current time.
.IP "super + r ; k"
Stop recording and save the screencast (saving depends on how cast was started).
.IP "super + r ; alt + r"
Record a screencast of a selection in a specified framerate.
.IP "super + r ; alt + w"
Record a screencast of the window in a specified framerate.
