#!/usr/bin/env bash
#

set -e

# https://blog.dhampir.no/content/sleeping-without-a-subprocess-in-bash-and-how-to-sleep-forever
snore() {
    local IFS
    [[ -n "${_snore_fd:-}" ]] || exec {_snore_fd}<> <(:)
    read -r ${1:+-t "$1"} -u "$_snore_fd" || :
}

DELAY=0.5

while snore $DELAY; do
    VOLUME=$(mpc volume | tr -d '[:alpha:],[:punct:]')
    ICON=(
        ""
        ""
        ""
    )

    if [[ $VOLUME -gt 50 ]]; then
        printf "%s" "${ICON[0]} "
    elif [[ $VOLUME -gt 25 ]]; then
        printf "%s" "${ICON[1]} "
    elif [[ $VOLUME -ge 0 ]]; then
        printf "%s" "${ICON[2]} "
    fi

    if [[ $VOLUME -ge 100 ]]; then
        printf " "
    fi

    printf "$VOLUME%%\n"
done
