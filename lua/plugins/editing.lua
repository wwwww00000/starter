return {
  -- change some telescope options and a keymap to browse plugin files
  {
    "echasnovski/mini.comment",
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
    "echasnovski/mini.pairs",
    enabled = false,
  },
}
