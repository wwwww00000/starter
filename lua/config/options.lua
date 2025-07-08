-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.g.maplocalleader = " " -- is "\\" by default
vim.g.python3_host_prog = "/home/wenbin/.asdf/shims/python"

local opt = vim.opt

opt.formatoptions = "jcrqlnt" -- tcqj -- wenbin removed o
opt.ignorecase = false
