#!/usr/bin/bash
#
# Script name: rosearch
# Description: Search various search engines (inspired by surfraw).
# Dependencies: rofi and a web browser
# GitLab: https://www.gitlab.com/dwt1/dmscripts
# License: https://www.gitlab.com/dwt1/dmscripts/LICENSE
# Contributors: Derek Taylor
#               Ali Furkan Yıldız
# Modified by: Vinesma (Otavio Cornelio da Silva)

# Defining our web browser.
DMBROWSER="firefox"

# An array of search engines.  You can edit this list to add/remove
# search engines. The format must be: "engine_name - url".
# The url format must allow for the search keywords at the end of the url.
# For example: https://www.amazon.com/s?k=XXXX searches Amazon for 'XXXX'.
declare -a options=(
"archaur - https://aur.archlinux.org/packages/?O=0&K="
"archpkg - https://archlinux.org/packages/?sort=&q="
"archwiki - https://wiki.archlinux.org/index.php?search="
"debianpkg - https://packages.debian.org/search?suite=default&section=all&arch=any&searchon=names&keywords="
"ddg - https://duckduckgo.com/?q="
"github - https://github.com/search?q="
"gitlab - https://gitlab.com/search?search="
"google - https://www.google.com/search?q="
"googleimages - https://www.google.com/search?hl=en&tbm=isch&q="
"googlenews - https://news.google.com/search?q="
"imdb - https://www.imdb.com/find?q="
"lbry - https://lbry.tv/$/search?q="
"reddit - https://www.reddit.com/search/?q="
"thesaurus - https://www.thesaurus.com/misspelling?term="
"translate - https://translate.google.com/?sl=auto&tl=en&text="
"urban - https://www.urbandictionary.com/define.php?term="
"wikipedia - https://en.wikipedia.org/wiki/"
"wiktionary - https://en.wiktionary.org/wiki/"
"wolfram - https://www.wolframalpha.com/input/?i="
"youtube - https://www.youtube.com/results?search_query="
"b-ok - https://b-ok.lat/s/"
"quit"
)

# Picking a search engine.
while [ -z "$engine" ]; do
    enginelist=$(printf '%s\n' "${options[@]}" | rofi -dmenu -i -lines 15 -p 'Choose search engine:') || exit
    engineurl=$(echo "$enginelist" | awk '{print $NF}')
    engine=$(echo "$enginelist" | awk '{print $1}')
done

# Searching the chosen engine.
while [ -z "$query" ]; do
    if [[ "$engine" == "quit" ]]; then
        echo "Program terminated." && exit 0
    else
        query=$(echo "$engine" | rofi -dmenu -p 'Enter search query:') || exit
    fi
done

# Display search results in web browser
$DMBROWSER "$engineurl""$query"
