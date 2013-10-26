--- Redshift for Awesome WM
-- author: Ryan Young <ryan .ry. young@gmail. com> (omit spaces)
--
-- https://github.com/YoRyan/awesome-redshift
--

-- standard libraries
local awful = require("awful")

-- variables
local redshift = {}
redshift.redshift = "/usr/bin/redshift"    -- binary path
redshift.method = "randr"                  -- randr or vidmode
redshift.options = ""                      -- additional redshift command options
redshift.state = 1                         -- 1 for screen dimming, 0 for none
redshift.timer = timer({ timeout = 60 })

-- functions
redshift.dim = function()
    if redshift.method == "randr"
    then
        awful.util.spawn(redshift.redshift .. " -m randr -o " .. redshift.options)
    elseif redshift.method == "vidmode"
    then
        local screens = screen.count()
        for i = 0, screens - 1
        do
            awful.util.spawn(redshift.redshift .. " -m vidmode:screen=" .. i ..
                             " -o " .. redshift.options)
        end
    end
    redshift.state = 1
    redshift.timer:start()
end
redshift.timer:connect_signal("timeout", redshift.dim)
redshift.undim = function()
    if redshift.method == "randr"
    then
        awful.util.spawn(redshift.redshift .. " -m randr -x " .. redshift.options)
    elseif redshift.method == "vidmode"
    then
        local screens = screen.count()
        for i = 0, screens - 1
        do
            awful.util.spawn(redshift.redshift .. " -m vidmode:screen=" .. i ..
                             " -x " .. redshift.options)
        end
    end
    redshift.state = 0
    redshift.timer:stop()
end
redshift.toggle = function()
    if redshift.state == 1
    then
        redshift.undim()
    else
        redshift.dim()
    end
end
redshift.init = function(initState)
    if initState == 1
    then
        redshift.dim()
    else
        redshift.undim()
    end
end

return redshift
