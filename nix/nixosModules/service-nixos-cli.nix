{ inputs
, pkgs
, ...
}:

{
  imports = [ inputs.nixos-cli.nixosModules.nixos-cli ];

  environment.systemPackages = with pkgs; [
    nix-output-monitor
    nvd
  ];

  services.nixos-cli = {
    enable = true;
    config = {
      use_nvd = true;
      apply.use_nom = true;
    };
  };
}
