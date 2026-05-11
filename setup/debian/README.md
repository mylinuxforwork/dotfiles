# Debian forky support

This folder is the **Debian-specific data** for the standard ml4w
install flow. It is invoked by `setup/preflight-debian.sh` (which is
called by `ml4w-dotfiles-installer` during install).

It builds, on the host, the pieces ML4W needs that aren't yet
in Debian forky:

- `nwg-dock-hyprland`

(Forky now ships `sway-notification-center` and `hyprsunset`, so they
are installed via apt by `setup/dependencies/packages-debian`, not
built here.)

The resulting `.deb` files are installed via `apt install`, then the
regular `setup/dependencies/packages-debian` step (still part of the
standard installer flow) installs everything else from apt.

Podman is **not** used by the install path. It exists only as an
opt-in `make build-debs-podman` target for testing builds in a clean
`debian:forky` container.

## Standard install flow

```sh
# Install the ml4w-dotfiles-installer fork once
git clone https://github.com/thywyn/ml4w-dotfiles-installer.git
make -C ml4w-dotfiles-installer install

# Run it against the (Debian-aware) profile
~/.local/bin/ml4w-dotfiles-installer --install \
    https://raw.githubusercontent.com/thywyn/ml4wdotfiles/main/hyprland-dotfiles.dotinst
```

The installer clones this repo, runs `setup/preflight-debian.sh`
(which builds and installs the `.deb`s above), then installs
`setup/dependencies/packages-debian`, then runs
`setup/post-debian.sh`, then symlinks the dotfiles.

## Make targets (dev convenience)

These are for iterating on individual `.deb` build recipes; the
install path doesn't need them directly — preflight-debian.sh calls
`make build-deps`, `make build-debs`, and `make install-debs`.

### Default (host) path

| Target              | What it does                                       |
| ------------------- | -------------------------------------------------- |
| `make build-deps`   | `apt install` build deps + `gem install fpm`       |
| `make build-debs`   | Build all `.deb` packages on the host into `dist/` |
| `make deb-<pkg>`    | Build a single `.deb` (`nwg-dock-hyprland`)        |
| `make install-debs` | `apt install ./dist/*.deb`                         |
| `make clean`        | Remove `dist/` and build work dirs                 |

### Opt-in podman path (test/dev)

| Target                   | What it does                                     |
| ------------------------ | ------------------------------------------------ |
| `make image`             | Build the `debian:forky` build container         |
| `make build-debs-podman` | Build all `.debs` inside the container           |
| `make deb-podman-<pkg>`  | Build a single `.deb` inside the container       |

## Layout

```
setup/debian/
├── Makefile              # dev-convenience build targets
├── versions.env          # pinned upstream tags for built packages
├── build/
│   ├── build-deps.txt    # apt build deps (host + container share this)
│   ├── Containerfile     # debian:forky build env (podman, opt-in)
│   ├── common.sh         # shared build helpers (clone, fpm wrapper)
│   └── nwg-dock-hyprland/build.sh
└── dist/                 # built .deb files (gitignored)
```

## Pinned versions

Edit `versions.env` to bump tags. Each `build/<pkg>/build.sh` clones
its upstream at the pinned tag, builds it, and emits a `.deb` into
`dist/`.
