#!/bin/bash

option=$(printf "Wallpapers\nPlaygoround\nPower Menu\nAbout" | rofi -dmenu)

case "$option" in
    "Wallpapers") ~/.config/hypr/scripts/changewp.sh ;;
    "Playgoround") ~/.config/hypr/scripts/playground.sh ;;
    "Power Menu") ~/.config/hypr/scripts/power-menu.sh ;;
    "About") kitty --hold fastfetch 
esac
