--!nonstrict
-- Chinese text formatting for calendar values. Pure functions only - no
-- `noctalia.*` access - so the whole module is unit-testable on its own.

local M = {}

local DAY_DIGITS = { "一", "二", "三", "四", "五", "六", "七", "八", "九", "十" }
local MONTH_NAMES = {
    "正月", "二月", "三月", "四月", "五月", "六月",
    "七月", "八月", "九月", "十月", "冬月", "腊月",
}
local WEEKDAY_NAMES = { "星期一", "星期二", "星期三", "星期四", "星期五", "星期六", "星期日" }
local WEEKDAY_SHORT = { "周一", "周二", "周三", "周四", "周五", "周六", "周日" }
local NUM_DIGITS = { "〇", "一", "二", "三", "四", "五", "六", "七", "八", "九" }

M.MONTH_NAMES = MONTH_NAMES

--- Lunar day name: 1 -> 初一, 10 -> 初十, 20 -> 二十, 30 -> 三十.
function M.lunar_day(day)
    if day <= 0 or day > 30 then
        return tostring(day)
    end
    if day <= 10 then
        return "初" .. DAY_DIGITS[day]
    end
    if day < 20 then
        return "十" .. DAY_DIGITS[day - 10]
    end
    if day == 20 then
        return "二十"
    end
    if day < 30 then
        return "廿" .. DAY_DIGITS[day - 20]
    end
    return "三十"
end

--- Lunar month name for a 1..12 month number (sign ignored).
function M.lunar_month(month)
    local index = math.abs(month)
    return MONTH_NAMES[index] or tostring(index)
end

--- Full lunar month+day, e.g. 八月初七 or 闰六月初一.
function M.lunar_month_day(month, day, is_leap)
    local prefix = is_leap and "闰" or ""
    return prefix .. M.lunar_month(month) .. M.lunar_day(day)
end

--- ISO weekday (1 = Monday .. 7 = Sunday).
function M.weekday(iso)
    return WEEKDAY_NAMES[iso] or ""
end

function M.weekday_short(iso)
    return WEEKDAY_SHORT[iso] or ""
end

--- Chinese numeral year, e.g. 2026 -> 二〇二六年.
function M.lunar_year(year)
    local out = {}
    for i = 1, #tostring(year) do
        local digit = tonumber(string.sub(tostring(year), i, i))
        out[#out + 1] = NUM_DIGITS[digit + 1] or "?"
    end
    return table.concat(out) .. "年"
end

--- 9月16日
function M.solar_month_day(month, day)
    return string.format("%d月%d日", month, day)
end

--- 2026年9月16日
function M.solar_ymd(year, month, day)
    return string.format("%d年%d月%d日", year, month, day)
end

--- 09-16 style date key used by the holiday data.
function M.date_key(year, month, day)
    return string.format("%04d-%02d-%02d", year, month, day)
end

--- Compact month title: 2026年9月
function M.month_title(year, month)
    return string.format("%d年%d月", year, month)
end

--- Days between two `days_from_civil` values, phrased for a countdown.
function M.days_phrase(days)
    if days <= 0 then
        return "今天"
    elseif days == 1 then
        return "明天"
    elseif days == 2 then
        return "后天"
    end
    return string.format("%d天后", days)
end

return M
