#!/usr/bin/env bash
#
# Rename files using a hash

HASHER=md5sum

for _file in "$@"; do
    if [ ! -f "$_file" ]; then continue; fi;

    hash=$($HASHER "$_file")
    dir_name=${_file%/*}
    extension=${_file##*.}
    new_file=${dir_name}/${hash%  *}.${extension}
    
    mv --verbose --no-clobber "$_file" "$new_file"
done