#!/usr/bin/env bash
#

set -euo pipefail

delete_original=
notify_on_end=
format="jpg"

show_help() {
    printf "%s\n" \
        "Convert one or multiple images to a different image format." \
        "Usage: $0 <options> <path|glob> [more paths/globs]" \
        "Options:" \
        "-h, --help               Show this help text and exit." \
        "-f, --format             The format to convert to, should be given as an extension with no ., like: 'webp' or 'jpg'." \
        "-d, --delete             Delete the original file after it gets converted." \
        "-n, --notify-on-end      Set this to send a notification when all files have been converted."
}

if [ $# -eq 0 ]; then
  show_help
  exit 1
fi

while :; do
    case $1 in
        -h|-\?|--help)
            show_help    # Display a usage synopsis.
            exit
            ;;
        -d|--delete)     # Delete original file
            delete_original=true
            ;;
        -n|--notify-on-end)     # Send a notification when all files have been converted.
            notify_on_end=true
            ;;
        -f|--format)     # Format to convert to, this will become the extension. e.g. 'webp'
            format="$2"
            shift
            ;;
        --)              # End of all options.
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
    filename=${FILE%%.*}
    if _convert -i "$FILE" "$filename.$format"; then
        if [[ -n $delete_original ]]; then
            _delete_file "$FILE"
        fi
    else
        printf "%s\n" "ERROR: ffmpeg encoutered an issue for file: $FILE"
    fi

done

if [[ -n $notify_on_end ]]; then
    _notify "[${0%.*}]" "All files have been converted."
fi
