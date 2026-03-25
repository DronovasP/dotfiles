vim.pack.add({
    "https://github.com/milanglacier/minuet-ai.nvim",
    "https://github.com/nvim-lua/plenary.nvim",
}, { load = true })

require("minuet").setup({
    provider = "openai_compatible",
    n_completions = 1,
    context_window = 512,
    throttle = 1000,
    debounce = 300,
    notify = false,
    virtualtext = {
        auto_trigger_ft = {},
        keymap = {
            accept = "<D-a>",
            accept_line = "<D-l>",
            next = "<D-]>",
            prev = "<D-[>",
            dismiss = "<D-e>",
        },
    },
    provider_options = {
        -- openai_compatible = {
        --     model = "qwen/qwen3-32b:nitro",
        --     api_key = "OPENROUTER_API_KEY",
        --     end_point = "https://openrouter.ai/api/v1/chat/completions",
        --     stream = true,
        --     optional = {
        --         max_tokens = 512,
        --         top_p = 0.9,
        --         enable_thinking = true,
        --     },
        -- },
    },
})

-- Manual trigger for virtual text
vim.keymap.set("i", "<D-y>", function()
    require("minuet.virtualtext").action.next()
end, { desc = "Minuet next suggestion" })
