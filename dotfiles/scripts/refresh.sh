#!/bin/zsh

# Reinicia Hyprland (recarga configs)
hyprctl reload

# Reinicia Waybar
killall -9 waybar
waybar &
