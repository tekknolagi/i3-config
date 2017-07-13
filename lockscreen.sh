#!/bin/bash

#scrot /tmp/screen_locked.png
#convert /tmp/screen_locked.png -scale 5% -scale 2000% /tmp/screen_locked2.png
#convert /tmp/screen_locked.png -blur 0x16 /tmp/screen_locked2.png
#i3lock -i /tmp/screen_locked2.png -d -f

# file must be 1920x180 -- use convert -resize "1920x1080"
WALLPAPER_IMG="japan_1980s.png"
i3lock --dpms --show-failed-attempts --tiling \
  --image="/home/max/Pictures/Wallpapers/${WALLPAPER_IMG}"
