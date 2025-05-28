require "nvchad.options"

-- add yours here!
local o = vim.opt
-- o.cursorlineopt ='both' -- to enable cursorline!
o.relativenumber = true
o.clipboard = "unnamedplus"
o.autoindent = true
o.cursorline = true
o.expandtab = true
o.shiftwidth = 2
o.tabstop = 2
o.encoding = "UTF-8"
o.ruler = true
o.mouse = "a"
o.title = true
o.hidden = true
o.ttimeoutlen = 0
o.wildmenu = true
o.showcmd = true
o.showmatch = true
o.inccommand = "split"
o.splitright = true
o.splitbelow = true
o.termguicolors = true

o.list = true
o.listchars = { trail = "-", eol = "↲", tab = "» ", space = "·", nbsp = "+"}

vim.cmd([[
  highlight Normal guibg=none
  highlight NonText guibg=none
  highlight Normal ctermbg=none
  highlight NonText ctermbg=none
]])
