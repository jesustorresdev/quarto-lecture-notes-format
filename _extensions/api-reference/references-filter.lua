-- shortcodes for create links to api references

local apiref = require "api-reference"

local Attr = pandoc.Attr
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
  ["struct"] = "estructura",
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
  local results = pandoc.Nil
  
  -- type marker
  local marker = opts['markers'][entry.type]
  if marker then
    header:insert(Span(marker, Attr("", {"apirefs-entry-marker"})))
    header:insert(RawInline("html", "&nbsp;"))
  end

  -- name
  local labelSuffix = entry.isFunc and "()" or ""
  header:insert(Span({entry.label, labelSuffix}, Attr("", {"apirefs-entry-label"})))  

  -- type
  -- header::insert(Span("«" .. TYPE_MAPPING[entry.type] .. "»"))
  header:insert(Space())
  header:insert(Span(TYPE_MAPPING[entry.type], Attr("", {"apirefs-entry-type"})))

  -- internal name
  if entry['internal-name'] then
    header:insert(Space())
    header:insert(Span({"|", Code(entry['internal-name']), "|"}, Attr("", {"apirefs-entry-internal-name"})))
  end

  -- derived class
  if entry.isClass and entry.extends then
    headerEnd:insert(": ")
    headerEnd:insert(Span(entry.extends, Attr("", {"apirefs-entry-extends"})))
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
      refList:insert(Link(opts['markers'][lang] or lang, url, LANG_MAPPING[lang],
      Attr("", {"apirefs-entry-ref " .. "apirefs-entry-ref-" .. lang})))
      firstRef = false
    end
    headerEnd:insert(Span(refList, Attr("", {"apirefs-entry-refs"})))
  end
  
  -- we use headerEnd to avoid breaking the line for the end of the header
  if #headerEnd > 0 then
    header:insert(Space())
    header:insert(Span(headerEnd, Attr("", {"apirefs-entry-nobrk"})))
  end

  results = Div({pandoc.Inlines(header)}, Attr(entry.refname, {"apirefs-entry", "apirefs-ref-" .. entry.type})))

  -- description
  if entry.description then
    description = Div(entry.description, Attr("", {"apirefs-entry-description"}))
    results.content:insert(description)
  end

  -- other reference list
  if entry['other-refs'] then
    local refList = pandoc.List()
    for _, ref in ipairs(entry['other-refs']) do
      refList:insert(Link(ref.title, ref.url, nil,
        Attr("", {"apirefs-entry-otherref"})))
    end
    otherRefsList = Div(BulletList(refList), Attr("", {"apirefs-entry-otherrefs"}))
    results.content:insert(otherRefsList)
  end
  
  return results
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
          end))}, Attr("", {"apirefs-list, apirefs-entry-members-list"}))
        refBlock.content:insert(membersList)
      end
      return refBlock
    end))}, Attr("", {"apirefs-list, apirefs-top-list"}))
end

return {
  Pandoc = function(doc)
    opts = apiref.getOptions(doc.meta) 
    -- insert references section at the end of the document
    if apiref.isInitialized() then
      local section = {
        Header(1, opts['reference-section-title'], Attr("toc-apirefs")),
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