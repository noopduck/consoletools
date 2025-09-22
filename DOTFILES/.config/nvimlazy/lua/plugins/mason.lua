return {
  "mason-org/mason-lspconfig.nvim",
  dependencies = { "mason-org/mason.nvim" },
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
