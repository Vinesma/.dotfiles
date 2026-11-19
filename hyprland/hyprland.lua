-- HYPRLAND CONFIG
-- Current Hyprland version: 0.57.2
-- Run 'hyprctl version | head -n 1 | cut -d ' ' -f1,2' to get this information
--
-- Refer to the wiki for more information.
-- https://wiki.hypr.land/getting-started

-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

-- See https://wiki.hypr.land/configuring/core/environment-variables

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

-------------------------------
---- REQUIRE BLOCK ------------
-------------------------------

require("monitors")
require("autostart")
require("input")
require("looknfeel")
require("windows")
require("permissions")
