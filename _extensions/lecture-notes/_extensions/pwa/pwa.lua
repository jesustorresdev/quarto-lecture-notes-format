local PWA_HEAD_SCRIPT = [[
<script>
  IconifyProviders = {
    '': {
      'resources': [
        '${projectOffset}/iconify',
        'https://api.iconify.design',
        'https://api.simplesvg.com',
        'https://api.unisvg.com'
      ]
    }
  }

  if ('serviceWorker' in navigator) {
    window.addEventListener('load', function() {
      navigator.serviceWorker.register('${projectOffset}/sw.js')
        .then(function(registration) {
          console.log('Service Worker registered with scope:', registration.scope);
        }, function(err) {
          console.log('Service Worker registration failed:', err);
        })
      })
  }
</script>
]]

local function stringInterp(s, tab)
  return (s:gsub('($%b{})', function(w) return tab[w:sub(3, -2)] or w end))
end

local function metaToLua(meta)
  if meta == nil then
    return nil
  end
  if pandoc.utils.type(meta) == "table" then
    local result = {}
    for k, v in pairs(meta) do
      result[k] = metaToLua(v)
    end
    return result
  elseif pandoc.utils.type(meta) == "List" then
    local result = {}
    for i, v in ipairs(meta) do
      result[i] = metaToLua(v)
    end
    return result
  elseif pandoc.utils.type(meta) == "Inlines" then
    return pandoc.utils.stringify(meta)
  else
    return nil
  end
end

local function generateManifest(meta)
  local manifest = metaToLua(meta['pwa']['manifest']) or {}

  manifest.name = pandoc.utils.stringify(manifest.name or meta.title or "My Book")
  manifest.start_url = manifest.start_url or (quarto.project.offset .. "/")
  manifest.description = pandoc.utils.stringify(manifest.description
    or meta.abstract
    or "A book created with Quarto"
  )
  
  manifest.display = manifest.display or "browser"
  manifest.background_color = manifest.background_color or "#ffffff"
  manifest.theme_color = manifest.theme_color or "#4F46E5"  
  return manifest
end

local function saveManifest(manifest)
  local output_path = quarto.project.output_directory .. "/manifest.json"
  local file = io.open(output_path, "w")
  if file then
    file:write(quarto.json.encode(manifest))
    file:close()
    return true
  end
  quarto.log.error("Failed to write manifest to: " .. output_path)
  return false
end

local function canPWABeEnabled(meta)
  return quarto.doc.is_format('html:js') and meta['pwa'] and meta['pwa']['manifest']
end

function Meta(meta)
  if not canPWABeEnabled(meta) then
    return meta
  end
    
  local manifest = generateManifest(meta)
  local links = {
    { rel = 'manifest', href = '/manifest.json' },
  }
  if manifest['apple-touch-icon'] then
    table.insert(links, { rel = 'apple-touch-icon', href = manifest['apple-touch-icon'] })
  end

  quarto.doc.add_html_dependency({
    name = 'pwa',
    serviceworkers = {'sw.js'},
    meta = {
      ['theme-color'] = manifest.theme_color,
      ['mobile-web-app-capable'] = 'yes',
      ['apple-mobile-web-app-status-bar-style'] = 'black',
      ['apple-mobile-web-app-title'] = manifest.name,
    },
    links = links,
    head = stringInterp(PWA_HEAD_SCRIPT, {projectOffset = quarto.project.offset})
  })

  -- Save manifest to output directory
  if quarto.project.output_directory and pandoc.path.filename(quarto.doc.input_file) == "index.qmd" then
    saveManifest(manifest)
  end
  return meta
end
