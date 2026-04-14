{ inputs, ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      packages.git = inputs.wrapper-modules.lib.wrapPackage {
        inherit pkgs;
        package = pkgs.git;
        env = rec {
          GIT_AUTHOR_NAME = "Version33";
          GIT_AUTHOR_EMAIL = "vee@versionthirtythr.ee";
          GIT_COMMITTER_NAME = GIT_AUTHOR_NAME;
          GIT_COMMITTER_EMAIL = GIT_AUTHOR_EMAIL;
        };
      };
    };

}
