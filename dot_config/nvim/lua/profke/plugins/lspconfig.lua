vim.pack.add({
    "https://github.com/neovim/nvim-lspconfig",
})

vim.cmd.packadd("nvim-lspconfig")

vim.lsp.enable("pylsp")
vim.lsp.enable("lua_ls")
vim.lsp.enable("ts_ls")
vim.lsp.enable("zls")

-- Enable auto-triggered completion on typing
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if client and client:supports_method("textDocument/completion") then
			vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
		end
	end,
})
