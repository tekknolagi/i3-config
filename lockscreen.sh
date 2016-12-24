#!/bin/bash

#scrot /tmp/screen_locked.png
#convert /tmp/screen_locked.png -scale 5% -scale 2000% /tmp/screen_locked2.png
#convert /tmp/screen_locked.png -blur 0x16 /tmp/screen_locked2.png
#i3lock -i /tmp/screen_locked2.png -d -f
i3lock --no-unlock-indicator --dpms --show-failed-attempts \
  --image=/home/max/Pictures/Wallpapers/yosemite1-blur-lock.png
