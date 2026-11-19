------------------
---- MONITORS ----
------------------
require("globals")

-- See https://wiki.hypr.land/Configuring/Basics/Monitors/

local function monitor_entry(m)
    local cfg = {
        output   = m.name,
        mode     = m.mode,
        position = m.position,
        scale    = m.scale,
    }
    if m.transform then
        cfg.transform = m.transform
    end
    if m.vrr then
        cfg.vrr = m.vrr
    end
    if m.cm then
        cfg.cm = m.cm
    end
    if m.bitdepth then
        cfg.bitdepth = m.bitdepth
    end
    return cfg
end

for _, m in ipairs(Monitors) do
    hl.monitor(monitor_entry(m))
end

-- Fallback rule
hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto",
    scale    = "1",
})
