------------------
---- MONITORS ----
------------------
require("globals")

-- See https://wiki.hypr.land/Configuring/Basics/Monitors/

if SecondaryMonitor then
    hl.monitor({
        output   = SecondaryMonitor,
        mode     = "preferred",
        position = "0x0",
        scale    = "1",
    })

    hl.monitor({
        output   = PrimaryMonitor,
        mode     = "preferred",
        position = "1920x0",
        scale    = "1",
    })
else
    hl.monitor({
        output   = PrimaryMonitor,
        mode     = "preferred",
        position = "0x0",
        scale    = "1",
    })
end

-- Fallback rule
hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto",
    scale    = "1",
})
