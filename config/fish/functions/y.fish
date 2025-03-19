function y
  set tmp (mktemp -t "yazi-cwd.XXXXXX")

  set -l config_dir $HOME/.config
  set -l script_path "$config_dir/yazi/scripts"
  set -lx PATH "$script_path:$PATH"

  yazi $argv --cwd-file="$tmp"
  if set cwd (command cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
     builtin cd -- "$cwd"
  end
  rm -f -- "$tmp"
end
