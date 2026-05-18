{
  inputs,
  ...
}:
{
  perSystem =
    { pkgs, ... }:
    {
      packages.git-angel = inputs.wrapper-modules.lib.wrapPackage {
        inherit pkgs;
        package = pkgs.git;
        env = rec {
          GIT_AUTHOR_NAME = "Angel";
          GIT_AUTHOR_EMAIL = "angel@example.com";
          GIT_COMMITTER_NAME = GIT_AUTHOR_NAME;
          GIT_COMMITTER_EMAIL = GIT_AUTHOR_EMAIL;
        };
      };
    };
}
