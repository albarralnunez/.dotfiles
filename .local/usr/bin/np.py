#!/usr/bin/env python3

import sys
import time
import gi
gi.require_version('Playerctl', '1.0')
from gi.repository import Playerctl, GLib  # noqa: E402


def get_player():
    player = Playerctl.Player()
    while not player.props.status:
        print('No player found', flush=True)
        player = Playerctl.Player()
        time.sleep(3)
    print(player.props.status, flush=True)
    return player

def on_exit(player, e, j):
    print('No player found', flush=True)

def on_metadata(player, e):
    if player.props.status == "Playing":
        meta = player.props.metadata
        print(
            '{artist} - {title}'.format(
                artist=meta['xesam:artist'][0],
                title=meta['xesam:title']),
            flush=True)
    else:
        # Print empty line if nothing is playing
        print(player.props.status, flush=True)


player = get_player()
player.on('metadata', on_metadata)
player.on('exit', on_exit)

# on_metadata(player, None)

main = GLib.MainLoop()
main.run()
