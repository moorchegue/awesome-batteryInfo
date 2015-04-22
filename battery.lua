-- This function returns a formatted string with the current battery status. It
-- can be used to populate a text widget in the awesome window manager. Based
-- on the "Gigamo Battery Widget" found in the wiki at awesome.naquadah.org

local naughty = require("naughty")
local beautiful = require("beautiful")


function _batteryInfo(adapter)
    local fcur = io.open("/sys/class/power_supply/"..adapter.."/charge_now")
    local fcap = io.open("/sys/class/power_supply/"..adapter.."/charge_full")
    local fsta = io.open("/sys/class/power_supply/"..adapter.."/status")
    local cur = fcur:read()
    local cap = fcap:read()
    local sta = fsta:read()
    fcur:close()
    fcap:close()
    fsta:close()
    local battery = math.floor(cur * 100 / cap)

    if sta:match("Charging") then
        icon = "⚡"
        percent = "%"
    elseif sta:match("Discharging") then
        icon = ""
        percent = "%"
        if tonumber(battery) < 10 then
            naughty.notify({ title        = "Battery Warning"
                         , text         = "Battery low!".."    "..battery..percent.."    ".."left!"
                         , timeout    = 5
                         , position = "top_right"
                         , fg             = beautiful.fg_focus
                         , bg             = beautiful.bg_focus
            })
        end
    else
        battery = "A/C"
        icon = ""
        percent = ""
    end
    return " "..icon..battery..percent.." "
end

function batteryInfo(adapter)
    local ok, battery = pcall(_batteryInfo, adapter)
    if ok then
        return battery
    else
        return "肏你妈"
    end
end
