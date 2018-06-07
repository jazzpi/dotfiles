local wibox = require('wibox')
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

local Widget = {}
Widget.__index = Widget

function Widget:create()
   local widget = {}
   setmetatable(widget, Widget)
   widget._status_widget = wibox.widget.textbox()
   widget._status_widget.font = beautiful.icon_font
   widget._textbox = wibox.widget.textbox()
   widget.widget = wibox.widget {
      widget._status_widget,
      widget._textbox,
      layout = wibox.layout.align.horizontal
   }
   widget._running = false
   widget._data = nil
   widget._status = "Unconnected"
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
      artist = metadata['xesam:artist'].value[1],
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
      if self._status == "Playing" then
         self._status_widget.text = '\u{f184}'  -- icon-play
      elseif self._status == "Paused" then
         self._status_widget.text = '\u{f186}'  -- icon-pause
      else
         common.notify.warn(self._status, 'Unknown playback status')
         return
      end
      self._textbox.markup = ' <b>' .. self._data.artist .. '</b> \u{2014} ' .. self._data.title
   else
      self._status_widget.text = '\u{f316}'  -- icon-warning-sign
      self._textbox.text = " Spotify isn't running"
   end
end

return {
   running = running,
   widget = Widget
}
