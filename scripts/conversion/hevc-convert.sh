#!/usr/bin/env bash

for FILE in *; do
    if [[ "$FILE" == "${0##*/}" ]]; then
        continue
    fi

    input_file_extension=${FILE##*.}
    input_file_size=$(du "$FILE" | awk '{printf $1}')
    output_file="output.${input_file_extension}"
    output_file_size=0

    ffmpeg \
        -hwaccel vaapi \
        -hwaccel_output_format vaapi \
        -hwaccel_device /dev/dri/renderD128 \
        -i "$FILE" \
        -map 0 \
        -c:v hevc_vaapi \
        -vf 'format=nv12|vaapi,hwupload' \
        -crf 23 \
        -preset slow \
        -c:a copy \
        -c:s copy \
        "$output_file"

    output_file_size=$(du "$output_file" | awk '{printf $1}')

    if [[ $input_file_size -gt $output_file_size ]]; then
        printf "Output is smaller than input (%s vs %s), removing input file.\n" "$output_file_size" "$input_file_size"
        mv -vf "$output_file" "$FILE"
    else
        printf "Output is bigger than input (%s vs %s), removing output file.\n" "$output_file_size" "$input_file_size"
        rm -vf "$output_file"
    fi
done
