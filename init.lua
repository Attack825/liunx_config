local set = vim.o
set.number = true 
set.relativenumber = true
set.clipboard = "unnamed"


-- 在copy后高亮
vim.api.nvim_create_autocmd({"TextYankPost"},{
	pattern = {"*"},
	callback = function()
		vim.highlight.on_yank({
			timeout = 300,
		})
	end,
})



-- keybindings
local opt = {noremap = true ,silent =true }
vim.g.mapleader = " "
vim.keymap.set("n","<C-l>", "<C-w>l", opt)
vim.keymap.set("n","<C-h>", "<C-w>h", opt)
vim.keymap.set("n","<C-j>", "<C-w>j", opt)
vim.keymap.set("n","<C-k>", "<C-w>k", opt)
vim.keymap.set("n","<Leader>v", "<C-w>v", opt)
vim.keymap.set("n","<Leader>s", "<C-w>s", opt)

-- problem_with_gj_and_gk
vim.keymap.set("n", "j" , [[v:count ? 'j' :'gj']],{ noremap =true ,expr = true })
vim.keymap.set("n", "k" ,[[v:coutn ? 'k' : 'gk']] ,{noremap =true ,expr =true})


-- lazy.nvim

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)
require("lazy").setup({
	{
		"RRethy/nvim-base16",
		lazy = true,
	},
	{
		cmd =  "Telescope",
		'nvim-telescope/telescope.nvim', tag = '0.1.1',
		-- or                              , branch = '0.1.1',
		dependencies = { 'nvim-lua/plenary.nvim' }
	},

	{    event = "VeryLazy",
	"williamboman/mason.nvim",
	build = ":MasonUpdate", -- :MasonUpdate updates registry contents
	config =function ()
		require ("mason").setup()
	end
},
{
	event ="VeryLazy",
	"neovim/nvim-lspconfig",

	dependencies={   "williamboman/mason-lspconfig.nvim",}
},

{
	event = "VeryLazy",
	"hrsh7th/nvim-cmp",
	dependencies={
		'neovim/nvim-lspconfig',
		'hrsh7th/cmp-nvim-lsp',
		'hrsh7th/cmp-buffer',
		'hrsh7th/cmp-path',
		'hrsh7th/cmp-cmdline',
		'hrsh7th/nvim-cmp',
	}
}

})





-- vim.cmd.colorscheme("base16-tender")


-- lsp
require'lspconfig'.pyright.setup{}


require("mason").setup()
require("mason-lspconfig").setup {
	ensure_installed = { "lua_ls", "rust_analyzer" },
}


require 'lspconfig'.pyright.setup{

    capabilities = capabilities

}

-- nvim cmp


local cmp = require'cmp'

  cmp.setup({
    snippet = {
      -- REQUIRED - you must specify a snippet engine
      expand = function(args)
        vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
        -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
        -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
      end,
    },
    window = {
      -- completion = cmp.config.window.bordered(),
      -- documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'vsnip' }, -- For vsnip users.
      -- { name = 'luasnip' }, -- For luasnip users.
      -- { name = 'ultisnips' }, -- For ultisnips users.
      -- { name = 'snippy' }, -- For snippy users.
    }, {
      { name = 'buffer' },
    })
  })

  -- Set configuration for specific filetype.
  cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
      { name = 'git' }, -- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
    }, {
      { name = 'buffer' },
    })
  })

  -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' }
    }
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
  })

  -- Set up lspconfig.
  local capabilities = require('cmp_nvim_lsp').default_capabilities()
  -- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
