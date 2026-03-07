vim.pack.add({
    "https://github.com/Mofiqul/adwaita.nvim",
}, { load = true })

vim.g.adwaita_darker = false
vim.g.adwaita_disable_cursorline = true
vim.g.adwaita_transparent = false
vim.cmd("colorscheme adwaita")