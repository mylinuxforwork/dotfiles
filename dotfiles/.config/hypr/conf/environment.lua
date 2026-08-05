-- Quickshell resolves app icons through Qt's icon theme, which does not follow
-- the GTK setting on its own — QS_ICON_THEME is what it reads. Take the name
-- from the GTK settings so the dock and the other shells use the selected icon
-- theme. Read once at compositor start; a theme switch applies on next login.
local gtk_settings = os.getenv("HOME") .. "/.config/gtk-3.0/settings.ini"
local settings = io.open(gtk_settings, "r")
if settings then
    for line in settings:lines() do
        local theme = line:match("^%s*gtk%-icon%-theme%-name%s*=%s*(.-)%s*$")
        if theme and theme ~= "" then
            hl.env("QS_ICON_THEME", theme)
            break
        end
    end
    settings:close()
end

local name = "default.lua"
load_variant(name,"environments")
