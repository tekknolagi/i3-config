#!/usr/bin/env bash

# Colour names
WHITE=ffffff
LIME=00ff00
GRAY=666666
YELLOW=ffff00
MAROON=cc3300

# Set delimiter to just newlines, instead of any white space
IFS=$'\n'

# text <string> <colour_name>
function text { output+=$(echo -n '{"full_text": "'${1//\"/\\\"}'", "color": "#'${2-$WHITE}'", "separator": false, "separator_block_width": 1}, ') ;}

# sensor <device> <sensor>
function sensor { echo "$SENSORS" | awk '/^'${1}'/' RS='\n\n' | awk -F '[:. ]' '/'${2}':/{print$5}' ;}

# getloadavg <uptime_output>
function getloadavg { echo ${1} | grep -oP 'load average:\s*\K(.*)' | tr -s ' ' ;}

# getuptime <uptime_output>
function getuptime { echo ${1} | grep -oP 'up\s*\K(\w+)\s+(\w+)' ;}

# getdiskavail
function getdiskavail { df -h | grep sda5 | tr -s ' ' | cut -d" " -f4 ;}

# getbattery
function getbattery { acpi | cut -d " " -f3,4 | tr -d ',' ;}

# getip <interface>
function getip { ip addr show ${1} | grep inet | head -1 \
    | grep -oP 'inet\K\s(\d+\.\d+\.\d+\.\d+)' | cut -d" " -f2 ;}

echo -e '{ "version": 1 }\n['
while :; do
    # WINDOW=( $(xprop -id $(xprop -root _NET_ACTIVE_WINDOW | cut -d\  -f5) _NET_WM_NAME WM_CLASS | sed 's/.*\ =\ "\|\",\ \".*\|"$//g;s/\\\"/"/g') )
    SENSORS="$(sensors -Au)"
    CPU=$(sensor acpitz-virtual-0 temp1_input) # amdk10
    RAM=$(awk '/MemTotal:/{total=$2}/MemAvailable:/{free=$2;print int(100-100/(total/free))}' /proc/meminfo)
    MB1=$(sensor temp1_input)
    MB1=$(sensor coretemp-isa-0000 temp2_input)
    # MB2=$(sensor asus-isa-0000 temp3_input)
    DATE=$(date "+%Y-%m-%d %H:%M")
    UPTIME=$(uptime)
    LOADAVG=$(getloadavg ${UPTIME})
    UPTIMETIME=$(getuptime ${UPTIME})
    DISKAVAIL=$(getdiskavail)
    BATTREMAIN=$(getbattery)
    WIRELESSIP=$(getip wlp2s0)
    WIREDIP=$(getip enx00e04c68013e)

    output=''
    # text ${WINDOW[1]}\  $GRAY
    # text ${WINDOW[0]}
    if [ -n "$WIREDIP" ]; then
        text ' eth ' $GRAY
        text "$WIREDIP"
    else
        text ' wlan ' $GRAY
        text "$WIRELESSIP"
    fi
    text ' disk ' $GRAY
    text "$DISKAVAIL"
    text ' up ' $GRAY
    text "$UPTIMETIME"
    text ' load ' $GRAY
    text "$LOADAVG"
    text " $BATTREMAIN" $YELLOW
    text ' CPU ' $GRAY
    text "$CPU°c"
    text ' RAM ' $GRAY
    text "$RAM%"
    text ' MB ' $GRAY
    text "$MB1°c"
    text ' | ' $GRAY
    # text "$MB2"
    # text ' ☕ ' $MAROON
    text "$DATE"
    echo -e "[${output%??}],"
    sleep 5
done
