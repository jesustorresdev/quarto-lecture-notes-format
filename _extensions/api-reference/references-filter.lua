-- shortcodes for create links to api references

local apiref = require "api-reference"

local BulletList = pandoc.BulletList
local Code = pandoc.Code
local Div = pandoc.Div
local Header = pandoc.Header
local Link = pandoc.Link
local RawInline = pandoc.RawInline
local Space = pandoc.Space
local Span = pandoc.Span

local TYPE_MAPPING = {
  ["class"] = "clase",
  ["function"] = "función",
  ["method"] = "método",
  ["event"] = "evento",
  ["static"] = "static",
}

local LANG_MAPPING = {
  ["cpp"] = "C++",
  ["bp"] = "Blueprint",
}

local function processEntry(opts, entry, parent)
  local header = pandoc.List()
  local headerEnd = pandoc.List()
  local otherRefsList = pandoc.Nil
  
  -- type marker
  local marker = opts['markers'][entry.type]
  if marker then
    header:insert(Span(marker, {class="apirefs-entry-marker"}))
    header:insert(RawInline("html", "&nbsp;"))
  end

  -- name
  local labelSuffix = entry.isFunc and "()" or ""
  header:insert(Span({entry.label, labelSuffix}, {id=entry.refname, class="apirefs-entry-label"}))  

  -- type
  -- header::insert(Span("«" .. TYPE_MAPPING[entry.type] .. "»"))
  header:insert(Space())
  header:insert(Span(TYPE_MAPPING[entry.type], {class="apirefs-entry-type"}))

  -- internal name
  if entry['internal-name'] then
    header:insert(Space())
    header:insert(Span({"|", Code(entry['internal-name']), "|"}, {class="apirefs-entry-internal-name"}))
  end

  -- derived class
  if entry.type == apiref.ENTITY_TYPES.class and entry.extends then
    headerEnd:insert(": ")
    headerEnd:insert(Span(entry.extends, {class="apirefs-entry-extends"}))
  end
  
  -- references
  if entry.refs then
    local refList = pandoc.List()
    local firstRef = true
    for lang, url in pairs(entry.refs) do
      -- only add space at the beginning if it's needed
      if #headerEnd > 0 or not firstRef then
        refList:insert(Space())
      end
      local langIcon = opts['markers'][lang]
      refList:insert(Link(langIcon or lang, url, LANG_MAPPING[lang],
      {class="apirefs-entry-ref " .. "apirefs-entry-ref-" .. lang}))
      firstRef = false
    end
    headerEnd:insert(Span(refList, {class="apirefs-entry-refs"}))
  end
  
  -- we use headerEnd to avoid breaking the line for the end of the header
  if #headerEnd > 0 then
    header:insert(Space())
    header:insert(Span(headerEnd, {class="apirefs-entry-nobrk"}))
  end

  -- other reference list
  if entry['other-refs'] then
    local refList = pandoc.List()
    for _, ref in ipairs(entry['other-refs']) do
      refList:insert(Link(ref.title, ref.url, nil,
        {class="apirefs-entry-otherref"}))
    end
    otherRefsList = Div(BulletList(refList), {class="apirefs-entry-otherrefs"})
  end
  
  return Div({
      pandoc.Inlines(header),
      otherRefsList
    }, {class="apirefs-entry " .. "apirefs-ref-" .. entry.type})
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
    end))}, {class="apirefs-list apirefs-top-list"})
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