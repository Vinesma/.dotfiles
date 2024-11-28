#!/usr/bin/env bash
#
# Script meant to be run by a keybind, opens a rofi/wofi menu for watching videos in mpv.
# Features:
# - VIDEO: Choose video format and watch straight from the rofi menu after a single keypress
# Dependencies:
# mpv, xclip/cliphist, yt-dlp, rofi/wofi

notify_time=2000

icon_error="/usr/share/icons/Papirus/32x32/status/dialog-error.svg"
icon_youtube_dl="/usr/share/icons/Papirus/32x32/apps/youtube-dl.svg"
icon_mpv="/usr/share/icons/Papirus/32x32/apps/mpv.svg"
session_wrofi="$HOME/.dotfiles/scripts/helpers/session-wrofi.sh"

folder_watchlater="$HOME/Sync/.mpv_files"
folder_videos="$HOME/Videos"
format_highq="bv+ba/b"
format_defaultq="bv[height<=720]+ba/b[height<=720]"
format_lowq="bv[height<=480]+ba/b[height<=480]"

# Check if script is passed an argument or not.
# If yes, use the argument
# If no, use the clipboard.
if [ "$XDG_SESSION_TYPE" != "wayland" ]; then
    clipboard_text=$(xclip -selection clipboard -o)
else
    clipboard_text=$(cliphist list | head -n 1 | cliphist decode)
fi

link=${1:-$clipboard_text}
# shellcheck source=../helpers/session-wrofi.sh
source "$session_wrofi"

send-error() {
    notify-send -i "$icon_error"  -t "$notify_time" "MPV" "$1"
}

start-playback() {
    local timestamp
    local wrofi_args
    local mpv_args

    if [ "$XDG_SESSION_TYPE" != "wayland" ]; then
        wrofi_args=(\
            "-p" "Timestamp"
            "-theme-str" "listview {lines: 5;}")
    else
        wrofi_args=(\
            "-p" "Timestamp"
            "--lines" "6"
        )
    fi

    timestamp="$(echo -e '0%\n25%\n50%\n75%\n90%' | wrofi-switch "${wrofi_args[@]}" 2> /dev/null)"
    mpv_args=("--no-terminal" "--ytdl-format=$1" "$link")

    notify-send -i "$icon_mpv" -t "$notify_time" "MPV" "Starting playback..."

    if [[ "$timestamp" != "0%" ]]; then
        mpv_args=("${mpv_args[@]}" "--start=$timestamp")
    fi

    if ! mpv "${mpv_args[@]}"; then
        send-error "Error during playback"
    fi
}

show-format-menu() {
    local format
    local wrofi_args

    if [ "$XDG_SESSION_TYPE" != "wayland" ]; then
        wrofi_args=(\
            "-p" "Video Format"
            "-theme-str" "listview {lines: 15;}")
    else
        wrofi_args=(\
            "-p" "Video Format"
            "--lines" "16"
        )
    fi


    format=$(echo -e "$1\nExit" | \
    wrofi-switch "${wrofi_args[@]}" 2> /dev/null | \
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

    notify-send -i "$icon_youtube_dl" -t "$notify_time" "MPV" "[yt-dlp] Loading video information..."

    if video_info="$(yt-dlp -F --no-playlist "$link")"; then
        parse-video-info "$video_info"
    else
        send-error '[yt-dlp] Error while fetching video info' && exit 1
    fi
}

show-resume-menu() {
    local choice
    local wrofi_args

    if [ "$XDG_SESSION_TYPE" != "wayland" ]; then
        wrofi_args=(\
            "-p" "Choice"
            "-theme-str" "listview {lines: 10;}")
    else
        wrofi_args=(\
            "-p" "Choice"
            "--lines" "11"
        )
    fi

    choice=$(echo -e "$1\n Exit" | wrofi-switch "${wrofi_args[@]}" 2> /dev/null)

    if [[ "$choice" != " Exit" ]]; then
        if [[ "$choice" != @(*youtube.com/watch*|*youtu.be*|*twitch.tv/videos*) ]]; then
            cd "$folder_videos" || exit
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
    local wrofi_args

    if [ "$XDG_SESSION_TYPE" != "wayland" ]; then
        wrofi_args=(\
            "-p" "Option"
            "-theme-str" "listview {lines: 10;}")
    else
        wrofi_args=(\
            "-p" "Option"
            "--lines" "10"
        )
    fi

    resume=$(grep -hve "# redirect entry" "$folder_watchlater"/* 2>/dev/null | grep "#")

    if [[ "$link" == @(*youtube.com/watch*|*youtu.be*|*twitch.tv/videos*) ]]; then
        option=" Watch (Default values)\n Watch (High Quality)\n Watch (Low Quality)\n Watch\n"
        lines=2

        if [[ -n "$resume" ]]; then
            lines="$(( lines + 2 ))"
            option=$(echo -e "$option菱 Resume watching\n Exit" | wrofi-switch "${wrofi_args[@]}" 2> /dev/null)
        else
            lines="$(( lines + 1 ))"
            option=$(echo -e "$option Exit" | wrofi-switch "${wrofi_args[@]}" 2> /dev/null)
        fi
    else
        option=""
        lines=0

        if [[ -n "$resume" ]]; then
            lines="$(( lines + 2 ))"
            option=$(echo -e "$option菱 Resume watching\n Exit" | wrofi-switch "${wrofi_args[@]}" 2> /dev/null)
        else
            send-error "Nothing to play or resume."
        fi
    fi

    resume=$(echo "$resume" | cut -d ' ' -f 2-)

    case "$option" in
        *Default*) start-playback "$format_defaultq" ;;
        *High\ Quality*) start-playback "$format_highq" ;;
        *Low\ Quality*) start-playback "$format_lowq" ;;
        *Watch) get-video-info ;;
        *Resume*) show-resume-menu "$resume" ;;
        *) exit ;;
    esac
}

show-menu
