# Defined in /home/ssattarov/.config/fish/functions/ll.fish @ line 1
function ll --wraps=ls
    eza -l --icons --git --group-directories-first $argv
end
