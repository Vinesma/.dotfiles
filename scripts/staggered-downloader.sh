#!/usr/bin/env bash
#

set -euo pipefail

script_name=$(basename "$0")
input_file="inputs-gl-dl.txt"
temp_file=$(mktemp)
sleep_for=160s
config_file=
limit=
notify_on_end=

trap 'rm -f "$temp_file"' EXIT

show_help() {
    printf "%s\n" \
        "Use gallery-dl to mass download, but sleep for X amount of time after each download. Reads urls and options to be passed to gallery-dl from a file called inputs-gl-dl.txt" \
        "Usage: $script_name <options>" \
        "Options:" \
        "-h, --help               Show this help text and exit." \
        "-l, --limit              Stop after downloading X items in input file." \
        "-i, --input-file         A path to a file with options and URLs. By default the script will look for a file named '$input_file' in the execution directory." \
        "-s, --sleep-for          Sleep for this long after downloading an item. Append the scale of time after the time. e.g. 160s for seconds or 5m for minutes or 1h for hours. Default: $sleep_for" \
        "-n, --notify-on-end      Set this to send a notification after the script completes."
}

while :; do
    case ${1:-} in
        -h|-\?|--help)
            show_help           # Display a usage synopsis.
            exit
            ;;
        -n|--notify-on-end)     # Send a notification when all files have been converted.
            notify_on_end=true
            ;;
        -l|--limit)             # How many items to download.
            limit="$2"
            shift
            ;;
        -i|--input-file)        # File to use as input
            input_file="$2"
            shift
            ;;
        -s|--sleep-for)         # Sleep for this long after a download.
            sleep_for="$2"
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

count=0
while :; do
    IFS= read -r line < "$input_file" || break

    gallery-dl --sleep-extractor 0 $line

    tail -n +2 "$input_file" > "$temp_file"
    mv "$temp_file" "$input_file"

    if ! IFS= read -r _ < "$input_file"; then
        printf "%s\n" "Input file is empty. Finishing up."
        break
    fi

    count=$(( count + 1 ))
    if [[ "$count" -eq "$limit" ]]; then
        printf "%s\n" "The limit of $limit items has been reached. Stopping execution."
        break
    fi

    printf "%s\n" "($count/$limit) Download complete. Sleeping for $sleep_for before next download..."
    sleep "$sleep_for"
done

if [[ -n $notify_on_end ]]; then
    _notify "[$script_name]" "Finished!"
fi
