#!/bin/bash

option=$(printf "Btop\nTtyper\nCava\nMomoisay" | rofi -dmenu)

case "$option" in
    "Btop") kitty --hold btop ;;
    "Ttyper") kitty --hold ttyper ;;
    "Cava") kitty --hold cava ;;
    "Momoisay") kitty --hold momoisay -f ;;
esac
