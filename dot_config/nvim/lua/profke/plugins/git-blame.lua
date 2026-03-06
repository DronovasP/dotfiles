vim.pack.add({
    "https://github.com/f-person/git-blame.nvim",
}, { load = true })

vim.api.nvim_create_autocmd("VimEnter", {
    once = true,
    callback = function()
        require("gitblame").setup({
            enabled = true,
            message_template = " <summary> • <date> • <author> • <<sha>>",
            date_format = "%m-%d-%Y %H:%M:%S",
            virtual_text_column = 1,
        })
    end,
})