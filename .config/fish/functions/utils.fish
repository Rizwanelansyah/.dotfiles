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

