{ inputs
, ...
}:

{
  imports = [ inputs.buaa-login.nixosModules.buaa-login ];

  services.buaa-login = {
    enable = true;
    configFile = "/etc/buaa-login/conf";
    interval = "15min";
  };
}
