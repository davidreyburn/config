vim.cmd.highlight 'clear'
vim.g.colors_name = 'phosphor'
vim.o.background = 'dark'

local c = {
  bg        = '#141a03',
  bg_dim    = '#0d1102',
  bg_hl     = '#1c2404',
  bg_sel    = '#2a3a08',
  dim       = '#2a6e2a',
  mid       = '#2eb82e',
  fg        = '#39FF39',
  fg_bright = '#66FF66',
  white     = '#ddffdd',
  teal      = '#00dd77',
  teal_hi   = '#11ffbb',
  none      = 'NONE',
}

local hi = function(group, opts)
  vim.api.nvim_set_hl(0, group, opts)
end

-- Base
hi('Normal',       { fg = c.fg,        bg = c.bg })
hi('NormalFloat',  { fg = c.fg,        bg = c.bg_dim })
hi('NormalNC',     { fg = c.mid,       bg = c.bg_dim })

-- Syntax
hi('Comment',      { fg = c.dim,       italic = true })
hi('String',       { fg = c.teal })
hi('Character',    { fg = c.teal })
hi('Number',       { fg = c.teal_hi })
hi('Float',        { fg = c.teal_hi })
hi('Boolean',      { fg = c.teal_hi })
hi('Constant',     { fg = c.teal_hi })
hi('Identifier',   { fg = c.fg })
hi('Function',     { fg = c.fg_bright })
hi('Statement',    { fg = c.fg_bright })
hi('Keyword',      { fg = c.fg_bright })
hi('Conditional',  { fg = c.fg_bright })
hi('Repeat',       { fg = c.fg_bright })
hi('Exception',    { fg = c.fg_bright })
hi('Operator',     { fg = c.fg })
hi('Type',         { fg = c.teal })
hi('TypeDef',      { fg = c.teal })
hi('Structure',    { fg = c.teal })
hi('PreProc',      { fg = c.mid })
hi('Include',      { fg = c.mid })
hi('Define',       { fg = c.mid })
hi('Macro',        { fg = c.mid })
hi('Special',      { fg = c.teal_hi })
hi('SpecialChar',  { fg = c.teal_hi })
hi('Delimiter',    { fg = c.dim })
hi('Underlined',   { fg = c.fg,        underline = true })
hi('Todo',         { fg = c.bg,        bg = c.teal,     bold = true })
hi('Error',        { fg = c.white,     bg = c.bg,       underline = true })
hi('Warning',      { fg = c.fg_bright, bg = c.bg,       underline = true })

-- Treesitter overrides
hi('@comment',             { link = 'Comment' })
hi('@string',              { link = 'String' })
hi('@number',              { link = 'Number' })
hi('@keyword',             { link = 'Keyword' })
hi('@keyword.function',    { link = 'Keyword' })
hi('@keyword.return',      { link = 'Keyword' })
hi('@function',            { link = 'Function' })
hi('@function.builtin',    { fg = c.teal_hi })
hi('@function.call',       { link = 'Function' })
hi('@method',              { link = 'Function' })
hi('@method.call',         { link = 'Function' })
hi('@type',                { link = 'Type' })
hi('@type.builtin',        { fg = c.teal })
hi('@variable',            { fg = c.fg })
hi('@variable.builtin',    { fg = c.teal_hi })
hi('@constant',            { link = 'Constant' })
hi('@constant.builtin',    { fg = c.teal_hi })
hi('@operator',            { link = 'Operator' })
hi('@punctuation',         { fg = c.dim })
hi('@punctuation.bracket', { fg = c.mid })
hi('@tag',                 { fg = c.fg_bright })
hi('@tag.attribute',       { fg = c.teal })
hi('@tag.delimiter',       { fg = c.dim })
hi('@markup.heading',      { fg = c.fg_bright, bold = true })
hi('@markup.link',         { fg = c.teal,      underline = true })
hi('@markup.link.url',     { fg = c.teal_hi,   underline = true })
hi('@markup.raw',          { fg = c.mid })
hi('@markup.list',         { fg = c.fg_bright })

-- UI
hi('LineNr',         { fg = c.dim })
hi('CursorLine',     { bg = c.bg_hl })
hi('CursorLineNr',   { fg = c.fg,    bg = c.bg_hl, bold = true })
hi('SignColumn',     { fg = c.dim,   bg = c.bg })
hi('ColorColumn',    { bg = c.bg_hl })
hi('Visual',         { bg = c.bg_sel })
hi('VisualNOS',      { bg = c.bg_sel })
hi('Search',         { fg = c.bg,    bg = c.teal })
hi('IncSearch',      { fg = c.bg,    bg = c.fg_bright })
hi('CurSearch',      { fg = c.bg,    bg = c.fg_bright })
hi('MatchParen',     { fg = c.white, bg = c.bg_sel, bold = true })
hi('Folded',         { fg = c.dim,   bg = c.bg_dim })
hi('FoldColumn',     { fg = c.dim,   bg = c.bg })
hi('NonText',        { fg = c.dim })
hi('EndOfBuffer',    { fg = c.bg })
hi('Whitespace',     { fg = c.bg_sel })
hi('VertSplit',      { fg = c.bg_sel })
hi('WinSeparator',   { fg = c.bg_sel })
hi('Title',          { fg = c.fg_bright, bold = true })

-- Statusline
hi('StatusLine',     { fg = c.fg,  bg = c.bg_dim })
hi('StatusLineNC',   { fg = c.dim, bg = c.bg_dim })

-- Tabline
hi('TabLine',        { fg = c.dim, bg = c.bg_dim })
hi('TabLineSel',     { fg = c.fg,  bg = c.bg,     bold = true })
hi('TabLineFill',    { bg = c.bg_dim })

-- Popup menu
hi('Pmenu',          { fg = c.fg,       bg = c.bg_dim })
hi('PmenuSel',       { fg = c.bg,       bg = c.mid })
hi('PmenuSbar',      { bg = c.bg_sel })
hi('PmenuThumb',     { bg = c.mid })

-- Diagnostics
hi('DiagnosticError',            { fg = c.fg_bright })
hi('DiagnosticWarn',             { fg = c.teal_hi })
hi('DiagnosticInfo',             { fg = c.teal })
hi('DiagnosticHint',             { fg = c.mid })
hi('DiagnosticUnderlineError',   { underline = true, sp = c.fg_bright })
hi('DiagnosticUnderlineWarn',    { underline = true, sp = c.teal_hi })

-- Git signs
hi('GitSignsAdd',    { fg = c.teal })
hi('GitSignsChange', { fg = c.mid })
hi('GitSignsDelete', { fg = c.fg_bright })
