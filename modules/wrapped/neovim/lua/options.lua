-- Hybrid line numbers: relative for lines 1-9 from cursor, absolute beyond
_G._hybrid_lnum = function()
  local relnum = vim.v.relnum
  local lnum   = vim.v.lnum
  local width  = math.max(3, #tostring(vim.fn.line("$")))
  local n = (relnum > 0 and relnum < 10) and relnum or lnum
  return string.format("%" .. width .. "d", n)
end
vim.o.statuscolumn = "%{v:lua._hybrid_lnum()} %s"

vim.opt.fillchars = {
  foldopen  = "▾",
  foldclose = "▸",
  fold      = " ",
  foldsep   = " ",
  diff      = "╱",
  eob       = " ",  -- removes the ~ on empty lines
}
vim.opt.shortmess:append({ W = true, I = true, c = true, C = true })
vim.opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }
