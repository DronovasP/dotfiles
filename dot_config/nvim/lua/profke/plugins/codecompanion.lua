vim.pack.add({
    "https://github.com/olimorris/codecompanion.nvim",
    "https://github.com/nvim-lua/plenary.nvim",
    "https://github.com/nvim-treesitter/nvim-treesitter",
}, { load = true })

require("codecompanion").setup({
    adapters = {
        http = {
            openrouter = function()
                return require("codecompanion.adapters").extend("openai_compatible", {
                    env = {
                        api_key = "OPENROUTER_API_KEY",
                    },
                    url = "https://openrouter.ai/api/v1/chat/completions",
                    schema = {
                        model = {
                            default = "qwen/qwen3-32b:nitro",
                        },
                    },
                })
            end,
        },
    },
    interactions = {
        chat = {
            adapter = "openrouter",
        },
        inline = {
            adapter = "openrouter",
        },
    },
})

vim.keymap.set("n", "<leader>cc", "<cmd>CodeCompanionChat Toggle<cr>", { desc = "[C]ode[C]ompanion Chat" })
vim.keymap.set("n", "<leader>ci", "<cmd>CodeCompanion<cr>", { desc = "[C]odeCompanion [I]nline" })
vim.keymap.set("v", "<leader>ce", "<cmd>CodeCompanion /explain<cr>", { desc = "[C]odeCompanion [E]xplain" })
