-- UI toggles (Snacks.toggle)
Snacks.toggle.option("spell",          { name = "Spelling" }):map("<leader>us")
Snacks.toggle.option("wrap",           { name = "Wrap" }):map("<leader>uw")
Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
Snacks.toggle.diagnostics():map("<leader>ud")
Snacks.toggle.line_number():map("<leader>ul")
Snacks.toggle.option("conceallevel", {
  off = 0,
  on  = vim.o.conceallevel > 0 and vim.o.conceallevel or 2,
  name = "Conceal Level",
}):map("<leader>uc")
Snacks.toggle.option("showtabline", {
  off = 0,
  on  = vim.o.showtabline > 0 and vim.o.showtabline or 2,
  name = "Tabline",
}):map("<leader>uA")
Snacks.toggle.treesitter():map("<leader>uT")
Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map("<leader>ub")
Snacks.toggle.dim():map("<leader>uD")
Snacks.toggle.animate():map("<leader>ua")
Snacks.toggle.indent():map("<leader>ug")
Snacks.toggle.scroll():map("<leader>uS")
Snacks.toggle.zoom():map("<leader>wm"):map("<leader>uZ")
Snacks.toggle.zen():map("<leader>uz")

-- Inlay hints toggle
if vim.lsp.inlay_hint then
  Snacks.toggle.inlay_hints():map("<leader>uh")
end

-- Lazygit (only if installed)
if vim.fn.executable("lazygit") == 1 then
  vim.keymap.set("n", "<leader>gg", function() Snacks.lazygit() end,
    { desc = "Lazygit", silent = true })
  vim.keymap.set("n", "<leader>gG", function() Snacks.lazygit({ cwd = vim.uv.cwd() }) end,
    { desc = "Lazygit (cwd)", silent = true })
end

-- Git browse / log via snacks
vim.keymap.set("n", "<leader>gb", function() Snacks.picker.git_log_line() end,
  { desc = "Git Blame Line", silent = true })
vim.keymap.set("n", "<leader>gf", function() Snacks.picker.git_log_file() end,
  { desc = "Git Current File History", silent = true })
vim.keymap.set("n", "<leader>gl", function() Snacks.picker.git_log() end,
  { desc = "Git Log", silent = true })
vim.keymap.set({ "n", "x" }, "<leader>gB", function() Snacks.gitbrowse() end,
  { desc = "Git Browse", silent = true })

-- Floating terminal
vim.keymap.set("n", "<leader>ft", function() Snacks.terminal() end,
  { desc = "Terminal (cwd)", silent = true })
vim.keymap.set({ "n", "t" }, "<c-/>", function() Snacks.terminal.toggle() end,
  { desc = "Toggle Terminal", silent = true })
vim.keymap.set({ "n", "t" }, "<c-_>", function() Snacks.terminal.toggle() end,
  { desc = "which_key_ignore", silent = true })

-- Scratch buffers
vim.keymap.set("n", "<leader>.", function() Snacks.scratch() end,
  { desc = "Toggle Scratch Buffer", silent = true })
vim.keymap.set("n", "<leader>S", function() Snacks.scratch.select() end,
  { desc = "Select Scratch Buffer", silent = true })
