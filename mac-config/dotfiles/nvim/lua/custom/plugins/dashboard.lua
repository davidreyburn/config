-- mini.starter is bundled with mini.nvim (already installed)
local starter = require 'mini.starter'

starter.setup {
  evaluate_single = true,
  header = table.concat({
    '                    ',
    '  ░░░░░░░░░░░░░░░░  ',
    '  ░░  verdigris  ░░  ',
    '  ░░░░░░░░░░░░░░░░  ',
    '                    ',
  }, '\n'),
  items = {
    starter.sections.recent_files(7, false),
    starter.sections.recent_files(5, true),
    {
      { name = 'New buffer',  action = 'enew',           section = 'Quick' },
      { name = 'Find file',   action = 'Telescope find_files', section = 'Quick' },
      { name = 'Grep',        action = 'Telescope live_grep',  section = 'Quick' },
      { name = 'Quit',        action = 'qa',             section = 'Quick' },
    },
  },
  content_hooks = {
    starter.gen_hook.adding_bullet('  '),
    starter.gen_hook.aligning('center', 'center'),
  },
  footer = '',
}

-- When nvim is opened with a directory argument, root neo-tree there and show starter
vim.api.nvim_create_autocmd('VimEnter', {
  callback = function(data)
    if vim.fn.isdirectory(data.file) ~= 1 then return end
    vim.cmd.cd(data.file)
    local main_win = vim.api.nvim_get_current_win()
    require('neo-tree.command').execute { action = 'show', dir = data.file }
    vim.api.nvim_set_current_win(main_win)
    require('mini.starter').open()
  end,
})

-- Verdigris highlight overrides for starter
vim.api.nvim_create_autocmd('User', {
  pattern = 'MiniStarterOpened',
  callback = function()
    vim.api.nvim_set_hl(0, 'MiniStarterHeader',     { fg = '#4AACA4' })
    vim.api.nvim_set_hl(0, 'MiniStarterSection',    { fg = '#44BB44', bold = true })
    vim.api.nvim_set_hl(0, 'MiniStarterItem',       { fg = '#D0CAB8' })
    vim.api.nvim_set_hl(0, 'MiniStarterItemBullet', { fg = '#524e48' })
    vim.api.nvim_set_hl(0, 'MiniStarterCurrent',    { fg = '#AAFF00', bold = true })
    vim.api.nvim_set_hl(0, 'MiniStarterQuery',      { fg = '#AAFF00' })
    vim.api.nvim_set_hl(0, 'MiniStarterFooter',     { fg = '#524e48' })
  end,
})
