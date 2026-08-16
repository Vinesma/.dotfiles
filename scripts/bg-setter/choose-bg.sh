#!/usr/bin/env bash

# Choose several options for wallpaper setting.
# Dependencies:
# feh, rofi/wofi, magick, matugen

wallpaper_dir="$HOME/Pictures/Wallpapers"
files_folder="$HOME/.dotfiles/scripts/bg-setter"
session_wrofi="$HOME/.dotfiles/scripts/helpers/session-wrofi.sh"
# shellcheck disable=SC2063
resolution=$(hyprctl monitors | grep 'ID 0' -A 1 | tail -n 1 | cut -d @ -f1 | awk '{printf $1}')
width=$(echo "$resolution" | cut -d 'x' -f 1)
height=$(echo "$resolution" | cut -d 'x' -f 2)

notify_time=2000
icon_error="/usr/share/icons/Papirus/32x32/status/dialog-error.svg"
icon_download="/usr/share/icons/Papirus/32x32/emblems/emblem-downloads.svg"

# shellcheck source=../helpers/session-wrofi.sh
source "$session_wrofi"

send-error() {
    notify-send -i "$icon_error"  -t "$notify_time" "choose-bg" "$1"
}

set-backend() {
    local value
    local wrofi_args

    wrofi_args=(\
        "-p" "Backend"
        "-mesg" "Which color generation backend to use?" \
        "-theme-str" "listview {lines: 5;}")

    value=$(wal --backend | sed '1d' | cut -d ' ' -f 3- | wrofi-switch "${wrofi_args[@]}")

    echo "$value" > "$files_folder/backend"
}

new-theme-notification() {
    local icon_image
    icon_image="/usr/share/icons/Papirus/32x32/apps/multimedia-photo-viewer.svg"
    notify-send -i "$icon_image" "Wallpaper" "New background and theme set."
}

create-filename() {
    local extension
    extension=$1
    if [[ -n $img_id ]]; then
        filename="$wallpaper_dir/wallpaper-pixiv_id-$img_id$extension"
    else
        filename="$wallpaper_dir/wallpaper-$RANDOM-$RANDOM-IMG$extension"
    fi
}

resize-image() {
    local accepted
    local gravity
    local extension
    local gravity_options
    local wrofi_args
    accepted=1
    extension=$1
    gravity_options=(\
        "NorthWest" \
        "North" \
        "NorthEast" \
        "West" \
        "Center" \
        "East" \
        "SouthWest" \
        "South" \
        "SouthEast")

    wrofi_args=(\
        "-p" "Center image at"
        "-theme-str" "listview {lines: 9;}" \
        "-no-show-icons" \
        "-select" "Center")

    while [ "$accepted" -eq 1 ]; do
        gravity=$(printf "%s\n" "${gravity_options[@]}" | wrofi-switch "${wrofi_args[@]}")

        if magick "/tmp/bg-setter-img$extension" \
            -resize "$width"x"$height"^ \
            -gravity "$gravity" \
            -extent "$width"x"$height" \
            "/tmp/bg-setter-img-final$extension"; \
        then
            accepted=$(feh -G \
                --action ';[Accept this image]echo 0' \
                --action1 ';[Reject and try again]echo 1' \
                --action2 ';[Exit]echo 3' \
                -F \
                "/tmp/bg-setter-img-final$extension")
            accepted=$(echo "$accepted" | tail -n 1)
        else
            send-error "Download failed or image conversion failed..."
            accepted=3
        fi
    done

    if [ "$accepted" -eq 0 ]; then
        create-filename "$extension"
        mv -f "/tmp/bg-setter-img-final$extension" "$filename"
        matugen image --prefer=lightness "$filename"
        new-theme-notification
        sleep 1
    fi
}

download-image() {
    local link
    link=$(wl-paste -n)

    if extension=$(echo "$link" | grep -o '\(\.jpg\|\.jpeg\|\.png\)'); then
        notify-send -i "$icon_download" "choose-bg" "Downloading image"

        if [[ "$link" == *i.pximg.net/* ]]; then
            # Handle pixiv links
            local pixiv_ref
            img_id=$(echo "$link" | cut -d '_' -f1 | grep -o "[0-9]\+\$")
            pixiv_ref="https://www.pixiv.net/en/artworks/$img_id"

            curl -H "Referer: $pixiv_ref" -s "$link" -o "/tmp/bg-setter-img$extension"
        else
            curl -s "$link" -o "/tmp/bg-setter-img$extension"
        fi

        resize-image "$extension"
    else
        send-error "Unsupported link."
    fi
}

show-chooser() {
    local wallpaper
    wallpaper=$(feh -G -A ';[Choose this image]echo %F' --min-dimension "$width"x"$height" -d -F "$wallpaper_dir")
    wallpaper=$(echo "$wallpaper" | tail -n 1)

    if [[ -n "$wallpaper" ]]; then
        matugen image --prefer=lightness "$wallpaper"
        new-theme-notification
    fi
}

show-menu() {
    local option
    local menu_options
    local wrofi_args
    menu_options=("1  Exit" "2  Pick wallpapers" "3  Download image")

    wrofi_args=(\
        "-theme-str" "listview {lines: 3;}" \
        "-no-show-icons")

    option=$(printf "%s\n" "${menu_options[@]}" | wrofi-switch "${wrofi_args[@]}")

    case "$option" in
        "${menu_options[1]}") show-chooser ;;
        "${menu_options[2]}") download-image ;;
        *) exit ;;
    esac
}

while true; do
    show-menu
done
