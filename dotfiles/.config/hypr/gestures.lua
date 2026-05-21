-------------------------------------------------------
-- Gestures
-------------------------------------------------------

-- Workspaces
hl.gesture({
    fingers = 3,
    direction = "vertical",
    action = "workspace"
})

-- Scrolling
hl.gesture({
    fingers = 3,
    direction = "horizontal",
    action = "scroll_move",
    scale = 0.9,
})

-- Fullscreen on  
hl.gesture({ fingers = 4, direction = "pinchout", action = function ()
    hl.dispatch(hl.dsp.window.fullscreen({ action="set" })) 
end})

-- Fullscreen off  
hl.gesture({ fingers = 4, direction = "pinchin", action = function ()
    hl.dispatch(hl.dsp.window.fullscreen({ action="unset" })) 
end})