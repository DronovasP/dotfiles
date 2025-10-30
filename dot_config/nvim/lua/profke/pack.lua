vim.env.NVIM_APPNAME = vim.env.NVIM_APPNAME or 'nvim'
local pack_path = vim.fs.joinpath(vim.fn.stdpath('data'), 'site')
vim.o.packpath = vim.o.packpath .. ',' .. pack_path

vim.pack.add({
  { src = 'https://github.com/neovim/nvim-lspconfig' },
  { src = 'https://github.com/hrsh7th/nvim-cmp' },
  { src = 'https://github.com/hrsh7th/cmp-nvim-lsp' }, -- For LSP completions
  { src = 'https://github.com/hrsh7th/cmp-buffer' },   -- For buffer word completions
  { src = 'https://github.com/hrsh7th/cmp-path' },
})

local cmp_ok, cmp = pcall(require, "cmp")
if not cmp_ok then
  vim.notify("nvim-cmp not found!", vim.log.levels.WARN)
  return
end

cmp.setup({
  -- Snippet functionality is fully removed per your request
  completion = {
    keyword_length = 1
  },

  -- 'luasnip' REMOVED FROM SOURCES
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'buffer' },
    { name = 'path' },
  }),

  -- MAPPINGS MODIFIED TO REMOVE LUASNIP
  mapping = cmp.mapping.preset.insert({
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),

    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      else
        fallback() -- No snippet logic
      end
    end, { 'i', 's' }),

    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      else
        fallback() -- No snippet logic
      end
    end, { 'i', 's' }),
  }),
})
