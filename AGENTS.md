# AGENTS.md

Guidance for AI agents working in this repository.

## Purpose

This repository manages a personal Arch Linux workstation with Ansible.

It installs system packages, AUR packages, services, low-level system files, and symlinks user configuration from `config/` into the home directory.

## Repository Layout

- `site.yaml` - main playbook, imports all configuration sections.
- `bootstrap.yaml` - prepares Ansible dependencies and the AUR builder user.
- `inventory.yaml` - local inventory and shared variables.
- `requirements.yaml` - Ansible Galaxy collections.
- `Makefile` - supported entry points for bootstrap, checks, and apply.
- `config/` - source files for user configuration symlinks.
- `common.yaml`, `dev-tools.yaml`, `display.yaml`, `audio.yaml`, `apps.yaml`, `virt.yaml`, `misc.yaml`, `system.yaml` - section playbooks.

## Commands

Use these commands instead of ad-hoc Ansible invocations unless there is a reason not to.

```sh
make bootstrap
make check
make syntax
make lint
make apply
```

Use `ANSIBLE_FLAGS` for dry runs or extra flags:

```sh
make apply ANSIBLE_FLAGS="--check --diff"
```

## Working Rules

- Keep diffs minimal.
- Do not reformat unrelated files.
- Do not change package choices unless explicitly asked.
- Do not commit, amend, or push unless explicitly asked.
- Do not revert user changes unless explicitly asked.
- Prefer editing existing playbooks over adding new structure.
- Preserve executable playbooks with `#!/usr/bin/env ansible-playbook`.
- Validate changes with `make syntax` and `make lint` when Ansible files change.
- Use `git diff --check` before finishing file edits.

## Ansible Style

- Use fully qualified collection names, for example `ansible.builtin.file` and `community.general.pacman`.
- Use double quotes for task names and file modes, for example `mode: "0644"`.
- Keep comments ASCII.
- Use `state: present` for package installation by default.
- Keep full system upgrades explicit; currently this is handled by `common.yaml`.
- Use `become: true` only for tasks that need root.
- Use `become_user: "{{ aur_builder_user }}"` for AUR package tasks.
- Use `aur_helper` from `inventory.yaml` when an AUR helper must be selected explicitly.
- Prefer idempotent modules over `command` or `shell`.
- If `command` is necessary, set `changed_when` and `failed_when` deliberately.
- Set `mode` for files created with `copy`, `template`, or `lineinfile` when permissions matter.

## Current Notes

- Playbooks target `localhost` with local connection from `inventory.yaml`.
- `ansible-lint` may print internal `ArgsRule.matchtasks` warnings for `community.general.pacman`; this is not a playbook lint failure when the final result is `Passed: 0 failure(s), 0 warning(s)`.
- Tags were intentionally not kept. Do not reintroduce tag-based apply targets without checking fact-gathering behavior.
