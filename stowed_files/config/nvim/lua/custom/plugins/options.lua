-- Additional options for nvim
vim.opt.shada = "'50,<1000,s100,:0"
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.numberwidth = 4

return {
  vim.keymap.set("n", "<leader>bn", ":bnext<CR>", { desc = "[B]uffer [N]ext" }),
  vim.keymap.set("n", "<leader>bp", ":bprevious<CR>", { desc = "[B]uffer [P]revious" })

}
