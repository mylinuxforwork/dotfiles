-- -----------------------------------------------------
-- General window decoration
-- name: "Rounding"
-- -----------------------------------------------------

hl.config({
    decoration = {
        rounding = 10,
        active_opacity = 1.0,
        inactive_opacity = 0.8,
        fullscreen_opacity = 1.0,
        rounding_power = 2,

        shadow = {
            enabled = true,
            range = 32,
            render_power = 2,
            color = "rgba(66000000)",
        },

        blur = {
            enabled   = true,
            size      = 3,
            passes    = 4,
            new_optimizations = on,
            ignore_opacity = true,
            xray = true,
            vibrancy  = 0.1696,
        },
    },
})