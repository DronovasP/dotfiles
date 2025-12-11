return {
  'nvim-telescope/telescope.nvim',
  branch = false,
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope-ui-select.nvim',
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
  },
  
  -- This is the config function
  config = function()
    local telescope = require('telescope')
    local builtin = require('telescope.builtin')
    local sorters = require('telescope.sorters')

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
          "--hidden", -- Search hidden files
          "--glob=!.git/", -- Still ignore .git directory
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
          case_mode = 'smart_case',
        },
        ['ui-select'] = {
          require('telescope.themes').get_dropdown(),
        },
      },
    })

    pcall(telescope.load_extension, 'fzf')
    pcall(telescope.load_extension, 'ui-select')
    
    vim.keymap.set('n', '<leader>f', builtin.find_files, { desc = '[F]ind Files' })
    vim.keymap.set('n', '<leader>g', builtin.live_grep, { desc = '[G]rep Text' })
    vim.keymap.set('n', '<leader>k', builtin.keymaps, { desc = '[K]eymaps' })
    vim.keymap.set('n', '<leader>b', builtin.buffers, { desc = '[B]uffer List' })
    vim.keymap.set('n', '<leader>h', builtin.help_tags, { desc = '[H]elp Tags' })
    vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
  end,
}
