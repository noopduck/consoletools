#!/bin/bash

#
# Written by noopduck 29-03-2020
# Dynamically configuring monitors, intended for use with i3wm
# Use in combination with 
# exec --no-startup-id srandrd ~/monitors.sh
# inside i3wm config, this will ensure that the scrip runs every time
# a change event occurr
#

relative_placement() {
	#1920x1080+0+360
	# In my particular case it's = 360 so --pos flag for eDP-1
	SUM=$((1440 - 1080))
	POS="--pos $SUM"
}

# Get all connected screens
SCREENS=$(xrandr | grep connected | grep -v disconnected)

SCR=""
while read -r line ; do
	SCREEN=$(echo $line | cut -d " " -f1)	
	SCR+="$SCREEN "
done < <(echo "$SCREENS")

EXPR_SCREENS=""
for s in $SCR; do
	EXPR_SCREENS+="--output $s --auto --rotate normal "
done

# Setting screens from left to right
n_scr=$(wc -w <<< "$SCR")
[ "$n_scr" -gt 1 ] && {
	echo "Dual monitors"
	EXPR_POSITION="--output holder0 --left-of holder1"
	POS=0
	for s in $SCR; do
		EXPR_POSITION=$(echo $EXPR_POSITION | sed "s/holder$POS/$s/")
		((POS++))	
	done

	sleep 0.5

	$(echo "xrandr $EXPR_SCREENS --primary $EXPR_POSITION")
	echo "xrandr $EXPR_SCREENS --primary $EXPR_POSITION" >> /tmp/monitors-$(date +"%Y%m%d").log

	sleep 0.5
	# Using nitrogen to set wallpaper correctly on the respective screens
	nitrogen --restore
} || { # Single monitor
	echo "SINGLE"
	SCREEN=$(xrandr | grep connected | grep -v disconnected | cut -d" " -f1)
	$(xrandr --output $SCREEN --primary)

	# Make sure that all the external displays are actually turned off
	SCREENS=$(xrandr | grep DP-)

	i=0
	while read -r line ; do
		SCREEN=$(echo $line | cut -d " " -f1)	
		[[ "$i" -gt "0" ]] && {
		    xrandr --output $SCREEN --off
		}
		let i++

	done < <(echo "$SCREENS")	
}

