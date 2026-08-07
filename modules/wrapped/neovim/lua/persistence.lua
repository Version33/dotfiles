require("persistence").setup({
	dir = vim.fn.stdpath("state") .. "/sessions/",
	pre_save = nil,
	save_empty = false,
})
