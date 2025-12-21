{ username, ... }:

{
  system = "x86_64-linux";

  specialArgs = { inherit username; };

  modules = [
    ./configuration.nix
  ];
}
