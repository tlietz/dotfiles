----------------------------------------------------------------------------
-- Mappings and general configs
---------------------------------------------------------------------------

vim.g.mapleader = " "
vim.wo.relativenumber = true
vim.wo.number = true

----------------------------------------------------------------------------
-- Plugin manager
----------------------------------------------------------------------------

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
	-- LSP Support
	{ 'williamboman/mason.nvim' },
	{ 'williamboman/mason-lspconfig.nvim' },
	{ 'VonHeikemen/lsp-zero.nvim',        branch = 'v3.x' },
	{ 'neovim/nvim-lspconfig' },

	-- Autocomplete
	{ 'hrsh7th/cmp-nvim-lsp' },
	{ 'hrsh7th/cmp-nvim-lua' },
	{ 'hrsh7th/nvim-cmp' },
	{ 'hrsh7th/cmp-buffer' },
	{ 'hrsh7th/cmp-path' },
	{ 'hrsh7th/cmp-cmdline' },
	{ 'saadparwaiz1/cmp_luasnip' },

	-- Snippets
	{
		"L3MON4D3/LuaSnip",
		-- follow latest release.
		version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
		-- install jsregexp (optional!).
		-- build = "make install_jsregexp"
		dependencies = { "rafamadriz/friendly-snippets" },
	},

	-- Syntax highlighting
	{
		'nvim-treesitter/nvim-treesitter',
		build = ':TSUpdate'
	},

	{
		"folke/trouble.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {
			icons = false,
			fold_open = "v", -- icon used for open folds
			fold_closed = ">", -- icon used for closed folds
			indent_lines = false, -- add an indent guide below the fold icons
			signs = {
				-- icons / text used for a diagnostic
				error = "error",
				warning = "warn",
				hint = "hint",
				information = "info"
			},
			use_diagnostic_signs = false -- enabling this will use the signs defined in your lsp client
		},
	},

	-- File, text finder, and undo tree
	{
		"nvim-telescope/telescope.nvim",
		version = '0.1.5',
		dependencies = {
			"nvim-lua/plenary.nvim",
			"debugloop/telescope-undo.nvim",
		},
		config = function()
			require("telescope").setup({
				-- the rest of your telescope config goes here
				extensions = {
					undo = {
						-- telescope-undo.nvim config, see below
					},
					-- other extensions:
					-- file_browser = { ... }
				},
			})
			require("telescope").load_extension("undo")
			vim.keymap.set("n", "<leader>u", "<cmd>Telescope undo<cr>")
		end,
	},

	-- Git Integration
	{ 'tpope/vim-fugitive' },

	-- Colorscheme
	{ "catppuccin/nvim",   name = "catppuccin", priority = 1000 },

	-- QOL
	{
		"nvim-tree/nvim-tree.lua",
		version = "*",
		lazy = false,
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			require("nvim-tree").setup {}
		end,
	},
})

----------------------------------------------------------------------------
-- Builtin Terminal Emulator
----------------------------------------------------------------------------
-- Open terminal in various splits
vim.keymap.set('n', '<leader>ts', ':sp|term<CR>')
vim.keymap.set('n', '<leader>tt', ':vsp|term<CR>')
vim.keymap.set('n', '<leader>tn', ':tabnew|term<CR>')

-- Map <Esc> to exit terminal-mode
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>')

-- simulates i CTRL-R (pasting a buffer) in terminal-mode
local function charinput()
	return '<C-\\><C-N>"' .. vim.fn.nr2char(vim.fn.getchar()) .. 'pi'
end
vim.keymap.set('t', '<C-R>', charinput, { expr = true })

----------------------------------------------------------------------------
-- Colorscheme
----------------------------------------------------------------------------

vim.o.termguicolors = true
vim.cmd.colorscheme "catppuccin"

----------------------------------------------------------------------------
-- File finder
----------------------------------------------------------------------------
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

----------------------------------------------------------------------------
-- Nvim Tree
----------------------------------------------------------------------------
-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- optionally enable 24-bit colour
vim.opt.termguicolors = true

-- OR setup with some options
require("nvim-tree").setup({
	sort = {
		sorter = "case_sensitive",
	},
	view = {
		width = 30,
	},
	renderer = {
		group_empty = true,
	},
	filters = {
		dotfiles = true,
	},
})

vim.keymap.set('n', '<leader>e', ':NvimTreeToggle<CR>', { noremap = true, silent = true })

----------------------------------------------------------------------------
-- Fugitive
----------------------------------------------------------------------------


----------------------------------------------------------------------------
-- LSP support
----------------------------------------------------------------------------
local lsp_zero = require('lsp-zero')

lsp_zero.on_attach(function(client, bufnr)
	local opts = { buffer = bufnr, remap = false }

	vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
	vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
	vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
	vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
	vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
	vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
	vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
	vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
	vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
	vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)

	lsp_zero.buffer_autoformat()
end)

-- to learn how to use mason.nvim with lsp-zero
-- read this: https://github.com/VonHeikemen/lsp-zero.nvim/blob/v3.x/doc/md/guides/integrate-with-mason-nvim.md
require('mason').setup({})
require('mason-lspconfig').setup({
	ensure_installed = { 'tsserver', 'rust_analyzer', 'lua_ls', 'elixirls', 'pyright' },
	handlers = {
		lsp_zero.default_setup,
		lua_ls = function()
			local lua_opts = lsp_zero.nvim_lua_ls()
			require('lspconfig').lua_ls.setup(lua_opts)
		end,
	}
})

----------------------------------------------------------------------------
-- Syntax highlighting
----------------------------------------------------------------------------

require 'nvim-treesitter.configs'.setup {
	ensure_installed = { "vimdoc", "javascript", "typescript", "c", "lua", "python", "elixir", "heex", "eex" },
	-- ensure_installed = "all", -- install parsers for all supported languages
	-- Install parsers synchronously (only applied to `ensure_installed`)
	sync_install = false,

	-- Automatically install missing parsers when entering buffer
	-- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
	auto_install = true,

	highlight = {
		-- `false` will disable the whole extension
		enable = true,

		-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
		-- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
		-- Using this option may slow down your editor, and you may see some duplicate highlights.
		-- Instead of true it can also be a list of languages
		additional_vim_regex_highlighting = false,
	},
}

----------------------------------------------------------------------------
-- Autocomplete
----------------------------------------------------------------------------

local cmp = require('cmp')
local cmp_select = { behavior = cmp.SelectBehavior.Select }

-- this is the function that loads the extra snippets to luasnip
-- from rafamadriz/friendly-snippets
local ls = require "luasnip"
require('luasnip.loaders.from_vscode').lazy_load()

local s = ls.snippet
local t = ls.text_node

ls.add_snippets("elixir", {
	-- IO.inspect() binding() with easy to search for label
	s("iib", {
		t('IO.inspect(binding(), label: "asdf", limit: :infinity)'),
	}),
	s("pii", {
		t('|> IO.inspect(label: "asdf", limit: :infinity)'),
	}),
	s("dbg", {
		t('dbg(limit: :infinity)'),
	}),
	s("pdbg", {
		t('|> dbg(limit: :infinity)'),
	}),
})

cmp.setup({
	sources = {
		{ name = 'path' },
		{ name = 'nvim_lsp' },
		{ name = 'luasnip', keyword_length = 1 },
		{ name = 'nvim_lua' },
		{ name = 'buffer',  keyword_length = 3 },
	},
	formatting = lsp_zero.cmp_format(),
	mapping = cmp.mapping.preset.insert({
		['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
		['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
		-- <C-i> should be recognized as <Tab>
		['<Tab>'] = cmp.mapping.select_next_item(cmp_select),
		['<C-Space>'] = cmp.mapping.complete(),
		['<C-e>'] = cmp.mapping.abort(),
		['<C-y>'] = cmp.mapping.confirm({ select = true }),
		['<CR>'] = cmp.mapping.confirm({ select = true }),
	}),
})



----------------------------------------------------------------------------
-- Elixir LS Setup (Archive since using a LS manager)
----------------------------------------------------------------------------

-- setting up the elixir language server
-- you have to manually specify the entrypoint cmd for elixir-ls
--
-- ### Downloading Elixir-ls pre-compiled release ###
-- https://github.com/elixir-lsp/elixir-ls/releases
--
-- ### Downloading Elixir-ls from source ###
-- cd ~ && git clone https://github.com/elixir-lsp/elixir-ls.git
--
-- Then follow the instructions here:
-- https://github.com/elixir-lsp/elixir-ls#building-and-running
--
-- At the time of creating this config, these were the commands run.
-- Note that `-o release` matches `elixir-ls/release`:
-- mix deps.get
-- MIX_ENV=prod mix compile
-- MIX_ENV=prod mix elixir_ls.release -o release

-- local capabilities = require('cmp_nvim_lsp').default_capabilities()
-- require('lspconfig').elixirls.setup {
--   cmd = { os.getenv("HOME") .. "/elixir-ls/release/language_server.sh" },
--   on_attach = on_attach,
--   capabilities = capabilities
-- }
--
-- local cmp = require'cmp'
--
-- cmp.setup({
--   snippet = {
--     expand = function(args)
--       -- setting up snippet engine
--       -- this is for vsnip, if you're using other
--       -- snippet engine, please refer to the `nvim-cmp` guide
--       vim.fn["vsnip#anonymous"](args.body)
--     end,
--   },
--   mapping = {
--     ['<CR>'] = cmp.mapping.confirm({ select = true }),
--   },
--   sources = cmp.config.sources({
--     { name = 'nvim_lsp' },
--     { name = 'vsnip' }, -- For vsnip users.
--     { name = 'buffer' }
--   })
-- })
--
-- require'nvim-treesitter.configs'.setup {
--   ensure_installed = {"elixir", "heex", "eex"}, -- only install parsers for elixir and heex
--   -- ensure_installed = "all", -- install parsers for all supported languages
--   sync_install = false,
--   ignore_install = { },
--   highlight = {
--     enable = true,
--     disable = { },
--   },
-- }
--
-- }
