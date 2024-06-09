if status is-interactive
  export PATH="$PATH:$HOME/.local/bin"
  export PATH="$PATH:$HOME/.cargo/bin"
  export PATH="$PATH:$HOME/go/bin"

  export FZF_DEFAULT_OPTS="--border --margin=1"
  export EDITOR="nvim"
  export SUDO_PROMPT=(printf "sudo: $(set_color blue)  $USER$(set_color green) Password$(set_color normal)? $(set_color yellow) $(set_color normal)")
  alias fishr "source ~/.config/fish/config.fish"
  alias rm "trash"
  alias ls "exa"
end

function fish_greeting
  if test -e ~/scripts/hyprfetch
    ~/scripts/hyprfetch 1
  end
end

function fish_mode_prompt
end

function fish_prompt
  set -l exit_code $status
  set -l exit_color "green"
  if test $exit_code != 0
    set exit_color "red"
    if test $exit_code = 2
      set exit_code "INCORRECT:2"
    else if test $exit_code = 126
      set exit_code "DENIED:126"
    else if test $exit_code = 127
      set exit_code "NOTFOUND:127"
    else if test $exit_code = 130
      set exit_code "SIGINT:130"
    else if test $exit_code = 143
      set exit_code "SIGTERM:143"
    end
  end

  set -l cwd (string replace $HOME " " $PWD)
  set cwd (string replace -a "/" -- "->" $cwd)
  printf "┌─(%s$USER%s@%s$hostname%s)─[%s$cwd%s] " \
    (set_color green) (set_color white) (set_color blue) (set_color normal) \
    (set_color yellow) (set_color normal)
  set -l git_prompt (fish_git_prompt)
  if test "$git_prompt " != " "
    printf "%s%s$git_prompt%s" (set_color red) (set_color cyan) (set_color normal)
  end

  if test -e Cargo.toml
    set -l crate (count_cargo_crates)
    if test "$crate " != " "
      set -l unit "crate"
      if test $crate -gt 1
        set unit "crates"
      end
      printf " %s(%s %s$crate %s$unit%s)" \
      (set_color normal) (set_color white) (set_color blue) (set_color yellow) (set_color normal)
    end
  end

  if test -e package.json
    set -l deps (count_npm_dep)
    set -l dev_deps (count_npm_dev_dep)

    set -l dep_dis ""
    if test "$deps " != " "
      if test $deps -gt 0
        set dep_dis " $(set_color blue)$deps $(set_color cyan)dep"
        if test $deps -gt 1
          set dep_dis $dep_dis"s"
        end
      end
    end

    if test "$dev_deps " != " "
      if test $dev_deps -gt 0
        set dep_dis $dep_dis" $(set_color blue)$dev_deps $(set_color red)devDep"
        if test $dev_deps -gt 1
          set dep_dis $dep_dis"s"
        end
      end
    end

    if test -e package-lock.json
      set -l packages (count_npm_packages)
      if test $packages -gt 0
        set dep_dis $dep_dis" $(set_color blue)$packages $(set_color yellow)pkg"
        if test $packages -gt 1
          set dep_dis $dep_dis"s"
        end
      end
    end

    printf " %s(%s $dep_dis%s)" (set_color normal) (set_color red) (set_color normal)
  end

  printf "\n└─[%s$exit_code%s] " (set_color $exit_color) (set_color normal)
end

function fish_right_prompt
end

function conf
  set -l conf_dirs ""
  for dir in $HOME/.config/**/*
    set conf_dirs "$conf_dirs:$dir"
  end
  set -l selected_conf_dir (string split ":" $conf_dirs | fzf --no-multi --prompt "configure ")
  if test "$selected_conf_dir " != " "
    $EDITOR $selected_conf_dir
  end
end

function count_cargo_crates
  if test -e Cargo.lock
    toml get Cargo.lock "package" | jq length
  else
    cargo metadata --format-version 1 --no-deps | jq -r '.packages' | jq length
  end
end

function count_npm_dep
  cat package.json | jq -r ".dependencies" | jq length
end

function count_npm_dev_dep
  cat package.json | jq -r ".devDependencies" | jq length
end

function count_npm_packages
  cat package-lock.json | jq -r ".packages" | jq length
end

function fish_command_not_found
end

function fish_postexec --on-event fish_postexec
  set -l code $status
  if test "$code " != " "
    if test $code = 2
      printf "%s %sIncorrect Command/Argument Usage %s%s\n" (set_color red) (set_color normal) (set_color red) (set_color normal)
    else if test $code = 126
      printf "%s %sPermission Denied %s%s\n" (set_color red) (set_color normal) (set_color red) (set_color normal)
    else if test $code = 127
      printf "%s %sCommand Not Found '$argv'%s%s\n" (set_color red) (set_color normal) (set_color red) (set_color normal)
    else if test $code = 130
      printf "%s󰈆 SIGINT %sKeyboard Interrupt %s󰚛%s\n" (set_color red) (set_color normal) (set_color red) (set_color normal)
    else if test $code = 143
      printf "%s󰈆 SIGTERM %sTerminated %s󰚛%s\n" (set_color red) (set_color normal) (set_color red) (set_color normal)
    end
  end
end

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH
