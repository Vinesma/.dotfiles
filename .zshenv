# EXPORTS
# editor
export EDITOR="/usr/bin/nvim"
export VISUAL="/usr/bin/nvim"
# flutter
export PATH="$PATH:$HOME/Documents/flutter/bin"
# add .local/bin to PATH
export PATH="$PATH:$HOME/.local/bin"
# fcitx
export GTK_IM_MODULE="fcitx"
export QT_IM_MODULE="fcitx"
export SDL_IM_MODULE="fcitx"
export XMODIFIERS="@im=fcitx"
# android visual studio
export ANDROID_HOME=$HOME/Documents/Android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools
# IME support in Kitty
export GLFW_IM_MODULE=ibus
# ssh-agent
export SSH_AUTH_SOCK=$XDG_RUNTIME_DIR/ssh-agent.socket
# pacdiff
export DIFFPROG="nvim -d"
