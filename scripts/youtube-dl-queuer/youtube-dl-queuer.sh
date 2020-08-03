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

# Check if script is passed and argument or not.
# If yes, use the argument
# If no, use the clipboard.
[[ "$#" -gt 0 ]] && link="$1" || link="$(xclip -o)"

# Check if user wants to download subtitles
if [[ -e "$files_folder/writesub" ]]; then
    menu_sub="Yes"
else
    menu_sub="No"
fi

# Check if user has a defined format
if [[ -e "$files_folder/format" ]]; then
    video_format=$(cat "$files_folder/format")
else
    video_format="22/18"
fi

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

        if [[ -e "$files_folder/writesub" ]]; then
            output=$(youtube-dl --write-sub -f "$video_format" --no-playlist -a "$files_folder/queue")
        else
            output=$(youtube-dl -f "$video_format" --no-playlist -a "$files_folder/queue")
        fi

        echo "$output" > "$files_folder/output"

        if [[ "$?" -eq 0 ]]; then
            notify-send -i "$icon_youtube_dl" "[youtube-dl]" "$queue_count item(s) successfully downloaded!"
            clear-queue
        else
            send-error "An error ocurred while downloading one or more items. The queue was preserved.\nOutput saved to file."
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
    local new_queue
    new_queue=$(( "$queue_count" + 1 ))
    echo "$link" >> "$files_folder/queue"
    notify-send \
        -i "$icon_youtube_dl_queuer" \
        -t "$notify_time" "[youtube-dl-queuer]" \
        "Video added to download queue!\nQueue: $new_queue"
}

change-format() {
    local option
    option=$(echo -e "22/18\n22\n18\nCancel" | \
    rofi -dmenu -p 'Format' -lines 4 -mesg 'Type new format (default=22/18)')

    case "$option" in
        "Cancel") exit ;;
        *) echo "$option" > "$files_folder/format" && \
           notify-send -i "$icon_youtube_dl_queuer" -t "$notify_time" "[youtube-dl-queuer]" "Format changed!" ;;
    esac
}

write-subs() {
    if [[ -e "$files_folder/writesub" ]]; then
        rm -f "$files_folder/writesub"
        notify-send -i "$icon_youtube_dl_queuer" -t "$notify_time" "[youtube-dl-queuer]" "Disabled subtitles!"
    else
        touch "$files_folder/writesub"
        notify-send -i "$icon_youtube_dl_queuer" -t "$notify_time" "[youtube-dl-queuer]" "Enabled subtitles!"
    fi
}

show-menu() {
    local option
    option=$(echo -e \
        "1  Queue video\n2  Start downloads\n3  Show queue\n4 裸 Clear queue\n5  Change video format\n6  Toggle subtitles\n7  Exit" | \
        rofi -dmenu -no-custom -p 'Option' -lines 7 -format 'd' -mesg "Format: $video_format / Queue: $queue_count / Subs: $menu_sub")

    case "$option" in
        1) add-to-queue ;;
        2) start-download ;;
        3) show-queue ;;
        4) clear-queue ;;
        5) change-format ;;
        6) write-subs ;;
        *) exit ;;
    esac
}

case "$link" in
    *youtube.com*|*youtu.be*) show-menu ;;
    *) send-error "Unsupported link, exiting" && exit 1 ;;
esac