#!/bin/env bash

# Set the main command
MAIN_CMD="xrandr"  
CMD="--output xdn --mode xdm --pos xpos --rotate normal"

declare -a resolutions
get_res() {
	MAX_RES=$(xrandr | grep -A1 "$i" | tail -1 | cut -d" " -f4)
	resolutions+=("$MAX_RES")
}

# Calculate positional offset in relation to difference in res height
calculate_position_offset() {
	LEN=$(("${#resolutions[@]}" - 1))
	OFFSET=0

	for i in $(seq 0 $LEN); do
		V1=$(echo ${resolutions[$i]} | cut -d"x" -f2)
		V2=$(echo ${resolutions[$i-1]} | cut -d"x" -f2)
		OFFSET=$((V1 - V2))
	done
}

# Collect list of monitors
find_displays() {
	CONNECTED=$(xrandr | grep connected | grep -v disconnected | cut -d" " -f1)
}


# build expression for display x.
find_displays
declare -a displays

for i in $CONNECTED; do
	# Switch display off to have a clear state
	# when plugging monitors in and out
	#xrandr --output $i --off
	get_res "$i"

	CMD_=$(echo $CMD | sed s/xdn/$i/ | sed s/xdm/$MAX_RES/) 
	displays+=("$CMD_ ")
done

# re-enable primary display
find_displays

for i in $CONNECTED; do
	xrandr --output $i --auto
done

# Now apply the positional offset
CMD_=""
calculate_position_offset
for i in "${displays[@]}"; do
		CMD_+=$(echo "$i " | sed s/xpos/0x$OFFSET/)
		OFFSET=0 # NOT QUITE OPTIMAL I GUESS BUT SHOULD BE FINE
done

CMD_="$MAIN_CMD $CMD_--primary" 
RES="$(echo "${resolutions[0]}"|cut -d"x" -f1)x0"

# execute the command
$(echo $CMD_ | sed s/0x0/"$RES"/)

# Set some defaults for the system when it gets back on
xset r rate 170 70
#feh --bg-fill /usr/share/backgrounds/blackcat.jpg
feh --bg-fill ~/Pictures/NMVuvFj8p8UzKg1pDUuLcqnlt4Vs255bgYXYJ5X8jWc.jpg
#nitrogen --restore

