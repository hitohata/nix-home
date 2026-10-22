{ config, lib, pkgs, ... }:

let
  kwriteconfig = "${pkgs.kdePackages.kconfig}/bin/kwriteconfig6";
  shortcutsFile = "${config.xdg.configHome}/kglobalshortcutsrc";
in
{
  # KGlobalAccel stores KWin shortcuts in kglobalshortcutsrc.  Set only the
  # shortcuts managed here, so unrelated shortcuts configured in Plasma's GUI
  # remain untouched.
  home.activation.kwinProductivityShortcuts = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    ${kwriteconfig} --file ${shortcutsFile} --group kwin --key "Window Quick Tile Left" "Meta+Left,none,Quick Tile Window to the Left"
    ${kwriteconfig} --file ${shortcutsFile} --group kwin --key "Window Quick Tile Right" "Meta+Right,none,Quick Tile Window to the Right"
    ${kwriteconfig} --file ${shortcutsFile} --group kwin --key "Window Quick Tile Top" "Meta+Up,none,Quick Tile Window to the Top"
    ${kwriteconfig} --file ${shortcutsFile} --group kwin --key "Window Quick Tile Bottom" "Meta+Down,none,Quick Tile Window to the Bottom"

    ${kwriteconfig} --file ${shortcutsFile} --group kwin --key "Switch One Desktop to the Left" "Ctrl+Meta+Left,none,Switch One Desktop to the Left"
    ${kwriteconfig} --file ${shortcutsFile} --group kwin --key "Switch One Desktop to the Right" "Ctrl+Meta+Right,none,Switch One Desktop to the Right"
    ${kwriteconfig} --file ${shortcutsFile} --group kwin --key "Switch One Desktop Up" "Ctrl+Meta+Up,none,Switch One Desktop Up"
    ${kwriteconfig} --file ${shortcutsFile} --group kwin --key "Switch One Desktop Down" "Ctrl+Meta+Down,none,Switch One Desktop Down"

    ${kwriteconfig} --file ${shortcutsFile} --group kwin --key "Window One Desktop to the Left" "Ctrl+Shift+Meta+Left,none,Window One Desktop to the Left"
    ${kwriteconfig} --file ${shortcutsFile} --group kwin --key "Window One Desktop to the Right" "Ctrl+Shift+Meta+Right,none,Window One Desktop to the Right"
    ${kwriteconfig} --file ${shortcutsFile} --group kwin --key "Window One Desktop Up" "Ctrl+Shift+Meta+Up,none,Window One Desktop Up"
    ${kwriteconfig} --file ${shortcutsFile} --group kwin --key "Window One Desktop Down" "Ctrl+Shift+Meta+Down,none,Window One Desktop Down"
  '';
}
