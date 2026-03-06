vim.pack.add({
    "https://github.com/stevearc/conform.nvim",
}, { load = true })

vim.api.nvim_create_autocmd("BufReadPre", {
    once = true,
    callback = function()
        local conform = require("conform")
        conform.setup({
            formatters_by_ft = {
                javascript = { "prettier" },
                typescript = { "prettier" },
                javascriptreact = { "prettier" },
                typescriptreact = { "prettier" },
                c = { "clang-format" },
                cpp = { "clang-format" },
                zig = { "zls" },
                lua = { "stylua" },
                ["*"] = { "injected" },
            },
            format_on_save = {
                lsp_fallback = true,
                async = false,
                timeout_ms = 500,
            },
        })
    end,
})