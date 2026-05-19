-- Game Mode
function activate_gamemode()
    -- Apply Performance Settings
    hl.config({
        animations = { enabled = false },
        decoration = {
            shadow = { enabled = false },
            blur = { enabled = false },
            active_opacity = 1.0,
            inactive_opacity = 1.0,
            fullscreen_opacity = 1.0,
            rounding = 0
        },
        general = {
            gaps_in = 0,
            gaps_out = 0,
            border_size = 1
        }
    })
    print("Gamemode ON")
end

-- Load Variant
function load_variant(variant_file,variant_name)
    variant_file = variant_file:gsub(".lua", "")
    require("conf." .. variant_name .. "." .. variant_file)
end