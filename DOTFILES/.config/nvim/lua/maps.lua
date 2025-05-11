vim.g.mapleader = " "

local function map(mode, lhs, rhs)
	vim.keymap.set(mode, lhs, rhs, { silent = true })
end

-- Save
map("n", "<leader>w", "<CMD>update<CR>")

-- Quit
map("n", "<leader>q", "<CMD>q<CR>")

-- Exit insert mode
map("i", "jk", "<ESC>")

-- NeoTree
map("n", "<leader>e", "<CMD>Neotree toggle<CR>")
map("n", "<leader>r", "<CMD>Neotree focus<CR>")

-- Telescope
map("n", "<leader>f", "<CMD>Telescope find_files<CR>")

-- New Windows
map("n", "<leader>o", "<CMD>vsplit<CR>")
map("n", "<leader>p", "<CMD>split<CR>")

-- Window Navigation
map("n", "<C-h>", "<C-w>h")
map("n", "<C-l>", "<C-w>l")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-j>", "<C-w>j")

-- Resize Windows
map("n", "<C-Left>", "<C-w><")
map("n", "<C-Right>", "<C-w>>")
map("n", "<C-Up>", "<C-w>+")
map("n", "<C-Down>", "<C-w>-")

--vim.keymap.set("n", "<F5>", require("dap").continue)
--vim.keymap.set("n", "<F10>", require("dap").step_over)
--vim.keymap.set("n", "<F11>", require("dap").step_into)
--vim.keymap.set("n", "<F12>", require("dap").step_out)
--vim.keymap.set("n", "<Leader>b", require("dap").toggle_breakpoint)
--vim.keymap.set("n", "<Leader>du", require("dapui").toggle)
