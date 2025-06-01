return {
  "williamboman/mason-lspconfig.nvim",
  dependencies = { "williamboman/mason.nvim" },
  opts = {
    ensure_installed = {
      "clangd",
      "bashls",
      "jsonls",
      "yamlls",
      "gopls",
      "pyright",
      "rust_analyzer",
      "cssls",
      "html",
      "dockerls",
      "ansiblels",
    },
  },
}
