local awful = require('awful')
local wibox = require('wibox')
local s = require('gears.string')
local t = require('gears.table')
local http = require('socket.http')
local lgi = require('lgi')
local GLib = lgi.GLib
local Gio = lgi.Gio
local GObject = lgi.GObject

local common = require('mywidgets.common')

local bus = Gio.bus_get_sync(Gio.BusType.SESSION)

local DBUS_NAME = 'org.freedesktop.DBus'
local DBUS_PATH = '/org/freedesktop/DBus'
local PLAYER_NAME = 'org.mpris.MediaPlayer2.Player'
local PROPERTIES_NAME = 'org.freedesktop.DBus.Properties'
local SPOTIFY_NAME = 'org.mpris.MediaPlayer2.spotify'
local SPOTIFY_PATH = '/org/mpris/MediaPlayer2'

local function check_err(err)
   if err then
      common.notify.warn(tostring(err), 'Spotify Error')
      print('Spotify Error: ' .. tostring(err))
   end
   return err
end

local function running()
   local data, err = bus:call_sync(
      DBUS_NAME,
      DBUS_PATH,
      DBUS_NAME,
      'NameHasOwner',
      GLib.Variant('s', SPOTIFY_NAME),
      nil,
      Gio.DBusConnectionFlags.NONE,
      -1
   )
   if check_err(err) then return end

   return data
end

local function split_url(url)
   local spl = s.split(url, '//')
   local prot = spl[1]
   local rest = table.concat({table.unpack(spl, 2, #spl)}, '//')
   spl = s.split(rest, '/')
   local domain = spl[1]
   local intermediate = table.concat({table.unpack(spl, 2, #spl-1)}, '/')
   local file = spl[#spl]
   return prot, domain, intermediate, file
end

local Popup = {
   IMAGE_WIDTH = 128,
   IMAGE_HEIGHT = 128,
   MARGIN = 5,
}
Popup.__index = Popup

function Popup:create(parent, width, height)
   local popup = {}
   setmetatable(popup, Popup)

   popup.width = width or 300
   popup.height = height or popup.IMAGE_HEIGHT
   popup._parent = parent

   popup._art_url = nil
   popup._art = wibox.widget.imagebox(nil, true)
   popup._art.forced_width = Popup.IMAGE_WIDTH
   popup._art.forced_height = Popup.IMAGE_HEIGHT

   popup._song = wibox.widget.textbox('Song')
   popup._song.font = beautiful.popup_font
   popup._artist = wibox.widget.textbox('Artist')
   popup._artist.font = beautiful.popup_font
   popup._album = wibox.widget.textbox('Album')
   popup._album.font = beautiful.popup_font

   popup._play_pause = wibox.widget.textbox('\u{f565}')  -- icon-circlepauseempty
   popup._play_pause.font = beautiful.large_icon_font
   popup._play_pause:buttons(awful.button({}, 1, nil,
                                function() popup._parent.play_pause() end))
   popup._prev = wibox.widget.textbox('\u{f56a}')  -- icon-circlepreviousempty
   popup._prev.font = beautiful.large_icon_font
   popup._prev:buttons(awful.button({}, 1, nil,
                          function() popup._parent.prev() end))
   popup._next = wibox.widget.textbox('\u{f569}')  -- icon-circlenextempty
   popup._next.font = beautiful.large_icon_font
   popup._next:buttons(awful.button({}, 1, nil,
                          function() popup._parent.next() end))

   popup._widget = wibox.widget {
      {
         {
            layout = wibox.layout.align.horizontal,
            popup._art,
            {
               layout = wibox.layout.fixed.vertical,
               popup._song,
               {
                  {
                     layout = wibox.layout.fixed.vertical,
                     popup._artist,
                     popup._album,
                  },
                  fg = beautiful.fg_low,
                  widget = wibox.container.background,
               },
               {
                  {
                     layout = wibox.layout.flex.horizontal,
                     spacing = 10,
                     popup._prev,
                     popup._play_pause,
                     popup._next,
                  },
                  valign = 'bottom',
                  fill_vertical = true,
                  fill_horizontal = true,
                  widget = wibox.container.place,
               }
            }
         },
         left = popup.MARGIN,
         right = popup.MARGIN,
         top = popup.MARGIN,
         bottom = popup.MARGIN,
         layout = wibox.container.margin,
      },
      bg = beautiful.bg_focus,
      widget = wibox.container.background,
   }
   popup._wibox = nil
   popup._hidden = nil

   popup._parent.widget:connect_signal('music::update', function(...) popup:_music_update(...) end)
   popup._parent.widget:connect_signal('mouse::enter', function(...) popup:_mouse_enter(...) end)
   popup._parent.widget:connect_signal('mouse::leave', function(...) popup:_mouse_leave(...) end)
end

function Popup:_music_update(_, status, data)
   if status == 'Playing' then
      self._play_pause.markup = '\u{f565}'  -- icon-circlepauseemtpy
   elseif status == 'Paused' then
      self._play_pause.text = '\u{f563}'  -- icon-circleplayempty
   else
      return
   end

   if data.art ~= self._art_url then
      self._art_url = data.art
      Gio.Async.start(self._download_art)(self, data.art)
   end
   self._song.markup = '<big><b>' .. data.title .. '</b></big>'
   self._artist.text = data.artist
   self._album.text = data.album
end

function Popup:_download_art(url)
   local prot, domain, intermediate, file = split_url(url)
   -- Downloading from i.scdn.co removes the Spotify logo from the image
   url = prot .. '//i.scdn.co/' .. intermediate .. '/' .. file
   local body, code = http.request(url)
   if not body then
      common.notify.err(code)
      return
   end

   local path = '/tmp/' .. file
   local f, err = io.open(path, 'wb')
   if not f then
      common.notify.err(err)
      return
   end

   f:write(body)
   f:close()

   self._art.image = path
end

function Popup:_setup_boxes(parent_geo)
   if not self._wibox then
      self._wibox = wibox {
         width = self.width,
         height = self.height,
         widget = self._widget,
         ontop = true,
      }
      self._wibox:connect_signal('mouse::leave', function(...) self:_mouse_leave(...) end)
   end
end

function Popup:_mouse_enter(_, geo)
   self:_setup_boxes(geo)
   self._wibox:geometry({
         x = geo.x + mouse.screen.geometry.x,
         y = geo.y + geo.height + mouse.screen.geometry.y,
   })
   self._wibox.visible = true
end

function Popup:_mouse_leave(maybe_align, geo)
   -- When the event fires on the parent, we get an align as the first argument
   -- for some reason. When it fires on our wibox, we only get the geometry.
   geo = geo or maybe_align
   if geo.widget == self._parent.widget and mouse.current_wibox == self._wibox then
      return
   elseif geo.widget == self._widget and mouse.current_wibox then
      local coords = mouse.coords()
      local wgeo = mouse.current_wibox:geometry()
      local x = coords.x - wgeo.x
      local y = coords.y - wgeo.y
      local widgets = mouse.current_wibox:find_widgets(x, y)
      local text = ''
      for k, v in pairs(widgets) do
         if v.widget == self._parent.widget then
            return
         end
      end
   end
   self._wibox.visible = false
end

local Widget = {}
Widget.__index = Widget

function Widget:create()
   local widget = {}
   setmetatable(widget, Widget)
   widget._status_widget = wibox.widget.textbox()
   widget._status_widget.font = beautiful.icon_font
   widget._textbox = wibox.widget.textbox()
   -- TODO: Scroll this on hover (wibox.container.scroll.horizontal continuously
   -- scrolls)
   widget.widget = wibox.widget {
      widget._status_widget,
      widget._textbox,
      layout = wibox.layout.align.horizontal
   }
   widget._popup = Popup:create(widget)

   widget._running = false
   widget._data = nil
   widget._status = 'Unconnected'
   widget:_update()
   widget._watch = Gio.bus_watch_name(
      Gio.BusType.SESSION,
      SPOTIFY_NAME,
      Gio.BusNameWatcherFlags.NONE,
      GObject.Closure(function() widget:_name_appeared() end),
      GObject.Closure(function() widget:_name_vanished() end)
   )
   widget._props_changed_id = bus:signal_subscribe(
      SPOTIFY_NAME,
      PROPERTIES_NAME,
      'PropertiesChanged',
      SPOTIFY_PATH,
      PLAYER_NAME,
      Gio.DBusSignalFlags.MATCH_ARG0_NAMESPACE,
      function(...) widget:_props_changed(...) end
   )
   -- This isn't implemented yet (neither is the Position property), but it
   -- would be nice. So listen to it and notify when it is implemented so we can
   -- use it!
   widget._seeked_id = bus:signal_subscribe(
      SPOTIFY_NAME,
      PLAYER_NAME,
      'Seeked',
      SPOTIFY_PATH,
      PLAYER_NAME,
      Gio.DBusSignalFlags.MATCH_ARG0_NAMESPACE,
      function(...)
         common.notify('Got a Seeked event! Looks like Spotify was updated!')
      end
   )

   return widget
end

function Widget:play_pause()
   local _, err = bus:call_sync(
      SPOTIFY_NAME,
      SPOTIFY_PATH,
      PLAYER_NAME,
      'PlayPause',
      nil,
      nil,
      Gio.DBusConnectionFlags.NONE,
      -1
   )
   check_err(err)
end

function Widget:prev()
   local _, err = bus:call_sync(
      SPOTIFY_NAME,
      SPOTIFY_PATH,
      PLAYER_NAME,
      'Previous',
      nil,
      nil,
      Gio.DBusConnectionFlags.NONE,
      -1
   )
   check_err(err)
end

function Widget:next()
   local _, err = bus:call_sync(
      SPOTIFY_NAME,
      SPOTIFY_PATH,
      PLAYER_NAME,
      'Next',
      nil,
      nil,
      Gio.DBusConnectionFlags.NONE,
      -1
   )
   check_err(err)
end

function Widget:_name_appeared()
   if not self._running then
      self._running = true
      self:_update_data()
      self:_update()
   end
end

function Widget:_name_vanished()
   if self._running then
      self._running = false
      self:_update()
   end
end

function Widget:_update_metadata(metadata)
   self._data = {
      title = metadata['xesam:title'],
      album = metadata['xesam:album'],
      artist = metadata['xesam:albumArtist'][1],
      art = metadata['mpris:artUrl']
   }
end

function Widget:_props_changed(_, _, _, _, _, params)
   self:_update_metadata(params.value[2].Metadata)
   self._status = params.value[2].PlaybackStatus
   self:_update()
end

function Widget:_update_data()
   local metadata, err = bus:call_sync(
      SPOTIFY_NAME,
      SPOTIFY_PATH,
      PROPERTIES_NAME,
      'Get',
      GLib.Variant('(ss)', {PLAYER_NAME, 'Metadata'}),
      nil,
      Gio.DBusConnectionFlags.NONE,
      -1
   )
   if check_err(err) then return end

   local status, err = bus:call_sync(
      SPOTIFY_NAME,
      SPOTIFY_PATH,
      PROPERTIES_NAME,
      'Get',
      GLib.Variant('(ss)', {PLAYER_NAME, 'PlaybackStatus'}),
      nil,
      Gio.DBusConnectionFlags.NONE,
      -1
   )
   if check_err(err) then return end

   -- Get for some reason returns a (v)
   self:_update_metadata(metadata[1].value)
   self._status = status[1].value
end

function Widget:_update()
   if self._running then
      if self._status == 'Playing' then
         self._status_widget.text = '\u{f184}'  -- icon-play
      elseif self._status == 'Paused' then
         self._status_widget.text = '\u{f186}'  -- icon-pause
      elseif self._status == 'Stopped' then
         self._status_widget.text = '\u{f185}'  -- icon-stop
         self._textbox.text = ' Stopped'
         return
      else
         common.notify.warn(self._status, 'Unknown playback status')
         return
      end
      self._textbox.markup = ' ' .. self._data.artist .. ' \u{2014} <b>' .. self._data.title .. '</b>'
   else
      self._status_widget.text = '\u{f316}'  -- icon-warning-sign
      self._textbox.markup = " <i>Spotify isn't running</i>"
   end

   self.widget:emit_signal('music::update', self._status, self._data)
end

return {
   running = running,
   widget = Widget
}
