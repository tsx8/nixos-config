{ pkgs, username, ... }:

{

  programs.firefox.enable = true;

  home.packages = with pkgs; [
    sops
    yek
  ];

  programs = {
    ssh = {
      enable = true;
      enableDefaultConfig = false;
      matchBlocks = {
        "github.com" = {
          hostname = "ssh.github.com";
          port = 443;
          user = "git";
          identityFile = "/home/${username}/.ssh/id_github";
        };
        "*" = {
          extraOptions = {
            "AddKeysToAgent" = "yes";
          };
        };
      };
    };
    git = {
      enable = true;
      settings = {
        user = {
          name = "tsx8";
          email = "tangsongxiaoba@163.com";
        };
        init.defaultBranch = "master";
        push.autoSetupRemote = true;
        url."git@github.com:".insteadOf = "https://github.com/";
      };
    };
  };
}
