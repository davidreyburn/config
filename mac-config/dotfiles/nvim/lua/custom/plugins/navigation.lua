-- ── Harpoon 2 ─────────────────────────────────────────────────────────
vim.pack.add { 'https://github.com/ThePrimeagen/harpoon' }
local harpoon = require 'harpoon'
harpoon:setup()

vim.keymap.set('n', '<leader>a',  function() harpoon:list():add() end,                          { desc = 'Harpoon add file' })
vim.keymap.set('n', '<C-e>',      function() harpoon.ui:toggle_quick_menu(harpoon:list()) end,  { desc = 'Harpoon menu' })
vim.keymap.set('n', '<leader>1',  function() harpoon:list():select(1) end,                      { desc = 'Harpoon file 1' })
vim.keymap.set('n', '<leader>2',  function() harpoon:list():select(2) end,                      { desc = 'Harpoon file 2' })
vim.keymap.set('n', '<leader>3',  function() harpoon:list():select(3) end,                      { desc = 'Harpoon file 3' })
vim.keymap.set('n', '<leader>4',  function() harpoon:list():select(4) end,                      { desc = 'Harpoon file 4' })

-- ── Flash ──────────────────────────────────────────────────────────────
-- s/S free because mini.surround was moved to gz prefix in init.lua
vim.pack.add { 'https://github.com/folke/flash.nvim' }
require('flash').setup()

vim.keymap.set({ 'n', 'x', 'o' }, 's', function() require('flash').jump() end,             { desc = 'Flash jump' })
vim.keymap.set({ 'n', 'x', 'o' }, 'S', function() require('flash').treesitter() end,       { desc = 'Flash treesitter select' })
vim.keymap.set('o',               'r', function() require('flash').remote() end,            { desc = 'Flash remote' })
vim.keymap.set({ 'o', 'x' },      'R', function() require('flash').treesitter_search() end, { desc = 'Flash treesitter search' })

-- ── Oil ────────────────────────────────────────────────────────────────
vim.pack.add { 'https://github.com/stevearc/oil.nvim' }
require('oil').setup {
  view_options = { show_hidden = true },
  float        = { padding = 2 },
}

vim.keymap.set('n', '-',         '<CMD>Oil<CR>',          { desc = 'Oil: open parent dir' })
vim.keymap.set('n', '<leader>-', '<CMD>Oil --float<CR>',  { desc = 'Oil: floating window' })
