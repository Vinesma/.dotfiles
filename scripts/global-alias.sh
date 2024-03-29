# Exposes aliases for general use
# Similar to a .bash_aliases file
# shellcheck shell=bash

alias cp="cp -i"     # confirm before overwriting something
alias df='df -h'     # human-readable sizes
alias du='du -h'     # human-readable sizes
alias free='free -m' # show sizes in MB
alias more=less
alias ls='ls --color=auto'
alias l='ls' # fail-proofing
alias s='ls' # fail-proofing
alias grep='grep --colour=auto'
alias egrep='egrep --colour=auto'
alias fgrep='fgrep --colour=auto'
alias journalctl='journalctl -r' # always forget this
alias email='neomutt'
alias music='ncmpcpp'
alias anacrontab='sudoedit /etc/anacrontab'
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
alias gaa='git add .'
alias gr='git restore'
alias gc='git commit'
alias gca='git commit -a'
alias gcam='git commit --amend'
alias gcp='git cherry-pick'
alias gch='git checkout'
alias gsw='git switch'
alias gb='git branch'
alias gm='git merge'
alias gre='git rebase'
alias gd='git diff'
alias gl='git log --graph --abbrev-commit --decorate'
alias gps='git push'
alias gpsnu='git push --set-upstream origin'
alias gpl='git pull'
alias git-aliases="grep --color=never \"='git \" ~/.zshrc"
# android device CLI mounting
alias android-mount='aft-mtp-cli'
# kitty
alias kssh='kitty +kitten ssh'
# ffprobe
alias ffprobe-bitrate-audio='ffprobe -v quiet -select_streams a:0 -show_entries stream=bit_rate -of default=noprint_wrappers=1:nokey=1'
#
alias sd='shutdown now'
alias ip='ip -br -c'
alias lock-session='dm-tool switch-to-greeter'
alias code='codium'
alias update-aliases='source ~/.zshrc'
