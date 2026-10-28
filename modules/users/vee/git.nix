{
  inputs,
  lib,
  ...
}:
{
  perSystem =
    { pkgs, ... }:
    let
      # Catppuccin palettes for delta; defines the `catppuccin-mocha` feature.
      deltaTheme = builtins.fetchurl {
        url = "https://raw.githubusercontent.com/catppuccin/delta/011516f5d14f66b771b3e716f29c77231e008c74/catppuccin.gitconfig";
        sha256 = "0mdlccyzjzlidiwilbd1fi233v5bmfi1cldj32vnfdqydgd0ln7h";
      };

      globalIgnore = pkgs.writeText "gitignore_global" ''
        **/.claude/settings.local.json
      '';

      gitconfig = pkgs.writeText "gitconfig" (
        lib.generators.toGitINI {
          include.path = toString deltaTheme;
          core = {
            excludesfile = toString globalIgnore;
            pager = "delta";
          };
          interactive.diffFilter = "delta --color-only";
          delta = {
            features = "catppuccin-mocha";
            side-by-side = true;
            line-numbers = true;
            navigate = true;
            hyperlinks = true;
            hyperlinks-file-link-format = "file://{path}#{line}";
            whitespace-error-style = "22 reverse";
            file-added-label = "[added]";
            file-copied-label = "[copied]";
            file-modified-label = "[modified]";
            file-removed-label = "[removed]";
            file-renamed-label = "[renamed]";
            word-diff-regex = ".";
            max-line-distance = "0.6";
            max-line-length = 512;
            line-numbers-left-format = "{nm:>4}┊";
            line-numbers-right-format = "{np:>4}│";
            blame-code-style = "syntax";
            blame-format = "{author:<18} ({commit:>7}) {timestamp:<16} │ ";
            blame-timestamp-format = "%Y-%m-%d %H:%M";
            inspect-raw-lines = false;
            color-moved = "default";
            color-moved-ws = "allow-indent-change";
            minus-empty-line-marker-style = "normal";
            plus-empty-line-marker-style = "normal";
            keep-plus-minus-markers = false;
          };
          diff.tool = "delta";
          difftool = {
            prompt = false;
            delta.cmd = "delta \"$LOCAL\" \"$REMOTE\"";
          };
          merge.tool = "delta";
          mergetool = {
            prompt = false;
            delta.cmd = "delta \"$LOCAL\" \"$MERGED\" \"$REMOTE\" --side-by-side";
          };
        }
      );
    in
    {
      packages.git-vee = inputs.wrapper-modules.lib.wrapPackage {
        inherit pkgs;
        package = pkgs.git;
        runtimePkgs = [ pkgs.delta ];
        env = rec {
          GIT_AUTHOR_NAME = "Version33";
          GIT_AUTHOR_EMAIL = "vee@versionthirtythr.ee";
          GIT_COMMITTER_NAME = GIT_AUTHOR_NAME;
          GIT_COMMITTER_EMAIL = GIT_AUTHOR_EMAIL;
          # Replaces ~/.gitconfig and ~/.config/git/config; `git config
          # --global` writes fail (store path) — edit this file instead.
          GIT_CONFIG_GLOBAL = toString gitconfig;
        };
      };
    };
}
