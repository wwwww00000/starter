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

if vim.env.HERDR_ENV then
  -- Restored Herdr sessions may not inherit the outer SSH environment. Keep
  -- LazyVim from enabling unnamedplus; OSC 52 clipboard reads are unavailable.
  opt.clipboard = ""

  local osc52 = require("vim.ui.clipboard.osc52")
  local copy = osc52.copy("+")

  local function paste()
    vim.notify("Herdr clipboard reads are unavailable; use the terminal paste action instead", vim.log.levels.WARN)
    return { {}, "v" }
  end

  vim.g.clipboard = {
    name = "OSC 52",
    copy = {
      ["+"] = copy,
      ["*"] = copy,
    },
    paste = {
      ["+"] = paste,
      ["*"] = paste,
    },
  }

  -- Forward ordinary yanks while keeping puts backed by Neovim's local
  -- unnamed register.
  vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
      local event = vim.v.event
      if event.operator == "y" and event.regname ~= "+" and event.regname ~= "*" then
        local lines = vim.list_extend({}, event.regcontents)
        if event.regtype == "V" then
          lines[#lines + 1] = ""
        end
        copy(lines)
      end
    end,
  })
end

opt.formatoptions = "jcrqlnt" -- tcqj -- wenbin removed o
opt.ignorecase = false
opt.conceallevel = 0

vim.g.snacks_animate = false

require("config.wezterm_image").setup()
