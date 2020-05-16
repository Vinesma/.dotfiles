#!/bin/bash

if [ $(echo $1 | grep youtube) ]
then
    echo
    echo "This appears to be a youtube link, what to do?"
    echo -e "1. Watch it\n2. Download it\n3. Exit"
    read option
    case $option in
        1) mpv --fullscreen=no --profile=youtube720p $1;;
        2) youtube-dl -f 22/18 $1;;
        3) echo;;
    esac
else
    firefox $1
fi
