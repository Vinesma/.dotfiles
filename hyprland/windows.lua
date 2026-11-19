--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------
require("globals")

-- See https://wiki.hypr.land/configuring/core/rules/window-rules
-- and https://wiki.hypr.land/configuring/core/rules/workspace-rules

local primaryMonitor = PrimaryMonitor()
local firstWorkspaceMonitor = SecondaryMonitor() or PrimaryMonitor()
local firstWorkspaceMonitorLayoutOptions = {}

if SecondaryMonitor() then
    firstWorkspaceMonitorLayoutOptions.orientation = "right"
end

hl.workspace_rule({
    workspace = "1",
    monitor = firstWorkspaceMonitor,
    default = true,
    layout_opts = firstWorkspaceMonitorLayoutOptions,
})
hl.workspace_rule({
    workspace = "2",
    monitor = primaryMonitor,
    default = true,
})
hl.workspace_rule({
    workspace = "3",
    monitor = primaryMonitor,
})
hl.workspace_rule({
    workspace = "4",
    monitor = primaryMonitor,
})
hl.workspace_rule({
    workspace = "5",
    monitor = primaryMonitor
})

local suppressMaximizeRule = hl.window_rule({
    -- Ignore maximize requests from all apps. You'll probably like this.
    name           = "suppress-maximize-events",
    match          = { class = ".*" },

    suppress_event = "maximize",
})
suppressMaximizeRule:set_enabled(true)

hl.window_rule({
    -- Fix some dragging issues with XWayland
    name     = "fix-xwayland-drags",
    match    = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },

    no_focus = true,
})

-- Hyprland-run windowrule
hl.window_rule({
    name  = "move-hyprland-run",
    match = { class = "hyprland-run" },

    move  = "20 monitor_h-120",
    float = true,
})

local obsidianWorkspace = SecondaryMonitor() and "1" or "2"
hl.window_rule({
    workspace = obsidianWorkspace .. " silent",
    opacity = "0.88 override 0.88 override",
    match = {
        class = "^md.obsidian.Obsidian$",
    },
})
hl.window_rule({
    workspace = "3 silent",
    match = {
        title = "^Steam$",
    },
})
hl.window_rule({
    workspace = "3 silent",
    match = {
        title = "^Sign in to Steam$",
    },
})
hl.window_rule({
    workspace = "3 silent",
    float = true,
    match = {
        title = "^Friends List$",
    },
})
hl.window_rule({
    workspace = "4 silent",
    match = {
        class = "^org.qbittorrent.qBittorrent$",
    },
})
hl.window_rule({
    float = true,
    persistent_size = true,
    match = {
        title = "^Bottles$",
    },
})
hl.window_rule({
    float = true,
    persistent_size = true,
    match = {
        title = "^Flatseal$",
    },
})
hl.window_rule({
    float = true,
    match = {
        title = "^Firefox — Sharing Indicator$",
    },
})

-- Floating rules
local function float_rule(name, match, size)
    hl.window_rule({
        float = true,
        name  = name,
        match = match,
        size  = size,
    })
end

float_rule("select-bottle", { title = "^Select Bottle$" },         "(monitor_w*0.3) (monitor_h*0.4)")
float_rule("pip",           { title = "^Picture-in-Picture$" },    "(monitor_w*0.6) (monitor_h*0.6)")
float_rule("torzu",         { class = "^onion.torzu_emu.torzu$" }, "(monitor_w*0.8) (monitor_h*0.8)")
float_rule("portal-gtk",    { class = "xdg-desktop-portal-gtk" },  "(monitor_w*0.5) (monitor_h*0.5)")
float_rule("thunar",        { class = "^[Tt]hunar$" },             "(monitor_w*0.5) (monitor_h*0.5)")
float_rule("mpv",           { class = "^mpv$" },                   "(monitor_w*0.4) (monitor_h*0.4)")
float_rule("xarchiver",     { class = "^xarchiver$" },             "(monitor_w*0.3) (monitor_h*0.4)")
float_rule("virt-manager",  { class = "^virt-manager$" },          "(monitor_w*0.4) (monitor_h*0.4)")

hl.window_rule({
    size = "(monitor_w*0.3) (monitor_h*0.2)",
    match = {
        title = "^Rename \".+\"$",
    },
})
hl.window_rule({
    float = true,
    match = {
        class = "^feh$",
    },
})
hl.window_rule({
    float = true,
    match = {
        class = "^imv$",
    },
})
hl.window_rule({
    float = true,
    match = {
        class = "^swayimg$",
    },
})
hl.window_rule({
    opacity = "0.85 override 0.85 override",
    match = {
        title = "^.*VSCodium$",
    },
})
hl.window_rule({
    match           = {
        title = "^Jellyfin$",
        fullscreen = true,
    },
    border_size     = 0,
    rounding        = 0,
    decorate        = false,
    sync_fullscreen = true,
    no_dim          = true,
    no_max_size     = true,
    no_shadow       = true,
    persistent_size = true,
    no_blur         = true,
    idle_inhibit    = "always",
})

-- Game rules
local function tag_game(match)
    hl.window_rule({ match = match, tag = "+game" })
end

tag_game({ class = "steam_app_.*|gamescope|steam_proton|retroarch" })
tag_game({ xdg_tag = "proton-game" })

-- Shared options applied to every game window rule.
local game_opts = {
    content      = "game",
    center       = true,
    immediate    = true,
    no_blur      = true,
    float        = true,
    opacity      = "2 2",
    idle_inhibit = "always",
}

hl.window_rule({
    name  = "game-rule",
    match = { tag = "game" },
    table.unpack(game_opts),
    border_size     = 0,
    rounding        = 0,
    decorate        = false,
    force_rgbx      = true,
    sync_fullscreen = true,
    no_anim         = true,
    no_dim          = true,
    no_max_size     = true,
    no_shadow       = true,
    persistent_size = true,
    focus_on_activate = true,
})
