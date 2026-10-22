# KDE Plasma on x1

At the GDM login screen, use the session menu to choose **Plasma (Wayland)**.
This guide applies to that session; GNOME and Hyprland keep their own window
management behavior.

## Virtual desktops

A virtual desktop is a separate workspace for windows. A simple starting
layout is four desktops in one row: communication, browser/research, coding,
and spare.

1. Open **System Settings** and search for **Virtual Desktops**.
2. Set the number of desktops to at least two (four is a useful starting
   point).
3. Keep them in one row if you want to use left and right to move between
   them.

To see your windows and desktops, press `Super+W` for **Overview**. Click a
desktop to switch to it, or drag a window to another desktop. If a directional
shortcut appears to do nothing, check that a desktop exists in that direction.

## Keyboard shortcuts

These shortcuts are configured in `shortcuts.nix` and affect KWin, Plasma's
window manager.

| Keys | Result |
| --- | --- |
| `Super+Left` / `Super+Right` | Tile the focused window to the left or right half |
| `Super+Up` / `Super+Down` | Tile the focused window to the top or bottom half |
| `Ctrl+Super+Arrow` | Switch to the virtual desktop in that direction |
| `Ctrl+Shift+Super+Arrow` | Move the focused window to the desktop in that direction |
| `Super+W` | Open Overview |

## Touchpad gestures

Plasma's built-in touchpad gestures are not the same as GNOME's:

| Gesture | Default Plasma behavior |
| --- | --- |
| Three-finger swipe left/right | Change virtual desktop left/right |
| Three-finger swipe up/down | Change virtual desktop up/down when the layout has rows |
| Four-finger swipe up | Open Overview |
| Four-finger swipe down | Open the desktop grid / leave Overview |

Therefore, a three-finger bottom-to-top swipe will not open Overview in a
one-row setup. Use `Super+W` or a four-finger upward swipe instead. Plasma's
built-in touchpad gestures are not currently configurable; do not add a
separate gesture daemon unless you specifically want to replace Plasma's
gesture handling.

If a gesture does not work, first make sure you are in **Plasma (Wayland)**,
then open **System Settings** and search for **Touchpad** to confirm the
touchpad is enabled. Hardware that does not report four simultaneous touch
points cannot use the four-finger gesture.

## Configuration layout

- `default.nix` enables the Plasma desktop services.
- `home.nix` contains user-level Plasma-related settings.
- `shortcuts.nix` writes only the managed KWin shortcuts, preserving other
  shortcuts configured through Plasma's GUI.

After changing a Nix file, rebuild the `user@x1` configuration. Log out and
back in if KWin does not immediately refresh shortcut changes.
