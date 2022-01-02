#!/usr/bin/env bash
#
# Setup autorandr hooks for multiple monitors

WORK_DIR=$HOME/.config/autorandr
POSTSWITCH_EXTRA_DIR=$WORK_DIR/postswitch.d
PREDETECT_SCRIPT=$WORK_DIR/predetect
POLYBAR_SCRIPT=$HOME/.dotfiles/polybar/launch.sh

# -- ACT --

# predetect hook
printf "%s\n" \
    '#!/usr/bin/env bash' \
    "sleep 1" > "$PREDETECT_SCRIPT"

# polybar hook
if command -v polybar &> /dev/null; then
    mkdir -p "$POSTSWITCH_EXTRA_DIR"
    ln -sfv "$POLYBAR_SCRIPT" "$POSTSWITCH_EXTRA_DIR/notify-polybar"
fi
