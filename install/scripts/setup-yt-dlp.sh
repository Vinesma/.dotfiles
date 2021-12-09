#!/usr/bin/env bash
#
# Setup yt-dlp, a video extractor/downloader for youtube and other sites.

WORK_DIR=$HOME/.dotfiles/install/workdir/
SOURCE=https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp
SOURCE_DOCS=https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp.tar.gz

# -- SETUP --
if [ ! -d "$WORK_DIR" ]; then
    mkdir "$WORK_DIR" || { printf "%s\n" "FAILED: creating $WORK_DIR."; exit 1; }
fi

# -- ACT --
cd "$WORK_DIR" || exit 1

sudo curl -L "$SOURCE" -o /usr/local/bin/yt-dlp
sudo chmod a+rx /usr/local/bin/yt-dlp

curl -L "$SOURCE_DOCS" -o yt-dlp.tar.gz
tar xf yt-dlp.tar.gz
cd yt-dlp || exit 1
sudo cp yt-dlp.1 /usr/share/man/man1
sudo cp completions/zsh/_yt-dlp /usr/share/zsh/functions/Completion/X
sudo mandb

# -- CLEANUP --
cd "$HOME" || exit 1
rm -rf "$WORK_DIR"