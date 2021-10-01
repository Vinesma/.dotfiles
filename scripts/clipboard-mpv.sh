#!/usr/bin/env bash
#
# Script meant to be run by a qtile keybind, opens a rofi menu for watching videos in mpv.
# Features:
# - VIDEO: Choose video format and watch straight from the rofi menu after a single keypress
# Dependencies:
# mpv, xclip, yt-dlp, rofi

notify_time=2000

icon_error="/usr/share/icons/Papirus/32x32/status/dialog-error.svg"
icon_youtube_dl="/usr/share/icons/Papirus/32x32/apps/youtube-dl.svg"
icon_mpv="/usr/share/icons/Papirus/32x32/apps/mpv.svg"

folder_watchlater="$HOME/Sync/.mpv_files"
folder_videos="$HOME/Videos"
default_formats="webm[height=480]+bestaudio/webm[height=720]+bestaudio/22/18/480p/360p/720p"

# Check if script is passed and argument or not.
# If yes, use the argument
# If no, use the clipboard.
[[ "$#" -gt 0 ]] && link="$1" || link="$(xclip -selection clipboard -o)"

send-error() {
    notify-send -i "$icon_error"  -t "$notify_time" "MPV" "$1"
}

start-playback() {
    local timestamp

    timestamp="$(echo -e '0%\n25%\n50%\n75%\n90%' | rofi -dmenu -p 'Timestamp' -lines 5)"

    notify-send -i "$icon_mpv" -t "$notify_time" "MPV" "Starting playback..."
    if [[ "$timestamp" = "0%" ]]; then
        if ! mpv --no-terminal --ytdl-format="$1" "$link"; then
            send-error "Error during playback"
        fi
    else
        if ! mpv --no-terminal --ytdl-format="$1" --start="$timestamp" "$link"; then
            send-error "Error during playback"
        fi
    fi
}

show-format-menu() {
    local format

    format=$(echo -e "$1\nExit" | \
    rofi -dmenu -only-match -p 'Video format' -lines 15 | \
    cut -d' ' -f 1)

    [[ "$format" != "Exit" ]] && start-playback "$format" || \
        send-error "Canceled by user" && exit 1
}

parse-video-info() {
    local choice

    choice=$(echo "$1" | \
    awk '{print $1 "  " $2 " - " $3}' | \
    sed '/\[.*\]/d' | \
    sed '1,2d' | \
    sort -n)

    show-format-menu "$choice"
}

get-video-info() {
    local video_info

    notify-send -i "$icon_youtube_dl" -t "$notify_time" "MPV" "[youtube-dl] Loading video information..."

    if video_info="$(yt-dlp -F --no-playlist "$link")"; then
        parse-video-info "$video_info"
    else
        send-error '[youtube-dl] Error while fetching video info' && exit 1
    fi
}

show-resume-menu() {
    local choice

    choice=$(echo -e "$1\n Exit" | \
        rofi -dmenu -only-match -p 'Choice' -lines 10)

    if [[ "$choice" != " Exit" ]]; then
        if [[ "$choice" != @(*youtube.com/watch*|*youtu.be*|*twitch.tv/videos*) ]]; then
            cd "$folder_videos"
            link="$choice"

            if ! mpv --no-terminal "$link"; then
                send-error "Error during playback"
            fi
        else
            link="$choice"
            get-video-info
        fi
    fi
}

show-menu() {
    local option
    local resume
    local lines

    resume=$(grep -hve "# redirect entry" "$folder_watchlater"/* 2>/dev/null | grep "#")

    if [[ "$link" == @(*youtube.com/watch*|*youtu.be*|*twitch.tv/videos*) ]]; then
        option=" Watch (default values)\n Watch\n"
        lines=2

        if [[ -n "$resume" ]]; then
            lines="$(( $lines + 2 ))"
            option=$(echo -e "$option菱 Resume watching\n Exit" | rofi -dmenu -only-match -p 'Option' -lines "$lines")
        else
            lines="$(( $lines + 1 ))"
            option=$(echo -e "$option Exit" | rofi -dmenu -only-match -p 'Option' -lines "$lines")
        fi
    else
        option=""
        lines=0

        if [[ -n "$resume" ]]; then
            lines="$(( $lines + 2 ))"
            option=$(echo -e "$option菱 Resume watching\n Exit" | rofi -dmenu -only-match -p 'Option' -lines "$lines")
        else
            send-error "Nothing to play or resume."
        fi
    fi

    resume=$(echo "$resume" | cut -d ' ' -f 2-)

    case "$option" in
        *default*) start-playback "$default_formats" ;;
        *Watch) get-video-info ;;
        *Resume*) show-resume-menu "$resume" ;;
        *) exit ;;
    esac
}

show-menu
