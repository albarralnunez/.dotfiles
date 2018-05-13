#!/bin/bash

xautolock -time 10 -locker "lock.sh" -notify 15 -notifier "notify-send -t 5000 -i gtk-dialog-info 'Locking in 15 seconds'" &
