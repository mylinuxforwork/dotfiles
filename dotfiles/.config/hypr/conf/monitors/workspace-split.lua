-------------------------------------------------------
-- Monitor Setup
-- name: "Workspace Split"
-------------------------------------------------------

local function map_workspaces(start_id, end_id, monitor_name)
    for i = start_id, end_id do
        hl.workspace_rule({
            workspace = tostring(i),
            monitor = monitor_name
        })
    end
end

map_workspaces(1, 5, "DP-1")
map_workspaces(6, 10, "HDMI-A-1")