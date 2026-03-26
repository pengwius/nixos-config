{
  inputs,
  pkgs,
  ...
}:
{

  imports = [ inputs.mnw.homeManagerModules.default ];
  config = {

    programs.mnw = {
      enable = true;

      initLua = ''
        vim.opt.rtp:prepend(vim.fn.stdpath("config"))
        require("config.lazy")
      '';

      plugins = {
        start = [
          pkgs.vimPlugins.lazy-nvim
          pkgs.vimPlugins.LazyVim
          pkgs.vimPlugins.catppuccin-nvim
        ];

        opt = with pkgs.vimPlugins; [
          bufferline-nvim
          cmp-buffer
          cmp-nvim-lsp
          cmp-path
          cmp_luasnip
          conform-nvim
          dashboard-nvim
          dressing-nvim
          flash-nvim
          friendly-snippets
          gitsigns-nvim
          indent-blankline-nvim
          lualine-nvim
          neo-tree-nvim
          noice-nvim
          nui-nvim
          nvim-cmp
          nvim-lint
          nvim-lspconfig
          nvim-notify
          nvim-spectre
          nvim-treesitter.withAllGrammars
          nvim-treesitter-context
          nvim-treesitter-textobjects
          nvim-ts-autotag
          nvim-ts-context-commentstring
          nvim-web-devicons
          persistence-nvim
          plenary-nvim
          telescope-fzf-native-nvim
          telescope-nvim
          todo-comments-nvim
          tokyonight-nvim
          trouble-nvim
          vim-illuminate
          vim-startuptime
          which-key-nvim

          luasnip
          catppuccin-nvim
          mini-nvim

          vim-wakatime
          copilot-lua
          copilot-cmp
          CopilotChat-nvim
          snacks-nvim

          lazydev-nvim
          render-markdown-nvim
        ];

        dev.config = {
          pure = ./.;
          impure =
            "/' .. vim.uv.cwd()";
        };
      };

      extraBinPath = with pkgs; [
        git
        curl
        ripgrep
        fd
        fzf

        gnumake
        gcc
        unzip

        lua-language-server
        stylua

        nixd
        nixfmt-rfc-style

        cargo
        rustc
        rustfmt
        clippy

        wakatime-cli

        shfmt
        prettierd
        jq
      ];

      aliases = [ "vim" ];
    };
  };
}
