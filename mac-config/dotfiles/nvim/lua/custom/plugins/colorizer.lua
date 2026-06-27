vim.opt.termguicolors = true
vim.pack.add { 'https://github.com/catgoose/nvim-colorizer.lua' }

local function clear_inline_code_colors()
  local hl = vim.api.nvim_get_hl(0, { name = 'MarkviewInlineCode' })
  hl.bg = nil
  hl.ctermbg = nil
  hl.fg = nil
  hl.ctermfg = nil
  vim.api.nvim_set_hl(0, 'MarkviewInlineCode', hl)
end

vim.api.nvim_create_autocmd('VimEnter', {
  once = true,
  callback = function()
    vim.cmd 'packadd nvim-colorizer.lua'
    local ok, colorizer = pcall(require, 'colorizer')
    if not ok then
      vim.notify('colorizer failed to load: ' .. colorizer, vim.log.levels.ERROR)
      return
    end
    colorizer.setup {
      filetypes = { '*' },
      user_default_options = {
        RGB      = true,
        RRGGBB   = true,
        RRGGBBAA = false,
        AABBGGRR = false,
        names    = false,
        mode     = 'background',
      },
    }
    colorizer.attach_to_buffer(0)
    vim.defer_fn(clear_inline_code_colors, 100)
  end,
})

vim.api.nvim_create_autocmd('ColorScheme', {
  callback = function() vim.defer_fn(clear_inline_code_colors, 50) end,
})
