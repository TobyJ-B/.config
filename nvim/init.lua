vim.cmd([[set noswapfile]])
vim.opt.tabstop = 2
vim.opt.cursorcolumn = false
vim.opt.ignorecase = true
vim.opt.shiftwidth = 2
vim.opt.smartindent = true
vim.opt.wrap = false
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.termguicolors = true
vim.opt.undofile = true
vim.opt.signcolumn = "yes"
vim.opt.equalalways = false
vim.o.winborder = "rounded"
vim.g.maplocalleader = " "
vim.g.mapleader = " "


vim.pack.add({
	{ src = "https://github.com/rebelot/kanagawa.nvim" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter",          version = "master" },
	{ src = "https://github.com/nvim-tree/nvim-tree.lua" },
	{ src = "https://github.com/nvim-tree/nvim-web-devicons" },
	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://github.com/echasnovski/mini.pick" },
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/windwp/nvim-autopairs" },
	{ src = "https://github.com/hrsh7th/nvim-cmp" },
	{ src = "https://github.com/hrsh7th/cmp-nvim-lsp" },
	{ src = "https://github.com/hrsh7th/cmp-buffer" },
	{ src = "https://github.com/hrsh7th/cmp-path" },
	{ src = "https://github.com/zbirenbaum/nvterm" },
	{ src = "https://github.com/L3MON4D3/LuaSnip" },
	{ src = "https://github.com/saadparwaiz1/cmp_luasnip" },
	{ src = "https://github.com/rafamadriz/friendly-snippets" },
	{ src = "https://github.com/MeanderingProgrammer/render-markdown.nvim" },
	{ src = "https://github.com/HakonHarnes/img-clip.nvim" },
})

require('mason').setup()
require('mini.pick').setup()
require('oil').setup()
require('nvim-autopairs').setup()
require('nvim-tree').setup()
require("nvim-treesitter.configs").setup({
	ensure_installed = { "lua", "python", "cpp", "java", "markdown", "markdown_inline", "yaml", "html", "vim", "vimdoc" },
	auto_install = true,
	highlight = { enable = true },
	indent = { enable = true },
})

require('render-markdown').setup({})
require('img-clip').setup({
  default = { dir_path = "assets", relative_to_current_file = true },
})

-- colorscheme
require "kanagawa".setup({
	transparent = false,
})

vim.cmd("colorscheme kanagawa-dragon")

-- lsp

--vim.lsp.enable(
--	{
--		"lua_ls",
--	"pyright",
--}
--)

local capabilities = require('cmp_nvim_lsp').default_capabilities()
local lspconfig = require('lspconfig')

local servers = { "pyright", "lua_ls", "jdtls", "clangd", "texlab" }

for _, lsp in ipairs(servers) do
	lspconfig[lsp].setup({ capabilities = capabilities })
end


local term = require("nvterm.terminal")

require("nvterm").setup({
	terminals = {
		shell = vim.o.shell,
		list = {},
		type_opts = {
			float = {
				relative = "editor",
				row = 0.1,
				col = 0.1,
				width = 0.8,
				height = 0.8,
				border = "rounded",
			},
			horizontal = {
				location = "rightbelow",
				split_ratio = 0.2,
			},
			vertical = {
				location = "rightbelow",
				split_ratio = 0.5,
			},
		},
	},
	behavior = {
		autoclose_on_quit = {
			enabled = false,
			confirm = true,
		},
		close_on_exit = true,
		auto_insert = true,
	},
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
    vim.opt_local.spell = true
  end,
})

local cmp = require('cmp')
local luasnip = require('luasnip')

require('luasnip.loaders.from_vscode').lazy_load()

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = false }),
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.locally_jumpable(1) then
        luasnip.jump(1)
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.locally_jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  }),
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'buffer' },
    { name = 'path' },
  },
})




-- keybinds
local map = vim.keymap.set
local opts = { noremap = true, silent = true }
map('n', '<leader>e', ':NvimTreeToggle<CR>', opts)
map('n', '<leader>lf', vim.lsp.buf.format)
map('n', '<leader>o', ':Oil<CR>')
map('n', '<leader>h', ':<Cmd>Pick help<CR>')
map('n', '<leader>f', ':<Cmd>Pick files<CR>')
map('n', '<leader>w', ':set wrap!<CR>')
map({ 'n', 'v', 'x' }, '<leader>y', '"+y', opts)
map('n', "<leader>tt", function() term.toggle("horizontal") end, opts)
map('t', "<Esc>", [[<C-\><C-n>]], opts)
map('n', '<leader>g', ':Pick grep_live<CR>', opts)
map('n', '<leader>b', ':Pick buffers<CR>', opts)
map('n', '<leader>n', function()
  MiniPick.builtin.files(nil, { source = { cwd = vim.fn.expand('~/notes') } })
end, opts)
map('n', '<leader>p', ':PasteImage<CR>', opts)
map('n', '<leader>r', function()
	vim.cmd('write')
	local src = vim.fn.expand('%:p')
	local bin = vim.fn.expand('%:p:r')
	vim.cmd('!g++ -std=c++20 -O2 ' .. vim.fn.shellescape(src)
		.. ' -o ' .. vim.fn.shellescape(bin)
		.. ' && ' .. vim.fn.shellescape(bin))
end)
