vim.pack.add { 'https://github.com/tidalcycles/vim-tidal' }

vim.g.tidal_target = 'tmux'
vim.g.tidal_boot = '/Users/dj/.config/tidal/BootTidal.hs'

-- use haskell treesitter parser for .tidal files
vim.treesitter.language.register('haskell', 'tidal')

-- Ctrl+s: silence the channel in the current block (pairs with Ctrl+e)
local function tidal_silence_block()
  local lnum = vim.fn.line('.')
  -- expand to paragraph boundaries
  local start = lnum
  while start > 1 and vim.fn.getline(start - 1) ~= '' do
    start = start - 1
  end
  local stop = lnum
  local last = vim.fn.line('$')
  while stop < last and vim.fn.getline(stop + 1) ~= '' do
    stop = stop + 1
  end
  -- find the first dN identifier in the block
  for i = start, stop do
    local ch = vim.fn.getline(i):match('^%s*(d%d+)%s')
    if ch then
      vim.fn['tidal#send'](ch .. ' silence\n')
      return
    end
  end
  vim.notify('No d1/d2/... found in paragraph', vim.log.levels.WARN)
end

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'tidal',
  callback = function()
    vim.keymap.set('n', '<C-s>', tidal_silence_block, { buffer = true, desc = 'Tidal silence block channel' })
  end,
})
