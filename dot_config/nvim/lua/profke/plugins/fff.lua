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

require("fff").setup({
    prompt = "  ",
    lazy_sync = true,
    prompt_vim_mode = true,
    layout = {
        height = 0.85,
        width = 0.85,
        prompt_position = "bottom",
        preview_position = "right",
        preview_size = 0.55,
        flex = { size = 120, wrap = "top" },
        show_scrollbar = true,
        path_shorten_strategy = "middle",
        anchor = "center",
    },
    preview = {
        enabled = true,
        line_numbers = true,
        cursorlineopt = "both",
        wrap_lines = false,
        filetypes = {
            svg = { wrap_lines = true },
            markdown = { wrap_lines = true },
            text = { wrap_lines = true },
        },
    },
    git = {
        status_text_color = true,
    },
    hl = {
        normal = "Normal",
    },
    grep = {
        smart_case = true,
        trim_whitespace = true,
        modes = { "plain", "regex", "fuzzy" },
    },
})

vim.keymap.set("n", "<leader>ff", function()
    require("fff").find_files()
end, { desc = "[F]ind [F]iles" })

vim.keymap.set("n", "<leader>fg", function()
    require("fff").live_grep()
end, { desc = "[F]ind [G]rep" })

vim.keymap.set("n", "<leader>fw", function()
    require("fff").live_grep({ query = vim.fn.expand("<cword>") })
end, { desc = "[F]ind [W]ord" })

vim.keymap.set("n", "<leader>fb", function()
    local bufs = vim.tbl_filter(function(b)
        return vim.api.nvim_buf_is_valid(b) and vim.bo[b].buflisted
    end, vim.api.nvim_list_bufs())

    local items = vim.tbl_map(function(b)
        local name = vim.api.nvim_buf_get_name(b)
        local display = name ~= "" and vim.fn.fnamemodify(name, ":~:.") or "[No Name]"
        local modified = vim.bo[b].modified and " ●" or ""
        return { label = display .. modified, buf = b }
    end, bufs)

    vim.ui.select(items, {
        prompt = "  Buffers",
        format_item = function(item) return item.label end,
    }, function(item)
        if item then vim.api.nvim_set_current_buf(item.buf) end
    end)
end, { desc = "[F]ind [B]uffer" })

vim.keymap.set("n", "<leader>/", function()
    require("fff").live_grep({ grep = { modes = { "fuzzy", "plain" } } })
end, { desc = "Fuzzy grep" })
