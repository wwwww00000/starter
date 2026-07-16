-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown", "markdown.mdx" },
  callback = function(event)
    vim.opt_local.conceallevel = 0

    -- Treesitter folding is configured after the initial fold calculation.
    -- Refresh it once all FileType callbacks have finished.
    vim.schedule(function()
      if not vim.api.nvim_buf_is_valid(event.buf) then
        return
      end

      for _, win in ipairs(vim.fn.win_findbuf(event.buf)) do
        vim.api.nvim_win_call(win, function()
          vim.cmd("normal! zx")
        end)
      end
    end)
  end,
})
