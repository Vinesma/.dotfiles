#!/usr/bin/env bash
#
# Queues videos instantly without opening a menu. Runs via keybind.
# Dependecies:
# xclip

notify_time="2200"
files_folder="$HOME/.dotfiles/scripts/youtube-dl-queuer"

icon_error="/usr/share/icons/Papirus/32x32/status/dialog-error.svg"
#icon_youtube_dl="/usr/share/icons/Papirus/32x32/apps/youtube-dl.svg"
icon_youtube_dl_queuer="/usr/share/icons/Papirus/32x32/status/dialog-information.svg"

# Check if script is passed and argument or not.
# If yes, use the argument
# If no, use the clipboard.
[ "$#" -gt 0 ] && link="$1" || link="$(xclip -selection clipboard -o)"

# Check no. of items in queue
if [[ -e "$files_folder/queue" ]]; then
    queue_count=$(wc -l "$files_folder/queue" | cut -d' ' -f 1)
else
    queue_count=0
fi

send-error() {
    notify-send -i "$icon_error"  -t "$notify_time" "[hot-queue]" "$1"
}

add-to-queue() {
    if [[ -e "/tmp/ytqueuer-running.tmp" ]]; then
        send-error "Cannot add item to queue, a download is in progress!"
    else
        local new_queue
        new_queue=$(( queue_count + 1 ))
        echo "$link" >> "$files_folder/queue"
        notify-send \
            -i "$icon_youtube_dl_queuer" \
            -t "$notify_time" "[youtube-dl-queuer]" \
            "Video added to download queue!\nQueue: $new_queue"
    fi
}

case "$link" in
    *youtube.com*|*youtu.be*) add-to-queue ;;
    *) send-error "Unsupported link, exiting" && exit 1 ;;
esac
