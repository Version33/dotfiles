{
  flake.modules.nixos.users-firefox =
    { pkgs, ... }:
    {
      programs.firefox = {
        enable = true;
        preferences = {
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
          "extensions.activeThemeID" = "{76aabc99-c1a8-4c1e-832b-d4f2941d5a7a}";
        };

        policies = {
          ExtensionSettings = {
            "{76aabc99-c1a8-4c1e-832b-d4f2941d5a7a}" = {
              installation_mode = "normal_installed";
              install_url = "https://addons.mozilla.org/firefox/downloads/file/3990325/catppuccin_mocha_mauve_git-2.0.xpi";
            };
            "uBlock0@raymondhill.net" = {
              installation_mode = "normal_installed";
              install_url = "https://addons.mozilla.org/firefox/downloads/file/4721638/ublock_origin-1.70.0.xpi";
            };
            "addon@darkreader.org" = {
              installation_mode = "normal_installed";
              install_url = "https://addons.mozilla.org/firefox/downloads/file/4783321/darkreader-4.9.125.xpi";
            };
            "jid1-ZAdIEUB7XOzOJw@jetpack" = {
              installation_mode = "normal_installed";
              install_url = "https://addons.mozilla.org/firefox/downloads/file/4785961/duckduckgo_for_firefox-2026.4.28.xpi";
            };
            "{762f9885-5a13-4abd-9c77-433dcd38b8fd}" = {
              installation_mode = "normal_installed";
              install_url = "https://addons.mozilla.org/firefox/downloads/file/4371820/return_youtube_dislikes-3.0.0.18.xpi";
            };
            "sponsorBlocker@ajay.app" = {
              installation_mode = "normal_installed";
              install_url = "https://addons.mozilla.org/firefox/downloads/file/4773757/sponsorblock-6.1.5.xpi";
            };
            "{74145f27-f039-47ce-a470-a662b129930a}" = {
              installation_mode = "normal_installed";
              install_url = "https://addons.mozilla.org/firefox/downloads/file/4432106/clearurls-1.27.3.xpi";
            };
            "{DDC359D1-844A-42a7-9AA1-88A850A938A8}" = {
              installation_mode = "normal_installed";
              install_url = "https://addons.mozilla.org/firefox/downloads/file/4628327/downthemall-4.14.2.xpi";
            };
            "extension@one-tab.com" = {
              installation_mode = "normal_installed";
              install_url = "https://addons.mozilla.org/firefox/downloads/file/4713960/onetab-2.13.xpi";
            };
            "treestyletab@piro.sakura.ne.jp" = {
              installation_mode = "normal_installed";
              install_url = "https://addons.mozilla.org/firefox/downloads/file/4781258/tree_style_tab-4.3.4.xpi";
            };
            "{7a7a4a92-a2a0-41d1-9fd7-1e92480d612d}" = {
              installation_mode = "normal_installed";
              install_url = "https://addons.mozilla.org/firefox/downloads/file/4786206/styl_us-2.3.22.xpi";
            };
            "firefox-extension@steamdb.info" = {
              installation_mode = "normal_installed";
              install_url = "https://addons.mozilla.org/firefox/downloads/file/4704123/steam_database-4.33.xpi";
            };
            "@contain-facebook" = {
              installation_mode = "normal_installed";
              install_url = "https://addons.mozilla.org/firefox/downloads/file/4451874/facebook_container-2.3.12.xpi";
            };
            "firefox@tampermonkey.net" = {
              installation_mode = "normal_installed";
              install_url = "https://addons.mozilla.org/firefox/downloads/file/4624137/tampermonkey-5.4.1.xpi";
            };
            "webextension@metamask.io" = {
              installation_mode = "normal_installed";
              install_url = "https://addons.mozilla.org/firefox/downloads/file/4785425/ether_metamask-13.28.0.xpi";
            };
            "78272b6fa58f4a1abaac99321d503a20@proton.me" = {
              installation_mode = "normal_installed";
              install_url = "https://addons.mozilla.org/firefox/downloads/file/4768005/proton_pass-1.36.1.xpi";
            };
            "plasma-browser-integration@kde.org" = {
              installation_mode = "normal_installed";
              install_url = "https://addons.mozilla.org/firefox/downloads/file/4614817/plasma_integration-2.1.xpi";
            };
            "adnauseam@rednoise.org" = {
              installation_mode = "normal_installed";
              install_url = "https://addons.mozilla.org/firefox/downloads/file/4756689/adnauseam-3.28.4.xpi";
            };
            "{6ea0a676-b3ef-48aa-b23d-24c8876945fb}" = {
              installation_mode = "normal_installed";
              install_url = "https://addons.mozilla.org/firefox/downloads/file/4491885/w2g-10.8.xpi";
            };
            "deArrow@ajay.app" = {
              installation_mode = "normal_installed";
              install_url = "https://addons.mozilla.org/firefox/downloads/file/4777329/dearrow-2.3.6.xpi";
            };
            "savepage-we@DW-dev" = {
              installation_mode = "normal_installed";
              install_url = "https://addons.mozilla.org/firefox/downloads/file/4091842/save_page_we-28.11.xpi";
            };
            "{2766e9f7-7bf2-4c72-81b9-d119eb54c753}" = {
              installation_mode = "normal_installed";
              install_url = "https://addons.mozilla.org/firefox/downloads/file/4111257/remove_youtube_shorts-1.2.1.xpi";
            };
            "skipredirect@sblask" = {
              installation_mode = "normal_installed";
              install_url = "https://addons.mozilla.org/firefox/downloads/file/3920533/skip_redirect-2.3.6.xpi";
            };
            "jid0-3GUEt1r69sQNSrca5p8kx9Ezc3U@jetpack" = {
              installation_mode = "normal_installed";
              install_url = "https://addons.mozilla.org/firefox/downloads/file/4464742/terms_of_service_didnt_read-5.1.1.xpi";
            };
            "privacy@privacy.com" = {
              installation_mode = "normal_installed";
              install_url = "https://addons.mozilla.org/firefox/downloads/file/4512297/pay_by_privacy-2.4.15.xpi";
            };
            "genericredirector@ark.wiki.gg" = {
              installation_mode = "normal_installed";
              install_url = "https://addons.mozilla.org/firefox/downloads/file/4583845/redirect_to_wiki_gg-1.8.2.xpi";
            };
            "jid1-0dhOSYKGj326og@jetpack" = {
              installation_mode = "normal_installed";
              install_url = "https://addons.mozilla.org/firefox/downloads/file/4270656/web_paint-1.2.7resigned1.xpi";
            };
            "{5f4e7d3d-9e51-459e-9dab-2a2a70415ae7}" = {
              installation_mode = "normal_installed";
              install_url = "https://addons.mozilla.org/firefox/downloads/file/3509008/bing_2_google-1.7.xpi";
            };
            "materialdesignicons-picker@s-quent.in" = {
              installation_mode = "normal_installed";
              install_url = "https://addons.mozilla.org/firefox/downloads/file/4451171/materialdesignicons_picker-3.14.1.xpi";
            };
          };
        };
      };

      systemd.user.services.firefox-userchrome = {
        description = "Deploy userChrome.css to Firefox profile";
        wantedBy = [ "default.target" ];
        serviceConfig = {
          Type = "oneshot";
          ExecStart = toString (
            pkgs.writeShellScript "firefox-userchrome" ''
              export PATH="${pkgs.coreutils}/bin"
              PROFILE_DIR=$(ls -d "$HOME"/.mozilla/firefox/*.default 2>/dev/null | head -1)
              if [ -n "$PROFILE_DIR" ]; then
                mkdir -p "$PROFILE_DIR/chrome"
                cp -f ${./userChrome.css} "$PROFILE_DIR/chrome/userChrome.css"
              fi
            ''
          );
        };
      };
    };
}
