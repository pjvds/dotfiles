local M = {}

M.general = {
  n = {
    [";"] = { ":", "enter command mode", opts = { nowait = true } },
  }
}

M.telescope = {
  n = {
    ["<leader>a"] = { "<cmd> Telescope keymaps<CR>", "key mappings finder" },
    ["<leader>f"] = { "<cmd> Telescope live_grep<CR>", "search in files" },
    ["<leader>p"] = { "<cmd> Telescope find_files<CR>", "file finder" },
    ["<leader>e"] = { "<cmd> Telescope find_files<CR>", "file finder" },
    ["<leader>j"] = { function() vim.diagnostic.goto_next({severity = vim.diagnostic.severity.ERROR}) end, "goto next diagnostics error" },
  },
}

return M
