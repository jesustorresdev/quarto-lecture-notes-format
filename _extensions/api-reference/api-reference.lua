-- api-reference-filter.lua

local CROSSREF_PREFIX = "apiref-"
local CROSSREF_SEP = "-"

local ENTITY_TYPES = {
  class = "class",
  func = "function",
  method = "method",
  event = "event",
}

local KNOWN_LANGUAGES = {
  ["cpp"] = {
    id = "cpp",
    -- reftitle = "C++ API Reference",
    reftitle = "C++ API",
  },
  blueprint = {
    id = "blueprint",
    -- reftitle = "Blueprint API Reference",
    reftitle = "Blueprint API",
  },
}

local LANG_MAPPING = {
  ["c++"] = KNOWN_LANGUAGES.cpp,
  cpp = KNOWN_LANGUAGES.cpp,
  blueprint = KNOWN_LANGUAGES.blueprint,
  ["bp"] = KNOWN_LANGUAGES.blueprint,
}

local DEFAULT_MARKERS = {
  ["class"] = pandoc.Str("C{}"),
  ["event"] = pandoc.Str("E→"),
  ["function"] = pandoc.Str("ƒ()"),
  ["method"] = pandoc.Str("ƒ()"),
}

local stringify = pandoc.utils.stringify
local Link = pandoc.Link
local Span = pandoc.Span

local globalReferences

local function readYamlFile(filename)
  local file = io.open(filename, 'r')
  if not file then
    quarto.log.warning("api-reference: '" .. filename .. "' file cannot open.")
    return {}
  end
  local content = file:read("*a")
  if not content:find("^---\n") then
    content = "---\n" .. content
  end
  content:gsub("\n...\n*$", "")
  content = content .. "\n---\n"
  file:close()
  local metadata = pandoc.read(content, "markdown-raw_html").meta
  -- quarto.log.output(metadata)
  return metadata
end

local function refsSorting(left, right) 
  if left.order and right.order then
    return left.order < right.order
  elseif left.order then
    return true
  elseif right.order then
    return false
  else
    return left.label < right.label
  end
end

local function buildRefLabel(ref)
  -- quarto.log.output(ref)
  local label = Link(ref.url, ref.url)
  if (ref.label) then
    label = Link(ref.label, ref.url)
  elseif ref.lang then
    label = KNOWN_LANGUAGES[ref.lang].reftitle
    if ref.name then
      label = Span({label, ": ", Link(ref.name, ref.url)})
    else
      label = Link(label, ref.url)
    end
  elseif ref.name then
    label = Link(ref.name, ref.url)
  end
  return label
end

local function intializeReference(item, parent)
  local entry = {}
  entry.id = item.id
  entry.used = false
  entry.type = item.type and stringify(item.type)
    or parent and ENTITY_TYPES.method or ENTITY_TYPES.class
  entry.label = item.label and stringify(item.label) or item.id
  entry.refname = table.concat({
    parent and parent.refname or CROSSREF_PREFIX,
    entry.id
  }, CROSSREF_SEP)
  if item['internal-name'] then
    entry['internal-name'] = stringify(item['internal-name'])
  end
  if item['extends'] then
    entry['extends'] = stringify(item['extends'])
  end
  if item.refs then
    entry.refs = {}
    for _, refItem in ipairs(item.refs) do
      local ref = {}
      if not refItem.url then
        quarto.log.warning("api-reference: ignoring an '" .. entry.label .. "' reference because the URL is missing.")
        goto continue
      end

      ref.url = stringify(refItem.url)
      ref.label = refItem.label and stringify(refItem.label)
      ref.name = refItem.name and stringify(refItem.name)
      ref.order = refItem.order and stringify(refItem.order)
      if refItem.lang then
        local lang = LANG_MAPPING[stringify(refItem.lang):lower()].id
        if lang then ref.lang = lang end
      end
    
      ref.richLabel = buildRefLabel(ref)
      ref.label = stringify(ref.richLabel)
      table.insert(entry.refs, ref)
      ::continue::
    end
    table.sort(entry.refs, refsSorting)
  end

  return entry
end

local function initializeReferences(metadata)
  local refs = {}
  for key, item in pairs(metadata) do
    item.id = key
    local entry = intializeReference(item)

    if item.members then
      entry.members = {}
      for memberKey, memberItem in pairs(item.members) do
        memberItem.id = memberKey
        local member = intializeReference(memberItem, entry)
        entry.members[memberKey] = member
      end
    end
    refs[key] = entry
  end
  return refs
end

local function findEntry(entry_ref, parent_ref)
  local found = { parent = nil, entry = nil }
  if parent_ref then
    found.parent = globalReferences[parent_ref]
    if found.parent and found.parent['members'] then
      found.entry = found.parent['members'][entry_ref]
    end
  elseif globalReferences[entry_ref] then
    found.entry = globalReferences[entry_ref]
  else
    -- serach for the entry in the members of the classes
    for _, class in pairs(globalReferences) do
      if class['members'] and class['members'][entry_ref] then
        found.parent = class
        found.entry = class['members'][entry_ref]
      end
    end
  end
  return found
end

return {
  ENTITY_TYPES = ENTITY_TYPES,
  initializeReferences = function(path)
    if not globalReferences then
      local metadata = readYamlFile(path)
      globalReferences = initializeReferences(metadata)
    end
  end,
  isInitialized = function()
    return globalReferences ~= nil
  end,
  findEntry = findEntry,
  referencesIterator = function()
    return pairs(globalReferences)
  end,
  getOptions = function(meta)
    local opts = meta['api-reference'] or {}
    opts['markers'] = opts['markers'] or {}
    opts['reference-section-title'] = opts['reference-section-title'] or "API References"
    -- merge the default markers
    for key, value in pairs(DEFAULT_MARKERS) do
      if not opts['markers'][key] then
        opts['markers'][key] = value
      end
    end
    return opts
  end,
}