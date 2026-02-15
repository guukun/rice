#!/bin/bash
set -e

WALLDIR="$HOME/Pictures/Wallpapers"
CACHEDIR="$HOME/.cache/wallpaper-thumbs"
ROFI_THEME="$HOME/.config/rofi/wallpaper.rasi"

mkdir -p "$CACHEDIR"

gen_thumb() {
    local img="$1"
    local name
    local thumb

    name="$(basename "$img")"
    thumb="$CACHEDIR/$name.png"

    if [ ! -f "$thumb" ]; then
        magick "$img" \
            -resize 256x256^ \
            -gravity center \
            -extent 256x256 \
            "$thumb"
    fi

    # rofi icon protocol
    printf '%s\0icon\x1f%s\n' "$name" "$thumb"
}

SELECTED=$(
    find "$WALLDIR" -type f \( \
        -iname "*.jpg"  -o -iname "*.jpeg" \
        -o -iname "*.png" \
        -o -iname "*.webp" \
        -o -iname "*.avif" \
    \) \
    | sort \
    | while read -r img; do
        gen_thumb "$img"
    done \
    | rofi -dmenu \
           -show-icons \
           -p "Wallpaper" \
           -theme "$ROFI_THEME"
)

[ -z "$SELECTED" ] && exit 0

WALL="$WALLDIR/$SELECTED"
[ ! -f "$WALL" ] && exit 1

# Apply wallpaper
swww img "$WALL" \
    --transition-type wipe \
    --transition-duration 3

# Generate color scheme
matugen image "$WALL"

# Restart affected components
pkill waybar && waybar &
pkill swaync && swaync &
pkill rofi
spicetify apply && pkill spicetify

# Reload Hyprland
hyprctl reload
