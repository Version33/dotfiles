{

  flake.modules.neovim.ui = { lib, ... }: {
    config.vim = {
      # LazyVim: nvim-mini/mini.icons
      mini.icons.enable = true;

      # LazyVim: akinsho/bufferline.nvim
      tabline.nvimBufferline = {
        enable = true;
        mappings = {
          cycleNext = "<S-l>";
          cyclePrevious = "<S-h>";
        };
        setupOpts.options.numbers = "none";
      };

      # LazyVim: nvim-lualine/lualine.nvim
      statusline.lualine = {
        enable = true;
        # "auto", not "catppuccin": setting the theme directly races catppuccin's
        # registration and trips a LualineNotices validation warning.
        setupOpts = {
          options = {
            theme = "auto";
            globalstatus = true;
          };

          # nvf hardcodes powerline-slant separators per section (U+E0BA/BC left,
          # U+E0BE/B8 right) with no standalone option, so overriding means restating
          # every section. Below: same layout, slants swapped for arrows U+E0B0/U+E0B2.
          sections = {
            lualine_a = [
              (lib.mkLuaInline ''
                {
                  "mode",
                  icons_enabled = true,
                  separator = {
                    left = '▎',
                    right = ''
                  },
                }
              '')
              (lib.mkLuaInline ''
                {
                  "",
                  draw_empty = true,
                  separator = { left = '', right = '' }
                }
              '')
            ];
            lualine_b = [
              (lib.mkLuaInline ''
                {
                  "filetype",
                  colored = true,
                  icon_only = true,
                  icon = { align = 'left' }
                }
              '')
              (lib.mkLuaInline ''
                {
                  "filename",
                  symbols = {modified = ' ', readonly = ' '},
                  separator = {right = ''}
                }
              '')
              (lib.mkLuaInline ''
                {
                  "",
                  draw_empty = true,
                  separator = { left = '', right = '' }
                }
              '')
            ];
            lualine_c = [
              (lib.mkLuaInline ''
                {
                  "diff",
                  colored = false,
                  diff_color = {
                    added    = 'DiffAdd',
                    modified = 'DiffChange',
                    removed  = 'DiffDelete',
                  },
                  symbols = {added = '+', modified = '~', removed = '-'},
                  separator = {right = ''}
                }
              '')
            ];
            lualine_x = [
              (lib.mkLuaInline ''
                {
                  function()
                    local clients = vim.lsp.get_clients({ bufnr = 0 })
                    if vim.tbl_isempty(clients) then return "" end
                    local names = {}
                    for _, c in ipairs(clients) do table.insert(names, c.name) end
                    return table.concat(names, ", ")
                  end,
                  icon = " ",
                  color = { fg = "#ffffff", gui = "bold" },
                }
              '')
              (lib.mkLuaInline ''
                {
                  "diagnostics",
                  sources = { "nvim_lsp", "nvim_diagnostic" },
                  symbols = { error = " ", warn = " ", info = " ", hint = " " },
                  colored = true,
                  update_in_insert = false,
                  always_visible = false,
                }
              '')
            ];
            lualine_y = [
              (lib.mkLuaInline ''
                {
                  "",
                  draw_empty = true,
                  separator = { left = '', right = '' }
                }
              '')
              (lib.mkLuaInline ''
                {
                  'searchcount',
                  maxcount = 999,
                  timeout = 120,
                  separator = {left = ''}
                }
              '')
              (lib.mkLuaInline ''
                {
                  "branch",
                  icon = ' •',
                  separator = {left = ''}
                }
              '')
            ];
            lualine_z = [
              (lib.mkLuaInline ''
                {
                  "",
                  draw_empty = true,
                  separator = { left = '', right = '' }
                }
              '')
              (lib.mkLuaInline ''
                {
                  "progress",
                  separator = {left = ''}
                }
              '')
              (lib.mkLuaInline ''
                {"location"}
              '')
              (lib.mkLuaInline ''
                {
                  "fileformat",
                  color = {fg='black'},
                  symbols = {
                    unix = '',
                    dos = '',
                    mac = '',
                  }
                }
              '')
            ];
          };
        };
      };

      # LazyVim: folke/noice.nvim
      ui.noice = {
        enable = true;
        setupOpts = {
          lsp.override = {
            "vim.lsp.util.convert_input_to_markdown_lines" = true;
            "vim.lsp.util.stylize_markdown" = true;
            "cmp.entry.get_documentation" = true;
          };
          routes = [
            {
              filter = {
                event = "msg_show";
                any = [
                  { find = "%d+L, %d+B"; }
                  { find = "; after #%d+"; }
                  { find = "; before #%d+"; }
                ];
              };
              view = "mini";
            }
          ];
          presets = {
            bottom_search = true;
            command_palette = true;
            long_message_to_split = true;
          };
        };
      };

      # LazyVim: folke/trouble.nvim
      lsp.trouble = {
        enable = true;
        # keymaps/tools.nix defines the Trouble keymap scheme; null nvf's so they don't duplicate.
        mappings = {
          workspaceDiagnostics = null;
          documentDiagnostics = null;
          lspReferences = null;
          quickfix = null;
          locList = null;
          symbols = null;
        };
      };

      # fzf-lua: primary fuzzy finder (preferred over telescope)
      fzf-lua = {
        enable = true;
        profile = "fzf-native";
      };

      # LazyVim: folke/snacks.nvim
      # Picker disabled — fzf-lua handles all finding
      utility.snacks-nvim = {
        enable = true;
        setupOpts = {
          bigfile = {
            enabled = true;
          }; # perf: disable features on large files
          quickfile = {
            enabled = true;
          }; # fast file rendering
          indent = {
            enabled = true;
          };
          input = {
            enabled = true;
          };
          notifier = {
            enabled = true;
          }; # snacks handles notifications
          picker = {
            enabled = false;
          }; # using fzf-lua
          explorer = {
            enabled = true;
          };
          scope = {
            enabled = true;
          };
          scroll = {
            enabled = true;
          };
          rename = {
            enabled = true;
          };

          # Dashboard — explicit sections to avoid lazy.stats reference
          dashboard = {
            enabled = true;
            preset = {
              header = builtins.concatStringsSep "\n" [
                "                                                                     "
                "       ████ ██████           █████      ██                     "
                "      ███████████             █████                             "
                "      █████████ ███████████████████ ███   ███████████   "
                "     █████████  ███    █████████████ █████ ██████████████   "
                "    █████████ ██████████ █████████ █████ █████ ████ █████   "
                "  ███████████ ███    ███ █████████ █████ █████ ████ █████  "
                " ██████  █████████████████████ ████ █████ █████ ████ ██████ "
                "                                                                       "
              ];
              keys = [
                {
                  icon = " ";
                  key = "f";
                  desc = "Find File";
                  action = ":lua require('fzf-lua').files()";
                }
                {
                  icon = " ";
                  key = "n";
                  desc = "New File";
                  action = ":ene | startinsert";
                }
                {
                  icon = " ";
                  key = "g";
                  desc = "Find Text";
                  action = ":lua require('fzf-lua').live_grep()";
                }
                {
                  icon = " ";
                  key = "r";
                  desc = "Recent Files";
                  action = ":lua require('fzf-lua').oldfiles()";
                }
                {
                  icon = " ";
                  key = "c";
                  desc = "Config";
                  action = ":lua require('fzf-lua').files({ cwd = vim.fs.normalize('~/nixos/modules/packages/neovim') })";
                }
                {
                  icon = "󰦛 ";
                  key = "s";
                  desc = "Restore Session";
                  action = ":lua require('persistence').load()";
                }
                {
                  icon = " ";
                  key = "q";
                  desc = "Quit";
                  action = ":qa";
                }
              ];
            };
            # Omit "startup" section which requires lazy.stats
            sections = [
              { section = "header"; }
              {
                section = "keys";
                gap = 1;
                padding = 1;
              }
            ];
          };
        };
      };
    };
  };

}
