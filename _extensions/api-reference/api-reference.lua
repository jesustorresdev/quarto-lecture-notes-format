-- api-reference-filter.lua

local CROSSREF_PREFIX = "apiref-"
local CROSSREF_SEP = "-"
local REFERENCE_SECTION_TITLE = "API References"

local stringify = pandoc.utils.stringify

local globalOptions = nil
local globalReferences = {}

local CLASS_TYPE_NAME = "class"
local METHOD_TYPE_NAME = "method"
local knownEntryTypes = {
  class = { title = "class", func = false, class = true, marker = "C{}" },
  struct = { title = "struct", func = false, class = true, marker = "{}" },
  enum = { title = "enum", func = false, class = true, marker = "E{}" },
  func = { title = "function", func = true, class = false, marker = "ƒ()" },
  method = { title = "method", func = true, class = false, marker = "ƒ()" },
}

local knownLanguages = {
  c = { title = "C", marker = "C" },
  cpp = { title = "C++", marker = "C++" },
}

local function ensureHtmlDeps()
  quarto.doc.add_html_dependency({
    name = 'api-reference',
    version = '0.1.0',
    stylesheets = {'assets/css/all.css'}
  })
end

local function createLanguage(lang, defaults)
  if not defaults then
    defaults = {}
  end

  local langEntry = {}
  langEntry.title = defaults.title or lang
  langEntry.marker = defaults.marker or langEntry.title
  return langEntry
end

local function createEntryType(type, defaults)
  if not defaults then
    defaults = {}
  end
  
  local typeEntry = {}
  typeEntry.title = defaults.title or type
  typeEntry.func = defaults.func or false
  typeEntry.class = defaults.class or false
  typeEntry.marker = defaults.marker or type:sub(1, 1):upper() .. (typeEntry.func and "()" or (typeEntry.class and "{}" or ""))
  return typeEntry
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
  opts['reference-section-title'] = opts['reference-section-title'] or REFERENCE_SECTION_TITLE
  
  -- merge the languages options with the default ones
  local langs = opts['langs'] or {}
  for lang, desc in pairs(langs) do
    if not knownLanguages[lang] ~= nil then
      knownLanguages[lang] = createLanguage(lang, desc)
    else
      for key, value in pairs(desc) do
        if knownLanguages[lang][key] then
          knownLanguages[lang][key] = value
        end
      end
    end
  end

  -- merge the entry types options with the default ones
  local types = opts['types'] or {}
  for type, desc in pairs(types) do
    if not knownEntryTypes[type] ~= nil then
      knownEntryTypes[type] = createEntryType(type, desc)
    else
      for key, value in pairs(desc) do
        if knownEntryTypes[type][key] then
          knownEntryTypes[type][key] = value
        end
      end
    end
  end

  opts['langs'] = nil
  opts['types'] = nil
  return opts
end

local function updateMarkersFromMeta(meta)
  if not globalOptions then
    return
  end

  local langs = meta['api-reference'] and meta['api-reference']['langs'] or {}

  for lang, _ in pairs(knownLanguages) do
    if langs[lang] and langs[lang]['marker'] then
      knownLanguages[lang]["marker"] = langs[lang]["marker"]
    end
  end

  local types = meta['api-reference'] and meta['api-reference']['types'] or {}

  for type, _ in pairs(knownEntryTypes) do
    if types[type] and types[type]['marker'] then
      knownEntryTypes[type]["marker"] = types[type]["marker"]
    end
  end
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
    or (parent and METHOD_TYPE_NAME or CLASS_TYPE_NAME)
  entry.isFunc = knownEntryTypes.func
  entry.isClass = knownEntryTypes.class
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

  local opts = getOptions(meta)
  if not (opts and opts['path']) then
    return false
  end

  local path = stringify(opts['path'])
  local metadata = readYamlFile(path)
  globalReferences = initializeReferences(metadata)

  globalOptions = opts
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
  updateMarkersFromMeta = updateMarkersFromMeta,
  findEntry = findEntry,
  referencesIterator = function()
    return pairs(globalReferences)
  end,
  getOptions = function()
    return globalOptions or {}
  end,
  getLanguage = function(lang)
    return knownLanguages[lang] or createLanguage(lang)
  end,
  getType = function(type)
    return knownEntryTypes[type] or createEntryType(type)
  end
}