vim.pack.add {
  'https://github.com/MunifTanjim/nui.nvim',
  'https://github.com/folke/noice.nvim',
}

require('noice').setup {
  cmdline = {
    view = 'cmdline_popup',
    format = {
      cmdline       = { icon = '>' },
      search_down   = { icon = '/' },
      search_up     = { icon = '?' },
      filter        = { icon = '$' },
      lua           = { icon = 'lua' },
      help          = { icon = '?' },
    },
  },
  messages = { enabled = true },
  lsp = {
    -- fidget.nvim handles LSP progress, let it
    progress = { enabled = false },
    override = {
      ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
      ['vim.lsp.util.stylize_markdown'] = true,
    },
  },
  presets = {
    command_palette    = true,   -- float centered, search-style
    long_message_to_split = true,
    lsp_doc_border     = true,
  },
}

-- Verdigris highlight overrides for noice popup
vim.api.nvim_create_autocmd('ColorScheme', {
  pattern = 'verdigris',
  callback = function()
    vim.api.nvim_set_hl(0, 'NoiceCmdlinePopup',       { bg = '#111110', fg = '#D0CAB8' })
    vim.api.nvim_set_hl(0, 'NoiceCmdlinePopupBorder', { fg = '#524e48', bg = '#111110' })
    vim.api.nvim_set_hl(0, 'NoiceCmdlineIcon',        { fg = '#44BB44' })
    vim.api.nvim_set_hl(0, 'NoiceConfirm',            { bg = '#111110', fg = '#D0CAB8' })
    vim.api.nvim_set_hl(0, 'NoiceConfirmBorder',      { fg = '#524e48', bg = '#111110' })
  end,
})
vim.cmd.colorscheme 'verdigris'
