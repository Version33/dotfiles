{

  flake.modules.neovim.ui = {
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
        # "auto" lets catppuccin register its lualine theme after the colorscheme loads.
        # Setting "catppuccin" directly causes a LualineNotices warning because lualine
        # validates the theme name before catppuccin has had a chance to register it.
        theme = "auto";
        globalStatus = true;

        # Separator style. nvf's default components hardcode powerline slants
        # (U+E0BA/U+E0BC on the left half, U+E0BE/U+E0B8 on the right), so the
        # only way to change them is to restate the sections. These are those
        # defaults with the slants swapped for powerline arrows:  (U+E0B0)
        # pointing right on the left half,  (U+E0B2) pointing left on the right.
        activeSection = {
          a = [
            ''
              {
                "mode",
                icons_enabled = true,
                separator = {
                  left = '▎',
                  right = ''
                },
              }
            ''
            ''
              {
                "",
                draw_empty = true,
                separator = { left = '', right = '' }
              }
            ''
          ];
          b = [
            ''
              {
                "filetype",
                colored = true,
                icon_only = true,
                icon = { align = 'left' }
              }
            ''
            ''
              {
                "filename",
                symbols = {modified = ' ', readonly = ' '},
                separator = {right = ''}
              }
            ''
            ''
              {
                "",
                draw_empty = true,
                separator = { left = '', right = '' }
              }
            ''
          ];
          c = [
            ''
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
            ''
          ];
          x = [
            ''
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
            ''
            ''
              {
                "diagnostics",
                sources = { "nvim_lsp", "nvim_diagnostic" },
                symbols = { error = " ", warn = " ", info = " ", hint = " " },
                colored = true,
                update_in_insert = false,
                always_visible = false,
              }
            ''
          ];
          y = [
            ''
              {
                "",
                draw_empty = true,
                separator = { left = '', right = '' }
              }
            ''
            ''
              {
                'searchcount',
                maxcount = 999,
                timeout = 120,
                separator = {left = ''}
              }
            ''
            ''
              {
                "branch",
                icon = ' •',
                separator = {left = ''}
              }
            ''
          ];
          z = [
            ''
              {
                "",
                draw_empty = true,
                separator = { left = '', right = '' }
              }
            ''
            ''
              {
                "progress",
                separator = {left = ''}
              }
            ''
            ''
              {"location"}
            ''
            ''
              {
                "fileformat",
                color = {fg='black'},
                symbols = {
                  unix = '',
                  dos = '',
                  mac = '',
                }
              }
            ''
          ];
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
        # keymaps/tools.nix defines the single LazyVim-style Trouble scheme;
        # null nvf's defaults so there is only one scheme, not two.
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
                  action = ":lua require('fzf-lua').files({ cwd = vim.fs.normalize('~/nixos/modules/wrapped/neovim') })";
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
