-- api-reference-filter.lua

local CROSSREF_PREFIX = "apiref-"
local CROSSREF_SEP = "-"

local ENTITY_TYPES = {
  class = { name = "class", isFunc = false, isClass = true },
  struct = { name = "struct", isFunc = false, isClass = true },
  ["function"] = { name = "function", isFunc = true, isClass = false },
  method = { name = "method", isFunc = true, isClass = false },
  event = { name = "event", isFunc = true, isClass = false },
  static = { name = "static", isFunc = true, isClass = false },
}

local DEFAULT_MARKERS = {
  ["class"] = pandoc.Str("C{}"),
  ["struct"] = pandoc.Str("S{}"),
  ["event"] = pandoc.Str("E→"),
  ["function"] = pandoc.Str("ƒ()"),
  ["method"] = pandoc.Str("ƒ()"),
  ["static"] = pandoc.Str("ƒ()"),
  ["cpp"] = pandoc.Str("C++"),
  ["bp"] = pandoc.Str("BP"),
}

local stringify = pandoc.utils.stringify

local globalReferences = {}
local globalOptions = nil

local function ensureHtmlDeps()
  quarto.doc.add_html_dependency({
    name = 'api-reference',
    version = '0.1.0',
    stylesheets = {'assets/css/all.css'}
  })
end

local function getOptions(meta)
  local opts = meta['api-reference'] or {}
  local suppressShowMarkers = opts['suppress-ref-marker'] and stringify(opts['suppress-ref-marker']):lower() or "0"
  if suppressShowMarkers == "true" or suppressShowMarkers == "1" then
      opts['suppress-ref-marker'] = true
  else
    opts['suppress-ref-marker'] = false
  end
  opts['ref-show-marker'] = opts['ref-show-marker']and true or opts['ref-show-marker']
  opts['markers'] = opts['markers'] or {}
  opts['reference-section-title'] = opts['reference-section-title'] or "API References"
  -- merge the default markers
  for key, value in pairs(DEFAULT_MARKERS) do
    if not opts['markers'][key] then
      opts['markers'][key] = value
    end
  end
  return opts
end

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
    return left.title < right.title
  end
end

local function intializeReference(item, parent)
  local entry = {}
  entry.id = item.id
  entry.used = false
  entry.type = item.type and stringify(item.type)
    or parent and ENTITY_TYPES.method.name or ENTITY_TYPES.class.name
  entry.isFunc = ENTITY_TYPES[entry.type].isFunc
  entry.isClass = ENTITY_TYPES[entry.type].isClass
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
  if item['description'] then
    entry['description'] = item['description']
  end
  
  -- references by language
  if item.refs then
    entry.refs = {}
    for refLang, refUrl in pairs(item.refs) do
      entry.refs[stringify(refLang)] = stringify(refUrl)
    end
  end

  -- other references
  if item['other-refs'] then
    entry['other-refs'] = {}
    for _, refItem in ipairs(item['other-refs']) do
      local ref = {}
      if not refItem.url then
        quarto.log.warning("api-reference: ignoring an '" .. entry.label .. "' reference because the URL is missing.")
        goto continue
      end

      if not refItem.title then
        quarto.log.warning("api-reference: ignoring an '" .. entry.label .. "' reference because the Title is missing.")
        goto continue
      end

      table.insert(entry['other-refs'], {
        url = stringify(refItem.url),
        title = stringify(refItem.title),
        order = refItem.order and stringify(refItem.order)
      })
      ::continue::
    end
    table.sort(entry['other-refs'], refsSorting)
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

local function initialize(meta)
  if globalOptions then
    return true
  end

  ensureHtmlDeps()

  globalOptions = getOptions(meta)
  if not (globalOptions and globalOptions['path']) then
    return false
  end

  local path = stringify(globalOptions['path'])
  local metadata = readYamlFile(path)
  globalReferences = initializeReferences(metadata)

  return true
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
  initialize = initialize,
  isInitialized = function()
    return globalOptions ~= nil
  end,
  findEntry = findEntry,
  referencesIterator = function()
    return pairs(globalReferences)
  end,
  getOptions = function()
    return globalOptions
  end
}