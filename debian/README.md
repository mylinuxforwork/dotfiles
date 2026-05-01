# Debian forky support

Bootstrap + orchestrator that installs these dotfiles on Debian forky
(testing). ML4W upstream targets Arch / Fedora / openSUSE; this folder
is the Debian path.

It does three things the upstream installer can't do on Debian:

1. Builds `.deb` packages, natively on the host, for the three pieces
   ML4W needs that aren't yet in Debian: `hyprsunset`, `swaync`,
   `nwg-dock-hyprland`.
2. `apt install`s those `.deb`s.
3. Runs the (forked) `ml4w-dotfiles-installer` against
   `profile.dotinst`, which points back at this repo's `dotfiles/`.

The Debian-specific dependency lists, preflight, and post scripts live
under `../setup/` (`packages-debian`, `preflight-debian.sh`,
`post-debian.sh`) — they are consumed by the installer, not by this
folder.

Podman is **not** used by the install path. It exists only as an
opt-in target (`make build-debs-podman`) for testing builds in a
clean `debian:forky` container.

## Usage

```sh
git clone https://github.com/thywyn/ml4wdotfiles.git
cd ml4wdotfiles/debian
./install.sh
```

`install.sh` will:

- bootstrap `git`, `curl`, `make`, `sudo` if missing
- `apt install` the build deps + `fpm` (`make build-deps`)
- build the missing-from-Debian packages on the host
  (`make build-debs`, output → `dist/`)
- `apt install` those `.deb`s
- install the `ml4w-dotfiles-installer` fork into `~/.local`
- run it against `profile.dotinst`

## Make targets

### Default (host) path

| Target                 | What it does                                       |
| ---------------------- | -------------------------------------------------- |
| `make build-deps`      | `apt install` build deps + `gem install fpm`       |
| `make build-debs`      | Build all `.deb` packages on the host into `dist/` |
| `make deb-<pkg>`       | Build a single `.deb` (`hyprsunset`, `swaync`, …)  |
| `make install-debs`    | `apt install ./dist/*.deb`                         |
| `make install`         | Equivalent to `./install.sh`                       |
| `make clean`           | Remove `dist/` and build work dirs                 |

### Opt-in podman path (test/dev)

| Target                   | What it does                                     |
| ------------------------ | ------------------------------------------------ |
| `make image`             | Build the `debian:forky` build container         |
| `make build-debs-podman` | Build all `.debs` inside the container           |
| `make deb-podman-<pkg>`  | Build a single `.deb` inside the container       |

## Layout

```
debian/
├── install.sh            # entry point
├── Makefile              # build / install targets
├── versions.env          # pinned upstream tags for built packages
├── profile.dotinst       # ML4W profile descriptor → this repo's dotfiles/
├── build/
│   ├── build-deps.txt    # apt build deps (host + container share this)
│   ├── Containerfile     # debian:forky build env (podman, opt-in)
│   ├── common.sh         # shared build helpers (clone, fpm wrapper)
│   ├── hyprsunset/build.sh
│   ├── swaync/build.sh
│   └── nwg-dock-hyprland/build.sh
└── dist/                 # built .deb files (gitignored)
```

## Pinned versions

Edit `versions.env` to bump tags. Each `build/<pkg>/build.sh` clones
its upstream at the pinned tag, builds it, and emits a `.deb` into
`dist/`.
