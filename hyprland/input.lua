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

local function bind_exec(bindings)
    for key, cmd in pairs(bindings) do
        hl.bind(key, hl.dsp.exec_cmd(cmd))
    end
end

-- APPS
bind_exec({
    [MainMod .. " + return"]      = Terminal,
    [MainMod .. " + ALT + B"]     = Browser,
    [MainMod .. " + ALT + E"]     = FileManager,
    [MainMod .. " + ALT + S"]     = "steam -gamepadui",
    [MainMod .. " + ALT + M"]     = Terminal .. " -T MPD ncmpcpp -q",
    [MainMod .. " + ALT + W"]     = "~/.dotfiles/scripts/bg-setter/choose-bg.sh",
    ["CTRL + ALT + delete"]       = Terminal .. " htop",
})

-- ROFI
bind_exec({
    [MainMod .. " + R"]           = "rofi -show drun -theme ~/.config/rofi/colors-rofi-launcher.rasi",
    [MainMod .. " + CTRL + M"]    = "~/.dotfiles/scripts/mpd/music-browser.sh",
    [MainMod .. " + ALT + P"]     = "~/.dotfiles/scripts/mpv/clipboard-mpv.sh",
    [MainMod .. " + Q"]           = "~/.dotfiles/scripts/rofi/powermenu.sh",
    [MainMod .. " + E"]           = "rofi -show window -theme ~/.config/rofi/colors-rofi-launcher.rasi",
})

-- MEDIA CONTROL
local media = function(cmd) return MediaControlScript .. cmd end
bind_exec({
    [MainMod .. " + P"]           = media(" toggle"),
    [MainMod .. " + page_up"]     = media(" +10"),
    [MainMod .. " + page_down"]   = media(" -10"),
    [MainMod .. " + home"]        = media(" seek +10"),
    [MainMod .. " + end"]         = media(" seek -10"),
    [MainMod .. " + comma"]       = media(" jump prev"),
    [MainMod .. " + period"]      = media(" jump next"),
    ["pause"]                     = media(" toggle"),
    ["xf86audioplay"]             = "playerctl play-pause",
    ["xf86audiostop"]             = "playerctl stop",
    ["xf86audionext"]             = "playerctl next",
    ["xf86audioprev"]             = "playerctl previous",
})

-- NOTIFICATIONS
bind_exec({
    [MainMod .. " + H"]           = "dunstctl history-pop",
    ["CTRL + space"]              = "dunstctl close",
    ["CTRL + SHIFT + space"]      = "dunstctl close-all",
})

-- SCREENSHOTS
hl.bind("Print",
    hl.dsp.exec_cmd(
        "grim -o \"$(hyprctl activeworkspace | grep -o \"monitor .*:\" | head -n 1 | cut -d ' ' -f2 | cut -d ':' -f1)\""))
hl.bind(MainMod .. " + Print", hl.dsp.exec_cmd("grim -g \"$(slurp)\""))

-- WINDOW SWAPPING
for _, dir in ipairs({ "left", "right", "up", "down" }) do
    hl.bind(MainMod .. " + SHIFT + " .. dir, function()
        hl.dispatch(hl.dsp.window.move({ direction = dir }))
    end)
end

-- FOCUS MOVE
for _, dir in ipairs({ "left", "right", "up", "down" }) do
    hl.bind(MainMod .. " + " .. dir, function()
        hl.dispatch(hl.dsp.focus({ direction = dir }))
    end)
end

local workspaceKeys = { 'A', 'S', 'D', 'F', 'G' }
-- SWITCH WORKSPACES
for i = 1, #workspaceKeys do
    hl.bind(MainMod .. " + " .. workspaceKeys[i], hl.dsp.focus({ workspace = i }))
end

-- MOVE ACTIVE WINDOW TO WORKSPACE
-- + THE DON'T-FOLLOW VARIANT
for i = 1, #workspaceKeys do
    hl.bind(MainMod .. " + CTRL + " .. workspaceKeys[i], hl.dsp.window.move({ workspace = i }))
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
