function __complete_crossplane
    set -lx COMP_LINE (commandline -cp)
    test -z (commandline -ct)
    and set COMP_LINE "$COMP_LINE "
    command crossplane
end
complete -f -c crossplane -a "(__complete_crossplane)"
