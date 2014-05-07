---------------------------
-- Default awesome theme --
---------------------------

theme = {}

theme.theme_dir     = "/home/pjvds/.config/awesome/default/"
theme.font          = "SourceCodePro-Black 14"
theme.transparancy  = ""
-- theme.bg_normal     = "#ffffff" .. theme.transparancy
-- theme.bg_focus      = "#efefef" .. theme.transparancy
-- theme.bg_urgent     = "#ff0000" .. theme.transparancy
-- theme.fg_normal     = "#4d4d4c"
-- theme.fg_focus      = "#c82829"
-- theme.fg_urgent     = "red"
-- theme.border_width  = 1
-- theme.border_normal = "#000000" .. theme.transparancy
-- theme.border_focus  = "#555555" .. theme.transparancy
-- theme.border_marked = "#91231c" .. theme.transparancy
theme.bg_normal     = "#ffffffee"
theme.bg_focus      = "#efefef"
theme.bg_urgent     = "#4271ae"
theme.bg_minimize   = "#3e999f"

theme.fg_normal     = "#4d4d4c"
theme.fg_focus      = "#4271ae"
theme.fg_urgent     = "#000000"
theme.fg_minimize   = "#000000"

theme.border_width  = 4
theme.border_normal = "#efefef"
theme.border_focus  = "#f5871f"
theme.border_marked = "#4271ae"
theme.useless_gap_width = 10

theme.lain_icons         = "/home/pjvds/.config/awesome/lain/icons/layout/default/"
theme.layout_termfair    = theme.lain_icons .. "termfairw.png"
theme.layout_cascade     = theme.lain_icons .. "cascadew.png"
theme.layout_cascadetile = theme.lain_icons .. "cascadetilew.png"
theme.layout_centerwork  = theme.lain_icons .. "centerworkw.png"

-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- [taglist|tasklist]_[bg|fg]_[focus|urgent]
-- titlebar_[bg|fg]_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- mouse_finder_[color|timeout|animate_timeout|radius|factor]
-- Example:
--theme.taglist_bg_focus = "#ff0000"

-- Display the taglist squares
theme.taglist_squares_sel   = (theme.theme_dir .. "taglist/squarefw.png")
theme.taglist_squares_unsel = (theme.theme_dir .. "taglist/squarew.png")

-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_submenu_icon = (theme.theme_dir .. "submenu.png")
theme.menu_height = 15
theme.menu_width  = 100

-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.bg_widget = "#cc0000"

-- Define the image to load
theme.titlebar_close_button_normal = (theme.theme_dir .. "titlebar/close_normal.png")
theme.titlebar_close_button_focus  = (theme.theme_dir .. "titlebar/close_focus.png")

theme.titlebar_ontop_button_normal_inactive = (theme.theme_dir .. "titlebar/ontop_normal_inactive.png")
theme.titlebar_ontop_button_focus_inactive  = (theme.theme_dir .. "titlebar/ontop_focus_inactive.png")
theme.titlebar_ontop_button_normal_active = (theme.theme_dir .. "titlebar/ontop_normal_active.png")
theme.titlebar_ontop_button_focus_active  = (theme.theme_dir .. "titlebar/ontop_focus_active.png")

theme.titlebar_sticky_button_normal_inactive = (theme.theme_dir .. "titlebar/sticky_normal_inactive.png")
theme.titlebar_sticky_button_focus_inactive  = (theme.theme_dir .. "titlebar/sticky_focus_inactive.png")
theme.titlebar_sticky_button_normal_active = (theme.theme_dir .. "titlebar/sticky_normal_active.png")
theme.titlebar_sticky_button_focus_active  = (theme.theme_dir .. "titlebar/sticky_focus_active.png")

theme.titlebar_floating_button_normal_inactive = (theme.theme_dir .. "titlebar/floating_normal_inactive.png")
theme.titlebar_floating_button_focus_inactive  = (theme.theme_dir .. "titlebar/floating_focus_inactive.png")
theme.titlebar_floating_button_normal_active = (theme.theme_dir .. "titlebar/floating_normal_active.png")
theme.titlebar_floating_button_focus_active  = (theme.theme_dir .. "titlebar/floating_focus_active.png")

theme.titlebar_maximized_button_normal_inactive = (theme.theme_dir .. "titlebar/maximized_normal_inactive.png")
theme.titlebar_maximized_button_focus_inactive  = (theme.theme_dir .. "titlebar/maximized_focus_inactive.png")
theme.titlebar_maximized_button_normal_active = (theme.theme_dir .. "titlebar/maximized_normal_active.png")
theme.titlebar_maximized_button_focus_active  = (theme.theme_dir .. "titlebar/maximized_focus_active.png")

theme.wallpaper_cmd = { "awsetbg /home/pjvds/.config/awesome/default/background.jpg" }

-- You can use your own layout icons like this:
theme.layout_fairh = (theme.theme_dir .. "layouts/fairh.png")
theme.layout_fairv = (theme.theme_dir .. "layouts/fairv.png")
theme.layout_floating  = (theme.theme_dir .. "layouts/floating.png")
theme.layout_magnifier = (theme.theme_dir .. "layouts/magnifier.png")
theme.layout_max = (theme.theme_dir .. "layouts/max.png")
theme.layout_fullscreen = (theme.theme_dir .. "layouts/fullscreen.png")
theme.layout_tilebottom = (theme.theme_dir .. "layouts/tilebottom.png")
theme.layout_tileleft   = (theme.theme_dir .. "layouts/tileleft.png")
theme.layout_tile = (theme.theme_dir .. "layouts/tile.png")
theme.layout_tiletop = (theme.theme_dir .. "layouts/tiletop.png")
theme.layout_spiral  = (theme.theme_dir .. "layouts/spiral.png")
theme.layout_dwindle = (theme.theme_dir .. "layouts/dwindle.png")

theme.awesome_icon = "/usr/share/awesome/icons/awesome16.png"

-- Define the icon theme for application icons. If not set then the icons 
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = nil

return theme
-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
