-- shortcodes for create links to api references

local apiref = require "api-reference"

local BulletList = pandoc.BulletList
local DefinitionList = pandoc.DefinitionList
local Code = pandoc.Code
local Div = pandoc.Div
local Emph = pandoc.Emph
local Header = pandoc.Header
local RawInline = pandoc.RawInline
local Space = pandoc.Space
local Span = pandoc.Span
local Str = pandoc.Str

local TYPE_MAPPING = {
  ["class"] = "clase",
  ["function"] = "función",
  ["method"] = "método"
}

local function processEntry(opts, entry, parent)
  local marker = pandoc.Nil
  local properties = pandoc.List()
  local refsList = pandoc.List()
  
  -- type marker
  marker = opts['markers'][entry.type]
  properties:insert(Emph("«" .. TYPE_MAPPING[entry.type] .. "»"))

  -- internal name
  if entry['internal-name'] then
    properties:insert(Str("|"))
    properties:insert(Code(entry['internal-name']))
    properties:insert(Str("|"))
    properties:insert(Space())
  end

  -- derived class
  if entry.type == apiref.ENTITY_TYPES.class and entry.extends then
    if quarto.doc.is_format("html") then
      properties:insert(RawInline("html", "&nbsp;:&nbsp;"))
    elseif quarto.doc.is_format("pdf") then
      properties:insert(RawInline("latex", "~:~"))
    else
      properties:insert(Str(" : "))
    end
    properties:insert(Emph(entry.extends))
  end

  -- reference list
  if entry.refs then
    for _, ref in pairs(entry.refs) do
      -- quarto.log.output(ref.label)
      refsList:insert(ref.richLabel)
    end
  end
  
  return Div({
      Span(marker, {class="apirefs-entry-marker"}),
      Span({entry.label}, {id=entry.refname, class="apirefs-entry-label"}),
      Span(properties, {class="apirefs-entry-properties"}),
      Div({BulletList(refsList)}, {class="apirefs-entry-refs"})
    }, {class="apirefs-entry"})
end

local function create_section_references(opts)
  -- filter references
  local references = pandoc.List()
  for _, entry in apiref.referencesIterator() do
    if not entry.used then goto continue end

    local membersList = pandoc.List()
    if entry.members then
      for _, member in pairs(entry.members) do
        if not member.used then goto continueMember end
        table.insert(membersList, member)
        ::continueMember::
      end

      if membersList then
        table.sort(membersList, function(left, right)
          return left.label < right.label end)
      end
    end

    table.insert(references, {entry, membersList})
    ::continue::
  end

  if #references == 0 then
    return pandoc.Nil
  end

  table.sort(references, function(left, right)
      return left[1].label < right[1].label  
    end)
  
  return Div({BulletList(references:map(function(ref)
      local refBlock = processEntry(opts, ref[1])
      if #ref[2] > 0 then
        local membersList = Div({BulletList(ref[2]:map(function(memberRef)
            return processEntry(opts, memberRef, ref[1])
          -- return 
          end))}, {class="apirefs-list apirefs-entry-members-list"})
        refBlock.content:insert(membersList)
      end
      return refBlock
    end))}, {class="apirefs-list"})
end

return {
  Pandoc = function(doc)
    opts = apiref.getOptions(doc.meta) 
    -- insert references section at the end of the document
    if apiref.isInitialized() then
      local section = {
        Header(1, opts['reference-section-title'], {id="toc-apirefs"}),
        create_section_references(opts)
      }
      local newSection = pandoc.structure.make_sections(section, {number_sections=false})
      -- usar extend para agregar los bloques al documento
      for _, block in pairs(newSection) do
        table.insert(doc.blocks, block)
      end
    end
    return doc
  end,
}