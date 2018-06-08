local naughty = require('naughty')

local notify = {
   _presets = {
      dbg = naughty.config.presets.low,
      info = naughty.config.presets.normal,
      warn = { bg = "#ff9900", fg = "#ffffff", timeout = 20 },
      err = naughty.config.presets.critical,
   },

}

function notify.dbg(text, title)
   return notify.__call(text, title, notify._presets.dbg)
end
function notify.info(text, title)
   return notify.__call(text, title, notify._presets.info)
end
function notify.warn(text, title)
   return notify.__call(text, title, notify._presets.warn)
end
function notify.err(text, title)
   return notify.__call(text, title, notify._presets.err)
end

function notify.__call(text, title, preset)
   preset = preset or notify._presets.info
   naughty.notify({ preset = preset,
                    title = title,
                    text = tostring(text) })
end

return {
   notify = notify
}
