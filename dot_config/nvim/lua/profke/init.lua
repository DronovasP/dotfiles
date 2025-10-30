vim.g.mapleader = " "
vim.g.maplocalleader = ""

require("profke.opts")
require("profke.keys")
require("profke.macros")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- This tells lazy.nvim to automatically load ALL .lua files
-- from your 'lua/profke/plugins' directory as plugin specs.
require("lazy").setup("profke.plugins")
