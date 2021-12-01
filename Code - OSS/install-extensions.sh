#!/usr/bin/env bash
while IFS= read -r extension; do
    code --install-extension "$extension"
done < "${HOME}/.dotfiles/Code - OSS/vscode-extensions.txt"
printf "Extensions installed."
