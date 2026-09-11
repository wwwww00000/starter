return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-mini/mini.icons",
    },
    opts = {
      -- Keep editing raw, including wrapped lines, and clear previews immediately.
      render_modes = { "n" },
      debounce = 0,
      anti_conceal = {
        enabled = true,
        ignore = { virtual_lines = false },
      },
      win_options = {
        conceallevel = { default = 0, rendered = 0 },
        concealcursor = { default = "", rendered = "" },
      },
      -- Only use this plugin for math previews.
      heading = { enabled = false },
      paragraph = { enabled = false },
      code = { enabled = false },
      dash = { enabled = false },
      document = { enabled = false },
      bullet = { enabled = false },
      checkbox = { enabled = false },
      quote = { enabled = false },
      pipe_table = { enabled = false },
      link = { enabled = false },
      sign = { enabled = false },
      inline_highlight = { enabled = false },
      indent = { enabled = false },
      html = { enabled = false },
      yaml = { enabled = false },
      latex = {
        enabled = true,
        converter = { "latex2text" },
        inline = true,
        block = true,
        -- Separate preview lines do not shift the source text or cursor columns.
        position = "above",
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "latex" } },
  },
}
