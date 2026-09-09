{
  flake.modules.neovim.editor =
    { lib, pkgs, ... }:
    let
      # IogaMaster/tuxedo.nvim — floating-window wrapper around the tuxedo
      # todo.txt TUI. Not packaged in nixpkgs' vimPlugins, so build it here.
      tuxedo-nvim = pkgs.vimUtils.buildVimPlugin {
        pname = "tuxedo.nvim";
        version = "0-unstable-2026-06-11";
        src = pkgs.fetchFromGitHub {
          owner = "IogaMaster";
          repo = "tuxedo.nvim";
          rev = "65650b0ae3b1c3755a43306b07ada13bd78d47ac";
          hash = "sha256-e8Vk2QvMNDDpYCiTWwm5IgDlDhVKj2g+kNHpLbkYGx4=";
        };
        meta.homepage = "https://github.com/IogaMaster/tuxedo.nvim";
      };
    in
    {
      config.vim = {
        # LazyVim: folke/which-key.nvim
        # Only set basic options here — spec is in luaConfigRC below because
        # which-key v3 expects positional mixed-tables ({ lhs, group=, icon= })
        # which toLuaObject cannot represent (it only produces pure dicts).
        binds.whichKey = {
          enable = true;
          setupOpts = {
            preset = "helix";
            notify = false;
          };
        };

        # LazyVim: folke/todo-comments.nvim
        notes.todo-comments.enable = true;

        # LazyVim: folke/flash.nvim
        utility.motion.flash-nvim.enable = true;

        # LazyVim: MagicDuck/grug-far.nvim
        utility.grug-far-nvim = {
          enable = true;
          setupOpts.headerMaxWidth = 80;
        };

        # which-key group spec with icons — must be Lua because the format
        # { "<leader>s", group = "search", icon = "…" } is a mixed array/dict
        # that Nix attrsets cannot produce via toLuaObject.
        luaConfigRC.whichkey-groups = lib.nvim.dag.entryAfter [ "pluginConfigs" ] (
          builtins.readFile ./lua/whichkey-groups.lua
        );

        # webstonehq/tuxedo — the TUI the plugin drives. It calls a bare
        # `tuxedo` through termopen, and nvf appends extraPackages to nvim's
        # PATH, so this resolves without installing the binary system-wide.
        extraPackages = [ pkgs.tuxedo ];

        # :Tuxedo opens todo.txt in a centred float. No `setup` here: the
        # plugin's own plugin/tuxedo.lua already calls setup() with the
        # defaults (create_todo_file, 0.95 x 0.80) and nvf puts plugins
        # straight on the rtp.
        extraPlugins.tuxedo-nvim.package = tuxedo-nvim;
      };
    };
}
