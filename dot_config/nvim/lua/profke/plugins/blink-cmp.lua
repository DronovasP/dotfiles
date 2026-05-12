vim.pack.add({
    "https://github.com/Saghen/blink.cmp",
}, { load = true })

require("blink.cmp").setup({
    keymap = {
        preset = "default",
        ["<Tab>"] = { "snippet_forward", "select_next", "fallback" },
        ["<S-Tab>"] = { "snippet_backward", "select_prev", "fallback" },
        ["<CR>"] = { "accept", "fallback" },
    },
    appearance = {
        nerd_font_variant = "mono",
    },
    sources = {
        default = { "lsp", "path", "snippets", "buffer" },
    },
    fuzzy = {
        implementation = "lua",
    },
    completion = {
        trigger = {
            prefetch_on_insert = true,
        },
        documentation = {
            auto_show = true,
            auto_show_delay_ms = 200,
        },
        ghost_text = {
            enabled = true,
        },
        list = {
            selection = {
                preselect = true,
                auto_insert = false,
            },
        },
    },
    signature = {
        enabled = true,
    },
})
