{
  lib,
  pkgs,
  host,
  ...
}:
let
  inherit (import ../hosts/${host}/variables.nix)
    keyboardLayout
    keyboardVariant
    ;
in
with lib;
{
  home.packages = with pkgs; [
    hyprpolkitagent
    playerctl
    pavucontrol
  ];

  gtk = {
    enable = true;
    iconTheme = {
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
    };
  };

  # see https://wiki.hyprland.org/Configuring/Environment-variables/
  home.file.".config/uwsm/env".text = ''
    # QT
    export QT_QPA_PLATFORM=wayland;xcb
    export QT_QPA_PLATFORMTHEME=qt6ct
    export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
    export QT_AUTO_SCREEN_SCALE_FACTOR=1
    export QT_STYLE_OVERRIDE=kvantum
    
    # Toolkit Backend Variables
    export GDK_BACKEND=wayland,x11,*
    export SDL_VIDEODRIVER=wayland
    export CLUTTER_BACKEND=wayland
    
    # XDG Specifications
    export XDG_CURRENT_DESKTOP=Hyprland
    export XDG_SESSION_TYPE=wayland
    export XDG_SESSION_DESKTOP=Hyprland
  '';

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    systemd.enable = false;
    settings =
      let
        modifier = "SUPER";
      in
      {
      exec-once = [
        "uwsm app -- dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
        "systemctl --user enable --now hyprpolkitagent.service"
        # "uwsm app -- dunst"
        "uwsm app -- waybar"
        "uwsm app -- swayosd-server"
        "uwsm app -- nm-applet --indicator"
        "uwsm app -- blueman-applet"
      ];
      input = {
        kb_layout = keyboardLayout;
        kb_variant = keyboardVariant;
        kb_options = "caps:escape";
        follow_mouse = 2;
        mouse_refocus = false;
        touchpad = {
          natural_scroll = true;
          disable_while_typing = true;
          scroll_factor = 0.8;
        };
        sensitivity = 0.4;
        accel_profile = "adaptative";
        repeat_rate = 20;
        repeat_delay = 400;
      };
      debug.disable_logs = true;
      general = {
        gaps_in = 4;
        gaps_out = 8;
        border_size = 2;
        resize_on_border = true;
      };
      dwindle = {
        force_split = 2;
      };
      decoration  = {
        rounding = 10;
        shadow = {
          enabled = true;
          range = 4;
        };
        blur = {
          enabled = true;
          size = 5;
          passes = 3;
          new_optimizations = "on";
          ignore_opacity = "off";
        };
      };
      animations  = {
        enabled = "yes";
        bezier = [
          "wind, 0.05, 0.9, 0.1, 1.05"
          "winIn, 0.1, 1.1, 0.1, 1.1"
          "winOut, 0.3, -0.3, 0, 1"
          "liner, 1, 1, 1, 1"
        ];
        animation = [
          "windows, 1, 6, wind, slide"
          "windowsIn, 1, 6, winIn, slide"
          "windowsOut, 1, 5, winOut, slide"
          "windowsMove, 1, 5, wind, slide"
          "border, 1, 1, liner"
          "fade, 1, 10, default"
          "workspaces, 1, 5, wind"
        ];
      };
      windowrulev2 = [
        "noborder, class:^(tofi)$"
        "center, class:^(tofi)$"
        "float, class:^(org.pulseaudio.pavucontrol|.blueman-manager-wrapped|nm-connection-editor)$"
        "stayfocused, class:^(org.pulseaudio.pavucontrol|.blueman-manager-wrapped|nm-connection-editor)$"
        "pin, class:^(org.pulseaudio.pavucontrol|.blueman-manager-wrapped|nm-connection-editor)$"
        "stayfocused, class:^(steam)$"
      ];
      gestures = {
        workspace_swipe = true;
        workspace_swipe_fingers = 4;
      };
      misc = {
        initial_workspace_tracking = 2;
        mouse_move_enables_dpms = false;
        key_press_enables_dpms = true;
      };
      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };
      monitor = ",preferred,auto,1";
    };
  };
}
