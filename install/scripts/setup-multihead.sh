#!/usr/bin/env bash
#
# Setup autorandr hooks for multiple monitors

WORK_DIR=$HOME/.config/autorandr
POSTSWITCH_EXTRA_DIR=$WORK_DIR/postswitch.d
PREDETECT_SCRIPT=$WORK_DIR/predetect
POLYBAR_SCRIPT=$HOME/.dotfiles/polybar/launch.sh

# -- SETUP --
mkdir -p "$WORK_DIR"

# -- ACT --

# predetect hook
printf "%s\n" \
    '#!/usr/bin/env bash' \
    "sleep 1" > "$PREDETECT_SCRIPT"

# wallpaper setter hook
# shellcheck disable=SC2016
if command -v feh &> /dev/null; then
    printf "%s\n" \
        'feh --bg-scale "$(< "${HOME}/.cache/wal/wal")" &' \
        > "$POSTSWITCH_EXTRA_DIR/set-wallpaper" \
        && chmod 777 "$POSTSWITCH_EXTRA_DIR/set-wallpaper"
fi

# polybar hook
if command -v polybar &> /dev/null; then
    mkdir -p "$POSTSWITCH_EXTRA_DIR"
    ln -sfv "$POLYBAR_SCRIPT" "$POSTSWITCH_EXTRA_DIR/notify-polybar"
fi
