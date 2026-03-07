vim.keymap.set("n", "<leader>gg", function()
    vim.fn.system("tmux popup -d '#{pane_current_path}' -xC -yC -w100% -h100% -E lazygit")
end, { desc = "Lazy[G]it" })
