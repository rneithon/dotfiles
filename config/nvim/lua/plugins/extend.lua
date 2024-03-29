local map = vim.keymap.set
local Util = require("lazyvim.util")
local icons = require("lazyvim.config").icons

local Path = require("plenary.path")

local function find_node_modules(start_path)
  local current_path = Path:new(start_path or vim.loop.cwd()):absolute()
  local root_path = Path:new("/"):absolute()

  while current_path ~= root_path do
    local node_modules_path = Path:new(current_path, "node_modules")

    if node_modules_path:exists() and node_modules_path:is_dir() then
      return node_modules_path:absolute()
    end

    -- Move up one directory
    current_path = Path:new(current_path):parent():absolute()
  end

  return "" -- node_modules not found
end
local function pretty_path(opts)
  opts = vim.tbl_extend("force", {
    relative = "cwd",
    modified_hl = "Constant",
  }, opts or {})

  return function()
    local path = vim.fn.expand("%:p") --[[@as string]]

    if path == "" then
      return ""
    end
    local root = Util.root.get({ normalize = true })
    local cwd = Util.root.cwd()

    if opts.relative == "cwd" and path:find(cwd, 1, true) == 1 then
      path = path:sub(#cwd + 2)
    else
      path = path:sub(#root + 2)
    end

    local sep = package.config:sub(1, 1)
    local parts = vim.split(path, "[\\/]")
    -- if #parts > 4 then
    --   parts = { parts[1], "…", parts[#parts - 1], parts[#parts] }
    -- end

    -- if opts.modified_hl and vim.bo.modified then
    --   parts[#parts] = M.format(self, parts[#parts], opts.modified_hl)
    -- end

    return table.concat(parts, sep)
  end
end

---@alias Mode "n"|"i"|"v"|"x"|"s"|"o"|"t"|"c"|"l"|"r"|"!"|"v"

---@alias Keymap fun(a: {[1]: string, [2]:string, mode:Mode[]|Mode, desc: string})

---@alias Filetype "qf" | "javascript" |"javascriptreact"|"typescriptreact" | "typescript"
---@alias VimEvent "BufAdd"| "BufDelete"| "BufEnter"| "BufFilePost"| "BufFilePre"| "BufHidden"| "BufLeave"| "BufModifiedSeufNewFile"| "BufRead" |  "BufReadPost"| "BufReadCmd"| "BufReadPre"| "BufUnload"| "BufWinEnter"| "BufWinLeave"| "BufWipeout"| "BufWrite" | "BufWritePre"| "BufWriteCmd"| "BufWritePost"| "ChanInfo"| "ChanOpen"| "CmdUndefined"| "CmdlineChanged"| "CmdlineEnter"| "CmdlineLeave"| "CmdwinEnter"| "CmdwinLeave"| "ColorScheme"| "ColorSchemePre"| "CompleteChanged"| "CompleteDonePre"| "CompleteDone"| "CursorHold"| "CursorHoldI" | "CursorMoved" | "CursorMovedI" | "DiffUpdated" | "DirChanged" | "DirChangedPre" | "ExitPre" | "FileAppendCmd" | "FileAppendPost" | "FileAppendPre" | "FileChangedRO" | "FileChangedShell" | "FileChangedShellPost" | "FileReadCmd" | "FileReadPost" | "FileReadPre" | "FileType" | "FileWriteCmd" | "FileWritePost" | "FileWritePre" | "FilterReadPost" | "FilterReadPre" | "FilterWritePost" | "FilterWritePre" | "FocusGained" | "FocusLost" | "FuncUndefined" | "UIEnter" | "UILeave" | "InsertChange" | "InsertCharPre" | "InsertEnter" | "InsertLeavePre" | "InsertLeave" | "MenuPopup" | "ModeChanged" |  "ModeChanged"  | "ModeChanged" |  "WinEnter"|"Win" | "OptionSet" | "QuickFixCmdPre" | "QuickFixCmdPost" | "QuitPre" | "RemoteReply" | "SearchWrapped" | "RecordingEnter" | "RecordingLeave" | "SessionLoadPost" | "ShellCmdPost" | "Signal" | "ShellFilterPost" | "SourcePre" | "SourcePost" | "SourceCmd" | "SpellFileMissing" | "StdinReadPost" | "StdinReadPre" | "SwapExists" | "Syntax" | "TabEnter" | "TabLeave" | "TabNew" | "TabNewEntered" | "TabClosed" | "TermOpen" | "TermEnter" | "TermLeave" | "TermClose" | "TermResponse" | "TextChanged" | "TextChangedI" | "TextChangedP" | "TextChangedT" | "TextYankPost" | "User" | "UserGettingBored" | "VimEnter" | "VimLeave" | "VimLeavePre" | "VimResized" | "VimResume" | "VimSuspend" | "WinClosed" | "WinEnter" | "WinLeave" | "WinNew" | "WinScrolled" | "WinResized"
---@alias Event VimEvent|"VaryLazy"

---@class Key
---@field [1] string
---@field [2] string|function | false
---@field mode? Mode[]|Mode
---@field desc? string

---@class OnePlugin
---@field [1] string
---@field opts? function | table
---@field keys? Key[]|Key|fun()
---@field event? Event[]|Event
---@field config? function | true
---@field ft? Filetype[]|Filetype

---@class Plugin : OnePlugin
---@field dependencies? OnePlugin[]|OnePlugin |string[]|string

---@alias plugins.Plugin Plugin

---@type Plugin[]
return {
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        ["javascript"] = { "biome" },
        ["javascriptreact"] = { "biome" },
        ["typescript"] = { "biome" },
        ["typescriptreact"] = { "biome" },
        ["vue"] = { "biome" },
        ["css"] = { "biome" },
        ["scss"] = { "biome" },
        ["json"] = { "biome" },
        ["jsonc"] = { "biome" },
        ["handlebars"] = { "biome" },
      },
    },
  },
  -- {
  --   "folke/flash.nvim",
  --   event = "VeryLazy",
  --   vscode = true,
  --   ---@type Flash.Config
  --   opts = {},
  --   config = function()
  --     local enterMode = function(callback)
  --       callback()
  --       local s
  --       while true do
  --         s = vim.fn.getchar()
  --         if type(s) == "number" then
  --           local char = vim.fn.nr2char(s)
  --           local keys = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"
  --           if string.match(keys, char) then
  --             vim.defer_fn(function()
  --               vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(char, true, false, true), "n", false)
  --             end, 0)
  --             require("flash").jump()
  --             return
  --           else
  --             vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(char, true, false, true), "n", false)
  --             return
  --           end
  --         else
  --           return
  --         end
  --       end
  --     end
  --
  --     local scroll_half_page_down = function()
  --       local win_height = vim.api.nvim_win_get_height(0)
  --       local cursor_height = vim.api.nvim_win_get_cursor(0)[1]
  --       local middle = math.floor(win_height / 2)
  --       local scroll_amount = 0
  --       if cursor_height < middle then
  --         scroll_amount = 2 * middle - cursor_height
  --       else
  --         scroll_amount = cursor_height - middle
  --       end
  --       vim.cmd("normal " .. scroll_amount .. "j zz")
  --     end
  --
  --     local scroll_half_page_up = function()
  --       local win_height = vim.api.nvim_win_get_height(0)
  --       local middle = math.floor(win_height / 2)
  --       local cursor_height = vim.api.nvim_win_get_cursor(0)[1]
  --       local scroll_amount = 0
  --       if cursor_height < middle then
  --         scroll_amount = 2 * middle - cursor_height
  --       else
  --         scroll_amount = cursor_height - middle
  --       end
  --       vim.cmd("normal " .. scroll_amount .. "k zz")
  --     end
  --
  --     vim.keymap.set("n", "<C-u>", function()
  --       enterMode(scroll_half_page_up)
  --     end, { noremap = true, silent = true })
  --
  --     vim.keymap.set("n", "<C-d>", function()
  --       enterMode(scroll_half_page_down)
  --     end, { noremap = true, silent = true })
  --   end,
  --
  --   -- stylua: ignore
  --   -- keys = {
  --   --   { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
  --   --   { "S", mode = { "n", "o", "x" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
  --   --   { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
  --   --   { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
  --   --   { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
  --   -- },
  -- },
  {
    "nvim-lualine/lualine.nvim",

    opts = function(_, opts)
      opts.inactive_winbar = {
        lualine_c = {
          pretty_path({ relative = "cwd" }),
        },
      }
      opts.winbar = {

        lualine_c = {
          pretty_path({ relative = "cwd" }),
        },
      }
    end,
  },
  -- word highlight
  {
    "RRethy/vim-illuminate",
    config = function()
      vim.api.nvim_set_hl(0, "IlluminatedWordWrite", { underline = true })
      vim.api.nvim_set_hl(0, "IlluminatedWordText", { underline = true })
      vim.api.nvim_set_hl(0, "IlluminatedWordRead", { underline = true })
    end,
    opts = function(_, opts)
      opts.delay = 0
    end,
  },
  {
    "L3MON4D3/LuaSnip",
    config = function()
      local ls = require("luasnip")
      local sn = ls.snippet_node
      local s = ls.snippet
      local t = ls.text_node
      local f = ls.function_node
      local d = ls.dynamic_node
      local i = ls.insert_node
      local postfix = require("luasnip.extras.postfix").postfix

      local newline = ""

      ls.add_snippets("typescript", {
        s("inSorceVitest", {
          t({ "if (import.meta.vitest) {", "	const { it, expect } = import.meta.vitest;", [[	test("]] }),
          i(1),
          t({ '" () => {', "    " }),
          i(2),
          t({ "", "	});", "}" }),
        }),
        postfix(".print", {
          d(1, function(_, parent)
            return sn(nil, { t({ "console.log(" .. parent.env.POSTFIX_MATCH .. ")", newline }) })
          end),
        }),
        postfix(".dbg", {
          d(1, function(_, parent)
            return sn(nil, {

              -- console.log('a:', a);
              -- t({ 'console.log("' .. parent.env.POSTFIX_MATCH .. ': ", ' .. parent.env.POSTFIX_MATCH .. ")" }),
              -- console.log(JSON.stringify(a, null, 2));
              t({
                'console.log("'
                  .. parent.env.POSTFIX_MATCH
                  .. ":,"
                  .. '"JSON.stringify('
                  .. parent.env.POSTFIX_MATCH
                  .. ", null, 2));",
              }),
            })
          end),
        }),
      })

      ls.add_snippets("all", {
        postfix(".let", {
          d(1, function(_, parent)
            return sn(nil, { t("let " .. parent.env.POSTFIX_MATCH .. " = ") })
          end),
        }),

        postfix(".const", {
          d(1, function(_, parent)
            return sn(nil, { t("const " .. parent.env.POSTFIX_MATCH .. " = ") })
          end),
        }),
        --         if (import.meta.vitest) {
        --   const { it, expect } = import.meta.vitest;
        --   it("", () => {
        --   });
        -- }
      }, {
        key = "all",
      })
    end,
  },
  {
    "gbprod/yanky.nvim",
    dependencies = { { "kkharji/sqlite.lua", enabled = not jit.os:find("Windows") } },

    ---@param opts table
    opts = function(_, opts)
      opts.ring.history_length = 10
    end,
    setup = function()
      require("yanky").setup({})
    end,
    --   highlight = { timer = 250 },
    --   ring = { storage = jit.os:find("Windows") and "shada" or "sqlite" },
    -- },
  },
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      opts.sections.lualine_c = {
        {
          "diagnostics",
          symbols = {
            error = icons.diagnostics.Error,
            warn = icons.diagnostics.Warn,
            info = icons.diagnostics.Info,
            hint = icons.diagnostics.Hint,
          },
        },
        { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
        {
          function()
            return Util.root.cwd()
          end,
        },
      }
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      "David-Kunz/markid",
      "windwp/nvim-ts-autotag",
    },
    opts = function(_, opts)
      opts.markid = {
        enable = true,
      }
      opts.autotag = {
        enable = true,
      }
    end,
  },
  { -- Add vitest runner
    "rcarriga/neotest",
    dependencies = {
      -- "marilari88/neotest-vitest",
      -- "rneithon/neotest-vitest",
      "thenbe/neotest-playwright",
    },
    opts = function(_, opts)
      -- table.insert(opts.adapters, require("neotest-vitest"))
      table.insert(
        opts.adapters,
        require("neotest-playwright").adapter({
          options = {
            persist_project_selection = false,

            enable_dynamic_test_discovery = true,

            preset = "none", -- "none" | "headed" | "debug"

            get_playwright_binary = function()
              --   return vim.loop.cwd() + "/node_modules/.bin/playwright"
              return find_node_modules() .. "/.bin/playwright"
            end,

            -- get_playwright_config = function()
            --   return vim.loop.cwd() + "/playwright.config.ts"
            -- end,

            -- Controls the location of the spawned test process.
            -- Has no affect on neither the location of the binary nor the location of the config file.
            -- get_cwd = function()
            --   return vim.loop.cwd()
            -- end,

            -- env = { },

            -- Extra args to always passed to playwright. These are merged with any extra_args passed to neotest's run command.
            extra_args = {},

            -- Filter directories when searching for test files. Useful in large projects (see performance notes).
            -- filter_dir = function(name, rel_path, root)
            --   return name ~= "node_modules"
            -- end,

            ---Filter directories when searching for test files
            ---@async
            ---@param name string Name of directory
            ---@param rel_path string Path to directory, relative to root
            ---@param root string Root directory of project
            ---@return boolean
            -- filter_dir = function(name, rel_path, root)
            --   local full_path = root .. "/" .. rel_path
            --
            --   if root:match("tobari") then
            --     if full_path:match("^packages/e2e-test") then
            --       return true
            --     else
            --       return false
            --     end
            --   else
            --     return name ~= "node_modules"
            --   end
            -- end,
          },
        })
      )
      table.insert(opts, {
        consumers = {
          playwright = require("neotest-playwright").consumers,
        },
      })
    end,
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = function(_, opts)
      -- opts.window.mappings["H"] = "close_all_nodes"
      local mappings = vim.tbl_extend("force", opts.window.mappings, {
        ["s"] = "open_split",
        ["v"] = "open_vsplit",
        -- ["H"] = "close_all_nodes",
        ["l"] = function(state)
          local node = state.tree:get_node()
          if node.type == "directory" then
            if not node:is_expanded() then
              require("neo-tree.sources.filesystem").toggle_directory(state, node)
            elseif node:has_children() then
              require("neo-tree.ui.renderer").focus_node(state, node:get_child_ids()[1])
            end
          end
        end,
        -- ["h"] = function(state)
        --   local node = state.tree:get_node()
        --   if node.type == "directory" and node:is_expanded() then
        --     require("neo-tree.sources.filesystem").toggle_directory(state, node)
        --   else
        --     require("neo-tree.ui.renderer").focus_node(state, node:get_parent_id())
        --   end
        -- end,
      })
      opts.window.mappings = mappings
    end,
  },
  { -- add window picker to neo-tree
    "nvim-neo-tree/neo-tree.nvim",
    dependencies = {
      {
        "s1n7ax/nvim-window-picker",
        version = "2.*",
        config = function()
          require("window-picker").setup({
            filter_rules = {
              include_current_win = false,
              autoselect_one = true,
              -- filter using buffer options
              bo = {
                -- if the file type is one of following, the window will be ignored
                filetype = { "neo-tree", "neo-tree-popup", "notify" },
                -- if the buffer type is one of following, the window will be ignored
                buftype = { "terminal", "quickfix" },
              },
            },
            highlights = {
              statusline = {
                focused = {
                  fg = "#ededed",
                  bg = "#e35e4f",
                  bold = true,
                },
                unfocused = {
                  fg = "#ededed",
                  bg = "#44cc41",
                  bold = true,
                },
              },
              winbar = {
                focused = {
                  fg = "#ededed",
                  bg = "#e35e4f",
                  bold = true,
                },
                unfocused = {
                  fg = "#ededed",
                  bg = "#44cc41",
                  bold = true,
                },
              },
            },
          })
        end,
      },
    },
  },

  -- { --
  --   "nvimtools/none-ls.nvim",
  --   opts = function(_, opts)
  --     local null_ls = require("null-ls")
  --     for i, item in ipairs(opts) do
  --       if item == null_ls.builtins.diagnostics.eslint then
  --         opts[i] = null_ls.builtins.diagnostics.eslint.with({
  --           diagnostics_postprocess = function(diagnostic)
  --             diagnostic.severity = vim.diagnostic.severity.WARN
  --           end,
  --         })
  --         break
  --       end
  --     end
  --     table.insert(
  --       opts.sources,
  --       null_ls.builtins.diagnostics.eslint.with({
  --         diagnostics_postprocess = function(diagnostic)
  --           diagnostic.severity = vim.diagnostic.severity.WARN
  --         end,
  --       })
  --     )
  --   end,
  -- },
  { -- better typescript error
    "neovim/nvim-lspconfig",
    dependencies = "davidosomething/format-ts-errors.nvim",
    ft = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
    keys = {
      {
        "gd",
        [[<cmd>require("telescope.builtin").lsp_definitions({ reuse_win = false })<cr>]],
        mode = "n",
        desc = "Goto Definition",
      },
    },
    opts = function(_, opts)
      opts.servers.tsserver.handlers = {
        ["textDocument/publishDiagnostics"] = function(_, result, ctx, config)
          if result.diagnostics == nil then
            return
          end

          -- ignore some tsserver diagnostics
          local idx = 1
          while idx <= #result.diagnostics do
            local entry = result.diagnostics[idx]

            local formatter = require("format-ts-errors")[entry.code]
            entry.message = formatter and formatter(entry.message) or entry.message

            -- codes: https://github.com/microsoft/TypeScript/blob/main/src/compiler/diagnosticMessages.json
            if entry.code == 80001 then
              -- { message = "File is a CommonJS module; it may be converted to an ES module.", }
              table.remove(result.diagnostics, idx)
            else
              idx = idx + 1
            end
          end

          vim.lsp.diagnostic.on_publish_diagnostics(_, result, ctx, config)
        end,
      }
      -- table.insert(opts.servers.rust_analyzer.settings["rust-analyzer"].procMacro.ignored, {
      --   leptos_macro = {
      --     -- optional: --
      --     -- "component",
      --     "server",
      --   },
      -- })
      -- require('lspconfig').rust_analyzer.setup {
      --   -- Other Configs ...
      --   settings = {
      --     ["rust-analyzer"] = {
      --       -- Other Settings ...
      --       procMacro = {
      --         ignored = {
      --             leptos_macro = {
      --                 -- optional: --
      --                 -- "component",
      --                 "server",
      --             },
      --         },
      --       },
      --     },
      --   }
      -- }
    end,
  },
  -- {
  --   "nvimtools/none-ls.nvim",
  --   dependencies = {
  --     "poljar/typos.nvim",
  --   },
  --   opts = function(_, opts)
  --     local typos = require("typos")
  --     typos.setup()
  --     table.insert(opts.sources, typos.actions)
  --   end,
  -- },

  {
    "nvim-treesitter/playground",
    cmd = "TSPlaygroundToggle",
    dependencies = "nvim-treesitter/nvim-treesitter",
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require("nvim-treesitter.configs").setup({
        playground = {
          enable = true,
        },
      })
    end,
  },
  {
    "ziontee113/syntax-tree-surfer",
    vscode = true,
    dependencies = "nvim-treesitter/nvim-treesitter",

    keys = {
      { "vi", "<cmd>STSSelectCurrentNode<cr>", mode = "n", desc = "Select Current Node" },
      { "va", "<cmd>STSSelectMasterNode<cr>", mode = "n", desc = "Select Master Node" },
      { "N", "<cmd>STSSelectNextSiblingNode<cr>", mode = "x", desc = "Select Next Sibling Node" },
      { "P", "<cmd>STSSelectPrevSiblingNode<cr>", mode = "x", desc = "Select Previous Sibling Node" },
      { "K", "<cmd>STSSelectParentNode<cr>", mode = "x", desc = "Select Parent Node" },
      { "J", "<cmd>STSSelectChildNode<cr>", mode = "x", desc = "Select Child Node" },
    },
    config = function()
      require("syntax-tree-surfer").setup()
    end,
  },
  {
    "kiyoon/treesitter-indent-object.nvim",
    keys = {
      {
        "ai",
        function()
          require("treesitter_indent_object.textobj").select_indent_outer()
        end,
        mode = { "x", "o" },
        desc = "Select context-aware indent (outer)",
      },
      {
        "aI",
        function()
          require("treesitter_indent_object.textobj").select_indent_outer(true)
        end,
        mode = { "x", "o" },
        desc = "Select context-aware indent (outer, line-wise)",
      },
      {
        "ii",
        function()
          require("treesitter_indent_object.textobj").select_indent_inner()
        end,
        mode = { "x", "o" },
        desc = "Select context-aware indent (inner, partial range)",
      },
      {
        "iI",
        function()
          require("treesitter_indent_object.textobj").select_indent_inner(true, "V")
        end,
        mode = { "x", "o" },
        desc = "Select context-aware indent (inner, entire range) in line-wise visual mode",
      },
    },
  },
  -- Disable code context
  -- {
  --   "nvim-treesitter/nvim-treesitter-context",
  --   enabled = false,
  -- },
  -- Disable indent line
  -- {
  --   "echasnovski/mini.indentscope",
  --   --   enabled = false,
  --   -- opts = function(_, opts)
  --   --   -- opts.draw.animation = require("mini.indentscope").gen_animation.none()
  --   --   -- table.insert(opts.draw.animation, require("mini.indentscope").gen_animation.none())
  --   --   -- vim.tbl_extend(
  --   --   --   "force",
  --   --   --   opts,
  --   --   --   { draw = {
  --   --   --     animation = require("mini.indentscope").gen_animation.none(),
  --   --   --   } }
  --   --   -- )
  --   -- end,
  -- },
  {
    "akinsho/bufferline.nvim",
    opts = function(_, opts)
      -- table.insert(opts.options, { show_close_icon = false })

      -- opts.options.show_close_icon = false
      opts.options = vim.tbl_extend("force", opts.options, {
        show_buffer_close_icons = false,
        show_close_icon = false,
        always_show_bufferline = true,
        indicator = {
          icon = "▎", -- this should be omitted if indicator style is not 'icon'
          style = "underline",
        },
      })
    end,
  },

  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "jvgrootveld/telescope-zoxide",
    },
    keys = {
      -- add a keymap to browse plugin files
      -- stylua: ignore
      {
        "<leader>fP",
        function() require("telescope.builtin").find_files({ cwd = require("lazy.core.config").options.root }) end,
        desc = "Find Plugin File",
      },
      {
        "<leader>fg",
        function()
          require("telescope.builtin").git_files()
        end,
        desc = "Find Git File",
      },
      {
        "<leader><tab>",
        "<cmd>Telescope buffers<cr>",
        desc = "Buffers",
      },
      {
        "<leader>fz",
        "<cmd>Telescope zoxide list<<cr>",
        desc = "Buffers",
      },
    },
    init = function()
      local keys = require("lazyvim.plugins.lsp.keymaps").get()
      keys[#keys + 1] = {
        "gd",
        function()
          require("telescope.builtin").lsp_definitions({ reuse_win = false })
        end,
        mode = "n",
        desc = "Goto Definition",
      }
    end,
    -- change some options
    opts = function(_, opts)
      -- Useful for easily creating commands
      local z_utils = require("telescope._extensions.zoxide.utils")

      vim.tbl_deep_extend("keep", opts, {
        extensions = {
          zoxide = {
            prompt_title = "[ Walking on the shoulders of TJ ]",
            mappings = {
              default = {
                after_action = function(selection)
                  print("Update to (" .. selection.z_score .. ") " .. selection.path)
                end,
              },
              ["<C-s>"] = {
                before_action = function(selection)
                  print("before C-s")
                end,
                action = function(selection)
                  vim.cmd.edit(selection.path)
                end,
              },
              -- Opens the selected entry in a new split
              ["<C-q>"] = { action = z_utils.create_basic_command("split") },
            },
          },
        },
      })

      require("telescope").load_extension("zoxide")

      -- layout_strategy = "horizontal",
      -- layout_config = { prompt_position = "top" },
      -- sorting_strategy = "ascending",
      -- winblend = 0,
    end,
  },

  -- Use <tab> for completion and snippets (supertab)
  -- first: disable default <tab> and <s-tab> behavior in LuaSnip
  {
    "L3MON4D3/LuaSnip",
    keys = function() end,
  },
  { -- setup cmp-cmdline
    "hrsh7th/cmp-cmdline",
    event = { "InsertEnter", "CmdwinEnter", "CmdlineEnter" },
    dependencies = {
      "hrsh7th/nvim-cmp",
      "hrsh7th/cmp-nvim-lsp-document-symbol",
    },
    config = function()
      local cmp = require("cmp")
      -- `:` cmdline setup.
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline({
          ["<Tab>"] = cmp.mapping({
            c = function()
              cmp.confirm({
                behavior = cmp.ConfirmBehavior.Replace,
                select = true,
              })
            end,
          }),
        }),
        sources = cmp.config.sources({
          { name = "path" },
        }, {
          {
            name = "cmdline",
            option = {
              ignore_cmds = { "Man", "!" },
            },
          },
        }),
      })

      cmp.setup.cmdline("/", {
        mapping = cmp.mapping.preset.cmdline({
          ["<Tab>"] = cmp.mapping({
            c = function()
              cmp.confirm({
                behavior = cmp.ConfirmBehavior.Replace,
                select = true,
              })
            end,
          }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp_document_symbol" },
        }, {
          { name = "buffer" },
        }),
      })
    end,
  },
  -- then: setup supertab in cmp
  {
    "hrsh7th/nvim-cmp",
    event = { "InsertEnter", "CmdwinEnter", "CmdlineEnter" },

    opts = function(_, opts)
      local luasnip = require("luasnip")
      local cmp = require("cmp")

      opts.mapping = vim.tbl_extend("force", opts.mapping, {
        ["<CR>"] = cmp.mapping({
          i = function(fallback)
            if cmp.visible() and cmp.get_active_entry() then
              cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
            else
              fallback()
            end
          end,
          -- s = cmp.mapping.confirm({ select = true }),
          -- c = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
        }),
        ["<C-e>"] = function()
          if cmp.visible() then
            cmp.abort()
          else
            cmp.complete()
          end
        end,
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.confirm({
              behavior = cmp.ConfirmBehavior.Replace,
              select = true,
            })
          elseif luasnip.expand_or_locally_jumpable() then
            luasnip.expand_or_jump()
          else
            -- vim.api.nvim_replace_termcodes("<Plug>(TaboutBack)", true, true, true)
            fallback()
          end
        end, { "i", "s" }),
        ["<C-n>"] = cmp.mapping({
          c = function()
            if cmp.visible() then
              cmp.select_next_item()
            else
              cmp.complete()
            end
          end,
          -- c = function()
          --   if cmp.visible() then
          --     cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
          --   else
          --     vim.api.nvim_feedkeys(t("<Down>"), "n", true)
          --   end
          -- end,
          i = function(fallback)
            if cmp.visible() then
              cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
            else
              fallback()
            end
          end,
        }),
        ["<C-p>"] = cmp.mapping({
          -- c = function()
          --   if cmp.visible() then
          --     cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
          --   else
          --     vim.api.nvim_feedkeys(t("<Up>"), "n", true)
          --   end
          -- end,
          i = function(fallback)
            if cmp.visible() then
              cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
            else
              fallback()
            end
          end,
        }),
      })
    end,
  },
  { -- override nvim-cmp and add cmp-emoji
    "hrsh7th/nvim-cmp",
    event = { "InsertEnter", "CmdwinEnter", "CmdlineEnter" },
    dependencies = { "hrsh7th/cmp-emoji" },
    opts = function(_, opts)
      table.insert(opts.sources, { name = "emoji" })
    end,
  },
  { -- change completion settings
    "hrsh7th/nvim-cmp",
    event = { "InsertEnter", "CmdwinEnter", "CmdlineEnter" },
    version = false, -- last release is way too old
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "saadparwaiz1/cmp_luasnip",
      {
        "Exafunction/codeium.nvim",
        cmd = "Codeium",
        build = ":Codeium Auth",
        opts = {},
      },
    },
  },
  {
    event = { "InsertEnter", "CmdwinEnter", "CmdlineEnter" },
    "nvim-cmp",
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      local compare = require("cmp.config.compare")
      local cmp = require("cmp")

      -- table.insert(opts.sources, 1, {
      --   name = "copilot",
      --   group_index = 1,
      --   priority = 100,
      -- })

      local remove_source = { "luasnip", "copilot", "codeium" }
      for i, source in ipairs(opts.sources) do
        if vim.tbl_contains(remove_source, source.name) then
          table.remove(opts.sources, i)
        end
      end

      table.insert(opts.sources, {
        name = "codeium",
        -- group_index = 1,
        -- priority = 100,
      })

      table.insert(opts.sources, {
        name = "copilot",
        group_index = nil,
        --   -- priority = 100,
      })
      table.insert(opts.sources, {
        name = "luasnip",
        -- group_index = 1,
        -- priority = 120,
      })

      -- local a = vim.tbl_extend("force", opts.sources, {
      -- })
      -- table.insert(opts.sources, 1, {
      --   name = "copilot",
      --   group_index = 1,
      --   priority = 100,
      -- })
      --
      -- table.insert(opts.sources, {
      --   name = "luasnip",
      --   group_index = 1,
      --   priority = 120,
      -- })

      opts.sorting = {
        priority_weight = 1,
        comparators = {
          compare.length,
          compare.offset,
          compare.exact,
          -- compare.scopes,
          compare.score,
          compare.recently_used,
          compare.locality,
          compare.kind,
          -- compare.sort_text,
          compare.order,
        },
      }
    end,
  },
}
