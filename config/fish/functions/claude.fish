function claude --description 'Claude Code wrapper with GitHub token from gopass'
    # Получить GitHub токен через gopass
    set -x GITHUB_PERSONAL_ACCESS_TOKEN (gopass show -o git/github.com/Bluesboy)

    # Вызвать настоящий бинарник claude со всеми аргументами
    command claude $argv
end
