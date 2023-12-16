-- shortcodes for create links to api references

local apiref = require "api-reference"
local fontawesome = require "fontawesome"

local faLink = fontawesome.fontAwesome("external-link-alt", nil, "tiny")

local stringify = pandoc.utils.stringify
local Code = pandoc.Code
local Link = pandoc.Link
local Plain = pandoc.Plain
local Strong = pandoc.Strong
local Superscript = pandoc.Superscript

local function splitCrossref(crossref)
  local parts = {}
  for word in crossref:gmatch('([^:]+)') do
    table.insert(parts, word)
  end
  return parts
end

local function apiShortcode(args, kwargs, meta)
  if not (meta['api-reference'] and meta['api-reference']['path']) then
    return Strong("api-ref?")
  end

  if not apiref.isInitialized() then
    local path = stringify(meta['api-reference']['path'])
    apiref.initializeReferences(path)
  end

  if #args < 1 then
      return Strong("api-ref?")
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
      return Strong("api-ref " .. crossref .. "?")
  end

  entry.used = true
  if parent then
      parent.used = true
  end
  
  reftext = isFull and parent.name .. "::" .. entry.name or entry.name 
  return Plain({
    entry.type == apiref.ENTITY_TYPES.func and Code(reftext) or Strong(reftext),
    Superscript(Link(faLink, "#" .. entry.refname))
  })
end

return {
    api = apiShortcode
}