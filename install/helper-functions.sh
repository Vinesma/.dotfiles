#!/bin/bash

[[ $# -gt 0 ]] && debug=1
autostart_file="$HOME/.autostart"

debug-msg() {
    echo -e "\t-> [DEBUG]:" "$@"
}

header-msg() {
    echo -e "\n==> " "$@"
}

header-msg-count() {
    echo -e "\n==> " "$@" "[$count/$total]"
    update-count
}

normal-msg() {
    echo -e "\t" "$@"
}

info-msg() {
    echo -e "\t-> [i]: " "$@"
}

arrow-msg() {
    echo -e "\t-> " "$@"
}

# $1 -> 'string to append to $autostart_file'
add-to-autostart() {
    if [[ -z "$debug" ]]; then
        echo -e "$@" >> "$autostart_file"
    else
        debug-msg "[autostart] Adding:\n\t[ $@ ]\n\tTo:\n\t[ $autostart_file ]"
    fi
}

# $1 -> 'path to origin link'
# $2 -> 'path to destination link'
create-link-function() {
    if [[ -z "$debug" ]]; then
        ln -sfv "$1" "$2"
    else
        debug-msg "Created [link] Between:\n\t[ $1 ]\n\tAnd:\n\t[ $2 ]"
    fi
}

# $1 -> 'path to copy from'
# $2 -> 'path to copy to'
create-copy-function() {
    if [[ -z "$debug" ]]; then
        cp -v "$1" "$2"
    else
        debug-msg "[copy] :\n\t[ $1 ]\n\tTo:\n\t[ $2 ]"
    fi
}

# $1 -> 'path to create a dir at'
create-dir-function() {
    if [[ -z "$debug" ]]; then
        mkdir -pv "$1"
    else
        debug-msg "Created [dir] at:\n\t[ $1 ]"
    fi
}

create-config() {
    local package_name
    local origin
    local destination
    package_name=$1
    origin="$HOME/$2"
    destination="$HOME/$3"

    if [[ $# -eq 4 ]]; then
        create-dir-function "$destination"
        create-copy-function "$origin" "$destination"
        create-link-function "$origin" "$destination"
    elif [[ $# -eq 3 ]]; then
        if [[ "$package_name" == '>>' ]]; then
            add-to-autostart "${@:2}"
        else
            create-copy-function "$origin" "$destination"
            create-link-function "$origin" "$destination"
        fi
    elif [[ $# -eq 1 ]]; then
        install-package "$package_name"
    else
        debug-msg "Nothing to do."
    fi
}

# Receive arguments in the following formats:
# $1 = package name / modifier for: {autostarting}
# $2 = dir where package configuration resides in the REPO / null
# $3 = dir where package configuration should reside in the SYSTEM / null
# Send these arguments separated by spaces to 'create-config' function, which decides what to do.
config-by-file() {
    while IFS=, read -r line; do
        package_instructions=$(echo "$line" | cut -d ',' --output-delimiter ' ' -f 1-)
        create-config $package_instructions
    done < "$1";
    arrow-msg "Done."
}

install-package-file() {
    if [[ -z "$debug" ]]; then
        sudo pacman --no-confirm --needed -S - < "$1"
    else
        debug-msg "[Install] $(wc -l "$1")"
    fi
}

install-package() {
    if [[ -z "$debug" ]]; then
        sudo pacman --no-confirm --needed -S "$@"
    else
         debug-msg "[Install]" "$@" "package(s)"
    fi
}

install-aur-file() {
    if [[ -z "$debug" ]]; then
        sudo yay --no-confirm -S - < "$1"
    else
         debug-msg "[Install][AUR]" "$@" "package(s)"
    fi
}

install-aur() {
    if [[ -z "$debug" ]]; then
        sudo yay --no-confirm -S "$@"
    else
         debug-msg "[Install][AUR]" "$@" "package(s)"
    fi
}
