# Dotfiles

Personal Arch Linux workstation configuration managed with Ansible.

The repository installs system packages, AUR packages, services, and symlinks user configuration from `config/` into the home directory.

## Requirements

- Arch Linux
- `sudo` access
- `make`

## Bootstrap

Install Ansible tools, Galaxy collections, and prepare the AUR builder user:

```sh
make bootstrap
```

## Apply

Apply the main local playbook:

```sh
make apply
```

Pass extra Ansible flags with `ANSIBLE_FLAGS`:

```sh
make apply ANSIBLE_FLAGS="--check --diff"
```

## Checks

Run syntax and lint checks:

```sh
make check
```

Separate checks:

```sh
make syntax
make lint
```

## Structure

- `site.yaml` - main playbook, imports all sections
- `bootstrap.yaml` - initial AUR builder setup
- `inventory.yaml` - local inventory and shared variables
- `requirements.yaml` - Ansible Galaxy collections
- `config/` - user configuration symlink source
- `common.yaml` - common CLI packages and base configuration
- `dev-tools.yaml` - developer tools
- `display.yaml` - display stack, Wayland, fonts, UI services
- `audio.yaml` - PipeWire and Bluetooth
- `apps.yaml` - desktop applications
- `virt.yaml` - containers, Kubernetes, virtualization
- `misc.yaml` - miscellaneous applications
- `system.yaml` - bootloader and low-level system configuration

## Notes

Playbooks target `localhost` and use local connection from `inventory.yaml`.

Package tasks use `state: present`; full system upgrades are explicit in `common.yaml`.
