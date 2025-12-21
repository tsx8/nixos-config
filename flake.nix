{
  description = "NixOS Flake Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    flakelight.url = "github:nix-community/flakelight";

    statix.url = "github:oppiliappan/statix";

    daeuniverse.url = "github:daeuniverse/flake.nix";
    buaa-login.url = "github:tsx8/buaa-login";
    nixos-cli.url = "github:nix-community/nixos-cli";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { self, flakelight, ... }@inputs:
    let
      username = "tsxb";
    in
    flakelight ./. {
      _module.args = {
        inherit username;
      };
      inherit inputs;
      systems = [ "x86_64-linux" ];

      checks = pkgs: {
        statix = "${pkgs.statix}/bin/statix check";
      };
    };
}
