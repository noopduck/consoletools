#!/bin/bash

# This script is used in Wayland SWAY (i3 WM derrived but it's built for wayland)
# It has me swayed!

while true; do 

	DATE="$(date)"
	BATT="$(upower -i $(upower -e | grep BAT) | grep --color=never -E "percentage" | xargs | sed s/percentage:/BATT/)";
	SIGNAL=$(/sbin/iwconfig wlp1s0 | grep "Link Quality" | xargs | sed s/Link\ Quality=/"Signal "/ | cut -d" " -f 1-2)


	echo "$SIGNAL | $BATT | $DATE"

	if [ ! $(ps -fe | grep sway | grep -v grep) ]; then
		pkill dmenu.sh
	fi

	sleep 2;
done

