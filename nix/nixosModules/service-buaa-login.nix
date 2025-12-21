{ inputs
, ...
}:

{
  imports = [ inputs.buaa-login.nixosModules.default ];

  services.buaa-login = {
    enable = true;
    configFile = "/etc/buaa-login/conf";
    interval = "15min";
  };
}
