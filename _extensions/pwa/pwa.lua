local DEPENDENCY_NAME = 'pwa'
local DEPENDENCY_DIRECTORY = '/site_libs/quarto-contrib/' .. DEPENDENCY_NAME

local function readManifest(manifestPath)
  local file = io.open(manifestPath, "r")
  if not file then
    quarto.log.error("Could not open manifest.json at: " .. manifestPath)
    return nil
  end
  local content = file:read("*all")
  file:close()
  
  local manifest = quarto.json.decode(content)
  return manifest
end

-- Reformat all heading text 
function Pandoc(doc)
  if quarto.doc.is_format('html:js') then
    manifest = readManifest(quarto.utils.resolve_path('manifest.json'))
    quarto.doc.add_html_dependency({
      name = DEPENDENCY_NAME,
      serviceworkers = {'sw.js'},
      meta = {
        ['theme-color'] = manifest.theme_color,
        ['mobile-web-app-capable'] = 'yes',
        ['apple-mobile-web-app-status-bar-style'] = 'black',
        ['apple-mobile-web-app-title'] = manifest.short_name,
      },
      links = {
        { rel = 'manifest', href = DEPENDENCY_DIRECTORY .. '/manifest.json' },
        { rel = 'apple-touch-icon', href = DEPENDENCY_DIRECTORY .. '/apple-touch-icon.png' },
      },
      resources = {
        'manifest.json',
      --   -- { name = 'apple-touch-icon.png', path = 'icons/apple-touch-icon.png' }
      },
      head = string.format([[
        <script>
          if ('serviceWorker' in navigator) {
            window.addEventListener('load', function() {
              navigator.serviceWorker.register('%s/sw.js').then(function(registration) {
                console.log('Service Worker registrado con éxito:', registration.scope);
              }, function(err) {
                console.log('Error al registrar el Service Worker:', err);
              });
            });
          }
        </script>
      ]], quarto.project.offset)
    })
    return doc
  end
end
