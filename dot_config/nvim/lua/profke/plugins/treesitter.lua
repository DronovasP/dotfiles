vim.pack.add({
    "https://github.com/nvim-treesitter/nvim-treesitter",
}, { load = true })

vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        require("nvim-treesitter.config").setup({
            ensure_installed = {
                "bash",
                "c",
                "diff",
                "html",
                "lua",
                "luadoc",
                "markdown",
                "markdown_inline",
                "zig",
                "vim",
                "vimdoc",
            },
            auto_install = true,
            highlight = {
                enable = true,
                additional_vim_regex_highlighting = { "ruby" },
            },
            indent = { enable = true, disable = { "ruby", "typescript", "javascript", "tsx" } },
        })
    end,
})