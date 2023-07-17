return {
  {
    "simrat39/rust-tools.nvim",
    event = "BufEnter *.rs",
    dependencies = { "mason-lspconfig.nvim", "lvimuser/lsp-inlayhints.nvim" },
    opts = {},
  },
  { "Saecki/crates.nvim", tag = "v0.3.0", dependencies = { "nvim-lua/plenary.nvim" }, opts = {} },
}
