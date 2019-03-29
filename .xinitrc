#!/bin/sh

autorandr --load `autorandr --detected`

.local/usr/bin/polybar.sh

if [ -d $HOME/.config/autostart ] ; then
    for f in $HOME/.config/autostart/?*.sh ; do
        [ -x "$f" ] && . "$f"
    done
    unset f
fi

# Launch WM
exec xmonad

