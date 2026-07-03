{
  pkgs,
  lib,
  ...
}:

{
  programs.neovim = {

    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    extraPackages = with pkgs; [
      nil
      rust-analyzer
      vtsls
      vscode-langservers-extracted
      pyright
      ripgrep
      fd
      nodejs
      prettier
      black
    ];

    plugins = with pkgs.vimPlugins; [
      catppuccin-nvim

      lualine-nvim

      telescope-nvim
      plenary-nvim

      neo-tree-nvim
      nvim-web-devicons
      nui-nvim

      barbar-nvim

      nvim-treesitter.withAllGrammars
      conform-nvim

      nvim-autopairs

      nvim-lspconfig
      cmp-nvim-lsp
      nvim-cmp
      luasnip
      cmp_luasnip
      cmp-buffer
      cmp-path

      gitsigns-nvim

      vim-wakatime

      copilot-lua

      markdown-preview-nvim
    ];

    extraLuaConfig = lib.mkForce ''
      --------------------------------------------------------------------------------
      -- BASIC SETTINGS
      --------------------------------------------------------------------------------

      vim.g.mapleader = " "

      vim.opt.number = true
      vim.opt.relativenumber = true

      vim.opt.shiftwidth = 2
      vim.opt.tabstop = 2
      vim.opt.expandtab = true
      vim.opt.cursorline = true

      vim.opt.mouse = "a"
      vim.opt.clipboard = "unnamedplus"

      vim.opt.termguicolors = true

      vim.opt.fillchars = { eob = " " }

      --------------------------------------------------------------------------------
      -- CATPPUCCIN
      --------------------------------------------------------------------------------

      require("catppuccin").setup({
        flavour = "mocha",

        transparent_background = false,

        integrations = {
          telescope = {
            enabled = true,
          },

          neotree = true,
          barbar = true,

          treesitter = true,
        },

        custom_highlights = function(colors)
          return {
            CursorLine = {
              bg = colors.surface0,
            },
          }
        end,
      })

      vim.cmd.colorscheme("catppuccin")

      --------------------------------------------------------------------------------
      -- LUALINE
      --------------------------------------------------------------------------------

      local mocha = require("catppuccin.palettes").get_palette()

      require("lualine").setup({
        options = {
          theme = {
            normal = {
              a = { bg = mocha.mauve, fg = mocha.base },
              b = { bg = mocha.surface0, fg = mocha.text },
              c = { bg = mocha.mantle, fg = mocha.text },
            },
          },
        },
      })

      --------------------------------------------------------------------------------
      -- TELESCOPE
      --------------------------------------------------------------------------------

      local builtin = require("telescope.builtin")

      vim.keymap.set("n", "<leader>f", builtin.find_files)
      vim.keymap.set("n", "<leader>g", builtin.live_grep)

      --------------------------------------------------------------------------------
      -- NEO-TREE
      --------------------------------------------------------------------------------

      require("neo-tree").setup({})

      vim.keymap.set(
        "n",
        "<leader>e",
        ":Neotree toggle left<CR>",
        { silent = true }
      )

      local cp = require("catppuccin.palettes").get_palette("mocha")

      require('neo-tree').setup({
        window = {
          width = 30,
          mappings = {
            ["<space>"] = "none",
          }
        },
        default_component_configs = {
          indent = {
            with_expanders = true,
            expander_collapsed = "",
            expander_expanded = "",
          },
          icon = {
            folder_closed = "",
            folder_open = "",
            folder_empty = "󱞞",
          },
        }
      })

      vim.api.nvim_set_hl(0, "NeoTreeNormal", { bg = cp.base })
      vim.api.nvim_set_hl(0, "NeoTreeNormalNC", { bg = cp.base })
      vim.api.nvim_set_hl(0, "NeoTreeWinSeparator", { fg = cp.surface1, bg = cp.base })

      --------------------------------------------------------------------------------
      -- BARBAR
      --------------------------------------------------------------------------------

      vim.keymap.set(
        "n",
        "H",
        "<Cmd>BufferPrevious<CR>",
        { silent = true }
      )

      vim.keymap.set(
        "n",
        "L",
        "<Cmd>BufferNext<CR>",
        { silent = true }
      )

      vim.keymap.set(
        "n",
        "<leader>c",
        "<Cmd>BufferClose<CR>",
        { silent = true }
      )

      --------------------------------------------------------------------------------
      -- SPLITS
      --------------------------------------------------------------------------------

      vim.keymap.set("n", "<C-h>", "<C-w>h", { silent = true })
      vim.keymap.set("n", "<C-j>", "<C-w>j", { silent = true })
      vim.keymap.set("n", "<C-k>", "<C-w>k", { silent = true })
      vim.keymap.set("n", "<C-l>", "<C-w>l", { silent = true })

      vim.keymap.set(
        "n",
        "<leader>v",
        ":vsplit<CR>",
        { silent = true }
      )

      vim.keymap.set(
        "n",
        "<leader>s",
        ":split<CR>",
        { silent = true }
      )

      --------------------------------------------------------------------------------
      -- INDENTATION
      --------------------------------------------------------------------------------

      vim.keymap.set("n", "<D-[>", "<<", { silent = true })
      vim.keymap.set("n", "<D-]>", ">>", { silent = true })

      vim.keymap.set("v", "<D-[>", "<gv", { silent = true })
      vim.keymap.set("v", "<D-]>", ">gv", { silent = true })

      --------------------------------------------------------------------------------
      -- MARKDOWN PREVIEW
      --------------------------------------------------------------------------------

      -- Space + m + p (Markdown Preview) opens preview in the browser
      vim.keymap.set("n", "<leader>mp", ":MarkdownPreviewToggle<CR>", { silent = true })

      -- Space + h + p (Hunk Preview) shows the changes in the current hunk
      vim.keymap.set('n', '<leader>hp', ':Gitsigns preview_hunk<CR>', { silent = true })

      require('nvim-autopairs').setup({
        check_ts = true,
      })

      local cmp_autopairs = require('nvim-autopairs.completion.cmp')
      local cmp = require('cmp')
      cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())

      --------------------------------------------------------------------------------
      -- LSPS
      --------------------------------------------------------------------------------

      require('gitsigns').setup()

      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      local default_config = {
        capabilities = capabilities
      }

      vim.lsp.config('nil_ls', default_config)
      vim.lsp.config('rust_analyzer', default_config)
      vim.lsp.config('vtsls', default_config)
      vim.lsp.config('html', default_config)
      vim.lsp.config('cssls', default_config)
      vim.lsp.config('pyright', default_config)

      vim.lsp.enable('nil_ls')
      vim.lsp.enable('rust_analyzer')
      vim.lsp.enable('vtsls')
      vim.lsp.enable('html')
      vim.lsp.enable('cssls')
      vim.lsp.enable('pyright')

      local cmp = require('cmp')
      local luasnip = require('luasnip')

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(), -- Force the suggestion window (Ctrl + Space)
          ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Enter confirms the suggestion

          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { 'i', 's' }),
          ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { 'i', 's' }),
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
        }, {
          { name = 'buffer' },
          { name = 'path' },
        })
      })

      --------------------------------------------------------------------------------
      -- GITHUB COPILOT INLINE COMPLETION
      --------------------------------------------------------------------------------
      require('copilot').setup({
        panel = { enabled = false },
        suggestion = {
          enabled = true,
          auto_trigger = true,
          debounce = 75,
          keymap = {
            accept = "<C-Down>",
            accept_word = "<C-Right>",
            accept_line = "<C-l>",
            next = "<C-j>",
            prev = "<C-k>",
            dismiss = "<Esc>",
          },
        },
        filetypes = {
          yaml = true,
          markdown = true,
          help = false,
          gitcommit = false,
          gitrebase = false,
          hgcommit = false,
          svn = false,
          cvs = false,
          ["."] = false,
        },
      })

      --------------------------------------------------------------------------------
      -- LSP WARNINGS AND ERRORS
      --------------------------------------------------------------------------------

      vim.diagnostic.config({
        float = { border = "rounded" },
      })

      vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float, { silent = true })

      vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { silent = true })
      vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { silent = true })

      --------------------------------------------------------------------------------
      -- AUTO FORMAT ON SAVE
      --------------------------------------------------------------------------------
      local conform = require("conform")

      conform.setup({
        formatters_by_ft = {
          javascript = { "prettier" },
          typescript = { "prettier" },
          javascriptreact = { "prettier" },
          typescriptreact = { "prettier" },
          html = { "prettier" },
          css = { "prettier" },
          json = { "prettier" },
          python = { "black" },
          rust = { "rustfmt" },
          nix = { "alejandra" },
        },
      })

      vim.keymap.set("n", "<leader>f", function()
        conform.format({
          lsp_fallback = true,
          async = false,
          timeout_ms = 1000,
        })
      end, { desc = "Format entire file" })

      --------------------------------------------------------------------------------
      -- GLOBAL INDENTATION RULES
      --------------------------------------------------------------------------------

      vim.opt.expandtab = true
      vim.opt.shiftwidth = 4
      vim.opt.tabstop = 4

      vim.api.nvim_create_autocmd("FileType", {
        pattern = {
          "javascript", "typescript", "javascriptreact", "typescriptreact",
          "html", "css", "json", "nix", "yaml", "markdown"
        },
        callback = function()
          vim.opt_local.shiftwidth = 2
          vim.opt_local.tabstop = 2
        end,
      })
    '';
  };
}
