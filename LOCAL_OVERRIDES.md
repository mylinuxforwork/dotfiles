# Local overrides (where to put personal changes)

This file documents the specific, low-conflict places to add personal customizations for this repo. Keep overrides small and use the designated extension points so upstream updates remain easy.

Recommended locations (concrete examples)
- `dotfiles/.config/hypr/custom.lua` — loaded last by `dotfiles/.config/hypr/hyprland.lua`; ideal for one-off tweaks and third‑party integrations.
- `dotfiles/.config/hypr/input.lua` and `dotfiles/.config/hypr/monitors.lua` — machine-specific input/monitor overrides.
- `dotfiles/.config/hypr/conf/<section>/*` — add new variants under sections like `keybindings`, `layouts`, `decorations`, then update the selector file (see example below).
- `dotfiles/.config/bashrc/custom/*` and `dotfiles/.config/zshrc/custom/*` — shell additions sourced by the loader stubs; do not edit `dotfiles/.bashrc` or `dotfiles/.zshrc` directly.
- `dotfiles/.config/ml4w/settings/` — file-based toggles and settings (presence or content of files drives behaviour). Example: add a file named `hide-fastfetch` to toggle that feature.

Why these locations?
- `hyprland.lua` requires `custom` last, so `custom.lua` sees the fully composed runtime environment and can safely override values.
- Variant loaders use `load_variant(...)` from `dotfiles/.config/hypr/functions.lua` — adding a new file into the appropriate `conf/<section>/` folder and pointing the selector to it is the least invasive change.
- Shell loader stubs are intentionally stable; small files under `.../custom/` avoid merge conflicts when upstream changes the loader.

Small examples
- Add a Hypr keybinding variant called `mykeys.lua`:
  1. Create `dotfiles/.config/hypr/conf/keybindings/mykeys.lua` with your bindings.
  2. Edit the selector `dotfiles/.config/hypr/conf/keybinding.lua` and set `local name = "mykeys.lua"` (it currently contains `local name = "default.lua"`).

- Use `custom.lua` for final tweaks:
  ```lua
  -- dotfiles/.config/hypr/custom.lua
  -- Example: remap a command or set a theme that must apply after all modules
  require("conf.some_module")
  hl.config({ general = { border_size = 2 } })
  ```

- Settings bus example (toggle):
  ```sh
  # create a toggle file to enable a feature
  touch $HOME/.config/ml4w/settings/hide-fastfetch
  ```

Two practical workflows to keep overrides separate from upstream

1) In-repo, protected files (simple)
   - Keep your personal edits inside the `dotfiles/` tree and commit them to a local branch (for example `personal`).
   - When you pull upstream updates, rebase your branch on `main` and resolve conflicts.
   - This is simple but requires keeping a branch with your changes.

   Example:
   ```fish
   git remote add upstream https://github.com/mylinuxforwork/dotfiles.git
   git fetch upstream
   git checkout main
   git pull --rebase upstream main
   git checkout personal
   git rebase main
   ```

2) Separate overlay package (recommended for minimal merge pain)
   - Create a second local package (e.g. `~/src/dotfiles-local`) with the same layout for only the files you want to override (for example `.config/hypr/custom.lua`).
   - Stow the main `dotfiles` package first, then stow your `dotfiles-local` package so its symlinks take precedence.

   Example (fish):
   ```fish
   # upstream dotfiles
   stow --dir=~/src/dotfiles --target=$HOME dotfiles

   # your overlay (created as a package named 'local')
   mkdir -p ~/src/dotfiles-local/.config/hypr
   # add custom.lua there, then
   stow --dir=~/src/dotfiles-local --target=$HOME local
   ```

Notes & cautions
- The repo's `.dotinst` restore-safe list includes `input.lua`, `monitors.lua`, and `custom.lua` — these are intentionally preserved during installer restores; prefer these files for machine-specific data.
- Avoid editing loader stubs like `dotfiles/.bashrc` and `dotfiles/.zshrc`; use the `custom/*` directories instead.
