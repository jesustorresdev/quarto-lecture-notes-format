-- from https://github.com/quarto-dev/quarto-cli/blob/184cd0d7024c355591ddabc494fe21af64fdf49b/src/resources/extensions/quarto/video/video.lua

-- === Utils ===
-- from http://lua-users.org/wiki/StringInterpolation
local interpolate = function(str, vars)
  -- Allow replace_vars{str, vars} syntax as well as replace_vars(str, {vars})
  if not vars then
    vars = str
    str = vars[1]
  end
  return (string.gsub(str, "({([^}]+)})",
          function(whole, i)
            return vars[i] or whole
          end))
end

local function splitString (toSplit, delimiter)
  delimiter = delimiter or "%s"

  local t={}
  for str in string.gmatch(toSplit, "([^".. delimiter .."]+)") do
    table.insert(t, str)
  end
  return t
end

local VIDEO_TYPES = {
  YOUTUBE = "YOUTUBE",
  BRIGHTCOVE = "BRIGHTCOVE",
  VIMEO = "VIMEO",
  UNKNOWN = "UNKNOWN"
}

local checkMatchStart = function(value, matcherFront)
  return string.match(value, '^' .. matcherFront .. '(.-)$')
end

local youTubeBuilder = function(params)
  if not (params and params.src) then return nil end
  local src = params.src
  match = checkMatchStart(src, 'https://www.youtube.com/embed/')
  match = match or checkMatchStart(src, 'https://www.youtube%-nocookie.com/embed/')
  match = match or checkMatchStart(src, 'https://youtu.be/')
  match = match or string.match(src, '%?v=(.-)&')
  match = match or string.match(src, '%?v=(.-)$')

  if not match then return nil end

  local YOUTUBE_EMBED = 'https://www.youtube.com/watch?v='
  params.src = YOUTUBE_EMBED .. match

  local LINK = [[{src}{start}]]
  local result = {}

  result.link = interpolate {
    LINK,
    src = params.src,
    start = params.start and '?t=' .. params.start or ''
  }
  result.type = VIDEO_TYPES.YOUTUBE
  result.src = params.src
  result.videoId = match

  return result
end

local brightcoveBuilder = function(params)
  if not (params and params.src) then return nil end
  local src = params.src
  local isBrightcove = function()
    return string.find(src, 'https://players.brightcove.net')
  end

  if not isBrightcove() then return nil end

  local result = {}

  result.link = params.src
  result.type = VIDEO_TYPES.BRIGHTCOVE
  result.src = params.src
  return result
end

local vimeoBuilder = function(params)
  if not (params and params.src) then return nil end

  local VIMEO_STANDARD = 'https://vimeo.com/'
  local match = checkMatchStart(params.src, VIMEO_STANDARD)
  if not match then return nil end

  -- Internal Links
  -- bug/5390-vimeo-newlink
  if string.find(match, '/') then
    local internalMatch = string.gsub(match, "?(.*)", "" )
    videoId = splitString(internalMatch, '/')[1]
    privacyHash = splitString(internalMatch, '/')[2]
    params.src = 'https://vimeo.com/video/' .. videoId .. '?h=' .. privacyHash
  else
    videoId = match
    params.src = 'https://vimeo.com/video/' .. videoId
  end


  local LINK = [[{src}{start}]]

  local result = {}
  result.link = interpolate {
    LINK,
    src = params.src,
    start = params.start and '#t=' .. params.start or ''
  }
  result.type = VIDEO_TYPES.VIMEO
  result.src = params.src
  result.videoId = videoId
  return result
end

local unknownBuilder = function(params)
  if not (params and params.src) then return nil end

  local result = {}

  result.link = params.src
  result.type = VIDEO_TYPES.UNKNOWN
  result.src = params.src
  return result
end

local getLinkFromBuilders = function(src, start)
  local builderList = {
    youTubeBuilder,
    brightcoveBuilder,
    vimeoBuilder,
    unknownBuilder}

  local params = { src = src, start = start }

  for i = 1, #builderList do
    local builtSnippet = builderList[i](params)
    if (builtSnippet) then
      return builtSnippet
    end
  end
end

return {
  ["checkMatchStart"] = checkMatchStart,
  ["youTubeBuilder"] = youTubeBuilder,
  ["brightcoveBuilder"] = brightcoveBuilder,
  ["vimeoBuilder"] = vimeoBuilder,
  ["unknownBuilder"] = unknownBuilder,
  ["VIDEO_TYPES"] = VIDEO_TYPES,
  ["getLinkFromBuilders"] = getLinkFromBuilders
}
