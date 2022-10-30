--- parse-latex.lua – parse and replace raw LaTeX snippets
---
--- Copyright: © 2021–2022 Albert Krewinkel
--- License: MIT – see LICENSE for details

-- Makes sure users know if their pandoc version is too old for this
-- filter.
PANDOC_VERSION:must_be_at_least '2.9'

-- Return an empty filter if the target format is LaTeX: the snippets will be
-- passed through unchanged.
if FORMAT:match 'latex' then
  return {}
end

-- Parse and replace raw TeX blocks, leave all other raw blocks
-- alone.
function RawBlock (raw)
  if raw.format:match 'tex' then
    return pandoc.read(raw.text, 'latex').blocks
  end
end

-- Parse and replace raw TeX inlines, leave other raw inline
-- elements alone.
function RawInline(raw)
  if raw.format:match 'tex' then
    return pandoc.utils.blocks_to_inlines(
      pandoc.read(raw.text, 'latex').blocks
    )
  end
end
