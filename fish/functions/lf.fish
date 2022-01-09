function lf --wraps=lf
  set icons_file ~/.config/lf/icons
  set -lx LF_ICONS (sed $icons_file -e '/^[ \t]*#/d' -e '/^[ \t]*$/d' -e 's/[ \t]\+/=/g' -e 's/$/ /' | tr '\n' :)
  command lf $argv 
end
