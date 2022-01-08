# Initialize Starship prompt
starship init fish | source

# Set Neovim as default editor
set -gx EDITOR nvim

# Set Starship config directory compatible with new standards
set -gx STARSHIP_CONFIG ~/.config/starship/config.toml

# Setup PATH from .bash_profile
fish_add_path -m ~/.local/bin
