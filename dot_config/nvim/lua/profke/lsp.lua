return {
  'neovim/nvim-lspconfig',
  config = function()
    -- Your original lsp.lua content
    vim.opt.completeopt = { "menuone", "noselect", "popup" }

    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('my.lsp', {}),
      callback = function(args)
        local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
        -- ... your formatting logic from lsp.lua ...
      end,
    })

    vim.diagnostic.config({
      virtual_lines = true,
      underline = true,
      update_in_insert = false,
      -- ... your other diagnostic settings ...
    })

    -- === THE MISSING PIECE ===
    -- You were never setting up your servers.

    local lspconfig = require('lspconfig')

    -- Setup for ts_ls
    lspconfig.ts_ls.setup({})

    -- Setup for lua_ls
    lspconfig.lua_ls.setup({
      -- Your config from the previous message
      cmd = { 'lua-language-server' },
      filetypes = { 'lua' },
      root_markers = { '.luarc.json', '.git' },
      settings = {
        Lua = {
          runtime = { version = 'LuaJIT' },
          diagnostics = { globals = { 'vim' } },
          workspace = {
            library = vim.api.nvim_get_runtime_file("", true),
            checkThirdParty = false,
          },
        },
      },
    })
  end,
}
