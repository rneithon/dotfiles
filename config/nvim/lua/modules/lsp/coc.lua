return {
  {
    "neoclide/coc.nvim",
    branch = "release",
    config = function()
      vim.g.coc_config_home = "$HOME/dotfiles/nvim"
      vim.g.coc_global_extension = {
        "coc-tabnine",
        "coc-tsserver",
        "coc-prettier",
        "coc-eslint",
        "coc-css",
        "coc-emmet",
        "coc-html",
        "coc-json",

        "coc-react-refactor",

        "coc-snippets",
        "coc-tabnine",
        "coc-sql",

        "coc-go",
        "coc-restclient",
        "coc-lua",
        "coc-sumneko-lua",
      }
      -- Some servers have issues with backup files, see #649
      vim.opt.backup = false
      vim.opt.writebackup = false

      -- Having longer updatetime (default is 4000 ms = 4s) leads to noticeable
      -- delays and poor user experience:
      vim.opt.updatetime = 300

      -- Always show the signcolumn, otherwise it would shift the text each time
      -- diagnostics appeared/became resolved
      vim.opt.signcolumn = "yes"

      -- Autocomplete
      function _G.check_back_space()
        local col = vim.fn.col(".") - 1
        return col == 0 or vim.fn.getline("."):sub(col, col):match("%s") ~= nil
      end

      local keyset = vim.keymap.set
      local opts = {
        silent = true,
        noremap = true,
        expr = true,
        replace_keycodes = false,
      }
      keyset(
        "i",
        "<TAB>",
        'coc#pum#visible() ? coc#pum#next(1) : v:lua.check_back_space() ? "<TAB>" : coc#refresh()',
        opts
      )
      keyset("i", "<S-TAB>", [[coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"]], opts)
      vim.g.coc_snippet_next = "<Tab>"
      vim.g.coc_snippet_prev = "<S-Tab>"

      keyset("i", "<CR>", [[coc#pum#visible()?coc#pum#confirm():"\<CR>"]], opts)

      -- Use <c-j> to trigger snippets
      -- Use <c-space> to trigger completion
      keyset("i", "<C-space>", "coc#refresh()", { silent = true, expr = true })
      -- Use K to show documentation in preview window
      function _G.show_docs()
        local cw = vim.fn.expand("<cword>")
        if vim.fn.index({ "vim", "help" }, vim.bo.filetype) >= 0 then
          vim.api.nvim_command("h " .. cw)
        elseif vim.api.nvim_eval("coc#rpc#ready()") then
          vim.fn.CocActionAsync("doHover")
        else
          vim.api.nvim_command("!" .. vim.o.keywordprg .. " " .. cw)
        end
      end

      -- Highlight the symbol and its references on a CursorHold event(cursor is idle)
      vim.api.nvim_create_augroup("CocGroup", {})
      vim.api.nvim_create_autocmd("CursorHold", {
        group = "CocGroup",
        command = "silent call CocActionAsync('highlight')",
        desc = "Highlight symbol under cursor on CursorHold",
      })

      -- Formatting selected code
      -- keyset("x", "<leader>f", "<Plug>(coc-format-selected)", { silent = true })
      -- keyset("n", "<leader>f", "<Plug>(coc-format-selected)", { silent = true })

      -- Setup formatexpr specified filetype(s)
      vim.api.nvim_create_autocmd("FileType", {
        group = "CocGroup",
        pattern = "typescript,json",
        command = "setl formatexpr=CocAction('formatSelected')",
        desc = "Setup formatexpr specified filetype(s).",
      })

      -- Update signature help on jump placeholder
      vim.api.nvim_create_autocmd("User", {
        group = "CocGroup",
        pattern = "CocJumpPlaceholder",
        command = "call CocActionAsync('showSignatureHelp')",
        desc = "Update signature help on jump placeholder",
      })

      -- Apply codeAction to the selected region
      -- Example: `<leader>aap` for current paragraph
      local opts = { silent = true, nowait = true }
      keyset("x", "<leader>a", "<Plug>(coc-codeaction-selected)", opts)
      keyset("n", "<leader>a", "<Plug>(coc-codeaction-selected)", opts)

      -- Remap keys for apply code actions at the cursor position.
      keyset("n", "<leader>ac", "<Plug>(coc-codeaction-cursor)", opts)
      -- Remap keys for apply code actions affect whole buffer.
      keyset("n", "<leader>as", "<Plug>(coc-codeaction-source)", opts)
      -- Apply the most preferred quickfix action on the current line.
      keyset("n", "<leader>qf", "<Plug>(coc-fix-current)", opts)

      -- Remap keys for apply refactor code actions.
      keyset("n", "<leader>re", "<Plug>(coc-codeaction-refactor)", { silent = true })
      keyset("x", "<leader>r", "<Plug>(coc-codeaction-refactor-selected)", { silent = true })
      keyset("n", "<leader>r", "<Plug>(coc-codeaction-refactor-selected)", { silent = true })

      -- Run the Code Lens actions on the current line
      keyset("n", "<leader>cl", "<Plug>(coc-codelens-action)", opts)

      -- Map function and class text objects
      -- NOTE: Requires 'textDocument.documentSymbol' support from the language server
      keyset("x", "if", "<Plug>(coc-funcobj-i)", opts)
      keyset("o", "if", "<Plug>(coc-funcobj-i)", opts)
      keyset("x", "af", "<Plug>(coc-funcobj-a)", opts)
      keyset("o", "af", "<Plug>(coc-funcobj-a)", opts)
      keyset("x", "ic", "<Plug>(coc-classobj-i)", opts)
      keyset("o", "ic", "<Plug>(coc-classobj-i)", opts)
      keyset("x", "ac", "<Plug>(coc-classobj-a)", opts)
      keyset("o", "ac", "<Plug>(coc-classobj-a)", opts)
      -- Remap <C-f> and <C-b> to scroll float windows/popups
      ---@diagnostic disable-next-line: redefined-local
      local opts = { silent = true, nowait = true, expr = true }
      keyset("n", "<C-f>", 'coc#float#has_scroll() ? coc#float#scroll(1) : "<C-f>"', opts)
      keyset("n", "<C-b>", 'coc#float#has_scroll() ? coc#float#scroll(0) : "<C-b>"', opts)
      keyset(
        "i",
        "<C-f>",
        'coc#float#has_scroll() ? "<c-r>=coc#float#scroll(1)<cr>" : "<Right>"',
        opts
      )
      keyset(
        "i",
        "<C-b>",
        'coc#float#has_scroll() ? "<c-r>=coc#float#scroll(0)<cr>" : "<Left>"',
        opts
      )
      keyset("v", "<C-f>", 'coc#float#has_scroll() ? coc#float#scroll(1) : "<C-f>"', opts)
      keyset("v", "<C-b>", 'coc#float#has_scroll() ? coc#float#scroll(0) : "<C-b>"', opts)

      -- Add `:Format` command to format current buffer
      vim.api.nvim_create_user_command("Format", "call CocAction('format')", {})

      -- " Add `:Fold` command to fold current buffer
      vim.api.nvim_create_user_command("Fold", "call CocAction('fold', <f-args>)", { nargs = "?" })

      -- Add `:OR` command for organize imports of the current buffer
      vim.api.nvim_create_user_command(
        "OR",
        "call CocActionAsync('runCommand', 'editor.action.organizeImport')",
        {}
      )
    end,
  },
}
