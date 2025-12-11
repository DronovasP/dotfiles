return {
  "folke/persistence.nvim",
  event = "BufReadPre",
  opts = { },
  keys = {
    { "<leader>qs", function() require("persistence").load() end, desc = "[Q]uick [S]ession load" },
    { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "[Q]uick [L]ast session" },
    { "<leader>qd", function() require("persistence").stop() end, desc = "[Q]uick [D]on't save session" },
  }
}
