vim.pack.add({
    "https://github.com/mason-org/mason.nvim",
})

vim.api.nvim_create_user_command("Mason", function()
    vim.cmd.packadd("mason.nvim")
    require("mason").setup()
    vim.cmd("Mason")
end, {})
