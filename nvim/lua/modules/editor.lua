return {
	{
		"anuvyklack/windows.nvim",
		dependencies = {
			"anuvyklack/middleclass",
		},
		config = function()
			vim.o.winwidth = 10
			vim.o.winminwidth = 10
			vim.o.equalalways = false
			require("windows").setup()
		end,
	},
	{
		"samodostal/image.nvim",
		dependencies = { "nvim-lua/plenary.nvim", "m00qek/baleia.nvim" },
		event = "BufReadPre",
		config = function()
			require("image").setup({
				render = {
					min_padding = 5,
					show_label = true,
					use_dither = true,
					foreground_color = true,
					background_color = true,
				},
				events = {
					update_on_nvim_resize = true,
				},
			})
		end,
	},
	{
		"kazhala/close-buffers.nvim",
		config = true,
	},
	{
		"tiagovla/scope.nvim",
		config = true,
	},
	{
		"itchyny/vim-cursorword",
	},
	{
		"numToStr/Comment.nvim",
		keys = { "gc", { "gc", mode = "v" } },
		config = true,
	},
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = function()
			require("nvim-autopairs").setup({
				map_cr = false, -- Avoid conflicts with CR keymap for completion
			})
		end,
	},
	{ "nacro90/numb.nvim", config = true, event = "CmdwinEnter" },
	{
		"godlygeek/tabular",
		cmd = "Tabularize",
		keys = { { "a ", mode = "v" }, { "a=", mode = "v" }, { "a:", mode = "v" } },
	},
	{
		"ggandor/lightspeed.nvim",
		keys = { "<Plug>Lightspeed_s", "<Plug>Lightspeed_S", "f", "F" },
		config = true,
	},
	{
		"chaoren/vim-wordmotion",
		keys = { "w", "e", "b", "W", "E", "B" },
	},
	{
		"hrsh7th/vim-searchx",
		keys = { "/", "?" },
		config = function()
			local g = {}

			g.auto_accept = true
			g.scrolloff = vim.g.scrolloff
			g.scrolltime = 500
			g.nohlsearch = { jump = true }
			g.markers = {
				"A",
				"B",
				"C",
				"D",
				"E",
				"F",
				"G",
				"H",
				"I",
				"J",
				"K",
				"L",
				"M",
				"N",
				"O",
				"P",
				"Q",
				"R",
				"S",
				"T",
				"U",
				"V",
				"W",
				"X",
				"Y",
				"Z",
			}

			vim.g.serachx = g
		end,
	},
	{
		"max397574/better-escape.nvim",
		event = "InsertEnter",
		config = function()
			require("better_escape").setup({
				mapping = { "jk" }, -- a table with mappings to use
				timeout = 200, -- the time in which the keys must be hit in ms. Use option timeoutlen by default
				clear_empty_lines = false, -- clear line after escaping if there is only whitespace
				keys = "<Esc>", -- keys used for escaping, if it is a function will use the result everytime
			})
		end,
	},
	{
		"machakann/vim-sandwich",
		dependencies = { "vim-wordmotion" },
		keys = {
			{ "sa" },
			{ "sd" },
			{ "sr" },

			{ "sa", mode = "v" },
			{ "sd", mode = "v" },
			{ "sr", mode = "v" },
		},
	},
	{
		"tversteeg/registers.nvim",
		branch = "main",
		keys = { '"' },
		config = true,
	},
	{
		"mg979/vim-visual-multi",
		branch = "master",
		keys = { "<C-n>" },
	},
}
