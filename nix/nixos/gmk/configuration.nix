{ inputs
, username
, ...
}:

{
  imports = with inputs.self.nixosModules; [
    ./hardware-configuration.nix
    base
    desktop
    service-buaa-login
    service-dae
    service-kmscon
    service-nixos-cli
    service-sunshine
  ];

  networking.hostName = "gmk";

  home-manager.users.${username}.imports = with inputs.self.homeModules; [
    base
    fcitx5
    rime
    moonlight-qt
    wechat
  ];

  system.stateVersion = "25.11";
}
