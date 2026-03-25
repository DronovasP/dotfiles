vim.pack.add({
    "https://github.com/nvim-lua/plenary.nvim",
    "https://github.com/mikavilpas/yazi.nvim",
}, { load = true })

vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        require("yazi").setup({
            open_for_directories = false,
            keymaps = {
                show_help = "<f1>",
            },
        })
    end,
})

vim.keymap.set("n", "<leader>gy", function()
    require("yazi").yazi()
end, { desc = "[G]o to [Y]azi" })

vim.keymap.set("n", "<leader>gY", function()
    require("yazi").yazi(nil, vim.fn.getcwd())
end, { desc = "[G]o to [Y]azi (cwd)" })
