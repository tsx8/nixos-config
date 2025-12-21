{ config
, pkgs
, lib
, ...
}:

let
  rime-ice-for-deploy = pkgs.runCommand "rime-ice-with-entrypoint" { } ''
    mkdir -p $out/share/rime-data
    cd $out/share/rime-data
    cp -r ${pkgs.rime-ice}/share/rime-data/* .
    cat > default.yaml << EOF
    schema_list:
      - schema: rime_ice
    EOF
  '';

  deployScript = builtins.readFile ../../configs/rime/deploy.sh;
  customConfig = builtins.readFile ../../configs/rime/default.custom.yaml;
in
{
  xdg.dataFile."fcitx5/rime/default.custom.yaml".text = customConfig;

  home.activation.rimeDeploy = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    export RIME_ICE_PATH="${rime-ice-for-deploy}/share/rime-data"
    export CONFIG_SOURCE="${config.xdg.dataFile."fcitx5/rime/default.custom.yaml".source}"
    export CACHE_HOME="${config.xdg.cacheHome}"
    export DATA_HOME="${config.xdg.dataHome}"

    export LIBRIME_BIN="${pkgs.librime}/bin/rime_deployer"
    export PGREP_BIN="${pkgs.procps}/bin/pgrep"
    export FCITX_REMOTE_BIN="${pkgs.fcitx5}/bin/fcitx5-remote"

    ${deployScript}
  '';
}
