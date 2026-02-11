{
  description = "NixOS Flake Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";

    flakelight = {
      url = "github:nix-community/flakelight";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    daeuniverse = {
      url = "github:daeuniverse/flake.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    buaa-login = {
      url = "github:tsx8/buaa-login";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-cli = {
      url = "github:nix-community/nixos-cli";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.optnix.inputs.nixpkgs.follows = "nixpkgs";
    };

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
    { flakelight, ... }@inputs:
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
        deadnix = "${pkgs.deadnix}/bin/deadnix --fail flake.nix nix";
      };
    };
}
