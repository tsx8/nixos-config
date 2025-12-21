{ pkgs, ... }:

let
  wechatDesktopContent = builtins.readFile ../../configs/wechat/wechat.desktop;
in
{
  home.packages = [
    (pkgs.wechat.overrideAttrs (oldAttrs: {
      buildCommand = (oldAttrs.buildCommand or "") + ''
        rm $out/share/applications/wechat.desktop
        mkdir -p $out/share/applications
        echo '${wechatDesktopContent}' > $out/share/applications/wechat.desktop
      '';
    }))
  ];
}
