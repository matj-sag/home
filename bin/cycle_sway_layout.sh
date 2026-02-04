#!/bin/sh
ws_name=$(swaymsg -t get_outputs -r | jq -r '.[] | select(.focused==true) | .current_workspace')
# get layout for that workspace from the tree
CURRENT=$(swaymsg -t get_tree | jq -r --arg ws "$ws_name" '
  .. | objects
  | select(.type=="workspace" and .name==$ws)
  | .nodes[]? | select(.layout != null) | .layout
  ')


echo $CURRENT

case "$CURRENT" in
  "splith") swaymsg layout splitv ;;
  "splitv") swaymsg layout tabbed ;;
  "tabbed") swaymsg layout splith ;;
	*) swaymsg layout splitv ;;
esac
