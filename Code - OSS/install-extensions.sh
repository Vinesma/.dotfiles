while IFS= read -r extension; do
    code --install-extension "$extension"
done < "./vscode-extensions.txt"

