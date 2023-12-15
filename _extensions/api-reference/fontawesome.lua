-- wrapper around fontawesome shortcode extension

local fontawesome = require(quarto.project.directory .. "/_extensions/quarto-ext/fontawesome/fontawesome")
local faShortcode = fontawesome["fa"]

local function fontAwesome(icon, group, size)
  local args = {icon}
  if group then 
    table.insert(args, 0, group)
  end
  local kwargs = setmetatable({}, { __index = function () return pandoc.Inlines({}) end })
  if size then
    kwargs['size'] = pandoc.Str(size)
  end
  return faShortcode(args, kwargs)
end

return {
  fontAwesome = fontAwesome
}