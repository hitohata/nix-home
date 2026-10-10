# Hyprland guide

At the GDM login screen, choose **Hyprland** from the session menu. This is a
separate session from GNOME, so its windows and workspaces are managed by
Hyprland while your normal GNOME session remains unchanged.

## First things to know

- `Super` means the Windows / Command key.
- Hyprland uses workspaces instead of GNOME's overview screen. The Waybar at
  the top shows them, and `Super+A` opens an application search menu.
- `Super+Space` switches between the US and Japanese keyboard layouts, just as
  the configured GNOME layout switch does. It is intentionally not a launcher.
- `Super+L` opens a simple secure lock screen. Enter your normal account
  password to unlock it.

## Keyboard shortcuts

| Keys | What it does |
| --- | --- |
| `Super+A` | Open the app search / launcher (closest built-in replacement for GNOME's app grid) |
| `Super+Enter` | Open a terminal |
| `Super+E` | Open Files (Nautilus) |
| `Super+B` | Open Firefox |
| `Super+C` | Open VS Code |
| `Super+L` | Lock the screen |
| `Alt+Tab` / `Alt+Shift+Tab` | Cycle forward / backward through open windows |
| `Alt+F4` | Close the focused window |
| `Super+Page Down` / `Super+Page Up` | Next / previous workspace |
| `Super+Shift+Page Down` / `Super+Shift+Page Up` | Move the focused window to the next / previous workspace |
| `Super+1` through `Super+0` | Go directly to workspace 1 through 10 |
| `Super+Shift+1` through `Super+Shift+0` | Move the focused window to workspace 1 through 10 |
| `Super+Arrow` | Focus the window in that direction |
| `Super+Shift+Arrow` | Move the focused window in that direction |
| `Super+Q` | Fullscreen the focused window |
| `Super+V` | Toggle floating mode for the focused window |
| `Super+N` | Open notifications and quick controls |
| `Print Screen` | Copy a screenshot of all displays to the clipboard |
| `Shift+Print Screen` | Select an area, then copy its screenshot to the clipboard |

The `Super+Arrow` keys are directional window controls, rather than GNOME's
edge-tiling shortcuts: Hyprland's tiling layout automatically places windows.
Use `Super+V` first when you want to freely move or resize a single window.

## Touchpad and mouse gestures

| Gesture | What it does |
| --- | --- |
| Three-finger swipe left / right | Switch workspaces, matching GNOME's primary workspace gesture |
| `Super` + mouse wheel | Previous / next workspace |
| `Super` + left mouse drag | Move a window |
| `Super` + right mouse drag | Resize a window |

Hyprland supports the three-finger horizontal workspace gesture directly. Its
built-in gestures do not provide GNOME's three-finger vertical Overview gesture,
so use `Super+A` and the Waybar workspace buttons instead. This avoids adding a
separate gesture daemon that could make normal touchpad behavior unreliable.

## Changing these settings

- `hyprland/input.nix` contains keyboard layout and touchpad/gesture settings.
- `hyprland/keybindings.nix` contains shortcuts.
- On x1, apply changes with `sudo nixos-rebuild switch --flake '.#user@x1'`.
  Then log out and select Hyprland again if a setting does not refresh
  immediately.
