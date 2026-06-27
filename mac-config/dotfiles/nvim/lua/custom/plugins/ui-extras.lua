-- ── Indent Blankline ───────────────────────────────────────────────────
vim.pack.add { 'https://github.com/lukas-reineke/indent-blankline.nvim' }
require('ibl').setup {
  indent = { char = '│', highlight = 'IblIndent' },
  scope  = { char = '│', highlight = 'IblScope', enabled = true },
}

-- ── Trouble ────────────────────────────────────────────────────────────
vim.pack.add { 'https://github.com/folke/trouble.nvim' }
require('trouble').setup {}

vim.keymap.set('n', '<leader>xx', '<cmd>Trouble diagnostics toggle<cr>',              { desc = 'Trouble: workspace diagnostics' })
vim.keymap.set('n', '<leader>xb', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>', { desc = 'Trouble: buffer diagnostics' })
vim.keymap.set('n', '<leader>xq', '<cmd>Trouble qflist toggle<cr>',                   { desc = 'Trouble: quickfix' })
vim.keymap.set('n', '<leader>xl', '<cmd>Trouble loclist toggle<cr>',                  { desc = 'Trouble: loclist' })
vim.keymap.set('n', 'gR',         '<cmd>Trouble lsp_references toggle<cr>',           { desc = 'Trouble: LSP references' })

-- ── Diffview ───────────────────────────────────────────────────────────
vim.pack.add { 'https://github.com/sindrets/diffview.nvim' }
require('diffview').setup {}

vim.keymap.set('n', '<leader>gd', '<cmd>DiffviewOpen<cr>',            { desc = 'Diffview: open' })
vim.keymap.set('n', '<leader>gh', '<cmd>DiffviewFileHistory %<cr>',   { desc = 'Diffview: file history' })
vim.keymap.set('n', '<leader>gH', '<cmd>DiffviewFileHistory<cr>',     { desc = 'Diffview: repo history' })
vim.keymap.set('n', '<leader>gc', '<cmd>DiffviewClose<cr>',           { desc = 'Diffview: close' })
