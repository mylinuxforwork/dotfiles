# Stow Workflow for This Repo

This repo can be used without `ml4w-dotfiles-installer` by stowing the `dotfiles/` package directly into `$HOME`.

## 1) One-time setup
```bash
bash install-stow.sh --install-deps
```

## 2) Install or re-apply dotfiles
```bash
bash install-stow.sh
```

If you already have files in `$HOME` and want Stow to take ownership:
```bash
bash install-stow.sh --adopt
```

If you prefer to overwrite existing files (safer: backed up automatically) instead of using `--adopt`, use:
```bash
# Back up existing files into ~/.local/share/dotfiles-backup-<timestamp> and overwrite
bash install-stow.sh --overwrite
```

Preview only:
```bash
bash install-stow.sh --dry-run
```

## 3) Where to put personal changes (low-conflict strategy)
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

## 4) Pull upstream updates safely
Use a fork + upstream remote and keep changes on your own branch.

```bash
git remote add upstream https://github.com/mylinuxforwork/dotfiles.git
git fetch upstream
git checkout main
git rebase upstream/main
bash install-stow.sh
```

If you keep local commits, rebase your custom branch onto updated `main`, resolve conflicts, then run `bash install-stow.sh` again.

## 5) Notes specific to this repo
- `dotfiles/.bashrc` and `dotfiles/.zshrc` are loaders; avoid editing them directly.
- Current ML4W `.dotinst` restore-safe files include `input.lua`, `monitors.lua`, and `custom.lua`; these are good places for personal edits.
- This repo has no unit test suite; validate changes with `bash install-stow.sh --dry-run` and by checking your Hyprland module paths.

