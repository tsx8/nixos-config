{ pkgs
, inputs
, username
, ...
}:

{
  imports = [
    inputs.sops-nix.nixosModules.sops
    inputs.home-manager.nixosModules.home-manager
  ];

  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 6;
      };
      efi.canTouchEfiVariables = true;
    };
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    auto-optimise-store = true;
  };

  nixpkgs.config.allowUnfree = true;

  networking.networkmanager.enable = true;

  time.timeZone = "Asia/Shanghai";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "zh_CN.UTF-8";
    LC_IDENTIFICATION = "zh_CN.UTF-8";
    LC_MEASUREMENT = "zh_CN.UTF-8";
    LC_MONETARY = "zh_CN.UTF-8";
    LC_NAME = "zh_CN.UTF-8";
    LC_NUMERIC = "zh_CN.UTF-8";
    LC_PAPER = "zh_CN.UTF-8";
    LC_TELEPHONE = "zh_CN.UTF-8";
    LC_TIME = "zh_CN.UTF-8";
  };

  environment.systemPackages = with pkgs; [
    vim
  ];

  users.users.${username} = {
    isNormalUser = true;
    description = "tsxb";
    extraGroups = [
      "networkmanager"
      "wheel"
      "uinput"
    ];
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
    extraSpecialArgs = { inherit inputs username; };
    users.${username} = {
      home = {
        inherit username;
        homeDirectory = "/home/${username}";
        stateVersion = "25.11";
      };
    };
  };

  services.openssh = {
    enable = true;
    hostKeys = [
      {
        type = "ed25519";
        path = "/etc/ssh/ssh_host_ed25519_key";
      }
    ];
  };

  sops = {
    defaultSopsFile = ../../secrets/secrets.yaml;
    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    secrets = {
      buaa-login-conf = {
        path = "/etc/buaa-login/conf";
        mode = "0600";
      };
      github-ssh-key = {
        path = "/home/${username}/.ssh/id_github";
        owner = username;
        mode = "0600";
      };
      dae-sub = {
        path = "/etc/dae/sub.dae";
        mode = "0600";
      };
    };
  };

  environment.variables.EDITOR = "vim";

  fonts = {
    fontDir.enable = true;
    packages = with pkgs; [
      font-awesome
      nerd-fonts.symbols-only
      nerd-fonts.jetbrains-mono
      noto-fonts
      noto-fonts-color-emoji
      source-sans
      source-serif
      source-han-sans
      source-han-serif
      source-han-mono
      lxgw-wenkai-screen
      maple-mono.NF-CN
    ];
    fontconfig = {
      defaultFonts = {
        serif = [
          "Source Serif 4"
          "Source Han Serif SC"
        ];
        sansSerif = [
          "Source Sans 3"
          "LXGW WenKai Screen"
          "Source Han Sans SC"
        ];
        monospace = [
          "Maple Mono NF CN"
          "JetBrainsMono Nerd Font"
        ];
        emoji = [ "Noto Color Emoji" ];
      };
      antialias = true;
      subpixel.rgba = "rgb";
    };
  };
}
