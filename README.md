# Archlinux Dotfiles
archlinux dotfiles

# Overview
![Overview 1](https://github.com/Rizwanelansyah/.dotfiles/blob/main/overview/1.png?raw=true)
![Overview 2](https://github.com/Rizwanelansyah/.dotfiles/blob/main/overview/2.png?raw=true)
![Overview 3](https://github.com/Rizwanelansyah/.dotfiles/blob/main/overview/3.png?raw=true)
![Overview 4](https://github.com/Rizwanelansyah/.dotfiles/blob/main/overview/4.png?raw=true)
![Overview 5](https://github.com/Rizwanelansyah/.dotfiles/blob/main/overview/5.png?raw=true)

# Info
## WM: Hyprland
- mainMod: `SUPER`
- bindings
    - `mainMod + Q` = Open terminal (with TMUX)
    - `ALT + Q` = Open terminal (without starting TMUX)
    - `mainMod + C` = Kill active window
    - `mainMod + M` = Logout Hyprland
    - `mainMod + V` = Toggle floating
    - `mainMod + F` = Toggle fullscreen
    - `mainMod + X` = Run application launcher
    - `mainMod + W` = Run web browser
    - `CTRL + mainMod + 0` = Increase brightness
    - `CTRL + mainMod + 9` = Decrease brightness
    - `CTRL + mainMod + P` = Screenshot with flameshot
    - `mainMod + LEFT` = Move focus left
    - `mainMod + RIGHT` = Move focus right
    - `mainMod + UP` = Move focus up
    - `mainMod + DOWN` = Move focus down
    - `mainMod + {1-9}` = Switch to workspace {n}
    - `SHIFT + mainMod + {1-9}` = Move active window to workspace {n}
    - `mainMod + S` = Switch to special magic workspace
    - `SHIFT + mainMod + S` = Move active window to special magic workspace

## StatusBar: Waybar
- theme: Onedark
- font: JetBrainsMono Nerd Font
- modules
    - left
        - Workspaces
        - Window
    - center
        - Notification
        - Clock
        - Tray
    - right
        - Backlight
        - Network
        - CPU
        - Memory
        - Battery

## Terminal: Kitty
- theme: Onedark
- font: HexCode
- shell: fish

## Editor: Neovim
- theme: Onedark
- plugin manager: lazy.nvim

## Multiplexer: Tmux
- prefix: `CTRL + x`
- bindings
    - `r`: Reload tmux config
    - `|`: Split panel horizontal
    - `_`: Split panel vertical
    - `c`: Next window
    - `z`: Previous window
    - `a`: Create new window
    - `p`: Choose buffer
    - `UP`: Select pane up
    - `DOWN`: Select pane down
    - `RIGHT`: Select pane right
    - `LEFT`: Select pane left

## Notification: Swaync
- theme: onedark
- widgets
    - title
    - dnd
    - notifications
