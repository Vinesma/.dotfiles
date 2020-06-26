#!/bin/bash

if [ $(echo $1 | grep youtube.com) ]
then
    echo
    echo "This appears to be a youtube link, what to do?"
    echo -e "1. Watch it\n2. Download it\n3. Open in browser\n4. Print video length\n5. Show video thumbnail\n6. Exit"
    read option
    case $option in
        1) mpv --fullscreen=no --profile=youtube720p $1;;
        2) youtube-dl -f 22/18 $1;;
        3) firefox $1;;
	4) notify-send "NEWSBOAT:" "Video length: $(youtube-dl --get-duration $1)";;
	5) feh -F "$(youtube-dl --get-thumbnail $1)";;
        *) echo;;
    esac
else
    firefox $1
fi
