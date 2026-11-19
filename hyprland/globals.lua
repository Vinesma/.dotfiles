---------------------
------ GLOBALS ------
---------------------

MainMod = "SUPER"
Terminal = "kitty"
FileManager = "thunar"
Browser = "firefox"
MediaControlScript = "~/.dotfiles/scripts/media-control.sh"

-- Add a new monitor here.
-- Primary/Secondary below are just positional indices into this table.
Monitors = {
    {
        name  = "DP-2",
        mode  = "1920x1080@120",
        position = "0x0",
        scale = "1",
        vrr   = 3,
        cm    = "auto",
    },
}

-- Positional helpers. These return the monitor NAME (string)
-- so they can be used directly in hl.workspace_rule / hl.monitor output fields.
function PrimaryMonitor()
    return Monitors[1] and Monitors[1].name
end

function SecondaryMonitor()
    return Monitors[2] and Monitors[2].name
end
