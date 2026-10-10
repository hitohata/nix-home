{ pkgs, ... }: 

let
  # Import modular configuration files
  environment = import ./hyprland/environment.nix;
  monitors = import ./hyprland/monitors.nix;
  input = import ./hyprland/input.nix;
  lookAndFeel = import ./hyprland/look_and_feel.nix;
  autostart = import ./hyprland/autostart.nix;
  keybindings = import ./hyprland/keybindings.nix;
  windowrules = import ./hyprland/windowrules.nix;
in
{
  wayland.windowManager.hyprland = {
    enable = true;

    # This configuration uses Hyprland's traditional $variables (for example
    # $mainMod). Home Manager's new Lua generator cannot represent those names.
    configType = "hyprlang";
    
    settings = environment // monitors // input // lookAndFeel // autostart // keybindings // windowrules;
  };
}
