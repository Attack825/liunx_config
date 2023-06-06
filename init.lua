local set = vim.o
set.number = true 
set.relativenumber = true
set.clipboard = "unnamed"


-- 在copy后高亮
vim.api.nvim_create_autocmd({"TextYankPost"},{
        pattern = {"*"},
	callback = function()
		vim.hightlight.on_yank({
			timeout = 300,
		})
	end,
})



