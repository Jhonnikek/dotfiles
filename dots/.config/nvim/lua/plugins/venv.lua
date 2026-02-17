return {
  "linux-cultist/venv-selector.nvim",
  dependencies = {
    { "nvim-telescope/telescope.nvim", version = "*", dependencies = { "nvim-lua/plenary.nvim" } }, -- optional: you can also use fzf-lua, snacks, mini-pick instead.
  },
  ft = "python",
  keys = {
    { ",v", "<cmd>VenvSelect<cr>" },
  },
  opts = {
    search = {},
    options = {},
  },
}
