#!/bin/bash

[[ $# -gt 0 ]] && debug=1

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

create-config() {
    local package_name
    local origin
    local destination
    package_name=$1
    origin="$HOME/$2"
    destination="$HOME/$3"
    if [[ -z "$debug" ]] && [[ $# -eq 4 ]]; then
        mkdir -pv "$destination"
        cp -v "$origin" "$destination"
        ln -sfv "$origin" "$destination"
    elif [[ -z "$debug" ]] && [[ $# -eq 3 ]]; then
        cp -v "$origin" "$destination"
        ln -sfv "$origin" "$destination"
    elif [[ -z "$debug" ]] && [[ $# -eq 1 ]]; then
        install-package "$package_name"
    else
        debug-msg "\n\t\tName: $package_name\n\t\tCopyFrom: ${2:-installonly} \n\t\tTo/mkdir: ${3:-installonly} $4"
        fi
    normal-msg "[$1] Config complete."
    arrow-msg "Done."
}

config-by-file() {
    while IFS=, read -r line; do
        package_instructions=$(echo "$line" | cut -d ',' --output-delimiter ' ' -f 1-)
        create-config $package_instructions
    done < "$1";
}

install-package-file() {
    if [[ -z "$debug" ]]; then
        sudo pacman --no-confirm --needed -S - < "$1"
    else
        debug-msg "Installing $(wc -l "$1")"
    fi
}

install-package() {
    if [[ -z "$debug" ]]; then
        sudo pacman --no-confirm --needed -S "$@"
    else
         debug-msg "Now installing the" "$@" "package(s)"
    fi
}
