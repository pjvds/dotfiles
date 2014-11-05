local beautiful = require("beautiful")
local ipairs = ipairs

local spiralccw = {}

local function spiral(p, spiral)

    local wa = p.workarea
    local cls = p.clients
    local n = #cls

    local x = wa.height
    local y = wa.width

    local static_wa = wa

    for k, c in ipairs(cls) do
        if k < n then
            if k % 2 == 0 then
                wa.height = wa.height / 2
                --wa.x = wa.x - wa.height
            else
                wa.width = wa.width / 2
                --wa.y = wa.y - wa.width
            end
        end

        if k % 4 == 0 and spiral then
            wa.x = wa.x - wa.width
        elseif k % 2 == 0 or
            (k % 4 == 3 and k < n and spiral) then
            wa.x = wa.x + wa.width
        end

        if k % 4 == 1 and k ~= 1 and spiral then
            wa.y = wa.y - wa.height
        elseif k % 2 == 1 and k ~= 1 or
            (k % 4 == 0 and k < n and spiral) then
            wa.y = wa.y + wa.height
        end

        c:geometry(wa2)
    end
end

--- Dwindle layout
spiralccw.dwindle = {}
spiralccw.dwindle.name = "dwindle"
function spiralccw.dwindle.arrange(p)
    return spiral(p, false)
end

--- Spiral layout
spiralccw.name = "spiralccw"
function spiralccw.arrange(p)
    return spiral(p, true)
end

return spiralccw
