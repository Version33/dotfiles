{
  flake.modules.neovim.options = {
    config.vim = {
      viAlias = true;
      vimAlias = true;

      lineNumberMode = "relNumber";
      searchCase = "smart"; # sets ignorecase + smartcase
      hideSearchHighlight = true;
      preventJunkFiles = true;
      enableLuaLoader = true;

      # Clipboard — skip if in SSH (OSC 52 handles it there)
      clipboard = {
        enable = true;
        registers = "unnamedplus";
        providers.wl-copy.enable = true;
      };

      options = {
        # Indentation
        expandtab = true;
        shiftwidth = 2;
        tabstop = 2;
        softtabstop = 2;
        smartindent = true;
        shiftround = true;

        # UI
        termguicolors = true;
        signcolumn = "yes";
        cursorline = true;
        scrolloff = 4;
        sidescrolloff = 8;
        wrap = false;
        linebreak = true;
        splitbelow = true;
        splitright = true;
        splitkeep = "screen";
        laststatus = 3; # global statusline
        showmode = false; # lualine shows mode
        ruler = false;
        winminwidth = 5;
        pumblend = 10;
        pumheight = 10;
        smoothscroll = true;

        # Search
        inccommand = "nosplit";
        grepformat = "%f:%l:%c:%m";
        grepprg = "rg --vimgrep";

        # Completion
        completeopt = "menu,menuone,noselect";

        # Timing
        timeoutlen = 300;
        updatetime = 200;

        # Folds — treesitter expr-based (set by treesitter.fold = true), open by default
        foldlevel = 99;
        foldtext = "";

        # Editing
        autowrite = true;
        confirm = true;
        virtualedit = "block";
        undofile = true;
        undolevels = 10000;
        mouse = "a";
        jumpoptions = "view";
        formatoptions = "jcroqlnt";
        conceallevel = 2;
        list = true; # show some invisible chars (tabs, trailing spaces)
        wildmode = "longest:full,full";

        # Spelling — string form for vim.o compatibility
        spelllang = "en";
      };

      globals = {
        mapleader = " ";
        maplocalleader = "\\";
        autoformat = true;
        snacks_animate = true;
        deprecation_warnings = false;
        trouble_lualine = true;
        markdown_recommended_style = 0;
        lazyvim_cmp = "blink.cmp";
        lazyvim_picker = "fzf-lua";
        root_spec = ''{ "lsp", { ".git", "lua" }, "cwd" }'';
        root_lsp_ignore = "{}";
        ai_cmp = false;
        # Disable unused providers
        loaded_node_provider = 0;
        loaded_perl_provider = 0;
        loaded_python3_provider = 0;
        loaded_ruby_provider = 0;
      };

      # Options that need vim.opt method calls rather than assignment
      luaConfigRC.lazyvim-options = builtins.readFile ./lua/options.lua;
    };
  };
}
