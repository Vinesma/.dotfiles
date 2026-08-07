-------------------
---- AUTOSTART ----
-------------------
require("globals")

-- See https://wiki.hypr.land/Configuring/Basics/Autostart/

-- Autostart necessary processes (like notifications daemons, status bars, etc.)
-- Or execute your favorite apps at launch like this:
--
hl.on("hyprland.start", function()
    -- Wallpaper
    hl.exec_cmd("~/.dotfiles/hyprland/scripts/wallpaper.sh")
    -- Status Bar
    hl.exec_cmd("~/.dotfiles/waybar/launch.sh")
    hl.exec_cmd("/usr/lib/polkit-kde-authentication-agent-1")

    -- GTK 3 Apps
    hl.exec_cmd("gsettings set org.gnome.desktop.interface gtk-theme Matcha-dark-azul")
    hl.exec_cmd("gsettings set org.gnome.desktop.interface icon-theme Papirus-Dark")
    hl.exec_cmd("gsettings set org.gnome.desktop.interface cursor-theme Adwaita")
    hl.exec_cmd("gsettings set org.gnome.desktop.interface font-name JetBrainsMono NF Medium 11")

    -- Screenshare
    hl.exec_cmd(" dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")

    -- Main Autostart Block
    hl.exec_cmd("fcitx")
    hl.exec_cmd("gammastep-indicator -m wayland")
    hl.exec_cmd("wl-paste --watch cliphist store")

    hl.exec_cmd(Browser)
    hl.exec_cmd("qbittorrent")
    hl.exec_cmd("nicotine")
    hl.exec_cmd("flatpak run md.obsidian.Obsidian")
    hl.exec_cmd("sleep 8s && steam")
end)
