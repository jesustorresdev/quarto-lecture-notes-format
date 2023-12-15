-- shortcodes for create links to api references

local apiref = require "api-reference"
local fontawesome = require "fontawesome"

local faArrow = fontawesome.fontAwesome("arrow-circle-right", nil, "small")
local faCube = fontawesome.fontAwesome("cube", nil, "small")

local stringify = pandoc.utils.stringify
local Attr = pandoc.Attr
local BulletList = pandoc.BulletList
local DefinitionList = pandoc.DefinitionList
local Code = pandoc.Code
local Emph = pandoc.Emph
local Link = pandoc.Link
local Space = pandoc.Space
local Span = pandoc.Span
local Str = pandoc.Str

local TYPE_MAPPING = {
  ["class"] = "clase",
  ["method"] = "método",
}

local function processEntry(entry)
  local name = entry.type == apiref.ENTITY_TYPES.method and entry.name .. "()" or entry.name
  local term = Span({
    entry.type == apiref.ENTITY_TYPES.method and faArrow or faCube,
    Space(),
    pandoc.Str(name)
  }, Attr(entry.refname))
  local descriptionParagraph = {}
  local refsList = {}

  -- internal name
  if entry['internal-name'] then
    table.insert(descriptionParagraph, Str("{"))
    table.insert(descriptionParagraph, Code(entry['internal-name']))
    table.insert(descriptionParagraph, Str("}"))
    table.insert(descriptionParagraph, Space())
  end

  -- type marker
  table.insert(descriptionParagraph, Emph("«" .. TYPE_MAPPING[entry.type] .. "»"))

  if entry.type == apiref.ENTITY_TYPES.class and entry.extends then
    table.insert(descriptionParagraph, Space())
    table.insert(descriptionParagraph, Str(":"))
    table.insert(descriptionParagraph, Space())
    table.insert(descriptionParagraph, Emph(entry.extends))
  end

  -- reference list
  if entry.refs then
    for _, ref in pairs(entry.refs) do
      table.insert(refsList, Link(ref.name, ref.url))
    end
  end

  return {term = term, description = {descriptionParagraph, BulletList(refsList)}}
end

local function Block(el)
  if el.identifier ~= 'api-refs' or not apiref.isInitialized() then
    return nil
  end

  local definitions = {}
  for _, entry in apiref.referencesIterator() do
    if not entry.used then goto continue end
    local definition = processEntry(entry)

    if entry.members then
      local membersList = {}
      for _, member in pairs(entry.members) do
        if not member.used then goto continueMember end

        local memberDefinition = processEntry(member)
        table.insert(membersList, {memberDefinition.term, memberDefinition.description})
        ::continueMember::
      end
      table.sort(membersList, function(left, right) return stringify(left[1].text) < stringify(right[1].text) end)
      table.insert(definition.description, DefinitionList(membersList))
    end

    table.insert(definitions, {
      definition.term,
      pandoc.Blocks(definition.description)
    })
    table.sort(definitions, function(left, right) return stringify(left[1]) < stringify(right[1]) end)
  ::continue::
  end

  return DefinitionList(definitions)
end

return {
    Block = Block
}