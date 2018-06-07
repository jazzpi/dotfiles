local naughty = require('naughty')

local notify = {
   _presets = {
      dbg = naughty.config.presets.low,
      info = naughty.config.presets.normal,
      warn = { bg = "#ffff00", fg = "#ffffff", timeout = 20 },
      err = naughty.config.presets.critical,
   },

   dbg = function(text, title) return __call(text, title, _presets.dbg) end,
   info = function(text, title) return __call(text, title, _presets.dbg) end,
   warn = function(text, title) return __call(text, title, _presets.dbg) end,
   err = function(text, title) return __call(text, title, _presets.dbg) end,
}
function notify.__call(self, text, title, preset)
   preset = preset or notify._presets.info
   naughty.notify({ preset = preset,
                    title = title,
                    text = tostring(text) })
end

setmetatable(notify, notify)

return {
   notify = notify
}
