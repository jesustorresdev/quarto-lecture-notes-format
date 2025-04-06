-- shortcodes for create links to api references

local apiref = require "api-reference"

local stringify = pandoc.utils.stringify
local Attr = pandoc.Attr
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
  if not apiref.isInitialized() then
    if not apiref.initialize(meta) then
      return Strong("?api:")
    end
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

  local marker = apiref.getOptions()['suppress-ref-marker'] and pandoc.Null() or apiref.getType(entry.type).marker
  local reftext = isFull and (parent and parent.label or "") .. "::" .. entry.label or entry.label
  reftextSuffix = entry.isFunc and "()" or ""
  return Span({
    Span(marker, Attr("", {"apirefs-ref-marker"})),
    Link(reftext, "#" .. entry.refname, nil, Attr("", {"quarto-xref"}, {{"role", "apiref"}})),
    Span({reftextSuffix}, Attr("", {"apirefs-ref-suffix"})),
  }, Attr("", {"apirefs-ref", "apirefs-ref-" .. entry.type}))
end

return {
    api = apiShortcode
}