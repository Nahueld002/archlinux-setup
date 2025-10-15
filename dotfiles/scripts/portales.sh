#!/bin/zsh
killall xdg-desktop-portal xdg-desktop-portal-hyprland xdg-desktop-portal-gtk
exec-once = dbus-update-activation-environment --systemd --all
/usr/lib/xdg-desktop-portal-hyprland &
/usr/lib/xdg-desktop-portal-gtk &
/usr/lib/xdg-desktop-portal &
