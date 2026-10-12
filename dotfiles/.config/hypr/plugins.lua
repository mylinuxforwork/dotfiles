-- Configuration for Hyprland plugins
-- See: https://wiki.hypr.land/Plugins/Using-Plugins/
-- And: https://github.com/hyprwm/hyprland-plugins
-- Also a list of Plugins: https://hypr.land/plugins/

-- Init Hyprland plugins
hl.exec_cmd("hyprpm reload -n")

--
-- Plugin configuration
--

-- Example for Hyprbars
-- See: https://github.com/hyprwm/hyprland-plugins/tree/main/hyprbars
-- Check if 'hyprbars' is installed and enabled
if hl.plugin.hyprbars ~= nil then
-- Set the config
    hl.config({
        plugin = {
            hyprbars = {
                -- example config
                bar_color = "rgba(121318cc)",
                col = {
                  text = "rgb(e2e2e9)",
                },
                bar_height = 30,
                bar_text_size = 18,
                bar_part_of_window = true,
                bar_precedence_over_border = true,
                on_double_click = "hyprctl dispatch 'hl.dsp.window.fullscreen({ mode = \"maximized\", action = \"toggle\" })'",
            },
        },
    })

    -- Configure the close button
--    hl.plugin.hyprbars.add_button({
--        bg_color = "rgb(ff4040)",
--        fg_color = "rgb(ffffff)",
--        size = 20,
--        icon = "󰖭",
--        action = "hl.dispatch(hl.dsp.killactive())",
--    })

    -- Configure the maximize button
--    hl.plugin.hyprbars.add_button({
--        bg_color = "rgb(eeee11)",
--        fg_color = "rgb(000000)",
--        size = 20,
--        icon = "",
--        action = "hyprctl dispatch 'hl.dsp.window.fullscreen({ mode = \"maximized\", action = \"toggle\" })'",
--    })
end
