{ config
, inputs
, lib
, ...
}:

let
  buaaLoginEnabled = lib.attrByPath [ "services" "buaa-login" "enable" ] false config;
in
{
  imports = [ inputs.daeuniverse.nixosModules.dae ];

  services.dae = {
    enable = true;
    configFile = "/etc/dae/config.dae";
  };

  systemd.services.dae = lib.mkIf buaaLoginEnabled {
    after = [ "buaa-login.service" ];
    wants = [ "buaa-login.service" ];
  };

  environment.etc."dae/config.dae" = {
    source = ../../configs/dae/config.dae;
    mode = "0600";
  };
}
