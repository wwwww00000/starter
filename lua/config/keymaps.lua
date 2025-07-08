-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- map escape
vim.keymap.set("i", "jk", "<Esc>", {})
vim.keymap.set("i", "jK", "<Esc>", {})
vim.keymap.set("i", "Jk", "<Esc>", {})
vim.keymap.set("i", "JK", "<Esc>", {})

-- buffers
vim.keymap.set("n", "<leader>bn", ":bn<cr>", {})
vim.keymap.set("n", "<leader>bp", ":bp<cr>", {})
vim.keymap.set("n", "<leader>bd", ":bp<bar>bd#<cr>", {})
vim.keymap.set("n", "<leader>b1", ":b1<cr>", {})
vim.keymap.set("n", "<leader>b2", ":b2<cr>", {})
vim.keymap.set("n", "<leader>b3", ":b3<cr>", {})
vim.keymap.set("n", "<leader>b4", ":b4<cr>", {})
vim.keymap.set("n", "<leader>b5", ":b5<cr>", {})
vim.keymap.set("n", "<leader>b6", ":b6<cr>", {})
vim.keymap.set("n", "<leader>b7", ":b7<cr>", {})
vim.keymap.set("n", "<leader>b8", ":b8<cr>", {})
vim.keymap.set("n", "<leader>b9", ":b9<cr>", {})
vim.keymap.del("n", "<S-h>") -- Prev buffer
vim.keymap.del("n", "<S-l>") -- Next buffer
vim.keymap.del("n", "[b") -- Prev buffer
vim.keymap.del("n", "]b") -- Next buffer

-- windows
vim.keymap.set("n", "<leader>wh", ":wincmd h<cr>", {})
vim.keymap.set("n", "<leader>wj", ":wincmd j<cr>", {})
vim.keymap.set("n", "<leader>wk", ":wincmd k<cr>", {})
vim.keymap.set("n", "<leader>wl", ":wincmd l<cr>", {})
vim.keymap.set("n", "<leader>wd", ":wincmd q<cr>", {})
vim.keymap.set("n", "<leader>w=", ":wincmd =<cr>", {})
vim.keymap.set("n", "<leader>w/", ":vsplit<cr>", {})
vim.keymap.set("n", "<leader>w-", ":split<cr>", {})
vim.keymap.del("n", "<leader>w|") -- Split window right
vim.keymap.del("n", "<leader>-") -- Split window below
vim.keymap.del("n", "<leader>|") --Split window right

-- very annoying since they can be trigger with esc-
vim.keymap.del("n", "<A-j>") -- Move down
vim.keymap.del("n", "<A-k>") -- Move up
vim.keymap.del("i", "<A-j>") -- Move down
vim.keymap.del("i", "<A-k>") -- Move up
vim.keymap.del("v", "<A-j>") -- Move down
vim.keymap.del("v", "<A-k>") -- Move up

vim.keymap.set("n", "<leader>fm", ":set foldmethod=marker<cr>", {})
