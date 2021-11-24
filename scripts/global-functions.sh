# Exposes sourceable functions for general use
# shellcheck shell=bash

# ex - archive extractor
# usage: ex <file>
ex ()
{
  if [[ -f "$1" ]]; then
    case "$1" in
      *.tar.bz2)   tar xjf "$1"   ;;
      *.tar.gz)    tar xzf "$1"   ;;
      *.bz2)       bunzip2 "$1"   ;;
      *.rar)       unrar x "$1"   ;;
      *.gz)        gunzip "$1"    ;;
      *.tar)       tar xf "$1"    ;;
      *.tbz2)      tar xjf "$1"   ;;
      *.tgz)       tar xzf "$1"   ;;
      *.zip)       unzip "$1"     ;;
      *.Z)         uncompress "$1";;
      *.7z)        7z x "$1"      ;;
      *)           echo "'$1' cannot be extracted via ex()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

# cheat.sh (Display examples of command usage)
cheat() {
    curl cheat.sh/"$1"
}

# wttr.in (Display weather for selected location)
weather() {
    curl wttr.in/"$1"
}

# Terminal calculator
calc() {
    node -p "$@"
}

# Ask user to update mirrors
update-pacman-mirrors() {
    echo -e ":: Update mirrorlist with the fastest mirrors? (y/n)"
    read -r answer

    [[ "$answer" == [yY] ]] && sudo pacman-mirrors -f
}

# Update mirrors and then download and update all packages in the system.
update-packages() {
    local icon_success
    local icon_fail
    local answer
    icon_success="/usr/share/icons/Papirus/32x32/apps/system-software-update.svg"
    icon_fail="/usr/share/icons/Papirus/32x32/apps/system-error.svg"

    update-pacman-mirrors

    sudo pacman -Syyu && \
    notify-send -i "$icon_success" 'PACMAN' 'Update complete!' || \
    notify-send -i "$icon_fail" 'PACMAN' 'Update FAILURE!'

    yay -Sua && \
    notify-send -i "$icon_success" 'YAY' 'Update complete!' || \
    notify-send -i "$icon_fail" 'YAY' 'Update FAILURE!'
}

# Update mirrors and then download packages without actually installing.
update-packages-only-download() {
    local icon_success
    local icon_fail
    local answer
    icon_success="/usr/share/icons/Papirus/32x32/apps/system-software-update.svg"
    icon_fail="/usr/share/icons/Papirus/32x32/apps/system-error.svg"

    update-pacman-mirrors

    sudo pacman -Syyuw && \
    notify-send -i "$icon_success" 'PACMAN' 'Update complete!' || \
    notify-send -i "$icon_fail" 'PACMAN' 'Update FAILURE!'
}

# for easy downloading of music
youtube-dl-audio() {
    yt-dlp -x --audio-format mp3 -o "$HOME/Downloads/Audio/%(title)s.%(ext)s" "$@"
}

# creates pieces of a file
split-create() {
    if [ "$#" -eq 2 ]; then
        split -b "$1" "$2" "$2.part" \
            && notify-send "[split-create]" "Split completed!"
    else
        echo "Usage: split-create [piece size] [filename]"
        echo "[piece size] Example: 1G"
        echo "[filename] Example: myfile.tar.gz"
    fi
}

# recreates files that were once split
split-recreate() {
    if [ "$#" -gt 2 ]; then
        cat "${@:2}" > "$1" \
            && notify-send "[split-recreate]" "Operation completed!"
    else
        echo "Usage: split-recreate [output filename] [file pieces]"
        echo "[file pieces] Example: myfile.tar.gz.part* (The glob expands to cover all the pieces in order)"
    fi
}

# create .tar archive
ca() {
    if [ "$#" -gt 1 ]; then
        tar cvf "$1.tar" "${@:2}" \
            && notify-send "[ca]" "Archive created!"
    else
        echo "ca: create a .tar archive"
        echo "Usage: ca [archive name (no extension)] [input]"
    fi
}

# create compressed .tar.gz archive
cca() {
    if [ "$#" -gt 1 ]; then
        tar czvf "$1.tar.gz" "${@:2}" \
            && notify-send "[cca]" "Compressed archive created!"
    else
        echo "cca: create a compressed .tar.gz archive"
        echo "Usage: cca [archive name (no extension)] [input]"
    fi
}

# trim video/music files
trim-ffmpeg() {
    if [ "$#" -eq 4 ]; then
        #local input_filename
        local input_extension
        local output_filename
        local output_extension
        #input_filename="${3%.*}"
        input_extension="${3##*.}"
        output_filename="${4%.*}"
        output_extension="${4##*.}"

        if [[ "$input_extension" = "$output_extension" ]]; then
            ffmpeg -ss "$1" -to "$2" -i "$3" -codec copy "$output_filename.$output_extension"
        else
            ffmpeg -ss "$1" -to "$2" -i "$3" "$output_filename.$output_extension"
        fi
    else
        echo "trim-ffmpeg: trim video and audio files"
        echo "Usage: trim-ffmpeg [start timestamp (mm:ss)] [end timestamp (mm:ss)] [input file.ext] [output file.ext]"
    fi
}

# Convert many files
mass-convert-ffmpeg() {
    if [ "$#" -eq 3 ]; then
        local directory="$1"
        local input_ext="$2"
        local destination_ext="$3"

        echo "$directory"
        echo "$input_ext"
        echo "$destination_ext"

        for FILE in "$directory"/*"$input_ext"
        do ffmpeg -i "$FILE" "${FILE%.*}$destination_ext"
        done
    else
        echo "mass-convert-ffmpeg: convert many files from one format to another."
        echo "Usage: mass-convert-ffmpeg [input/dir/] [.ext to convert from] [.ext to convert to]"
    fi
}

# GPG helpers
# generate a key pair
gpg-keypair-gen() {
    gpg --full-gen-key
}
# encrypt file
gpg-encrypt() {
    if [ "$#" -eq 2 ]; then
        gpg --recipient "$1" --encrypt "$2"
    else
        echo "gpg-encrypt: Encrypt files asymetrically using gpg, requires a key-pair which can be generated with the gpg-keypair function."
        echo "Usage: gpg-encrypt [recipient (your email/key identifier)] [target file.ext]"
    fi
}
# decrypt file
gpg-decrypt() {
    if [ "$#" -eq 1 ]; then
        gpg -q --decrypt "$1"
    else
        echo "gpg-decrypt: Output the contents of a encrypted file to stdout."
        echo "Usage: gpg-decrypt [target file.ext.gpg]"
    fi
}
