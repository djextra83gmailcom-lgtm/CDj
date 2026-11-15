{ config, pkgs, ... }:

{
  imports = [
    # Include the hardware scan generated on your Zenbook during install
    ./hardware-configuration.nix
  ];

  # ============================================================================
  # 1. Bootloader: Limine (Catppuccin Mocha + Triple-Boot Ready)
  # ============================================================================
  boot.loader.limine = {
    enable = true;
    efiSupport = true;
    maxGenerations = 10; # Keep last 10 NixOS generations in boot menu for rollbacks

    extraConfig = ''
      timeout: 5
      interface_branding:   NixOS  |    CachyOS  |    Windows
      interface_branding_colour: 4

      # Catppuccin Mocha Palette
      term_background: 1e1e2e
      term_foreground: cdd6f4
      term_background_bright: 313244
      term_foreground_bright: cdd6f4
      term_palette: 181825;f38ba8;a6e3a1;f9e2af;89b4fa;cba6f7;94e2d5;bac2de
      term_palette_bright: 585b70;f38ba8;a6e3a1;f9e2af;89b4fa;cba6f7;94e2d5;a6adc8
    '';

    # Uncomment and add your EFI partition UUIDs after installing CachyOS & Windows:
    # extraEntries = ''
    #   /CachyOS
    #     protocol: efi
    #     path: uuid(<EFI-UUID>):/EFI/limine/limine_x64.efi
    #   /Windows
    #     protocol: efi
    #     path: uuid(<EFI-UUID>):/EFI/Microsoft/Boot/bootmgfw.efi
    # '';
  };

  boot.loader.efi.canTouchEfiVariables = true;

  # Latest Linux kernel (best hardware support for modern ASUS Zenbooks)
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # ============================================================================
  # 2. Networking, Locale & Timezone
  # ============================================================================
  networking.hostName = "zenbook-nix";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Chisinau";
  i18n.defaultLocale = "en_US.UTF-8";

  # ============================================================================
  # 3. ASUS Zenbook Hardware, Audio, Bluetooth & Power
  # ============================================================================
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  services.asusd.enable = true;
  services.power-profiles-daemon.enable = true;
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # PipeWire Audio (also required for OBS Studio Wayland screen recording)
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # ============================================================================
  # 4. Wayland Compositor: Hyprland + Portals
  # ============================================================================
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-hyprland pkgs.xdg-desktop-portal-gtk ];
  };

  # ============================================================================
  # 5. System-Wide Nerd Fonts (JetBrainsMono Nerd Font Everywhere)
  # ============================================================================
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      nerd-fonts.jetbrains-mono
      noto-fonts
      noto-fonts-color-emoji
    ];

    fontconfig = {
      enable = true;
      defaultFonts = {
        monospace = [ "JetBrainsMono Nerd Font" ];
        sansSerif = [ "JetBrainsMono Nerd Font" ];
        serif = [ "JetBrainsMono Nerd Font" ];
      };
    };
  };

  # ============================================================================
  # 6. User Account (`CdjHub`) & Fish Shell
  # ============================================================================
  programs.fish.enable = true;

  users.users.CdjHub = {
    isNormalUser = true;
    description = "THE IDEA dev (Btw)";
    extraGroups = [ "networkmanager" "wheel" "video" "audio" ];
    shell = pkgs.fish;
  };

  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # ============================================================================
  # 7. System Packages (Your Exact Stack)
  # ============================================================================
  environment.systemPackages = with pkgs; [
    # Terminal, Shell & CLI Tools
    kitty
    starship
    fastfetch
    micro
    yazi
    btop
    git
    stow
    unzip
    ripgrep
    fd

    # Browser & Recording
    helium-browser
    obs-studio

    # Hyprland & Quickshell Ecosystem
    quickshell
    hyprpaper
    dunst
    wl-clipboard
    grim
    slurp
    brightnessctl
    playerctl
    networkmanagerapplet

    # Catppuccin Mocha GTK / Cursors / Icons
    catppuccin-gtk
    catppuccin-cursors.mochaBlue
    papirus-icon-theme
  ];

  # Wayland environment variables for crisp 1.5x Zenbook scaling
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";
    QT_QPA_PLATFORM = "wayland";
  };

  system.stateVersion = "25.05";
}
