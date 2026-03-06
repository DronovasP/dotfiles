vim.pack.add({
    "https://github.com/Mofiqul/adwaita.nvim",
})

vim.g.adwaita_darker = false
vim.g.adwaita_disable_cursorline = true
vim.g.adwaita_transparent = false

vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        vim.cmd("colorscheme adwaita")
    end,
})