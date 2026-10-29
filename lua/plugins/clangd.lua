-- C/C++ on top of the lang.clangd extra: clangd for LSP, clang-format for formatting.
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        clangd = {
          cmd = {
            "clangd",
            "--background-index",
            "--completion-style=detailed",
            "--header-insertion=never",
            "--pch-storage=memory",
          },
        },
      },
    },
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        c = { "clang_format" },
        cpp = { "clang_format" },
      },
    },
  },
  {
    "mason-org/mason.nvim",
    opts = { ensure_installed = { "clang-format" } },
  },
}
