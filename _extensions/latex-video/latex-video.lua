-- shortcodes for create links to videos

local video = require('video')

local THUMBNAIL_PATH = quarto.utils.resolve_path('resources/thumbnail.jpg')

local function isEmpty(s)
  return s == nil or s == ''
end

local function checkArg(toCheck, key)
  value = pandoc.utils.stringify(toCheck[key])
  if not isEmpty(value) then
    return value
  else
    return nil
  end
end

local function latexVideo(src, start)
  local videoLinkAndType = video.getLinkFromBuilders(src, start)
  return pandoc.RawBlock('latex', 
    '\\href{' .. videoLinkAndType.link .. '}{\\includegraphics{' .. THUMBNAIL_PATH .. '}}')
end

local function videoShortcode(args, kwargs, _meta, raw_args)
  local srcValue = checkArg(kwargs, "src")
  local startValue = checkArg(kwargs, 'start')

  if isEmpty(srcValue) then
    if #raw_args > 0 then
      srcValue = pandoc.utils.stringify(raw_args[1])
    else
      fail("No video source specified for video shortcode")        
    end
  end

  if quarto.doc.is_format('latex') then
    return latexVideo(srcValue, startValue)
  end

  return pandoc.Link(srcValue, srcValue)
end

return {
    video = videoShortcode
}