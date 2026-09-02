return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-mini/mini.icons",
    },
    opts = {
      code = {
        conceal_delimiters = false,
        language = false,
        border = "none",
      },
      latex = {
        enabled = true,
        converter = { "latex2text" },
        inline = true,
        block = true,
      },
      link = {
        custom = {
          hackernews = { icon = "HN " },
          microsoft = { icon = "MS " },
          neovim = { icon = "NV " },
          x = { icon = "X " },
        },
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "latex" } },
  },
}
