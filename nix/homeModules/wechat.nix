{ pkgs, ... }:

let
  isCI = (builtins.getEnv "GITHUB_ACTIONS") == "true";
  wechatDesktopContent = builtins.readFile ../../configs/wechat/wechat.desktop;

  wechatStub = pkgs.runCommand "wechat-stub" { } ''
    mkdir -p $out/share/applications
    echo '${wechatDesktopContent}' > $out/share/applications/wechat.desktop
  '';

  wechatReal = pkgs.wechat.overrideAttrs (oldAttrs: {
    buildCommand = (oldAttrs.buildCommand or "") + ''
      rm $out/share/applications/wechat.desktop
      mkdir -p $out/share/applications
      echo '${wechatDesktopContent}' > $out/share/applications/wechat.desktop
    '';
  });
in
{
  home.packages = [ (if isCI then wechatStub else wechatReal) ];
}
