-- Keep Sleuth's indentation guesses from overriding these Markdown defaults.
vim.b.sleuth_heuristics = false

-- Treesitter uses the host buffer's shiftwidth for injected languages.
-- Keep fenced Python blocks consistent with regular Python buffers.
vim.opt_local.expandtab = true
vim.opt_local.shiftwidth = 4
vim.opt_local.softtabstop = 4
vim.opt_local.tabstop = 4
