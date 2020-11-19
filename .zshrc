# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
unsetopt beep
bindkey -v
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/vinesma/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

zstyle ':completion:*' menu select
setopt COMPLETE_ALIASES

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Change the window title of X terminals
autoload -Uz add-zsh-hook

function xterm_title_precmd () {
	print -Pn -- "\e]2;${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/\~}\a"
	[[ "$TERM" == 'screen'* ]] && print -Pn -- '\e_\005{g}%n\005{-}@\005{m}%m\005{-} \005{B}%~\005{-}\e\\'
}

function xterm_title_preexec () {
	print -Pn -- '\e]2;%n@%m %~ %# ' && print -n -- "${(q)1}\a"
	[[ "$TERM" == 'screen'* ]] && { print -Pn -- '\e_\005{g}%n\005{-}@\005{m}%m\005{-} \005{B}%~\005{-} %# ' && print -n -- "${(q)1}\e\\"; }
}

if [[ "$TERM" == (alacritty*|gnome*|konsole*|putty*|rxvt*|screen*|tmux*|xterm*) ]]; then
	add-zsh-hook -Uz precmd xterm_title_precmd
	add-zsh-hook -Uz preexec xterm_title_preexec
fi

# Change cursor shape for different vi modes.
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] ||
     [[ $1 = 'block' ]]; then
    echo -ne '\e[1 q'
  elif [[ ${KEYMAP} == main ]] ||
       [[ ${KEYMAP} == viins ]] ||
       [[ ${KEYMAP} = '' ]] ||
       [[ $1 = 'beam' ]]; then
    echo -ne '\e[5 q'
  fi
}
zle -N zle-keymap-select
zle-line-init() {
    zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
    echo -ne "\e[5 q"
}
zle -N zle-line-init
echo -ne '\e[5 q' # Use beam shape cursor on startup.
preexec() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.

## USER SPACE ##

setopt autocd		# Automatically cd into typed directory.

# Edit line in vim with ctrl-v:
autoload edit-command-line; zle -N edit-command-line
bindkey '^V' edit-command-line

# Bindings from bash
bindkey "^[." insert-last-word
bindkey "^K" kill-line
bindkey "^A" beginning-of-line
bindkey "^E" end-of-line
bindkey "^[[1;5D" backward-word
bindkey "^[[1;5C" forward-word
bindkey "^R" history-incremental-search-backward
bindkey "^S" history-incremental-search-forward

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
alias cp="cp -i"                          # confirm before overwriting something
alias df='df -h'                          # human-readable sizes
alias du='du -h'                          # human-readable sizes
alias free='free -m'                      # show sizes in MB
alias np='nano -w PKGBUILD'
alias more=less
alias ls='ls --color=auto'
alias l='ls'                              # fail-proofing
alias s='ls'                              # fail-proofing
alias grep='grep --colour=auto'
alias egrep='egrep --colour=auto'
alias fgrep='fgrep --colour=auto'
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
alias git-aliases="grep --color=never \"='git \" ~/.zshrc"
# android device CLI mounting
alias android-mount='aft-mtp-cli'
#
alias sd='shutdown now'
alias ip='ip -br -c'
alias update-aliases='. ~/.zshrc'

### PERSONAL FUNCTIONS ###
# cheat.sh (Display examples of command usage)
cheat() {
    curl cheat.sh/"$1"
}

# wttr.in (Display weather for selected location)
weather() {
    curl wttr.in/"$1"
}

# Update mirrors and then all packages in the system.
update-packages() {
    local icon_success
    local icon_fail
    local answer
    icon_success="/usr/share/icons/Papirus/32x32/apps/system-software-update.svg"
    icon_fail="/usr/share/icons/Papirus/32x32/apps/system-error.svg"

    echo -e "\t:: Update mirrorlist with the fastest mirrors? (y/n)"
    read -r answer

    [[ "$answer" == @(y|Y) ]] && sudo pacman-mirrors --fasttrack --continent

    sudo pacman -Syyu | tee ~/last-update-log.tmp && \
    notify-send -i "$icon_success" 'PACMAN' 'Update complete!' || \
    notify-send -i "$icon_fail" 'PACMAN' 'Update FAILURE!'

    yay -Sua \
    notify-send -i "$icon_success" 'YAY' 'Update complete!' || \
    notify-send -i "$icon_fail" 'YAY' 'Update FAILURE!'
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

# SOURCES
source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
