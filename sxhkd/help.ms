.TL
sxhxd Keybinds - dvorak version
.SH
Movement Commands
.LP
.IP "super + {h,t,n,s}"
Move focus left, up, down, or right.
.IP "super + shift + {h,t,n,s}"
Move node left, up, down, or right.
.IP "super + p"
Move focus to the parent node.
.IP "super + b"
Move focus to the brother node.
.IP "super + l"
Move focus to the first child.
.IP "super + ."
Move focus to the second child.
.IP "super + `"
Focus the last node that was focused before the current one.
.IP "super + {left, right, up, down}"
Move a floating node.
.SH
Desktop Controls
.LP
.IP "super + c"
Focus the next node in this desktop.
.IP "super + shift + c"
Focus the previous node in this desktop.
.IP "super + {0-9}"
Go to the nth desktop (by order of creation). 0 is desktop #10.
.IP "super + shift + {0-9}"
Send a node to the nth desktop. 0 is desktop #10.
.IP "super + ="
Go to desktop by name, creating the desktop if necessary.
.IP "super + alt + ="
Remove desktop by name.
.IP "super + ctrl + ="
Rename current desktop.
.IP "super + /"
Send node to a desktop using the desktop name.
.IP "super + alt + /"
Send node to a desktop using the name and follow the node to the desktop.
.IP "super + tab"
Switch to previously focused desktop (on any monitor).
.IP "super + ["
Switch to the next desktop on this monitor.
.IP "super + ]"
Switch to the previous desktop on this monitor.
.IP "super + m"
Swap desktop between monocled and tiled layout.
.IP "super + ctrl + space"
Clear all node preselections in the current desktop.
.SH
Monitor Controls
.LP
.IP "super + ctrl + /"
Send node to the active desktop on a particular monitor.
.IP "super + ctrl + alt + /"
Send node to a monitor and follow it there.
.IP "super + shift + m"
Focus the next monitor.
.SH
Node Controls
.LP
.IP "super + ctrl + {h,t,n,s}"
Preselect a node split to be in a direction.
.IP "super + ctrl + {1-9}"
Preset the ratio for a node split.
.IP "super + ctrl + space"
Clear direction preselect
.IP "super + ,"
Close focused node.
.IP "super + shift + ,"
Kill the focused node.
.IP "super + g"
Swap the current node and the biggest node.
.IP "super + y"
Make the current node tiled.
.IP "super + shift + y"
Make the current node pseudo tiled.
.IP "super + f"
Make the current node fullscreen.
.IP "super + shift + f"
Make the current node floating.
.IP "super + alt + {h,t,n,s}"
Resize a tiled node by moving a side outward.
.IP "super + alt + shift + {h,t,n,s}"
Resize a tiled node by moving a side inward.
.IP "super + ctrl + m"
Mark the current node.
.IP "super + ctrl + x"
Lock the current node.
.IP "super + ctrl + y"
Make the current node sticky.
.IP "super + ctrl + z"
Make the current node private.
.IP "super + o"
Focus a node 1 older in the focus history.
.IP "super + i"
Focus a node 1 newer in the focus history.
.SH
Special WM keys
.LP
.IP "super + space"
Run a program.
.IP "super + alt + space"
Toggle between dvorak and qwerty. Changes x keyboard map and WM hotkeys.
.IP "super + escape"
Reload hotkey daemon.
.IP "super + alt + escape"
Exit xorg.
.IP "super + shift + b"
Reload the wallpapers.
.IP "super + enter"
Launch a terminal.
.IP "super + '"
Clear messages on polybar.
.IP "super + x"
Swap contents of primary and clipboard x buffers.
.IP "super + shift + /"
Show this help file.
.SH
Convience scripts
.LP
.IP "super + z"
Play a url with mpv.
.IP "super + -"
Bring up a calculator (uses julia).
.IP "super + alt + enter"
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
