return {
  -- change some telescope options and a keymap to browse plugin files
  {
    "nvim-mini/mini.comment",
    opts = {
      mappings = {
        comment = "<leader>;",
        comment_line = "<leader>;;",
        comment_visual = "<leader>;",
        textobject = "<leader>;",
      },
    },
  },
  {
    "nvim-mini/mini.pairs",
    enabled = false,
  },
  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        { "z=", icon = "ABC " },
      },
    },
  },
}
