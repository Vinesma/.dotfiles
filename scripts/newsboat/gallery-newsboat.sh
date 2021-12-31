#!/usr/bin/env bash
#
# Reaches into newsboat's database to download unread twitter posts with images

NEWSBOAT_DB_FILE=$HOME/.local/share/newsboat/cache.db
CURL_CONFIG_FILE=/tmp/gallery_newsboat_curl_config.tmp
QUERY='SELECT content FROM rss_item WHERE content GLOB "*nitter.moomoo.me/pic/media*" AND unread = 1;'
IMAGE_DIR=/tmp/twitter_nb_gallery
TWITTER_LINK_ID=https://pbs.twimg.com/media/
TWITTER_LINK_FORMAT='?format='

ICON_DOWNLOAD=/usr/share/icons/Papirus/32x32/emblems/emblem-downloads.svg
ICON_INFO=/usr/share/icons/Papirus/32x32/status/dialog-information.svg
ICON_ERROR=/usr/share/icons/Papirus/32x32/status/dialog-error.svg

send-notification() {
    notify-send "$@"
}

# Use sqlite3 to filter the newsboat database 
# Look for twitter content with images and transform it into the true twitter image url
# Append this link into a config file that curl can use to download
fetch-gallery() {
    sqlite3 "$NEWSBOAT_DB_FILE" "$QUERY" | grep img | cut -d '"' -f 2 \
    | while IFS= read -r nitter_link; do
       twitter_id=${nitter_link##*media%2F}
       extension=${twitter_id##*.}
       twitter_id=${twitter_id%.*}
       twitter_link=${TWITTER_LINK_ID}${twitter_id}${TWITTER_LINK_FORMAT}${extension}
       
       printf "%s\n" "url = $twitter_link" "output = $IMAGE_DIR/$twitter_id.$extension" >> $CURL_CONFIG_FILE
    done

    if [ -f "$CURL_CONFIG_FILE" ]; then
        mkdir -p $IMAGE_DIR
        send-notification -i "$ICON_DOWNLOAD" "[gallery-newsboat]" "Starting download..."
        # shellcheck disable=SC2015
        curl --config "$CURL_CONFIG_FILE" \
            && rm "$CURL_CONFIG_FILE" \
            && send-notification -i "$ICON_INFO" "[gallery-newsboat]" "Download complete!" \
            || send-notification -i "$ICON_ERROR" "[gallery-newsboat" "Download error!"
        return 0
    else
        send-notification -i "$ICON_ERROR" "[gallery-newsboat]" "Nothing to download."
        return 1
    fi
}

use-image-viewer() {
    feh --zoom fill --scale-down "$@" &> /dev/null
}

mark-as-read() {
    local query
    query='UPDATE rss_item SET unread = 0 WHERE'
    
    find "$IMAGE_DIR" -type f -printf '%f\n' 2> /dev/null | while IFS= read -r _file; do
        id=${_file%.*}
        sqlite3 "$NEWSBOAT_DB_FILE" "${query} content GLOB '*nitter.moomoo.me/pic/media%2F$id*' AND unread = 1;"
    done
}

clear-gallery() {
    rm -rf "$IMAGE_DIR"
    return 0
}

declare -a options=(
    " Download art"
    " View gallery"
    " Mark all as read"
    " Clear gallery"
    " Exit" 
)

while :; do
    if [ -d "$IMAGE_DIR" ]; then
        files=$(find "$IMAGE_DIR" -type f | wc -l)
    else
        files=0
    fi

    choice=$(\
        printf "%s\n" "${options[@]}" \
        | rofi -dmenu -only-match -l ${#options[@]} -i -format 'd' -p 'choice' -mesg "${files:-0} images currently stored" 2> /dev/null)

    case "$choice" in
        1) fetch-gallery && exit ;;
        2) use-image-viewer "$IMAGE_DIR" ;;
        3) mark-as-read ;;
        4) clear-gallery;;
        *) exit ;;
    esac
done