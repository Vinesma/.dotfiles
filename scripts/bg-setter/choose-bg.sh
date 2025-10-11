#!/usr/bin/env bash

# Choose several options for wallpaper setting.
# Dependencies:
# feh, rofi/wofi, magick

wallpaper_dir="$HOME/Pictures/Wallpapers"
files_folder="$HOME/.dotfiles/scripts/bg-setter"
session_wrofi="$HOME/.dotfiles/scripts/helpers/session-wrofi.sh"
# shellcheck disable=SC2063
resolution=$(xrandr | grep '*' | head -n 1 | awk '{printf $1}')
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

load-config() {
    if [[ -e "$files_folder/saturation" ]]; then
        saturation_amount=$(< "$files_folder/saturation")
    else
        saturation_amount=1
    fi

    if [[ -e "$files_folder/backend" ]]; then
        backend=$(< "$files_folder/backend")
    else
        backend=wal
    fi
}

set-saturation() {
    local value
    local wrofi_args

    if [ "$XDG_SESSION_TYPE" != "wayland" ]; then
        wrofi_args=(\
            "-p" "Saturation"
            "-mesg" "Type a value between 0.0 and 1.0" \
            "-theme-str" "listview {lines: 1;}")
    else
        wrofi_args=(\
            "-p" "[Saturation]: Type a value between 0.0 and 1.0"
            "--lines" "1"
        )
    fi

    value=$(wrofi-switch "${wrofi_args[@]}")

    echo "$value" > "$files_folder/saturation"
}

set-backend() {
    local value
    local wrofi_args

    if [ "$XDG_SESSION_TYPE" != "wayland" ]; then
        wrofi_args=(\
            "-p" "Backend"
            "-mesg" "Which color generation backend to use?" \
            "-theme-str" "listview {lines: 5;}")
    else
        wrofi_args=(\
            "-p" "[Backend]: Which color generation backend to use?"
            "--lines" "6"
        )
    fi

    value=$(wal --backend | sed '1d' | cut -d ' ' -f 3- | wrofi-switch "${wrofi_args[@]}")

    echo "$value" > "$files_folder/backend"
}

clear-cache() {
    wal -c
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

create-display-manager-image() {
    local filename
    local extension
    local final_name
    local lightdm_wallpaper_dir
    filename=$1
    extension=$2
    final_name="$wallpaper_dir/display-manager-bg$extension"
    lightdm_wallpaper_dir=/usr/share/wallpapers

    if [ ! -d $lightdm_wallpaper_dir ]; then
        send-error "Could not find '${lightdm_wallpaper_dir}'\nMake sure the directory exists and run chmod 777 on it."
    else
        magick "$filename" -blur 10x5 -brightness-contrast -15 "$final_name" \
        && mv -f "$final_name" "${lightdm_wallpaper_dir}/display-manager-bg"
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

    if [ "$XDG_SESSION_TYPE" != "wayland" ]; then
        wrofi_args=(\
            "-p" "Center image at"
            "-theme-str" "listview {lines: 9;}" \
            "-no-show-icons" \
            "-select" "Center")
    else
        wrofi_args=(\
            "-p" "Center image at:"
            "--lines" "10"
        )
    fi

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
        create-display-manager-image "$filename" "$extension"
        # shellcheck source=/dev/null
        . "$files_folder/set-bg.sh" "$filename" --saturate "$saturation_amount" --backend "$backend" > "$files_folder/setbg-log"
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
        # shellcheck source=/dev/null
        . "$files_folder/set-bg.sh" "$wallpaper" --saturate "$saturation_amount" --backend "$backend" > "$files_folder/setbg-log"
        create-display-manager-image "$wallpaper" ".${wallpaper##*.}"
    fi
}

show-menu() {
    local option
    local menu_options
    local wrofi_args
    menu_options=("1  Exit" "2  Pick wallpapers" "3  Download image" "4  Clear cache" "5 Set saturation" "6 Set backend")

    if [ "$XDG_SESSION_TYPE" != "wayland" ]; then
        wrofi_args=(\
            "-mesg" \
            "Saturation: $saturation_amount | Backend: $backend" \
            "-theme-str" "listview {lines: 6;}" \
            "-no-show-icons")
    else
        wrofi_args=(\
            "-p" "Saturation: $saturation_amount | Backend: $backend"
            "--lines" "7"
        )
    fi

    option=$(printf "%s\n" "${menu_options[@]}" | wrofi-switch "${wrofi_args[@]}")

    case "$option" in
        "${menu_options[1]}") show-chooser ;;
        "${menu_options[2]}") download-image ;;
        "${menu_options[3]}") clear-cache ;;
        "${menu_options[4]}") set-saturation ;;
        "${menu_options[5]}") set-backend ;;
        *) exit ;;
    esac
}

while true; do
    load-config
    show-menu
done
