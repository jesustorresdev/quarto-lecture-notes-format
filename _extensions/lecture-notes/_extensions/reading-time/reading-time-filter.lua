-- count wordCounter in a document, compute the estimated reading time and update that info in document metadata
local DEFAULT_WORDS_PER_MINUTE = 200
local DEFAULT_LANGUAGE = "en"

local wordCounter = 0
local translation = {}

local function loadTranslation(meta)
  local lang = pandoc.utils.stringify(meta.lang) or DEFAULT_LANGUAGE
  local translation = require("language/language-" .. lang)
  local customized_strings = meta["reading-time"] and meta["reading-time"].strings or {}
  for k,v in pairs(customized_strings) do translation[k] = pandoc.utils.stringify(v) end
  return translation
end

local function tr(str)
  return translation[str] or str
end

local wordCount = {
  Str = function(el)
    -- we don't count a word if it's entirely punctuation:
    if el.text:match("%P") then
        wordCounter = wordCounter + 1
    end
  end,

  Code = function(el)
    local _, n = el.text:gsub("%S+","")
    wordCounter = wordCounter + n
  end,

  CodeBlock = function(el)
    local _, n = el.text:gsub("%S+","")
    wordCounter = wordCounter + n
  end
}

local function formatReadingTime(reading_time)
  if reading_time < 1 then
    return tr("less_than_a_minute")
  end

  local formattedString = tr("about") .. " "
  local hours = reading_time // 60
  local minutes = math.floor(reading_time % 60 + 0.5)

  if hours > 0 then
    if hours == 1 then
      formattedString = formattedString .. tr("one_hour")
    elseif hours > 1 then
      formattedString = formattedString .. string.format(tr("other_hours"), hours)
    end    
    
    if minutes < 10 then
      return formattedString
    else
      formattedString = formattedString .. " " .. tr("ampersand") .. " "
      -- round to nearest 5 minutes
      minutes = math.floor(minutes / 5 + 0.5) * 5
    end
  end

  if minutes == 1 then
    formattedString = formattedString .. tr("one_minute")
  else
    formattedString = formattedString .. string.format(tr("other_minute"), minutes)
  end

  return formattedString
end

function Pandoc(el)
    -- skip metadata, just count body:
    el.blocks:walk(wordCount)
    local wordsPerMinute = el.meta["reading-time"] and
                           el.meta["reading-time"]["words-per-minute"] or
                           DEFAULT_WORDS_PER_MINUTE
    local readingTime = wordCounter / wordsPerMinute

    translation = loadTranslation(el.meta)
    local formattedReadingTime = formatReadingTime(readingTime)
    
    el.meta["reading-time"] = el.meta["reading-time"] or {}
    el.meta["reading-time"]["words"] = string.format("%d", wordCounter)
    el.meta["reading-time"]["formatted"] = formattedReadingTime
    el.meta["reading-time"]["minutes"] = string.format("%f", readingTime)

    return pandoc.Pandoc(el.blocks, el.meta)
end
