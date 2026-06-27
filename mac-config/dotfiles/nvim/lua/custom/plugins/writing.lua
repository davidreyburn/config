-- markview: visual rendering of markdown in-buffer
vim.pack.add { 'https://github.com/OXY2DEV/markview.nvim' }
require('markview').setup {
  markdown = {
    tables = {
      enable = true,
      parts = {
        top        = { "┌", "─", "┐", "┬" },
        header     = { "│", "│", "│" },
        separator  = { "├", "─", "┤", "┼" },
        row        = { "│", "│", "│" },
        bottom     = { "└", "─", "┘", "┴" },
        overlap    = { "┝", "━", "┥", "┿" },
        align_left   = "╼",
        align_right  = "╾",
        align_center = { "╴", "╶" },
      },
    },
  },
}

-- ── Zen Mode + Twilight ────────────────────────────────────────────────
vim.pack.add {
  'https://github.com/folke/zen-mode.nvim',
  'https://github.com/folke/twilight.nvim',
}
require('zen-mode').setup {
  window = {
    width   = 82,
    options = { number = false, relativenumber = false, signcolumn = 'no' },
  },
  plugins = { twilight = { enabled = true } },
}
require('twilight').setup {
  dimming = { alpha = 0.25, color = { 'Normal', '#524e48' } },
  context = 10,
}
vim.keymap.set('n', '<leader>z', '<cmd>ZenMode<cr>', { desc = 'Zen mode' })

-- ── Obsidian ───────────────────────────────────────────────────────────
vim.pack.add { 'https://github.com/epwalsh/obsidian.nvim' }
require('obsidian').setup {
  workspaces = { { name = 'knowledge', path = '~/knowledge' } },
  completion = { nvim_cmp = false, min_chars = 2 },
  ui         = { enable = false },  -- markview handles rendering
  follow_url_func = function(url) vim.fn.jobstart { 'open', url } end,
  note_id_func = function(title)
    return title and title:gsub(' ', '-'):gsub('[^A-Za-z0-9-]', ''):lower()
        or tostring(os.time())
  end,
}

vim.keymap.set('n', '<leader>on', '<cmd>ObsidianNew<cr>',          { desc = 'Obsidian: new note' })
vim.keymap.set('n', '<leader>of', '<cmd>ObsidianQuickSwitch<cr>',  { desc = 'Obsidian: find note' })
vim.keymap.set('n', '<leader>og', '<cmd>ObsidianSearch<cr>',       { desc = 'Obsidian: grep notes' })
vim.keymap.set('n', '<leader>ob', '<cmd>ObsidianBacklinks<cr>',    { desc = 'Obsidian: backlinks' })
vim.keymap.set('n', '<leader>ol', '<cmd>ObsidianLinks<cr>',        { desc = 'Obsidian: links' })
vim.keymap.set('n', '<leader>ot', '<cmd>ObsidianToday<cr>',        { desc = 'Obsidian: today' })

-- ── Prose FileType settings ────────────────────────────────────────────
-- spellcheck, soft wrap, and line width for prose filetypes
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'markdown', 'text' },
  callback = function()
    vim.opt_local.spell = false
    vim.opt_local.spelllang = 'en_gb'
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
    vim.opt_local.breakindent = true
    -- navigate wrapped lines naturally
    vim.keymap.set('n', 'j', 'gj', { buffer = true, silent = true })
    vim.keymap.set('n', 'k', 'gk', { buffer = true, silent = true })
  end,
})
