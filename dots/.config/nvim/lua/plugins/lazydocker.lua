return {
  "mgierada/lazydocker.nvim",
  dependencies = { "akinsho/toggleterm.nvim" },
  config = function()
    require("lazydocker").setup({
      border = "curved",
      width = 0.9,
      height = 0.9,
    })
  end,
  event = "BufRead",
  keys = {
    {
      "<leader>ld",
      function()
        require("lazydocker").open()
      end,
      desc = "Open Lazydocker floating window",
    },
  },
}
