#!/usr/bin/env bash
while IFS= read -r extension; do
    codium --install-extension "$extension"
done < "${HOME}/.dotfiles/VSCodium/codium-extensions.txt"
printf "Extensions installed."
