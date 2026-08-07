---------------
---- INPUT ----
---------------
require("globals")

hl.config({
    input = {
        kb_layout          = "br",
        kb_variant         = "",
        kb_model           = "",
        kb_options         = "",
        kb_rules           = "",
        numlock_by_default = true,

        follow_mouse       = 1,

        sensitivity        = 0, -- -1.0 - 1.0, 0 means no modification.

        touchpad           = {
            natural_scroll = true,
        },
    },
})

---------------------
---- KEYBINDINGS ----
---------------------

hl.bind(MainMod .. " + CTRL + Q", function()
    hl.dispatch(hl.dsp.exit())
end)
hl.bind(MainMod .. " + CTRL + R", hl.dsp.exec_cmd("hyprctl reload"))
hl.bind(MainMod .. " + W", hl.dsp.window.close())
hl.bind(MainMod .. " + up", function()
    hl.dispatch(hl.dsp.window.fullscreen({ action = "set" }))
end)
hl.bind(MainMod .. " + down", function()
    hl.dispatch(hl.dsp.window.fullscreen({ action = "unset" }))
end)
hl.bind(MainMod .. " + V", function()
    hl.dispatch(hl.dsp.window.float({ action = "toggle" }))
end)
hl.bind("ALT + tab", function()
    hl.dispatch(hl.dsp.window.cycle_next())
end)

-- APPS
hl.bind(MainMod .. " + return", hl.dsp.exec_cmd(Terminal))
hl.bind(MainMod .. " + ALT + B", hl.dsp.exec_cmd(Browser))
hl.bind(MainMod .. " + ALT + E", hl.dsp.exec_cmd(FileManager))
hl.bind(MainMod .. " + ALT + S",
    hl.dsp.exec_cmd("SDL_VIDEODRIVER=x11 gamescope -W 1920 -H 1080 -r 140 -e -f -- steam -gamepadui"))
hl.bind(MainMod .. " + ALT + M", hl.dsp.exec_cmd(Terminal .. " -T MPD ncmpcpp -q"))
hl.bind("CTRL + ALT + delete", hl.dsp.exec_cmd(Terminal .. " htop"))

-- ROFI
hl.bind(MainMod .. " + R", hl.dsp.exec_cmd("rofi -show drun -theme ~/.cache/wal/colors-rofi-launcher.rasi"))
hl.bind(MainMod .. " + Q", hl.dsp.exec_cmd("~/.dotfiles/scripts/rofi/powermenu.sh"))
hl.bind(MainMod .. " + E", hl.dsp.exec_cmd("rofi -show window -theme ~/.cache/wal/colors-rofi-launcher.rasi"))
hl.bind(MainMod .. " + CTRL + M", hl.dsp.exec_cmd("~/.dotfiles/scripts/mpd/music-browser.sh"))
hl.bind(MainMod .. " + ALT + W", hl.dsp.exec_cmd("~/.dotfiles/scripts/bg-setter/choose-bg.sh"))
hl.bind(MainMod .. " + ALT + P", hl.dsp.exec_cmd("~/.dotfiles/scripts/mpv/clipboard-mpv.sh"))

-- MEDIA CONTROL
hl.bind("pause", hl.dsp.exec_cmd(MediaControlScript .. " toggle"))
hl.bind(MainMod .. " + P", hl.dsp.exec_cmd(MediaControlScript .. " toggle"))
hl.bind(MainMod .. " + page_up", hl.dsp.exec_cmd(MediaControlScript .. " +10"))
hl.bind(MainMod .. " + page_down", hl.dsp.exec_cmd(MediaControlScript .. " -10"))
hl.bind(MainMod .. " + home", hl.dsp.exec_cmd(MediaControlScript .. " seek +10"))
hl.bind(MainMod .. " + end", hl.dsp.exec_cmd(MediaControlScript .. " seek -10"))
hl.bind(MainMod .. " + insert", hl.dsp.exec_cmd("mpc stop"))
hl.bind(MainMod .. " + comma", hl.dsp.exec_cmd(MediaControlScript .. " jump prev"))
hl.bind(MainMod .. " + period", hl.dsp.exec_cmd(MediaControlScript .. " jump next"))
hl.bind("xf86audioplay", hl.dsp.exec_cmd("playerctl play-pause"))
hl.bind("xf86audiostop", hl.dsp.exec_cmd("playerctl stop"))
hl.bind("xf86audionext", hl.dsp.exec_cmd("playerctl next"))
hl.bind("xf86audioprev", hl.dsp.exec_cmd("playerctl previous"))

-- SCREENSHOTS
hl.bind("Print",
    hl.dsp.exec_cmd(
        "grim -o \"$(hyprctl activeworkspace | grep -o \"monitor .*:\" | head -n 1 | cut -d ' ' -f2 | cut -d ':' -f1)\""))
hl.bind(MainMod .. " + Print", hl.dsp.exec_cmd("grim -g \"$(slurp)\""))

-- NOTIFICATIONS
hl.bind("CTRL + space", hl.dsp.exec_cmd("dunstctl close"))
hl.bind("CTRL + SHIFT + space", hl.dsp.exec_cmd("dunstctl close-all"))
hl.bind(MainMod .. " + H", hl.dsp.exec_cmd("dunstctl history-pop"))

-- WINDOW SWAPPING
hl.bind(MainMod .. " + SHIFT + left", function()
    hl.dispatch(hl.dsp.window.move({ direction = "left" }))
end)
hl.bind(MainMod .. " + SHIFT + right", function()
    hl.dispatch(hl.dsp.window.move({ direction = "right" }))
end)
hl.bind(MainMod .. " + SHIFT + up", function()
    hl.dispatch(hl.dsp.window.move({ direction = "up" }))
end)
hl.bind(MainMod .. " + SHIFT + down", function()
    hl.dispatch(hl.dsp.window.move({ direction = "down" }))
end)

-- FOCUS MOVE
hl.bind(MainMod .. " + left", function()
    hl.dispatch(hl.dsp.focus({ direction = "left" }))
end)
hl.bind(MainMod .. " + right", function()
    hl.dispatch(hl.dsp.focus({ direction = "right" }))
end)
hl.bind(MainMod .. " + up", function()
    hl.dispatch(hl.dsp.focus({ direction = "up" }))
end)
hl.bind(MainMod .. " + down", function()
    hl.dispatch(hl.dsp.focus({ direction = "down" }))
end)

local workspaceKeys = { 'A', 'S', 'D', 'F', 'G' }
-- SWITCH WORKSPACES
for i = 1, #workspaceKeys do
    hl.bind(MainMod .. " + " .. workspaceKeys[i], hl.dsp.focus({ workspace = i }))
end

-- MOVE ACTIVE WINDOW TO WORKSPACE
for i = 1, #workspaceKeys do
    hl.bind(MainMod .. " + CTRL + " .. workspaceKeys[i], hl.dsp.window.move({ workspace = i }))
end

-- SAME AS ABOVE, BUT DO NOT FOLLOW THE WINDOW
for i = 1, #workspaceKeys do
    hl.bind(MainMod .. " + SHIFT + " .. workspaceKeys[i], hl.dsp.window.move({ workspace = i, follow = false }))
end

-- SCROLL THROUGH EXISTING WORKSPACES
hl.bind(MainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(MainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- MOVE/RESIZE WINDOWS WITH MAINMOD + LMB/RMB MOUSE
hl.bind(MainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(MainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- LID SWITCH
hl.bind("switch:Lid Switch", hl.dsp.exec_cmd("swaylock"), {
    locked = true,
})
