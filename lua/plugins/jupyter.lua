return {
  {
    "jupyter-vim/jupyter-vim",
    init = function()
      vim.g.jupyter_mapkeys = 0
    end,
    lazy = false,
    keys = {
      { "<leader>jC", "<cmd>JupyterConnect<cr>", desc = "Jupyter Connect" },
      { "<leader>jd", "<cmd>JupyterDisconnect<cr>", desc = "Jupyter Disconnect" },
      { "<leader>jc", "<cmd>JupyterSendCell<cr>", desc = "Jupyter Send Cell" },
      { "<leader>jj", "<cmd>JupyterSendRange<cr>", desc = "Jupyter Send Range" },
      { "<leader>je", "<plug>JupyterRunTextObj", desc = "Jupyter Run Text Obj" },
      { "<leader>je", "<plug>JupyterRunVisual", mode = "v", desc = "Jupyter Run Text Obj" },
    },
  },
}
