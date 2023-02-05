local M = {}

M.telescope = {
  n = {
    ["<leader>p"] = { "<cmd> Telescope find_files<CR>", "file finder" },
    ["<leader>e"] = { "<cmd> Telescope live_grep<CR>", "telescope live grep" },
  },
}

return M
