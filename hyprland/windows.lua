--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------
require("globals")

-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/
-- and https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/

local firstWorkspaceMonitor
if SecondaryMonitor then
    firstWorkspaceMonitor = SecondaryMonitor
else
    firstWorkspaceMonitor = PrimaryMonitor
end

hl.workspace_rule({
    workspace = "1",
    monitor = firstWorkspaceMonitor,
    default = true,
    layout_opts = {
        orientation = "right",
    },
})
hl.workspace_rule({
    workspace = "2",
    monitor = PrimaryMonitor,
    default = true,
})
hl.workspace_rule({
    workspace = "3",
    monitor = PrimaryMonitor,
})
hl.workspace_rule({
    workspace = "4",
    monitor = PrimaryMonitor,
})
hl.workspace_rule({
    workspace = "5",
    monitor = PrimaryMonitor
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

hl.window_rule({
    workspace = "1 silent",
    opacity = "0.88 override 0.88 override",
    match = {
        class = "^md.Obsidian$",
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
    match = {
        title = "^Bottles$",
    },
})
hl.window_rule({
    float = true,
    match = {
        title = "^Firefox — Sharing Indicator$",
    },
})
hl.window_rule({
    float = true,
    size = "(monitor_w*0.3) (monitor_h*0.4)",
    match = {
        title = "^Select Bottle$",
    },
})
hl.window_rule({
    float = true,
    size = "(monitor_w*0.6) (monitor_h*0.6)",
    match = {
        title = "^Picture-in-Picture$",
    },
})
hl.window_rule({
    float = true,
    size = "(monitor_w*0.8) (monitor_h*0.8)",
    match = {
        class = "^onion.torzu_emu.torzu$",
    },
})
hl.window_rule({
    float = true,
    size = "(monitor_w*0.5) (monitor_h*0.5)",
    match = {
        class = "^[Tt]hunar$",
    },
})
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
    float = true,
    size = "(monitor_w*0.4) (monitor_h*0.4)",
    match = {
        class = "^mpv$",
    },
})
hl.window_rule({
    float = true,
    size = "(monitor_w*0.3) (monitor_h*0.4)",
    match = {
        class = "^xarchiver$",
    },
})
hl.window_rule({
    float = true,
    size = "(monitor_w*0.4) (monitor_h*0.4)",
    match = {
        class = "^virt-manager$",
    },
})
hl.window_rule({
    float = true,
    match = {
        title = "^MTool$",
    },
})
hl.window_rule({
    opacity = "0.85 override 0.85 override",
    match = {
        title = "^.*VSCodium$",
    },
})
