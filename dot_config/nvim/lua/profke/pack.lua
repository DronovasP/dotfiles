local plugin_dir = vim.fn.stdpath("config") .. "/lua/profke/plugins"

for _, path in ipairs(vim.fn.glob(plugin_dir .. "/*.lua", false, true)) do
    local name = vim.fn.fnamemodify(path, ":t:r")
    require("profke.plugins." .. name)
end
