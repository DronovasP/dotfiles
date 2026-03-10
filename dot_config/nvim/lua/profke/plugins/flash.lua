vim.pack.add({
	"https://github.com/folke/flash.nvim",
})

vim.cmd.packadd("flash.nvim")

local flash = require("flash")

flash.setup({
	modes = {
		search = {
			enabled = true,
		},
		char = {
			enabled = false,
		},
	},
})

-- Jump to any visible text
vim.keymap.set({ "n", "x", "o" }, "s", function()
	flash.jump()
end, { desc = "Flash" })

-- Treesitter selection (Helix-like)
vim.keymap.set({ "n", "x", "o" }, "S", function()
	flash.treesitter()
end, { desc = "Flash Treesitter" })

-- Treesitter search and select
vim.keymap.set({ "o" }, "r", function()
	flash.remote()
end, { desc = "Remote Flash" })

-- Treesitter node expansion (Helix-like 'v' in selection mode)
vim.keymap.set({ "x", "o" }, "v", function()
	flash.treesitter({
		label = {
			rainbow = { enabled = true },
		},
	})
end, { desc = "Expand Treesitter Selection" })

-- Continue last search with labels
vim.keymap.set({ "n", "x", "o" }, "<leader>j", function()
	flash.jump({ continue = true })
end, { desc = "Continue Flash Search" })
