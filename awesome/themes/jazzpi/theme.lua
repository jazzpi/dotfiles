-------------------------------
--  "jazzpi" awesome theme   --
--  By Jasper v. B. (jazzpi) --
--       based on the        --
--  "Zenburn" awesome theme  --
--    By Adrian C. (anrxc)   --
-------------------------------

local awful = require("awful")

-- {{{ Main
local theme = {}
theme.dir = awful.util.getdir("config") .. "themes/jazzpi/"
theme.wallpaper = theme.dir .. "bird-on-branch.png"
-- }}}

-- {{{ Styles
theme.font      = "DejaVu Sans 9"
theme.icon_font = "WebHostingHubGlyphs 10"
theme.large_icon_font = "WebHostingHubGlyphs 18"
theme.taglist_font = theme.icon_font
theme.popup_font = "DejaVu Sans 10"

-- {{{ Colors
theme.fg_low     = "#e4e4e4"
theme.fg_normal  = "#FFFFFF"
theme.fg_focus   = "#FFFFFF"
theme.fg_urgent  = "#FFFFFF"
theme.bg_normal  = "#00000011"
theme.bg_focus   = "#3188b455"
theme.bg_urgent  = "#e7842c"
theme.bg_systray = "#73965b" -- TODO: The opacity isn't honored :|
-- }}}

-- {{{ Borders
theme.useless_gap   = 3
theme.border_width  = 1
theme.border_normal = "#704c71"
theme.border_focus  = "#7c779a"
theme.border_marked = "#CC9393"
-- }}}

-- {{{ Titlebars
theme.titlebar_bg_focus  = "#34595b"
theme.titlebar_bg_normal = "#21393a"
theme.titlebar_fg_normal = "#aaaaaa"
-- }}}

-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- [taglist|tasklist]_[bg|fg]_[focus|urgent]
-- titlebar_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- Example:
--theme.taglist_bg_focus = "#CC9393"
-- }}}

-- {{{ Widgets
-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.fg_widget        = "#AECF96"
--theme.fg_center_widget = "#88A175"
--theme.fg_end_widget    = "#FF5656"
--theme.bg_widget        = "#494B4F"
--theme.border_widget    = "#3F3F3F"
-- }}}

-- {{{ Hotkeys Popup
theme.hotkeys_bg = "#181223"
-- }}}

-- {{{ Mouse finder
theme.mouse_finder_color = "#CC9393"
-- mouse_finder_[timeout|animate_timeout|radius|factor]
-- }}}

-- {{{ Menu
-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_bg_normal = "#1d4b66"
theme.menu_bg_focus = "#175982"
theme.menu_border_color = "#54839f"
theme.menu_height = 15
theme.menu_width  = 100
-- }}}

-- {{{ Icons
-- {{{ Taglist
theme.taglist_squares_sel   = theme.dir .. "taglist/squarefz.png"
theme.taglist_squares_unsel = theme.dir .. "taglist/squarez.png"
--theme.taglist_squares_resize = "false"
-- }}}

-- {{{ Misc
theme.awesome_icon           = theme.dir .. "arch-awesome.png"
theme.menu_submenu_icon      = "/usr/local/share/awesome/themes/default/submenu.png"
-- }}}

-- {{{ Layout
theme.layout_tile       = theme.dir .. "layouts/tile.png"
theme.layout_tileleft   = theme.dir .. "layouts/tileleft.png"
theme.layout_tilebottom = theme.dir .. "layouts/tilebottom.png"
theme.layout_tiletop    = theme.dir .. "layouts/tiletop.png"
theme.layout_fairv      = theme.dir .. "layouts/fairv.png"
theme.layout_fairh      = theme.dir .. "layouts/fairh.png"
theme.layout_spiral     = theme.dir .. "layouts/spiral.png"
theme.layout_dwindle    = theme.dir .. "layouts/dwindle.png"
theme.layout_max        = theme.dir .. "layouts/max.png"
theme.layout_fullscreen = theme.dir .. "layouts/fullscreen.png"
theme.layout_magnifier  = theme.dir .. "layouts/magnifier.png"
theme.layout_floating   = theme.dir .. "layouts/floating.png"
theme.layout_cornernw   = theme.dir .. "layouts/cornernw.png"
theme.layout_cornerne   = theme.dir .. "layouts/cornerne.png"
theme.layout_cornersw   = theme.dir .. "layouts/cornersw.png"
theme.layout_cornerse   = theme.dir .. "layouts/cornerse.png"
-- }}}

-- {{{ Titlebar
theme.titlebar_close_button_focus  = theme.dir .. "titlebar/close_focus.png"
theme.titlebar_close_button_normal = theme.dir .. "titlebar/close_normal.png"

theme.titlebar_minimize_button_normal = "/usr/local/share/awesome/themes/default/titlebar/minimize_normal.png"
theme.titlebar_minimize_button_focus  = "/usr/local/share/awesome/themes/default/titlebar/minimize_focus.png"

theme.titlebar_ontop_button_focus_active  = theme.dir .. "titlebar/ontop_focus_active.png"
theme.titlebar_ontop_button_normal_active = theme.dir .. "titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_inactive  = theme.dir .. "titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_inactive = theme.dir .. "titlebar/ontop_normal_inactive.png"

theme.titlebar_sticky_button_focus_active  = theme.dir .. "titlebar/sticky_focus_active.png"
theme.titlebar_sticky_button_normal_active = theme.dir .. "titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_inactive  = theme.dir .. "titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_inactive = theme.dir .. "titlebar/sticky_normal_inactive.png"

theme.titlebar_floating_button_focus_active  = theme.dir .. "titlebar/floating_focus_active.png"
theme.titlebar_floating_button_normal_active = theme.dir .. "titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_inactive  = theme.dir .. "titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_inactive = theme.dir .. "titlebar/floating_normal_inactive.png"

theme.titlebar_maximized_button_focus_active  = theme.dir .. "titlebar/maximized_focus_active.png"
theme.titlebar_maximized_button_normal_active = theme.dir .. "titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_inactive  = theme.dir .. "titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_inactive = theme.dir .. "titlebar/maximized_normal_inactive.png"
-- }}}

-- Non-standard naughty configuration
theme.naughty_icon_size = 48
theme.naughty_bg = theme.titlebar_bg_focus

-- }}}

return theme

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
