#!/usr/bin/env bash
#

output_ext="$1"
shift

for file_path in "$@"
do
  output_path="${file_path%.*}${output_ext}"
  convert "$file_path" "$output_path"
done
