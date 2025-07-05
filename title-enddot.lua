function Meta(meta)
  if pandoc.utils.type(meta.title) == "Inlines" then
    meta.title = meta.title:walk({
      Inline = function(el)
        if el.classes and el.classes:includes("chapter-number") then
          local chapterNumber = el.content[1].text
          if not chapterNumber:match("%.$") then
            el.content[1].text = chapterNumber .. "."
          end
        end
        return el
      end,
    })
  end
  return meta
end