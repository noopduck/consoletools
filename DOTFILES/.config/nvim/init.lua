vim.g.mapleader = ' '

-- Disable optional providers that aren't used
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_python3_provider = 0
vim.o.number = true
vim.o.relativenumber = true
vim.o.signcolumn = 'yes:1'
vim.o.cursorline = true
vim.o.smartindent = true
vim.o.autoindent = true
vim.o.expandtab = true
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.softtabstop = 2

vim.pack.add {
  { src = 'https://github.com/mason-org/mason.nvim', name = 'mason.nvim' },
  { src = 'https://github.com/neovim/nvim-lspconfig', name = 'nvim-lspconfig' },
  { src = 'https://github.com/catppuccin/nvim', name = 'catppuccin' },
  { src = 'https://github.com/creativenull/efmls-configs-nvim', name = 'efmls-configs-nvim' },
  { src = 'https://github.com/preservim/nerdtree', name = 'nerdtree' },
  { src = 'https://github.com/nvim-lualine/lualine.nvim', name = 'lualine.nvim' },
}

vim.cmd.packadd 'mason.nvim'
vim.cmd.packadd 'nvim-lspconfig'
vim.cmd.packadd 'catppuccin'
vim.cmd.packadd 'efmls-configs-nvim'
vim.cmd.packadd 'nerdtree'
vim.cmd.packadd 'lualine.nvim'

require("catppuccin").setup({
  flavor = "mocha",
})
vim.cmd.colorscheme('catppuccin')

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then return end

    if client:supports_method('textDocument/completion') then
      vim.o.completeopt = 'menu,menuone,popup,noinsert'
      vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
    end

    local map = function(keys, fn, desc)
      vim.keymap.set('n', keys, fn, { buffer = args.buf, desc = desc })
    end

    map('gd',         vim.lsp.buf.definition,      'Go to definition')
    map('gD',         vim.lsp.buf.declaration,     'Go to declaration')
    map('gr',         vim.lsp.buf.references,      'References')
    map('gi',         vim.lsp.buf.implementation,  'Go to implementation')
    map('K',          vim.lsp.buf.hover,            'Hover docs')
    map('<leader>rn', vim.lsp.buf.rename,           'Rename')
    map('<leader>ca', vim.lsp.buf.code_action,      'Code action')
    map('<leader>d',  vim.diagnostic.open_float,    'Diagnostic float')
    map('[d',         vim.diagnostic.goto_prev,     'Prev diagnostic')
    map(']d',         vim.diagnostic.goto_next,     'Next diagnostic')
  end,
})

vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function() vim.highlight.on_yank() end,
})

-- NERDTree
vim.keymap.set('n', '<leader>e', ':NERDTreeToggle<CR>', { silent = true, desc = 'Toggle NERDTree' })
vim.keymap.set('n', '<leader>f', ':NERDTreeFind<CR>',   { silent = true, desc = 'Find file in NERDTree' })

require("mason").setup({
  ensure_installed = {
    'lua-language-server',
    'prettier',
    'stylua',
    'pyright',
    'gopls',
    'bash-language-server',
    'json-lsp',
    'yaml-language-server',
    'efm',
  },
})

vim.lsp.enable({
  'lua_ls',
  'pyright',
  'gopls',
  'bashls',
  'jsonls',
  'yamlls',
  'efm',
})

vim.lsp.config('lua_ls', {
  settings = {
    Lua = {
      diagnostics = { globals = { 'vim' } },
      telemetry = { enable = false },
    },
  },
})

vim.lsp.config('yamlls', {
  settings = {
    yaml = { schemaStore = { enable = true } },
  },
})

-- Register linters and formatters per language
local eslint = require('efmls-configs.linters.eslint')
local prettier = require('efmls-configs.formatters.prettier')
local stylua = require('efmls-configs.formatters.stylua')
local languages = {
  typescript = { eslint, prettier },
  lua = { stylua },
}

-- Or use the defaults provided by this plugin
-- check doc/SUPPORTED_LIST.md for the supported languages
--
-- local languages = require('efmls-configs.defaults').languages()

local efmls_config = {
  filetypes = vim.tbl_keys(languages),
  settings = {
    rootMarkers = { '.git/' },
    languages = languages,
  },
  init_options = {
    documentFormatting = true,
    documentRangeFormatting = true,
  },
}

-- If using nvim >= 0.11 then use the following
vim.lsp.config('efm', vim.tbl_extend('force', efmls_config, {
  cmd = { 'efm-langserver' },

  -- Pass your custom lsp config below like on_attach and capabilities
  --
  -- on_attach = on_attach,
  -- capabilities = capabilities,
}))

-- Format buffer
vim.keymap.set('n', '<leader>F', vim.lsp.buf.format, { desc = 'Format file' })

-- Bubbles config for lualine
-- Author: lokesh-krishna
-- MIT license, see LICENSE for more details.

-- Catppuccin Mocha palette
local m = {
  base   = '#1E1E2E',
  mantle = '#181825',
  crust  = '#11111B',
  text   = '#CDD6F4',
  subtext0 = '#A6ADC8',
  surface1 = '#313244',
  blue   = '#89B4FA',
  teal   = '#94E2D5',
  red    = '#F38BA8',
  mauve  = '#cba6f7',
}

local bubbles_theme = {
  normal = {
    a = { fg = m.base, bg = m.mauve },
    b = { fg = m.text, bg = m.surface1 },
    c = { fg = m.text },
  },

  insert = { a = { fg = m.base, bg = m.blue } },
  visual = { a = { fg = m.base, bg = m.teal } },
  replace = { a = { fg = m.base, bg = m.red } },

  inactive = {
    a = { fg = m.text, bg = m.base },
    b = { fg = m.text, bg = m.base },
    c = { fg = m.text },
  },
}

require('lualine').setup {
  options = {
    theme = bubbles_theme,
    component_separators = '',
    section_separators = { left = '', right = '' },
  },
  sections = {
    lualine_a = { { 'mode', separator = { left = '' }, right_padding = 2 } },
    lualine_b = { 'filename', 'branch' },
    lualine_c = {
      '%=', --[[ add your center components here in place of this comment ]]
    },
    lualine_x = {},
    lualine_y = { 'filetype', 'progress' },
    lualine_z = {
      { 'location', separator = { right = '' }, left_padding = 2 },
    },
  },
  inactive_sections = {
    lualine_a = { 'filename' },
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = { 'location' },
  },
  tabline = {},
  extensions = {},
}
