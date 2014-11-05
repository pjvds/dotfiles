local setmetatable = setmetatable

local layout       = { _NAME = "custom.layout" }

return setmetatable(layout, { __index = wrequire })
