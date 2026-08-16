-------------------
---- AUTOSTART ----
-------------------
require("globals")
require("colors")

-- See https://wiki.hypr.land/Configuring/Basics/Autostart/

hl.on("hyprland.start", function()
    -- Wallpaper
    hl.exec_cmd("~/.dotfiles/hyprland/scripts/wallpaper.sh --image-path " .. Image)
    -- Status Bar
    hl.exec_cmd("~/.dotfiles/waybar/launch.sh")
    hl.exec_cmd("/usr/lib/polkit-kde-authentication-agent-1")

    -- GTK 3 Apps
    hl.exec_cmd("gsettings set org.gnome.desktop.interface gtk-theme Matcha-dark-azul")
    hl.exec_cmd("gsettings set org.gnome.desktop.interface icon-theme Papirus-Dark")
    hl.exec_cmd("gsettings set org.gnome.desktop.interface cursor-theme Adwaita")
    hl.exec_cmd("gsettings set org.gnome.desktop.interface font-name JetBrainsMono NF Medium 11")

    -- Screenshare
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")

    local autostartApps = {
        "fcitx",
        "gammastep-indicator -m wayland",
        "wl-paste --watch cliphist store",

        Browser,
        "qbittorrent",
        "nicotine",
        "flatpak run md.obsidian.Obsidian",
        "sleep 8s && steam",
    }

    for i = 1, #autostartApps do
        hl.exec_cmd(autostartApps[i])
    end
end)
