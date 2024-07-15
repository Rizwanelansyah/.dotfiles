> NOTE: before installing this dotfiles you need to reconfig the neovim config first
because it have a local plugin

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
        - CTRL + mainMod, R: Rerun AGS
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
- Font: `IosevkaTerm Nerd Font`
- Color Scheme: One Dark or Gruvbox (not fully gruvbox)
- Launcher: Rofi (will be changed soon)
- Widgets: AGS
    - StatusBar #status-bar:
        - Left: Arch Linux logo, workspaces, active window icon and title
        - Center: colapsable clock, colapsable date
        - Right: colapsable memory usage, battery, QuickMenu button
    - QuickMenu #quick-menu (not completed):
        - Shutdown button
        - Reboot button
        - Logout button
- Notification Daemon: SwayNotificationCenter
- Wallpaper: Swaybg
- Terminal Emulator: Wezterm
- Code Editor: Neovim
    - 'rizwan' profile:
        - plugin-manager: lazy.nvim
        - leader: \<space\>
        - plugins: onedark.nvim, nvim-web-devicons, simplyfile.nvim, nvim-treesitter, nvim-lspconfig,
        Comment.nvim, nvim-cmp, Luasnip, nvim-notify, neodev
        - LSP: lua_ls, rust_analyzer, tsserver, cssls, html, emmet_ls, jsonls,
        intelephense, ccls, taplo, gopls
    - 'minvim' profile:
        - plugin-manager: lazy.nvim
        - plugins: luarocks.nvim, image.nvim with kitty backend (still work when use wezterm on my laptop),
        simplyfile.nvim, nvim-web-devicons, nvim-treesitter, gruvbox.nvim (for trying gruvbox last week), onedark.nvim,
        nvim-cmp and other completion stuff, nvim-lspconfig, vim-blade, lazy-dev an awesome lua tools for neovim,
        luvit-meta, blade-nav, windui.nvim (this is local plugin but you can use install it from repo Rizwanelansyah/windui.nvim)
        - LSP: lua_ls, cssls, jsonls, emmet_ls, rust_analyzer, (the tsserver commented because my laptop crash when used that), gopls,
        tailwindcss, intelephense, zls
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
```
and copy all config you want.

this example make a backup for your old config and copy the neovim config from my dotfiles:
```
mv ~/.config/nvim ~/.config/nvim.bak
cp .config/nvim ~/.config/nvim
```
