{ config
, inputs
, lib
, ...
}:

{
  imports = [ inputs.daeuniverse.nixosModules.dae ];

  services.dae = {
    enable = true;
    configFile = "/etc/dae/config.dae";
  };

  systemd.services.dae =
    lib.mkIf ((builtins.hasAttr "buaa-login" config.services) && config.services.buaa-login.enable)
      {
        after = [ "buaa-login.service" ];
        wants = [ "buaa-login.service" ];
      };

  environment.etc."dae/config.dae" = {
    source = ../../configs/dae/config.dae;
    mode = "0600";
  };
}
