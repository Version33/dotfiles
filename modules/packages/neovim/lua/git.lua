-- ── Git signs toggle ─────────────────────────────────────────────
Snacks.toggle.new({
  name = "Git Signs",
  get = function()
    local config = require("gitsigns.config").config
    return config.signcolumn ~= false
  end,
  set = function(state)
    local gs = require("gitsigns")
    if state then gs.toggle_signs(true) else gs.toggle_signs(false) end
  end,
}):map("<leader>uG")

-- ── Lazygit (only if installed) ──────────────────────────────────
if vim.fn.executable("lazygit") == 1 then
  vim.keymap.set("n", "<leader>gg", function() Snacks.lazygit() end,
    { desc = "Lazygit", silent = true })
  vim.keymap.set("n", "<leader>gG", function() Snacks.lazygit({ cwd = vim.uv.cwd() }) end,
    { desc = "Lazygit (cwd)", silent = true })
end

-- ── Git log / browse via Snacks picker ───────────────────────────
vim.keymap.set("n", "<leader>gb", function() Snacks.picker.git_log_line() end,
  { desc = "Git Blame Line", silent = true })
vim.keymap.set("n", "<leader>gf", function() Snacks.picker.git_log_file() end,
  { desc = "Git Current File History", silent = true })
vim.keymap.set("n", "<leader>gl", function() Snacks.picker.git_log() end,
  { desc = "Git Log", silent = true })
vim.keymap.set("n", "<leader>gL", function() Snacks.picker.git_log({ cwd = vim.uv.cwd() }) end,
  { desc = "Git Log (cwd)", silent = true })
vim.keymap.set({ "n", "x" }, "<leader>gB", function() Snacks.gitbrowse() end,
  { desc = "Git Browse", silent = true })
vim.keymap.set({ "n", "x" }, "<leader>gY", function() Snacks.gitbrowse({ open = false }) end,
  { desc = "Git Browse (copy URL)", silent = true })

-- ── Git diff / stash via Snacks picker ───────────────────────────
vim.keymap.set("n", "<leader>gd", function() Snacks.picker.git_diff() end,
  { desc = "Git Diff (hunks)", silent = true })
vim.keymap.set("n", "<leader>gD", function() Snacks.picker.git_diff({ remote = true }) end,
  { desc = "Git Diff (origin)", silent = true })
vim.keymap.set("n", "<leader>gS", function() Snacks.picker.git_stash() end,
  { desc = "Git Stash", silent = true })

-- ── Gitsigns first/last hunk (not available via nvf mappings) ────
vim.keymap.set("n", "]H", function() require("gitsigns").nav_hunk("last") end,
  { desc = "Last Hunk", silent = true })
vim.keymap.set("n", "[H", function() require("gitsigns").nav_hunk("first") end,
  { desc = "First Hunk", silent = true })
