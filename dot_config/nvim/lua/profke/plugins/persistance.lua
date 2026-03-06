vim.pack.add({
    "https://github.com/folke/persistence.nvim",
}, { load = true })

vim.api.nvim_create_autocmd("BufReadPre", {
    once = true,
    callback = function()
        require("persistence")
    end,
})

vim.keymap.set("n", "<leader>qs", function() require("persistence").load() end, { desc = "[Q]uick [S]ession load" })
vim.keymap.set("n", "<leader>ql", function() require("persistence").load({ last = true }) end, { desc = "[Q]uick [L]ast session" })
vim.keymap.set("n", "<leader>qd", function() require("persistence").stop() end, { desc = "[Q]uick [D]on't save session" })