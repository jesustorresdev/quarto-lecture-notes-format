-- shortcodes for create links to api references

local apiref = require "api-reference"

local stringify = pandoc.utils.stringify
local Link = pandoc.Link
local Span = pandoc.Span
local Strong = pandoc.Strong

local function splitCrossref(crossref)
  local parts = {}
  for word in crossref:gmatch('([^:]+)') do
    table.insert(parts, word)
  end
  return parts
end

local function apiShortcode(args, kwargs, meta)
  local opts = apiref.getOptions(meta)
  if not (opts and opts['path']) then
    return Strong("?api:")
  end

  if not apiref.isInitialized() then
    local path = stringify(meta['api-reference']['path'])
    apiref.initializeReferences(path)
  end

  if #args < 1 then
      return Strong("?api:")
  end 

  local mode
  local crossref = stringify(args[1])
  if #args > 1 then
      mode = crossref
      crossref = stringify(args[2])
  end

  local crossrefParts = splitCrossref(crossref)
  local isFull = mode == "full" or (#crossrefParts == 2 and mode ~= "short")
  local found = apiref.findEntry(crossrefParts[#crossrefParts], crossrefParts[#crossrefParts-1])
  
  local entry = found.entry
  local parent = found.parent
  
  if not entry then
    return Strong("?api:" .. crossref)
  end

  entry.used = true
  if parent then
    parent.used = true
  end

  local marker = opts['suppress-ref-marker'] and pandoc.Null() or opts['markers'][entry.type]
  local reftext = isFull and parent.label .. "::" .. entry.label or entry.label
  reftextSuffix = entry.type == apiref.ENTITY_TYPES.func
    or entry.type == apiref.ENTITY_TYPES.method and "()" or ""
  return Span({
    Span(marker, {class="apirefs-ref-marker"}),
    Link(reftext, "#" .. entry.refname, nil, {role="apiref"}),
    Span({reftextSuffix}, {class="apirefs-ref-suffix"}),
  }, {class="apirefs-ref " .."apirefs-ref-" .. entry.type})
end

return {
    api = apiShortcode
}