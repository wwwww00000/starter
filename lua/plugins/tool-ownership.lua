local home_manager_owns_tools = vim.fn.filereadable(vim.fn.expand("~/.config/canon/nvim-tools-home-manager")) == 1

return {
  { "mason-org/mason.nvim", enabled = not home_manager_owns_tools },
  { "mason-org/mason-lspconfig.nvim", enabled = not home_manager_owns_tools },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        lua_ls = { mason = not home_manager_owns_tools },
        pyright = { mason = not home_manager_owns_tools },
      },
    },
  },
}
