return {
	{
		"bayne/vim-dot-http",
		lazy = true,
		ft = "http",
		cmd = "DotHttp",
		config = function()
			vim.g.dot_http_env = "dev"
		end,
	},
	{
		"numToStr/FTerm.nvim",
		lazy = true,
		cmd = { "FTermOpen", "FTermClose", "FTermClose" },
		config = function()
			require("FTerm").setup({
				border = "double",
				dimensions = {
					height = 0.9,
					width = 0.9,
				},
			})

			-- create command
			vim.api.nvim_create_user_command("FTermOpen", require("FTerm").open, { bang = true })
			vim.api.nvim_create_user_command("FTermClose", require("FTerm").close, { bang = true })
			vim.api.nvim_create_user_command("FTermToggle", require("FTerm").toggle, { bang = true })
		end,
	},
	{
		"folke/which-key.nvim",
		event = "InsertLeave",
		config = function()
			require("which-key").setup({
				key_labels = {
					["<space>"] = "<SPACE>",
					["<CR>"] = "<ENTER>",
					["<Tab>"] = "<TAB>",
				},
				triggers = { "<leader>" }, -- If not written, conflict with vfiler to cause error occurs
				disable = {
					buftypes = { "vfiler", "nofile" },
					filetypes = { "vfiler", "nofile" },
				},
			})
		end,
	},
	{
		"glepnir/lspsaga.nvim",
		cmd = { "Lspsaga" },
		module = { "lspsaga.diagnostic" },
		config = true,
	},
	{
		"kkvh/vim-docker-tools",
		cmd = "DockerToolsOpen",
	},
	{
		"thinca/vim-qfreplace",
		event = "QuickFixCmdPost",
	},
	{
		"kevinhwang91/nvim-bqf",
		ft = "qf",
		config = function()
			require("bqf").setup({
				auto_enable = true,
				auto_resize_height = true, -- highly recommended enable
				preview = {
					win_height = 12,
					win_vheight = 12,
					delay_syntax = 80,
					border_chars = { "┃", "┃", "━", "━", "┏", "┓", "┗", "┛", "█" },
					show_title = false,
					should_preview_cb = function(bufnr, qwinid)
						local ret = true
						local bufname = vim.api.nvim_buf_get_name(bufnr)
						local fsize = vim.fn.getfsize(bufname)
						if fsize > 100 * 1024 then
							-- skip file size greater than 100k
							ret = false
						elseif bufname:match("^fugitive://") then
							-- skip fugitive buffer
							ret = false
						end
						return ret
					end,
				},
				-- make `drop` and `tab drop` to become preferred
				func_map = {
					drop = "o",
					openc = "O",
					split = "<C-s>",
					tabdrop = "<C-t>",
					-- set to empty string to disable
					tabc = "",
					ptogglemode = "z,",
				},
				filter = {
					fzf = {
						action_for = { ["ctrl-s"] = "split", ["ctrl-t"] = "tab drop" },
						extra_opts = { "--bind", "ctrl-o:toggle-all", "--prompt", "> " },
					},
				},
			})
		end,
	},
	{
		"uga-rosa/ccc.nvim",

		cmd = { "CccPick" },
		config = function()
			local ColorInput = require("ccc.input")
			local convert = require("ccc.utils.convert")

			local RgbHslCmykInput = setmetatable({
				name = "RGB/HSL/CMYK",
				max = { 1, 1, 1, 360, 1, 1, 1, 1, 1, 1 },
				min = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
				delta = { 1 / 255, 1 / 255, 1 / 255, 1, 0.01, 0.01, 0.005, 0.005, 0.005, 0.005 },
				bar_name = { "R", "G", "B", "H", "S", "L", "C", "M", "Y", "K" },
			}, { __index = ColorInput })

			function RgbHslCmykInput.format(n, i)
				if i <= 3 then
					-- RGB
					n = n * 255
				elseif i == 5 or i == 6 then
					-- S or L of HSL
					n = n * 100
				elseif i >= 7 then
					-- CMYK
					return ("%5.1f%%"):format(math.floor(n * 200) / 2)
				end
				return ("%6d"):format(n)
			end

			function RgbHslCmykInput.from_rgb(RGB)
				local HSL = convert.rgb2hsl(RGB)
				local CMYK = convert.rgb2cmyk(RGB)
				local R, G, B = unpack(RGB)
				local H, S, L = unpack(HSL)
				local C, M, Y, K = unpack(CMYK)
				return { R, G, B, H, S, L, C, M, Y, K }
			end

			function RgbHslCmykInput.to_rgb(value)
				return { value[1], value[2], value[3] }
			end

			function RgbHslCmykInput:_set_rgb(RGB)
				self.value[1] = RGB[1]
				self.value[2] = RGB[2]
				self.value[3] = RGB[3]
			end

			function RgbHslCmykInput:_set_hsl(HSL)
				self.value[4] = HSL[1]
				self.value[5] = HSL[2]
				self.value[6] = HSL[3]
			end

			function RgbHslCmykInput:_set_cmyk(CMYK)
				self.value[7] = CMYK[1]
				self.value[8] = CMYK[2]
				self.value[9] = CMYK[3]
				self.value[10] = CMYK[4]
			end

			function RgbHslCmykInput:callback(index, new_value)
				self.value[index] = new_value
				local v = self.value
				if index <= 3 then
					local RGB = { v[1], v[2], v[3] }
					local HSL = convert.rgb2hsl(RGB)
					local CMYK = convert.rgb2cmyk(RGB)
					self:_set_hsl(HSL)
					self:_set_cmyk(CMYK)
				elseif index <= 6 then
					local HSL = { v[4], v[5], v[6] }
					local RGB = convert.hsl2rgb(HSL)
					local CMYK = convert.rgb2cmyk(RGB)
					self:_set_rgb(RGB)
					self:_set_cmyk(CMYK)
				else
					local CMYK = { v[7], v[8], v[9], v[10] }
					local RGB = convert.cmyk2rgb(CMYK)
					local HSL = convert.rgb2hsl(RGB)
					self:_set_rgb(RGB)
					self:_set_hsl(HSL)
				end
			end

			local ccc = require("ccc")
			local mapping = ccc.mapping

			ccc.setup({
				default_color = "#ffffff",
				inputs = {
					RgbHslCmykInput,
				},
				mappings = {
					t = mapping.toggle_alpha,
					L = mapping.increase5,
					a = mapping.increase10,
					H = mapping.decrease5,
					i = mapping.decrease10,
					I = mapping.set0,
					A = mapping.set100,
				},
			})
		end,
	},
	{
		"tpope/vim-fugitive",
		cmd = { "GV", "Git", "Gdiffsplit", "Gvdiffsplit" },
	},
	{
		"junegunn/gv.vim",
		cmd = { "GV" },
	},
	{
		"lewis6991/gitsigns.nvim",
		config = true,
	},
	{
		"mbbill/undotree",
		cmd = { "UndotreeShow", "UndotreeFocus" },
	},
	{
		"nvim-telescope/telescope.nvim",
		module = { "telescope" },
		cmd = { "Telescope" },
		dependencies = {
			{ "nvim-lua/plenary.nvim", module = { "plenary" } },
			{ "nvim-lua/popup.nvim", module = { "popup" } },
		},
	},
	{
		"obaland/vfiler.vim",

		cmd = "VFiler",
		dependencies = {
			"obaland/vfiler-column-devicons",
		},
		config = function()
			require("vfiler/config").setup({
				options = {
					columns = "indent,devicons,name,git",
					auto_cd = true,
					auto_resize = true,
					keep = true,
					layout = "left",
					width = 40,
					git = {
						enabled = true,
						untracked = true,
						ignored = true,
					},
				},
			})
		end,
	},
}