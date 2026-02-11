{ pkgs, ... }:

let
  isCI = (builtins.getEnv "GITHUB_ACTIONS") == "true";
  wechatDesktopContent = builtins.readFile ../../configs/wechat/wechat.desktop;

  wechatDesktopFile = pkgs.writeText "wechat.desktop" wechatDesktopContent;

  wechatStub = pkgs.runCommand "wechat-stub" { } ''
    mkdir -p $out/share/applications
    cp ${wechatDesktopFile} $out/share/applications/wechat.desktop
  '';

  wechatReal = pkgs.wechat.overrideAttrs (oldAttrs: {
    buildCommand = (oldAttrs.buildCommand or "") + ''
      rm -f $out/share/applications/wechat.desktop
      mkdir -p $out/share/applications
      cp ${wechatDesktopFile} $out/share/applications/wechat.desktop
    '';
  });
in
{
  home.packages = [ (if isCI then wechatStub else wechatReal) ];
}
