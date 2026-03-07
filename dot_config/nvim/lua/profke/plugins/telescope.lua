vim.pack.add({
    "https://github.com/nvim-telescope/telescope.nvim",
    "https://github.com/nvim-lua/plenary.nvim",
    "https://github.com/nvim-telescope/telescope-ui-select.nvim",
    "https://github.com/nvim-telescope/telescope-fzf-native.nvim",
}, { load = true })

vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        local telescope = require("telescope")
        local builtin = require("telescope.builtin")
        local sorters = require("telescope.sorters")

        telescope.setup({
            defaults = {
                file_sorter = sorters.get_fzf_sorter,
                generic_sorter = sorters.get_fzf_sorter,
                file_ignore_patterns = { ".git/" },
                vimgrep_arguments = {
                    "rg",
                    "--color=never",
                    "--no-heading",
                    "--with-filename",
                    "--line-number",
                    "--column",
                    "--smart-case",
                    "--hidden",
                    "--glob=!.git/",
                },
            },
            pickers = {
                find_files = {
                    hidden = true,
                },
            },
            extensions = {
                fzf = {
                    fuzzy = true,
                    override_generic_sorter = true,
                    override_file_sorter = true,
                    case_mode = "smart_case",
                },
                ["ui-select"] = {
                    require("telescope.themes").get_dropdown(),
                },
            },
        })

        pcall(telescope.load_extension, "fzf")
        pcall(telescope.load_extension, "ui-select")

        vim.keymap.set("n", "<leader>/", builtin.current_buffer_fuzzy_find, { desc = "Grep current buffer" })
        vim.keymap.set("n", "<leader>f", builtin.find_files, { desc = "[F]ind Files" })
        vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch [G]rep" })
        vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
        vim.keymap.set("n", "<leader>k", builtin.keymaps, { desc = "[K]eymaps" })
        vim.keymap.set("n", "<leader>b", builtin.buffers, { desc = "[B]uffer List" })
        vim.keymap.set("n", "<leader>h", builtin.help_tags, { desc = "[H]elp Tags" })
    end,
})

vim.api.nvim_create_autocmd("PackChanged", {
    callback = function(ev)
        if ev.data.spec.name == "telescope-fzf-native.nvim" and ev.data.kind == "install" then
            vim.system({ "make" }, { cwd = ev.data.path })
        end
    end,
})