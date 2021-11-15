while IFS= read -r extension; do
    code --install-extension "$extension"
done < "~/.dotfiles/Code - OSS/vscode-extensions.txt"

