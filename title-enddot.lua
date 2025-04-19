function Meta(meta)
  if pandoc.utils.type(meta.title) == "Inlines" then
    local first = meta.title[1]
    if pandoc.utils.type(first) == "Inline"
        and first.classes
        and first.classes:includes("chapter-number") then
      local chapterNumnber = first.content[1].text
      if not chapterNumnber:match("%.$") then
        first.content[1].text = chapterNumnber .. "."
      end
    end
  end
  return meta
end