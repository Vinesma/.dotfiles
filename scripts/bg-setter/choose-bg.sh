#!/bin/bash

# Choose several options for wallpaper setting.
# Dependencies:
# feh, rofi, magick

wallpaper_dir="$HOME/Pictures/Wallpapers"
files_folder="$HOME/.dotfiles/scripts/bg-setter"
resolution=$(xrandr | grep '*' | awk '{printf $1}')
width=$(echo "$resolution" | cut -d 'x' -f 1)
height=$(echo "$resolution" | cut -d 'x' -f 2)

notify_time=2000
icon_error="/usr/share/icons/Papirus/32x32/status/dialog-error.svg"
icon_download="/usr/share/icons/Papirus/32x32/emblems/emblem-downloads.svg"

send-error() {
    notify-send -i "$icon_error"  -t "$notify_time" "choose-bg" "$1"
}

load-config() {
    if [[ -e "$files_folder/saturation" ]]; then
        saturation_amount=$(cat "$files_folder/saturation")
    else
        saturation_amount=1
    fi

#    if [[ -e "$files_folder/transparency" ]]; then
#        transparency_amount=$(cat "$files_folder/transparency")
#    else
#        transparency_amount=1
#    fi
}

set-saturation() {
    local value
    value=$(rofi -dmenu -p 'Saturation' -mesg "Type a value between 0.0 and 1.0" -lines 0)

    echo "$value" > "$files_folder/saturation"
}

set-transparency() {
    local value
    value=$(rofi -dmenu -p 'Transparency' -mesg "Type a value between 0.0 and 1.0" -lines 0)

    echo "$value" > "$files_folder/transparency"
}

clear-cache() {
    wal -c
}

resize-image() {
    local accepted
    local gravity
    accepted=1

    while [[ "$accepted" -eq 1 ]]; do
        gravity=$(echo -e "NorthWest\nNorth\nNorthEast\nWest\nCenter\nEast\nSouthWest\nSouth\nSouthEast" \
            | rofi -dmenu -only-match -p 'Center image at' -lines 9)

        if magick "$files_folder/output$1" \
            -resize "$width"x"$height"^ \
            -gravity "$gravity" \
            -extent "$width"x"$height" \
            "$files_folder/output-final$1"; \
        then
            accepted=$(feh -G \
                --action ';[Accept this image]echo 0' \
                --action1 ';[Reject and try again]echo 1' \
                --action2 ';[Exit]echo 3' \
                -F \
                "$files_folder/output-final$1")
            accepted=$(echo "$accepted" | tail -n 1)
        else
            send-error "Download failed or image conversion failed..."
            accepted=3
        fi
    done

    if [[ "$accepted" -eq 0 ]]; then
        filename="$wallpaper_dir/wallpaper-$RANDOM-$RANDOM-IMG$1"
        mv -f "$files_folder/output-final$1" "$filename"
        . "$files_folder/set-bg.sh" "$filename" --saturate "$saturation_amount" > "$files_folder/setbg-log"
    fi

    rm "$files_folder/output$1"
    rm "$files_folder/output-final$1"
}

download-image() {
    local link
    link=$(xclip -selection clipboard -o)

    if extension=$(echo "$link" | grep -o '\(\.jpg\|\.jpeg\|\.png\)'); then
        notify-send -i "$icon_download" "choose-bg" "Downloading image"

        if [[ "$link" == *i.pximg.net/* ]]; then
            # Handle pixiv links
            local pixiv_id
            local pixiv_ref
            pixiv_id=$(echo "$link" | cut -d '_' -f1 | grep -o "[0-9]\+\$")
            pixiv_ref="https://www.pixiv.net/en/artworks/$pixiv_id"

            curl -H "Referer: $pixiv_ref" -s "$link" -o "$files_folder/output$extension"
        else
            curl -s "$link" -o "$files_folder/output$extension"
        fi

        resize-image "$extension"
    else
        send-error "Unsupported link."
    fi
}

show-chooser() {
    local wallpaper
    wallpaper=$(feh -G -A ';[Choose this image]echo %F' --max-dimension "$width"x"$height" -d -F "$wallpaper_dir")
    wallpaper=$(echo "$wallpaper" | tail -n 1)

    if [[ -n "$wallpaper" ]]; then
        . "$files_folder/set-bg.sh" "$wallpaper" --saturate "$saturation_amount" > "$files_folder/setbg-log"
    fi
}

show-menu() {
    local option
    option=$(echo -e "1  Pick wallpapers\n2  Download image\n3  Clear cache\n4 Set saturation\n5 Set transparency\n6  Exit" \
        | rofi -dmenu -only-match -p 'option' -format 'd' -mesg "Saturation: $saturation_amount" -lines 6)

    case "$option" in
        1) show-chooser ;;
        2) download-image ;;
        3) clear-cache ;;
        4) set-saturation ;;
        5) set-transparency ;;
        *) exit ;;
    esac
}

while true; do
    load-config
    show-menu
done
