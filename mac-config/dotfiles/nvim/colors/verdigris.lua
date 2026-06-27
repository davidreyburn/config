vim.cmd.highlight 'clear'
vim.g.colors_name = 'verdigris'
vim.o.background = 'dark'

local c = {
  bg         = '#161614',
  bg_dim     = '#111110',
  bg_hl      = '#1e1d1b',
  bg_sel     = '#2c2b28',
  dim        = '#524e48',
  bone       = '#D0CAB8',
  bone_hi    = '#E8E2D0',
  white      = '#F0EDE4',
  green      = '#44BB44',
  orange     = '#C4834A',
  teal       = '#4AACA4',
  blue       = '#5B8DB8',
  purple     = '#8855BB',
  lime       = '#AAFF00',
  red        = '#CC5555',
  none       = 'NONE',
}

local hi = function(group, opts)
  vim.api.nvim_set_hl(0, group, opts)
end

-- Base
hi('Normal',       { fg = c.bone,    bg = c.bg })
hi('NormalFloat',  { fg = c.bone,    bg = c.bg_dim })
hi('NormalNC',     { fg = c.dim,     bg = c.bg_dim })

-- Syntax
hi('Comment',      { fg = c.dim,     italic = true })
hi('String',       { fg = c.orange })
hi('Character',    { fg = c.orange })
hi('Number',       { fg = c.lime })
hi('Float',        { fg = c.lime })
hi('Boolean',      { fg = c.blue })
hi('Constant',     { fg = c.blue })
hi('Identifier',   { fg = c.bone })
hi('Function',     { fg = c.teal })
hi('Statement',    { fg = c.green })
hi('Keyword',      { fg = c.green })
hi('Conditional',  { fg = c.green })
hi('Repeat',       { fg = c.green })
hi('Exception',    { fg = c.green })
hi('Operator',     { fg = c.bone_hi })
hi('Type',         { fg = c.purple })
hi('TypeDef',      { fg = c.purple })
hi('Structure',    { fg = c.purple })
hi('PreProc',      { fg = c.dim })
hi('Include',      { fg = c.green })
hi('Define',       { fg = c.green })
hi('Macro',        { fg = c.orange })
hi('Special',      { fg = c.teal })
hi('SpecialChar',  { fg = c.orange })
hi('Delimiter',    { fg = c.dim })
hi('Underlined',   { fg = c.bone,    underline = true })
hi('Todo',         { fg = c.bg,      bg = c.green,  bold = true })
hi('Error',        { fg = c.red,     underline = true })
hi('Warning',      { fg = c.orange,  underline = true })

-- Treesitter
hi('@comment',                 { link = 'Comment' })
hi('@string',                  { link = 'String' })
hi('@string.escape',           { fg = c.orange,   bold = true })
hi('@number',                  { link = 'Number' })
hi('@float',                   { link = 'Float' })
hi('@boolean',                 { link = 'Boolean' })
hi('@keyword',                 { link = 'Keyword' })
hi('@keyword.function',        { link = 'Keyword' })
hi('@keyword.return',          { link = 'Keyword' })
hi('@keyword.import',          { link = 'Keyword' })
hi('@keyword.operator',        { fg = c.bone_hi })
hi('@function',                { link = 'Function' })
hi('@function.builtin',        { fg = c.teal,     italic = true })
hi('@function.call',           { link = 'Function' })
hi('@function.method',         { link = 'Function' })
hi('@function.method.call',    { link = 'Function' })
hi('@constructor',             { fg = c.purple })
hi('@type',                    { link = 'Type' })
hi('@type.builtin',            { fg = c.purple,   italic = true })
hi('@type.definition',         { fg = c.purple,   bold = true })
hi('@variable',                { fg = c.bone })
hi('@variable.builtin',        { fg = c.blue,     italic = true })
hi('@variable.parameter',      { fg = c.bone_hi })
hi('@constant',                { link = 'Constant' })
hi('@constant.builtin',        { fg = c.blue })
hi('@constant.macro',          { fg = c.orange })
hi('@operator',                { fg = c.bone_hi })
hi('@punctuation',             { fg = c.dim })
hi('@punctuation.bracket',     { fg = c.dim })
hi('@punctuation.delimiter',   { fg = c.dim })
hi('@tag',                     { fg = c.green,    bold = true })
hi('@tag.attribute',           { fg = c.teal })
hi('@tag.delimiter',           { fg = c.dim })
hi('@namespace',               { fg = c.blue })
hi('@markup.heading',          { fg = c.green,    bold = true })
hi('@markup.heading.1',        { fg = c.green,    bold = true })
hi('@markup.heading.2',        { fg = c.green,    bold = true })
hi('@markup.heading.3',        { fg = c.green,    bold = true })
hi('@markup.bold',             { fg = c.blue,     bold = true })
hi('@markup.italic',           { fg = c.purple,   italic = true })
hi('@markup.link',             { fg = c.teal,     underline = true })
hi('@markup.link.url',         { fg = c.teal,     underline = true })
hi('@markup.link.label',       { fg = c.blue })
hi('@markup.raw',              { fg = c.lime })
hi('@markup.raw.block',        { fg = c.lime })
hi('@markup.list',             { fg = c.green })
hi('@markup.list.checked',     { fg = c.teal })
hi('@markup.list.unchecked',   { fg = c.dim })
hi('@diff.plus',               { fg = c.green })
hi('@diff.minus',              { fg = c.red })
hi('@diff.delta',              { fg = c.orange })
hi('@property',                { fg = c.teal })
hi('@label',                   { fg = c.bone })
hi('@punctuation.special',     { fg = c.orange })

-- Flash
hi('FlashBackdrop',  { fg = c.dim })
hi('FlashMatch',     { fg = c.teal,   bold = true })
hi('FlashCurrent',   { fg = c.lime,   bold = true })
hi('FlashLabel',     { fg = c.bg,     bg = c.lime,  bold = true })
hi('FlashPrompt',    { fg = c.bone,   bg = c.bg_dim })

-- Indent Blankline
hi('IblIndent',      { fg = c.bg_sel })
hi('IblScope',       { fg = c.dim })

-- JSON overrides: keys teal (via @property), values bone (strings dominate, orange is too much)
hi('@string.json',             { fg = c.bone })

-- Haskell / Tidal overrides
hi('@keyword.haskell',         { fg = c.orange })
hi('@operator.haskell',        { fg = c.blue })
hi('@string.haskell',          { fg = c.green })
hi('@number.haskell',          { fg = c.lime })
hi('@variable.haskell',        { fg = c.purple })
hi('@function.call.haskell',   { fg = c.bone })
hi('@function.haskell',        { fg = c.bone })

-- UI chrome
hi('LineNr',         { fg = c.dim })
hi('CursorLine',     { bg = c.bg_hl })
hi('CursorLineNr',   { fg = c.bone_hi, bg = c.bg_hl, bold = true })
hi('SignColumn',     { fg = c.dim,     bg = c.bg })
hi('ColorColumn',    { bg = c.bg_hl })
hi('Visual',         { bg = c.bg_sel })
hi('VisualNOS',      { bg = c.bg_sel })
hi('Search',         { fg = c.bg,      bg = c.teal })
hi('IncSearch',      { fg = c.bg,      bg = c.orange })
hi('CurSearch',      { fg = c.bg,      bg = c.orange })
hi('MatchParen',     { fg = c.white,   bg = c.bg_sel, bold = true })
hi('Folded',         { fg = c.dim,     bg = c.bg_dim })
hi('FoldColumn',     { fg = c.dim,     bg = c.bg })
hi('NonText',        { fg = c.dim })
hi('EndOfBuffer',    { fg = c.bg })
hi('Whitespace',     { fg = c.bg_sel })
hi('VertSplit',      { fg = c.bg_sel })
hi('WinSeparator',   { fg = c.bg_sel })
hi('Title',          { fg = c.bone_hi, bold = true })
hi('FloatBorder',    { fg = c.dim,     bg = c.bg_dim })
hi('FloatTitle',     { fg = c.orange,  bg = c.bg_dim, bold = true })

-- Statusline
hi('StatusLine',     { fg = c.bone,  bg = c.bg_dim })
hi('StatusLineNC',   { fg = c.dim,   bg = c.bg_dim })

-- Tabline
hi('TabLine',        { fg = c.dim,   bg = c.bg_dim })
hi('TabLineSel',     { fg = c.bone,  bg = c.bg,     bold = true })
hi('TabLineFill',    { bg = c.bg_dim })

-- Popup / completion menu
hi('Pmenu',          { fg = c.bone,   bg = c.bg_dim })
hi('PmenuSel',       { fg = c.bg,     bg = c.green })
hi('PmenuSbar',      { bg = c.bg_sel })
hi('PmenuThumb',     { bg = c.dim })

-- Diagnostics
hi('DiagnosticError',          { fg = c.red })
hi('DiagnosticWarn',           { fg = c.orange })
hi('DiagnosticInfo',           { fg = c.teal })
hi('DiagnosticHint',           { fg = c.blue })
hi('DiagnosticUnderlineError', { underline = true, sp = c.red })
hi('DiagnosticUnderlineWarn',  { underline = true, sp = c.orange })

-- Git signs
hi('GitSignsAdd',    { fg = c.green })
hi('GitSignsChange', { fg = c.blue })
hi('GitSignsDelete', { fg = c.red })

-- File tree (neo-tree)
hi('Directory',               { fg = c.green,    bold = true })
hi('NeoTreeNormal',           { fg = c.bone,     bg = c.bg_dim })
hi('NeoTreeNormalNC',         { fg = c.dim,      bg = c.bg_dim })
hi('NeoTreeRootName',         { fg = c.green,    bold = true, italic = true })
hi('NeoTreeDirectoryName',    { fg = c.bone_hi })
hi('NeoTreeDirectoryIcon',    { fg = c.green })
hi('NeoTreeFileName',         { fg = c.bone })
hi('NeoTreeFileNameOpened',   { fg = c.bone_hi,  bold = true })
hi('NeoTreeIndentMarker',     { fg = c.bg_sel })
hi('NeoTreeExpander',         { fg = c.dim })
hi('NeoTreeDimText',          { fg = c.dim })
hi('NeoTreeDotfile',          { fg = c.dim })
hi('NeoTreeModified',         { fg = c.orange })
hi('NeoTreeGitAdded',         { fg = c.green })
hi('NeoTreeGitModified',      { fg = c.blue })
hi('NeoTreeGitDeleted',       { fg = c.red })
hi('NeoTreeGitUntracked',     { fg = c.dim,      italic = true })
hi('NeoTreeGitIgnored',       { fg = c.dim })
hi('NeoTreeGitStaged',        { fg = c.teal })
hi('NeoTreeGitConflict',      { fg = c.orange,   bold = true, italic = true })
hi('NeoTreeWinSeparator',     { fg = c.bg_sel,   bg = c.bg_dim })
hi('NeoTreeEndOfBuffer',      { fg = c.bg_dim })

-- Telescope
hi('TelescopeNormal',         { fg = c.bone,     bg = c.bg_dim })
hi('TelescopeBorder',         { fg = c.dim,      bg = c.bg_dim })
hi('TelescopeTitle',          { fg = c.orange,   bold = true })
hi('TelescopeSelection',      { fg = c.bone_hi,  bg = c.bg_sel })
hi('TelescopeSelectionCaret', { fg = c.green,    bg = c.bg_sel })
hi('TelescopeMatching',       { fg = c.lime,     bold = true })
hi('TelescopePromptPrefix',   { fg = c.green })
