vim.diagnostic.config({ virtual_text = true, update_in_insert = true, underline = false })
vim.opt.signcolumn = "no"
vim.opt.relativenumber = true
vim.opt.termguicolors = false
vim.g.mapleader = " "

-- Blink
vim.pack.add({
	{ src = "https://github.com/saghen/blink.cmp", version = "v1.10.2" },
	{ src = "https://github.com/rafamadriz/friendly-snippets" },
})

require("blink.cmp").setup({
	keymap = { preset = "super-tab" },
	appearance = {
		use_nvim_cmp_as_default = true,
		nerd_font_variant = "mono",
	},
	signature = { enabled = true },
})

-- LSP
vim.pack.add({
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/mason-org/mason-lspconfig.nvim" },
	{ src = "https://github.com/neovim/nvim-lspconfig" },
})

require("mason").setup()
require("mason-lspconfig").setup({ ensure_installed = { "lua_ls", "ty" } })

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(ev)
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = ev.buf })
	end,
})
vim.keymap.set("n", "<leader>o", "<C-o>", {})

local capabilities = require("blink.cmp").get_lsp_capabilities()
vim.lsp.config("lua_ls", { settings = { Lua = { diagnostics = { globals = { "vim" } } } } })
vim.lsp.enable("lua_ls", { capabilities = capabilities })
vim.lsp.enable("ty", { capabilities = capabilities })

-- Formatting
vim.pack.add({ { src = "https://github.com/stevearc/conform.nvim" } })

require("conform").setup({
	format_on_save = { lsp_format = "fallback" },
	formatters_by_ft = {
		python = { "black", "isort" },
		lua = { "stylua" },
	},
})

-- Autopairs
vim.api.nvim_create_autocmd("InsertEnter", {
	once = true,
	callback = function()
		vim.pack.add({ { src = "https://github.com/windwp/nvim-autopairs" } })
		require("nvim-autopairs").setup()
	end,
})

-- Telescope
vim.pack.add({
	{ src = "https://github.com/nvim-telescope/telescope.nvim" },
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{ src = "https://github.com/nvim-telescope/telescope-fzf-native.nvim" },
})

vim.api.nvim_create_autocmd("PackChanged", {
	callback = function(ev)
		if
			ev.data.spec.name == "telescope-fzf-native.nvim"
			and (ev.data.kind == "install" or ev.data.kind == "update")
		then
			vim.system({ "make" }, { cwd = ev.data.path }):wait()
		end
	end,
})

local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>f", builtin.find_files)
vim.keymap.set("n", "<leader>g", builtin.live_grep)
