-- shortcodes for create links to api references

local apiref = require "api-reference"
local fontawesome = require "fontawesome"

local faArrow = fontawesome.fontAwesome("arrow-circle-right", nil, "small")
local faCube = fontawesome.fontAwesome("cube", nil, "small")

local BulletList = pandoc.BulletList
local DefinitionList = pandoc.DefinitionList
local Code = pandoc.Code
local Div = pandoc.Div
local Emph = pandoc.Emph
local RawInline = pandoc.RawInline
local Space = pandoc.Space
local Span = pandoc.Span
local Str = pandoc.Str

local TYPE_MAPPING = {
  ["class"] = "clase",
  ["func"] = "función",
  ["method"] = "método"
}

local function processEntry(entry, parent)
  local term = Span({
    entry.type == apiref.ENTITY_TYPES.func and faArrow or faCube,
    Space(),
    pandoc.Str(entry.label)
  }, {id=entry.refname, sortBy=entry.label})
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
  if entry.type == apiref.ENTITY_TYPES.class then
    table.insert(descriptionParagraph, Emph("«" .. TYPE_MAPPING.class .. "»"))
  elseif parent and parent.type == apiref.ENTITY_TYPES.class then
    table.insert(descriptionParagraph, Emph("«" .. TYPE_MAPPING.method .. "»"))
  else
    table.insert(descriptionParagraph, Emph("«" .. TYPE_MAPPING.func .. "»"))
  end

  if entry.type == apiref.ENTITY_TYPES.class and entry.extends then
    table.insert(descriptionParagraph, RawInline("latex", "~:~"))
    table.insert(descriptionParagraph, Emph(entry.extends))
  end

  -- reference list
  if entry.refs then
    for _, ref in pairs(entry.refs) do
      -- quarto.log.output(ref.label)
      table.insert(refsList, ref.richLabel)
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

        local memberDefinition = processEntry(member, entry)
        table.insert(membersList, {memberDefinition.term, memberDefinition.description})
        ::continueMember::
      end

      if membersList then
        table.sort(membersList, function(left, right)
          return left[1].attr.attributes.sortBy < right[1].attr.attributes.sortBy end)
        table.insert(definition.description, DefinitionList(membersList))
      end
    end

    table.insert(definitions, {
      definition.term,
      pandoc.Blocks(definition.description)
    })
    ::continue::
  end

  if definitions then
    table.sort(definitions, function(left, right)
      return left[1].attr.attributes.sortBy < right[1].attr.attributes.sortBy end)
    return Div({
      RawInline("latex", "\\begin{flushleft}"),
      DefinitionList(definitions),
      RawInline("latex", "\\end{flushleft}")
    }) 
  else
    return pandoc.Null()
  end
end

return {
    Block = Block
}