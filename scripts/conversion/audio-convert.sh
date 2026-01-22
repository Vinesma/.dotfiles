#!/usr/bin/env bash
#

set -euo pipefail

script_name=$(basename $0)
delete_original=
notify_on_end=
size_skip=
bitrate="-b:a 320k"
format="mp3"

show_help() {
    printf "%s\n" \
        "Convert one or multiple audio files to a different audio format." \
        "Usage: $script_name <options> <path|glob> [more paths/globs]" \
        "Options:" \
        "-h, --help               Show this help text and exit." \
        "-f, --format             The format to convert to, should be given as an extension with no ., like: 'mp3' or 'flac'." \
        "-b, --bitrate            The bitrate of the new file." \
        "-d, --delete             Delete the original file after it gets converted." \
        "-s, --skip-if-size       Skip converting this file if the file size is lower than this number in KB." \
        "-n, --notify-on-end      Set this to send a notification when all files have been converted."
}

if [ $# -eq 0 ]; then
  show_help
  exit 1
fi

while :; do
    case $1 in
        -h|-\?|--help)
            show_help           # Display a usage synopsis.
            exit
            ;;
        -d|--delete)            # Delete original file
            delete_original=true
            ;;
        -n|--notify-on-end)     # Send a notification when all files have been converted.
            notify_on_end=true
            ;;
        -f|--format)            # Format to convert to, this will become the extension. e.g. 'mp3'
            format="$2"
            shift
            ;;
        -b|--bitrate)            # Bitrate of new file. e.g '320k' for high quality mp3
            bitrate="-b:a $2"
            shift
            ;;
        -s|--skip-if-size)      # Skip converting a file if its size is smaller than this number in KB
            size_skip="$2"
            shift
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

_notify() {
    notify-send "$1" "$2"
}

_delete_file() {
    rm -f "$1"
}

_convert() {
    ffmpeg -loglevel error "$@"
}

for FILE in "$@"; do
    if [[ -n $size_skip ]] && [[ $(stat -c%s "$FILE") -lt $((size_skip * 1024)) ]]; then
        continue
    fi

    filename=${FILE%.*}
    if _convert -i "$FILE" $bitrate "$filename.$format"; then
        if [[ -n $delete_original ]]; then
            _delete_file "$FILE"
        fi
    else
        printf "%s\n" "ERROR: ffmpeg encountered an issue for file: $FILE"
    fi
done

if [[ -n $notify_on_end ]]; then
    _notify "[${0%.*}]" "All files have been converted."
fi
