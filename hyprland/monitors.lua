------------------
---- MONITORS ----
------------------
require("globals")

-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
hl.monitor({
    output   = Monitor2,
    mode     = "preferred",
    position = "0x0",
    scale    = "1",
})

hl.monitor({
    output   = Monitor1,
    mode     = "preferred",
    position = "1920x0",
    scale    = "1",
})

-- Fallback rule
hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto",
    scale    = "1",
})
