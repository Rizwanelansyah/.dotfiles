# Dotfiles
Just a simple dotfiles for Arch+Hyprland with One Dark theme

# Info
- WM: Hyprland
    - layout: dwindle
    - keybinds:
        - mainMod: SUPER
        - mainMod, Q: Open terminal with tmux
        - mainMod, C: Kill active window
        - mainMod, M: Exit
        - mainMod, V: Toggle floating
        - mainMod, F: Toggle fullscreen
        - mainMod, X: Run launcher(Rofi)
        - CTRL + mainMod, P: Screenshot area
        - CTRL + mainMod, 0: Increase brightness with `brightnessctl`
        - CTRL + mainMod, 9: Decrease brightness with `brightnessctl`
        - mainMod, \[left|right|up|down\]: Move focus to {x}
        - mainMod, \[1-9\]: Switch to workspace {x}
        - SHIFT + mainMod, \[1-9\]: Move window to workspace {x}
        - mainMod, S: Toggle Special Workspace
        - SHIFT + mainMod, S: Move window to special workspace
        - mainMod, LMB: Move window
        - mainMod, RMB: Resize window
        - CTRL + mainMod, \[left|right|up|down\]: Move window to {x}
        - SHIFT + mainMod, \[left|right|up|down\]: Resize window to {x}
        - mainMod, TAB: Dwindle - toggle split
        - SHIFT + mainMod, TAB: Dwindle - swap split
- Shell: Fish
    - alias:
        - rm => trash
        - ls => exa
        - fishr => source ~/.config/fish/config.fish
    - function:
        - conf => select file/folder with fzf and configure selected folder/file with $EDITOR
- Font: CodeNewRoman Nerd Font
- Color Scheme: One Dark
- Launcher: Rofi
- Status Bar: Waybar
    - modules-left: custom/os, hyprland/workspace, hyprland/window
    - modules-center: custom/notification, clock, tray
    - modules-right: backlight, network, cpu, memory, battery
- Notification Daemon: SwayNotificationCenter
- Wallpaper: Swaybg
    - image-source: [freepik.com](https://www.freepik.com/free-photos-vectors/abstract-wallpaper/3#uuid=ed999d21-075f-492c-bbe4-a4ad3edac321)
- Terminal: Alacritty
- Code Editor: Neovim
    - plugin-manager: lazy.nvim
    - leader: \<space\>
    - plugins: onedark.nvim, nvim-web-devicons, simplyfile.nvim, nvim-treesitter, nvim-lspconfig,
    Comment.nvim, nvim-cmp, Luasnip, nvim-notify, neodev
    - LSP: lua_ls, rust_analyzer, tsserver, cssls, html, emmet_ls, jsonls,
    intelephense, ccls, taplo, gopls
- Terminal Multiplexer: Tmux
    - prefix: C-x
- Icon: Fluent-Dark
- Theme: Fluent-Dark
- Cursor: Vimix-cursors
- Additional Scripts:
    - hyprfetch: Simple display system information

# Installation
```
git clone https://github.com/Rizwanelansyah/.dotfiles.git
cd .dotfiles
chmod +x scripts/install
./scripts/install
```

install all configured LSP for neovim:
```
chmod +x scripts/install-lsp
./scripts/install-lsp
```
