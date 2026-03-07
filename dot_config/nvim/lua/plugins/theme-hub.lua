return {
  {
    "erl-koenig/theme-hub.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      require("theme-hub").setup({
        install_dir = vim.fn.stdpath("data") .. "/theme-hub",
        auto_install_on_select = true,
        apply_after_install = true,
        persistent = true,
      })
    end,
  }
}
