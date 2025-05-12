require("config.lazy")
require("lualine")
require("config.bubbles")
require("config.telescope")
require("maps")
require("settings")
require("options")

require("nvim-treesitter.configs").setup({ highlight = { enable = true } })
