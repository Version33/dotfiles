{
  flake.modules.neovim.editor =
    { lib, pkgs, ... }:
    let
      # Not packaged in nixpkgs' vimPlugins (IogaMaster/tuxedo.nvim), so build it here.
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
        # Basic options only; which-key v3's spec format mixes positional and named
        # keys ({ lhs, group=, icon= }) which toLuaObject can't emit, so the full
        # spec lives in luaConfigRC below instead.
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

        # Same toLuaObject limitation as above (mixed positional/dict tables) —
        # the which-key icon spec needs real Lua, not a Nix attrset.
        luaConfigRC.whichkey-groups = lib.nvim.dag.entryAfter [ "pluginConfigs" ] (
          builtins.readFile ./lua/whichkey-groups.lua
        );

        # webstonehq/tuxedo TUI: it calls a bare `tuxedo` via termopen, so putting the
        # package in extraPackages (added to nvim's PATH) is enough — no system install.
        extraPackages = [ pkgs.tuxedo ];

        # :Tuxedo opens a centred float; no `setup` call needed here since the plugin's
        # own plugin/tuxedo.lua already calls setup() with its defaults.
        extraPlugins.tuxedo-nvim.package = tuxedo-nvim;
      };
    };
}
