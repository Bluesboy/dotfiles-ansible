#Use VI mode by default
fish_vi_key_bindings

# Initialize Starship prompt
starship init fish | source

# Alias for the fuck
thefuck --alias | source

# Set Neovim as default editor
set -gx EDITOR nvim

# Set Starship config directory compatible with new standards
set -gx STARSHIP_CONFIG ~/.config/starship/config.toml

# Set Starship config directory compatible with new standards
set -gx N_PREFIX ~/.local/share/n

# Set TTY for pass-git-helper
set -gx GPG_TTY (tty)

# Use gcloud-gke-auth-plugin by default
set -gx USE_GKE_GCLOUD_AUTH_PLUGIN True

# Use system URI for libvirt by default
set -gx LIBVIRT_DEFAULT_URI qemu:///system

# Setup PATH from .bash_profile
fish_add_path -m ~/.local/bin
fish_add_path -m $N_PREFIX
fish_add_path -m ~/.cargo/bin

# Do not display greeting
functions -e fish_greeting

# Bind lf start to CTRL+O
function fish_user_key_bindings
  bind -M insert \co 'set old_tty (stty -g); stty sane; lfcd; stty $old_tty; commandline -f repaint'
end

# Setup abbreviations
if status --is-interactive
  abbr --add --global -- aurox 'gcloud config configurations activate aurox && kubectx aurox'
  abbr --add --global -- dr 'docker run -it --rm'
  abbr --add --global -- flux 'gcloud config configurations activate flux && kubectx flux'
  abbr --add --global -- swaps 'gcloud config configurations activate aurox-swaps && kubectx swaps'
  abbr --add --global -- stage 'gcloud config configurations activate stage && kubectx stage'
  abbr --add --global -- g git
  abbr --add --global -- gvm g
  abbr --add --global -- ga 'git add'
  abbr --add --global -- gc 'git commit -m'
  abbr --add --global -- gca 'git commit --amend'
  abbr --add --global -- glo 'git lo'
  abbr --add --global -- gp 'git push'
  abbr --add --global -- gpu 'git pull'
  abbr --add --global -- gs 'git status'
  abbr --add --global -- hl 'helm ls'
  abbr --add --global -- k kubectl
  abbr --add --global -- kc kubectx
  abbr --add --global -- kn kubens
  abbr --add --global -- lg lazygit
  abbr --add --global -- tf terraform
  abbr --add --global -- tp 'terraform plan'
  abbr --add --global -- fishconf 'vim ~/.config/fish/config.fish'
  abbr --add --global -- ck 'kubectl get pod --all-namespaces | grep -i \'terminated\|nodeshutdown\|error\|nodeaffinity\|completed\' | awk \'{ print $1, $2 }\' | xargs -n2 kubectl delete pod -n'
  abbr --add --global -- tm 'tmux'
end

set -gx GOPATH $HOME/go; set -gx GOROOT $HOME/.go; set -gx PATH $GOPATH/bin $PATH; # g-install: do NOT edit, see https://github.com/stefanmaric/g

# Enable krew
set -q KREW_ROOT; and set -gx PATH $PATH $KREW_ROOT/.krew/bin; or set -gx PATH $PATH $HOME/.krew/bin

# Created by `pipx` on 2024-04-29 19:26:34
set PATH $PATH /home/bluesboy/.local/bin

fish_add_path -m ~/.luarocks/bin/

# Initiate Zoxide
zoxide init fish | source
