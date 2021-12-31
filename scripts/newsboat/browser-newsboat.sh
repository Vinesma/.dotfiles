#!/usr/bin/env bash
#
# Script meant to be used by newsboat for handling links from youtube, images and other videos.
# Features:
# - YOUTUBE: Download, Watch or view thumbnail and duration of videos in the command line.
# - IMAGES: View images in the command line.
# - VIDEOS: Other than youtube, open in mpv in a loop. (Mainly, to emulate twitter video functionality)
# - OTHERS: Open in the browser.
# Dependencies:
# - feh, mpv, yt-dlp, firefox, rofi, clipboard-mpv.sh
#

NITTER_INSTANCE=nitter.moomoo.me
clipboard_mpv_dir="$HOME/.dotfiles/scripts/mpv/clipboard-mpv.sh"
youtube_dl_queuer_dir="$HOME/.dotfiles/scripts/youtube-dl-queuer/hot-queue.sh"
newsboat_db_file="$HOME/.local/share/newsboat/cache.db"

use-image-viewer() {
    feh --zoom fill --scale-down "$@" &> /dev/null & disown
}

use-video-player() {
    mpv --really-quiet --loop "$@" & disown
}

use-browser() {
    firefox "$@" & disown
}

video-info() {
    local video
    local title
    local thumbnail
    local duration

    video=$(yt-dlp --get-title --get-duration --get-thumbnail "$1")
    title=$(echo "$video" | head -n 1)
    thumbnail=$(echo "$video" | sed -e '1d' -e '3d')
    duration=$(echo "$video" | tail -n 1)

    # Deal with .webp
    if [[ "${thumbnail##*.}" == "webp" ]]; then
        temp_file="/tmp/newsboat-thumbs.tmp.webp"
        jpg_file="/tmp/newsboat-thumbs.jpg"
        thumbnail="$jpg_file"

        curl -s "$thumbnail" > "$temp_file"
        convert "$temp_file" "$jpg_file"
        rm "$temp_file"
    fi

    use-image-viewer "$thumbnail" -F --title "$title" --info "echo \"LENGTH: $duration\""
}

if [[ "$1" == *youtube.com* ]]; then
    option=$(echo -e "1  Watch\n2  Send to queue\n3  Open in browser\n4  Show video info\n5  Exit" | \
        rofi -dmenu -only-match -p 'option' -format 'd' -mesg 'This is a youtube link, what to do?' 2> /dev/null)
    case $option in
        1) "$clipboard_mpv_dir" "$1" & ;;
        2) "$youtube_dl_queuer_dir" "$1" ;;
        3) firefox "$1" & ;;
        4) video-info "$1" ;;
        *) exit ;;
    esac
elif [[ "$1" == @(*.jpg|*.jpeg|*.png) ]]; then
    link="$1"
    if [[ "$1" == *$NITTER_INSTANCE/pic/media* ]]; then
        twitter_id=${1##*media%2F}
        extension=$(echo "$twitter_id" | cut -d '.' -f 2)
        twitter_id=$(echo "$twitter_id" | cut -d '.' -f 1)
        link="https://pbs.twimg.com/media/$twitter_id?format=$extension"

        use-image-viewer "$link"
    elif [[ "$1" == *$NITTER_INSTANCE/pic/ext_tw_video_thumb* ]]; then
        true_nitter_url=$(sqlite3 "$newsboat_db_file" "select url from rss_item where content glob '*$1*'")
        link=${true_nitter_url%#*}
        link=${link/$NITTER_INSTANCE/twitter.com}

        use-video-player "$link"
    else
        use-image-viewer "$link"
    fi
elif [[ "$1" == @(*.mp4) ]]; then
    use-video-player "$1"
else
    if [[ "$1" == *$NITTER_INSTANCE* ]]; then
        use-browser "${1/$NITTER_INSTANCE/twitter.com}"
    else
        use-browser "$1"
    fi
fi

clear
