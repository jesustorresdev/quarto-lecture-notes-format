-- api-reference-filter.lua

local CROSSREF_PREFIX = "api"
local CROSSREF_SEP = "-"

local ENTITY_TYPES = {
  class = "class",
  method = "method"
}

local KNOWN_LANGUAGES = {
  ["cpp"] = {
    id = "cpp",
    -- reftitle = "C++ API Reference",
    reftitle = "API de C++",
  },
  blueprint = {
    id = "blueprint",
    -- reftitle = "Blueprint API Reference",
    reftitle = "API de Blueprint",
  },
}

local LANG_MAPPING = {
  ["c++"] = KNOWN_LANGUAGES.cpp,
  cpp = KNOWN_LANGUAGES.cpp,
  blueprint = KNOWN_LANGUAGES.blueprint,
  ["bp"] = KNOWN_LANGUAGES.blueprint,
}

local stringify = pandoc.utils.stringify

local globalReferences

local function readYamlFile(filename)
  local file = io.open(filename, 'r')
  if not file then
    quarto.log.warning("api-reference: '" .. filename .. "' file cannot open.")
    return {}
  end
  local content = "---\n" .. file:read("*a") .. "\n---\n"
  file:close()
  local metadata = pandoc.read(content, "markdown").meta
  -- quarto.log.output(metadata)
  return metadata
end

local function intializeReference(item, parent)
  local entry = {}
  entry.id = item.id
  entry.used = false
  entry.type = item.type and stringify(item.type)
    or parent and ENTITY_TYPES.method or ENTITY_TYPES.class
  entry.name = item.name and stringify(item.name) or entry.id
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
        quarto.log.warning("api-reference: ignoring an '" .. entry.name .. "' reference because the URL is missing.")
        goto continue
      end

      ref.url = stringify(refItem.url)
      if refItem.lang then
        local lang = LANG_MAPPING[stringify(refItem.lang):lower()].id
        if lang then ref.lang = lang end
      end
    
      ref.name = refItem.name and stringify(refItem.name)
        or ref.lang and KNOWN_LANGUAGES[ref.lang].reftitle or ref.url
      table.insert(entry.refs, ref)
      ::continue::
    end
    table.sort(entry.refs, function(left, right) return left.name < right.name end)
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
}