# Initialize Starship prompt
starship init fish | source

# Set Neovim as default editor
set -gx EDITOR nvim

# Set Starship config directory compatible with new standards
set -gx STARSHIP_CONFIG ~/.config/starship/config.toml

# Set Starship config directory compatible with new standards
set -gx N_PREFIX ~/.local/share/n

# Set TTY for pass-git-helper
set -gx GPG_TTY (tty)

# Setup PATH from .bash_profile
fish_add_path -m ~/.local/bin
fish_add_path -m $N_PREFIX

function fish_greeting
  echo Hey there, you in FISH!
end
