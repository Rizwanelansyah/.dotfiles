function conf
  set -l files ""
  for path in ~/.config/*
    set files "$files:$path"
  end
  set -l file (string split ":" $files | fzf)
  if test "$file " != " "
    $EDITOR $file
  end
end

function fish_prompt
  set -l last_status $status
  printf "\n"
  printf "┍[$(set_color green)$USER$(set_color normal)@$(set_color blue)$hostname$(set_color normal)] "
  set -l cur_dir (pwd)
  if test "" != "$(string match -r "^$HOME" $cur_dir)"
    set cur_dir (string replace -r "^$HOME" "$(set_color red)Home" $cur_dir)
    set cur_dir (string replace -r "/" "$(set_color normal)::$(set_color cyan)" $cur_dir)
  else
    set cur_dir (string replace -r "^/" "$(set_color red)Root$(set_color normal)::" $cur_dir)
    set cur_dir (string replace -r '::$' "" $cur_dir)
    set cur_dir (string replace -r '::' "::$(set_color cyan)" $cur_dir)
  end

  set cur_dir (string replace -ra "/" "$(set_color normal)->$(set_color cyan)" $cur_dir)
  printf "$cur_dir$(set_color normal)"

  set -l git (fish_git_prompt)
  if test "" != "$git"
    set git (string replace -r '^\s*\((.*)\)\s*$' '$1' $git)
    printf " $(set_color purple)🮤$(set_color green)$git$(set_color purple)🮥"
  end
  set -l error_code ""
  if test $last_status -ne 0
    set error_code "$(set_color normal)<$(set_color red)$last_status$(set_color normal)>"
  end
  set -l end_sign "!"
  if test "$USER" = "root"
    set end_sign "#"
  end
  printf "$(set_color normal)\n└$(set_color cyan)fish$error_code$(set_color blue)$end_sign$(set_color normal) "
end

export EDITOR="nvim"

export PATH="$HOME/.config/composer/vendor/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.luarocks/bin:$PATH"

# java
export PATH="$HOME/.jenv/bin:$PATH"
eval "$(jenv init -)"
jenv enable-plugin export

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# wine
export WINE_ROOT="$HOME/.wine"
export WINE_HOME="$WINE_ROOT/drive_c/users/$USER"

# flutter
export PATH="$HOME/Tools/flutter/bin:$PATH"
export FLUTTER_ROOT="$HOME/Tools/flutter"

# Android SDK
export ANDROID_HOME="$HOME/Tools/Android/SDK"

alias fishr="source $HOME/.config/fish/config.fish"
alias ls="exa --icons=always"

set -q GHCUP_INSTALL_BASE_PREFIX[1]; or set GHCUP_INSTALL_BASE_PREFIX $HOME ; set -gx PATH $HOME/.cabal/bin /home/rizwan/.ghcup/bin $PATH # ghcup-env
