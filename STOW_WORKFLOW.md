# Stow Workflow for This Repo

This repo uses **GNU Stow** to manage dotfiles directly without `ml4w-dotfiles-installer`.

## Modular Architecture
Installation is split into focused scripts:
- `install.sh` — Main orchestrator (runs all steps in order)
- `setup/install-deps.sh` — Install system packages (distro-aware)
- `setup/stow.sh` — Link dotfiles using GNU Stow
- `setup/run-preflight.sh` — Pre-install setup
- `setup/run-postflight.sh` — Post-install setup

## 1) First-time install (full flow)
```bash
bash install.sh --overwrite
```
Runs: preflight → install deps → stow → postflight.

## 2) Re-apply stow only (safe, no dependency reinstall)
```bash
bash setup/stow.sh --overwrite
```

## 3) Preview changes (dry-run)
```bash
bash install.sh --dry-run --overwrite
```

Stow is invoked with `--no-folding`, so directories like `dotfiles/.config/*` are linked as individual entries instead of collapsing the whole `.config` tree into one symlink.

## 4) Skip specific steps (advanced)
```bash
# Skip preflight/postflight, just install deps and stow
bash install.sh --skip-preflight --skip-postflight --overwrite

# Skip dependency installation
bash install.sh --skip-deps --overwrite
```

## 5) Where to put personal changes (low-conflict strategy)
Prefer extension points that are already designed for customization, so upstream pulls stay easy.

- Hyprland local overrides: `dotfiles/.config/hypr/custom.lua` (loaded last by `dotfiles/.config/hypr/hyprland.lua`)
- Input and monitor specifics: `dotfiles/.config/hypr/input.lua`, `dotfiles/.config/hypr/monitors.lua`
- Shell customizations: `dotfiles/.config/bashrc/custom/*`, `dotfiles/.config/zshrc/custom/*`
- Optional feature toggles: files under `dotfiles/.config/ml4w/settings/` (for example `hide-fastfetch`)

For variant-driven Hypr sections, add new files under:
- `dotfiles/.config/hypr/conf/keybindings/`
- `dotfiles/.config/hypr/conf/layouts/`
- `dotfiles/.config/hypr/conf/decorations/`

Then switch the selector file (example: `dotfiles/.config/hypr/conf/keybinding.lua`) to your variant.

## 6) Pull upstream updates safely
Use a fork + upstream remote and keep changes on your own branch.

```bash
git remote add upstream https://github.com/mylinuxforwork/dotfiles.git
git fetch upstream
git checkout main
git rebase upstream/main
bash install.sh --overwrite
```

If you keep local commits, rebase your custom branch onto updated `main`, resolve conflicts, then run `bash install.sh --overwrite` again.

## 7) Notes specific to this repo
- `dotfiles/.bashrc` and `dotfiles/.zshrc` are loaders; avoid editing them directly.
- Stow is invoked with `--no-folding` to keep `.config` children separate; if you ever see a top-level `.config` symlink, rerun `bash setup/stow.sh --overwrite`.
- This repo has no unit test suite; validate changes with `bash install.sh --dry-run` and by checking your Hyprland module paths.


