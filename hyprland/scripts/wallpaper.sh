#!/usr/bin/env bash
#
# Set the wallpaper in Wayland

gen_display_manager_image=
wallpaper_path=

if [ $# -eq 0 ]; then
  printf "%s\n" "No options passed to script. This script requires at least the path to an image to work."
  exit 1
fi

while :; do
    case $1 in
        -p|--image-path)        # Wallpaper image path
            wallpaper_path=$2
            shift
            ;;
        -g|--generate-dp-image) # Generate display manager image
            gen_display_manager_image=true
            ;;
        --)                     # End of all options.
            shift
            break
            ;;
        -?*)
            printf 'WARN: Unknown option (ignored): %s\n' "$1" >&2
            ;;
        *)
            break
    esac

    shift
done

WALLPAPER_DIR="$HOME/Pictures/Wallpapers"
WALLPAPER_PATH=$wallpaper_path
WALLPAPER_SETTER=swaybg

killall -q "$WALLPAPER_SETTER"

"$WALLPAPER_SETTER" -i "$WALLPAPER_PATH" & disown

if [[ -n $gen_display_manager_image ]]; then
    filename=$WALLPAPER_PATH
    extension=".${WALLPAPER_PATH##*.}"
    final_name="$WALLPAPER_DIR/display-manager-bg$extension"
    lightdm_wallpaper_dir=/usr/share/wallpapers

    if [ ! -d $lightdm_wallpaper_dir ]; then
        send-error "Could not find '${lightdm_wallpaper_dir}'\nMake sure the directory exists and run chmod 777 on it."
    else
        magick "$filename" -blur 10x5 -brightness-contrast -15 "$final_name" \
        && mv -f "$final_name" "${lightdm_wallpaper_dir}/display-manager-bg"
    fi
fi
