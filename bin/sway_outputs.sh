#!/usr/bin/env bash
# generate_sway_outputs.sh
# Generates sway output config lines from current layout

swaymsg -t get_outputs -r | jq -c '.[] | select(.active==true)' | \
while read output; do
    name=$(echo "$output" | jq -r '.name')
    res=$(echo "$output" | jq -r '.current_mode.width')x$(echo "$output" | jq -r '.current_mode.height')
    pos_x=$(echo "$output" | jq -r '.rect.x')
    pos_y=$(echo "$output" | jq -r '.rect.y')
    scale=$(echo "$output" | jq -r '.scale')
    transform=$(echo "$output" | jq -r '.transform')

    echo "output $name resolution $res position $pos_x,$pos_y scale $scale transform $transform"
done
