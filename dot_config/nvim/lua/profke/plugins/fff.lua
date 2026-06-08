vim.pack.add({ "https://github.com/dmtrKovalenko/fff.nvim" }, { load = true })

vim.api.nvim_create_autocmd("PackChanged", {
    callback = function(ev)
        local name, kind = ev.data.spec.name, ev.data.kind
        if name == "fff.nvim" and (kind == "install" or kind == "update") then
            if not ev.data.active then
                vim.cmd.packadd("fff.nvim")
            end
            require("fff.download").download_or_build_binary()
        end
    end,
})

vim.g.fff = {
    lazy_sync = true,
}

vim.keymap.set("n", "<leader>ff", function()
    require("fff").find_files()
end, { desc = "[F]ind [F]iles" })

vim.keymap.set("n", "<leader>fg", function()
    require("fff").live_grep()
end, { desc = "[F]ind [G]rep" })

vim.keymap.set("n", "<leader>fw", function()
    require("fff").live_grep({ query = vim.fn.expand("<cword>") })
end, { desc = "[F]ind [W]ord" })

vim.keymap.set("n", "<leader>/", function()
    require("fff").live_grep({ grep = { modes = { "fuzzy", "plain" } } })
end, { desc = "Fuzzy grep" })
