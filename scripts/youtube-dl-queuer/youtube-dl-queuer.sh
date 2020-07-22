#!/bin/bash
#
# Script meant to be run by a qtile keybind or called by another, opens a rofi menu for downloading many videos.
# Features:
# - QUEUE: Queue videos to be downloaded at any time.
# Dependencies:
# xclip, youtube-dl, rofi

notify_time="2200"
files_folder="$HOME/.dotfiles/scripts/youtube-dl-queuer"

icon_error="/usr/share/icons/Papirus/32x32/status/dialog-error.svg"
icon_youtube_dl="/usr/share/icons/Papirus/32x32/apps/youtube-dl.svg"
icon_youtube_dl_queuer="/usr/share/icons/Papirus/32x32/status/dialog-information.svg"

video_format="22/18"

# Check if script is passed and argument or not.
# If yes, use the argument
# If no, use the clipboard.
[[ "$#" -gt 0 ]] && link="$1" || link="$(xclip -o)"

# Check no. of items in queue
if [[ -e "$files_folder/queue" ]]; then
    queue_count=$(wc -l "$files_folder/queue" | cut -d' ' -f 1)
else
    queue_count=0
fi

send-error() {
    notify-send -i "$icon_error"  -t "$notify_time" "[youtube-dl-queuer]" "$1"
}

clear-queue() {
    if [[ -e "$files_folder/queue" ]]; then
        rm -f "$files_folder/queue" && \
        notify-send -i "$icon_youtube_dl_queuer" -t "$notify_time" "[youtube-dl-queuer]" "Queue cleared!"
    else
        send-error "There's no queue to clear..."
    fi
}

start-download() {
    local output
    if [[ -e "$files_folder/queue" ]]; then
        notify-send -i "$icon_youtube_dl" -t "$notify_time" "[youtube-dl]" "Starting download..."

        if output=$(youtube-dl -f "$video_format" --no-playlist -a "$files_folder/queue"); then
            notify-send -i "$icon_youtube_dl" -t "$notify_time" "[youtube-dl]" "All items successfully downloaded!"
            clear-queue
            echo "$output" > "$files_folder/output"
        else
            echo "$output" > "$files_folder/output"
            send-error "An error ocurred while downloading one or more items... the queue was preserved. Output saved to file."
        fi
    else
        send-error "No queued items! Aborting download..."
    fi
}

show-queue() {
    if [[ -e "$files_folder/queue" ]]; then
        rofi -dmenu -p 'Queue' -mesg "Current queue has $queue_count item(s)." -input "$files_folder/queue" >/dev/null
    else
        send-error "No queued items!"
    fi
}

add-to-queue() {
    echo "$link" >> "$files_folder/queue"
    notify-send -i "$icon_youtube_dl_queuer" -t "$notify_time" "[youtube-dl-queuer]" "Video added to download queue!"
}

show-menu() {
    option=$(echo -e "1  Queue video\n2  Start downloads\n3  Show queue\n4 裸 Clear queue\n5  Exit" | \
    rofi -dmenu -no-custom -p 'Option' -lines 5 -format 'd' -mesg "Current queue has $queue_count item(s).")

    case "$option" in
        1) add-to-queue ;;
        2) start-download ;;
        3) show-queue ;;
        4) clear-queue ;;
        *) exit ;;
    esac
}

case "$link" in
    *youtube.com*|*youtu.be*) show-menu ;;
    *) send-error "Unsupported link, exiting" && exit 1 ;;
esac
