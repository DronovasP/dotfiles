vim.pack.add({
    "https://github.com/folke/persistence.nvim",
}, { load = true })

require("persistence").setup()

vim.keymap.set("n", "<leader>qs", function() require("persistence").load() end, { desc = "[Q]uick [S]ession load" })
vim.keymap.set("n", "<leader>ql", function() require("persistence").load({ last = true }) end, { desc = "[Q]uick [L]ast session" })
vim.keymap.set("n", "<leader>qd", function() require("persistence").stop() end, { desc = "[Q]uick [D]on't save session" })
