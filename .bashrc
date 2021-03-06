#
# ~/.bashrc
#

[[ $- != *i* ]] && return

colors() {
	local fgc bgc vals seq0

	printf "Color escapes are %s\n" '\e[${value};...;${value}m'
	printf "Values 30..37 are \e[33mforeground colors\e[m\n"
	printf "Values 40..47 are \e[43mbackground colors\e[m\n"
	printf "Value  1 gives a  \e[1mbold-faced look\e[m\n\n"

	# foreground colors
	for fgc in {30..37}; do
		# background colors
		for bgc in {40..47}; do
			fgc=${fgc#37} # white
			bgc=${bgc#40} # black

			vals="${fgc:+$fgc;}${bgc}"
			vals=${vals%%;}

			seq0="${vals:+\e[${vals}m}"
			printf "  %-9s" "${seq0:-(default)}"
			printf " ${seq0}TEXT\e[m"
			printf " \e[${vals:+${vals+$vals;}}1mBOLD\e[m"
		done
		echo; echo
	done
}

[ -r /usr/share/bash-completion/bash_completion ] && . /usr/share/bash-completion/bash_completion

# Change the window title of X terminals
case ${TERM} in
	xterm*|rxvt*|Eterm*|aterm|kterm|gnome*|interix|konsole*)
		PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/\~}\007"'
		;;
	screen*)
		PROMPT_COMMAND='echo -ne "\033_${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/\~}\033\\"'
		;;
esac

use_color=true

# Set colorful PS1 only on colorful terminals.
# dircolors --print-database uses its own built-in database
# instead of using /etc/DIR_COLORS.  Try to use the external file
# first to take advantage of user additions.  Use internal bash
# globbing instead of external grep binary.
safe_term=${TERM//[^[:alnum:]]/?}   # sanitize TERM
match_lhs=""
[[ -f ~/.dir_colors   ]] && match_lhs="${match_lhs}$(<~/.dir_colors)"
[[ -f /etc/DIR_COLORS ]] && match_lhs="${match_lhs}$(</etc/DIR_COLORS)"
[[ -z ${match_lhs}    ]] \
	&& type -P dircolors >/dev/null \
	&& match_lhs=$(dircolors --print-database)
[[ $'\n'${match_lhs} == *$'\n'"TERM "${safe_term}* ]] && use_color=true

if ${use_color} ; then
	# Enable colors for ls, etc.  Prefer ~/.dir_colors #64489
	if type -P dircolors >/dev/null ; then
		if [[ -f ~/.dir_colors ]] ; then
			eval $(dircolors -b ~/.dir_colors)
		elif [[ -f /etc/DIR_COLORS ]] ; then
			eval $(dircolors -b /etc/DIR_COLORS)
		fi
	fi

	if [[ ${EUID} == 0 ]] ; then
		PS1='\[\033[01;31m\][\h\[\033[01;36m\] \W\[\033[01;31m\]]\$\[\033[00m\] '
	else
		PS1='\[\033[01;32m\][\u@\h\[\033[01;37m\] \W\[\033[01;32m\]]\$\[\033[00m\] '
	fi

	alias ls='ls --color=auto'
	alias grep='grep --colour=auto'
	alias egrep='egrep --colour=auto'
	alias fgrep='fgrep --colour=auto'
else
	if [[ ${EUID} == 0 ]] ; then
		# show root@ when we don't have colors
		PS1='\u@\h \W \$ '
	else
		PS1='\u@\h \w \$ '
	fi
fi

unset use_color safe_term match_lhs sh

alias cp="cp -i"                          # confirm before overwriting something
alias df='df -h'                          # human-readable sizes
alias du='du -h'                          # human-readable sizes
alias free='free -m'                      # show sizes in MB
alias np='nano -w PKGBUILD'
alias more=less

xhost +local:root > /dev/null 2>&1

complete -cf sudo

# Bash won't get SIGWINCH if another process is in the foreground.
# Enable checkwinsize so that bash will check the terminal size when
# it regains control.  #65623
# http://cnswww.cns.cwru.edu/~chet/bash/FAQ (E11)
shopt -s checkwinsize

shopt -s expand_aliases

# export QT_SELECT=4

# Enable history appending instead of overwriting.  #139609
shopt -s histappend

#
# # ex - archive extractor
# # usage: ex <file>
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

# Colorscheme import from wal
(cat ~/.cache/wal/sequences &)

### EXPORTS ###
export EDITOR="/usr/bin/nvim"
export VISUAL="/usr/bin/nvim"
export PATH="$PATH:$HOME/Documents/flutter/bin"
export PATH="$PATH:$HOME/.local/bin"

### PERSONAL ALIASES ###
# nvim
alias v='nvim'
alias sv='sudo nvim'
# cd
alias ..='cd ..'
# mpv
alias mpvd='mpv --profile=youtube720p'
alias mpvl='mpv --profile=youtube360p'
alias mpvw='mpv --profile=window'
alias mpva='mpv --profile=audio-only'
alias mpvsw='mpv --profile=window-stream'
# git
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gd='git diff'
alias gaa='git add .'
alias gca='git commit -a'
alias gcam='git commit --amend'
alias gl='git log'
alias gch='git checkout'
alias gps='git push'
alias gpl='git pull'
alias git-aliases="grep --color=never \"='git \" ~/.bashrc"
# android device CLI mounting
alias android-mount='aft-mtp-cli'
#
alias sd='shutdown now'
alias ip='ip -br -c'
alias update-aliases='. ~/.bashrc'
alias update-packages="sudo pacman -Syu && notify-send 'PACMAN' 'Update complete!' || notify-send 'PACMAN' 'Exited with non-zero error code!'"

### PERSONAL FUNCTIONS ###
# cheat.sh (Display examples of command usage)
cheat() {
    curl cheat.sh/"$1"
}

# wttr.in (Display weather for selected location)
weather() {
    curl wttr.in/"$1"
}

# for easy saving of video without syncing to other devices
youtube-dl-save() {
    local download_icon
    local error_icon
    download_icon="/usr/share/icons/Papirus/32x32/apps/youtube-dl.svg"
    error_icon="/usr/share/icons/Papirus/32x32/status/dialog-error.svg"

    youtube-dl -o "$HOME/Videos/Saved/%(uploader)s/%(title)s.%(ext)s" "$@" \
        && notify-send -i "$download_icon" "[youtube-dl-save]" "Download complete!" \
        || notify-send -i "$error_icon" "[youtube-dl-save]" "Download failed!"
}

# for easy downloading of music
youtube-dl-audio() {
    youtube-dl -x --audio-format mp3 -o "$HOME/Downloads/Audio/%(title)s.%(ext)s" "$@"
}

# for easy downloading of streams
youtube-dl-stream() {
    local download_icon
    local error_icon
    download_icon="/usr/share/icons/Papirus/32x32/apps/youtube-dl.svg"
    error_icon="/usr/share/icons/Papirus/32x32/status/dialog-error.svg"

    youtube-dl -o "$HOME/Videos/Streams/%(uploader)s/%(title)s.%(ext)s" "$@" \
        && notify-send -i "$download_icon" "[youtube-dl-stream]" "Download complete!" \
        || notify-send -i "$error_icon" "[youtube-dl-stream]" "Download failed!"
}

# creates pieces of a file
split-create() {
    if [[ "$#" -eq 2 ]]; then
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
    if [[ "$#" -gt 2 ]]; then
        cat "${@:2}" > "$1" \
            && notify-send "[split-recreate]" "Operation completed!"
    else
        echo "Usage: split-recreate [output filename] [file pieces]"
        echo "[file pieces] Example: myfile.tar.gz.part* (The glob expands to cover all the pieces in order)"
    fi
}

# create .tar archive
ca() {
    if [[ "$#" -gt 2 ]]; then
        tar cvf "$1.tar" "${@:2}" \
            && notify-send "[ca]" "Archive created!"
    else
        echo "ca: create a .tar archive"
        echo "Usage: ca [archive name (no extension)] [input]"
    fi
}

# create compressed .tar.gz archive
cca() {
    if [[ "$#" -gt 2 ]]; then
        tar czvf "$1.tar.gz" "${@:2}" \
            && notify-send "[cca]" "Compressed archive created!"
    else
        echo "cca: create a compressed .tar.gz archive"
        echo "Usage: cca [archive name (no extension)] [input]"
    fi
}

# trim video/music files
trim-ffmpeg() {
    if [[ "$#" -eq 4 ]]; then
        local input_filename
        local input_extension
        local output_filename
        local output_extension
        input_filename="${3%.*}"
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
