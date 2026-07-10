-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.g.maplocalleader = " " -- is "\\" by default

local hostname = (vim.uv or vim.loop).os_gethostname()
if hostname:match("^agent%-vps") then
  vim.g.python3_host_prog = vim.fn.exepath("python3")
else
  vim.g.python3_host_prog = vim.env.HOME .. "/.asdf/shims/python"
end

local opt = vim.opt

opt.formatoptions = "jcrqlnt" -- tcqj -- wenbin removed o
opt.ignorecase = false
opt.conceallevel = 0

vim.g.snacks_animate = false

require("config.wezterm_image").setup()
