#!/usr/bin/env bash
#
# Setup/update yt-dlp, a video extractor/downloader for youtube and other sites.

WORK_DIR=$HOME/.dotfiles/install/workdir/
SOURCE=https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp
SOURCE_DOCS=https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp.tar.gz
ZSH_COMPLETION_DIR=/usr/share/zsh/functions/Completion/X

# -- SETUP --
if [ ! -d "$WORK_DIR" ]; then
    mkdir "$WORK_DIR" || { printf "%s\n" "FAILED: creating $WORK_DIR."; exit 1; }
fi

# -- ACT --
cd "$WORK_DIR" || exit 1

if ! command -v yt-dlp; then
    sudo curl -L "$SOURCE" -o /usr/local/bin/yt-dlp
    sudo chmod a+rx /usr/local/bin/yt-dlp
else
    sudo yt-dlp -U
fi

curl -L "$SOURCE_DOCS" -o yt-dlp.tar.gz
tar xf yt-dlp.tar.gz
cd yt-dlp || exit 1
sudo cp -vf yt-dlp.1 /usr/share/man/man1
[ -d $ZSH_COMPLETION_DIR ] && \
    sudo cp -vf completions/zsh/_yt-dlp $ZSH_COMPLETION_DIR
sudo mandb

# -- CLEANUP --
cd "$HOME" || exit 1
rm -rf "$WORK_DIR"
