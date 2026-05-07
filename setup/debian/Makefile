SHELL := /bin/bash

ROOT := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))
DIST := $(ROOT)/dist
IMAGE := localhost/ml4w-debian-builder:forky

PACKAGES := hyprsunset nwg-dock-hyprland

# This Makefile is a *dev convenience* for iterating on the .deb build
# recipes. The install path is the standard ml4w flow:
#   ml4w-dotfiles-installer --install hyprland-dotfiles.dotinst
# which invokes setup/preflight-debian.sh, which in turn drives the
# same build steps these targets expose.

.PHONY: help build-deps build-debs $(addprefix deb-,$(PACKAGES)) \
        image build-debs-podman $(addprefix deb-podman-,$(PACKAGES)) \
        install-debs clean

help:
	@echo "Default (host) targets:"
	@echo "  build-deps         apt install build deps + fpm on the host"
	@echo "  build-debs         Build all .deb packages on the host into dist/"
	@echo "  deb-<pkg>          Build a single .deb on the host (pkg in: $(PACKAGES))"
	@echo "  install-debs       apt install the built .debs"
	@echo "  clean              Remove dist/ and build work dirs"
	@echo ""
	@echo "Opt-in podman targets (test/dev only):"
	@echo "  image              Build the podman build container"
	@echo "  build-debs-podman  Build all .debs inside the podman container"
	@echo "  deb-podman-<pkg>   Build a single .deb inside the podman container"

# ---------- host build path (default) ----------

build-deps:
	sudo DEBIAN_FRONTEND=noninteractive apt-get update
	sudo DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
		$$(grep -vE '^\s*(#|$$)' $(ROOT)/build/build-deps.txt)
	@if ! command -v fpm >/dev/null 2>&1; then \
		echo ":: installing fpm via gem"; \
		sudo gem install --no-document fpm; \
	fi

build-debs: $(addprefix deb-,$(PACKAGES))

$(addprefix deb-,$(PACKAGES)): deb-%:
	mkdir -p $(DIST)
	set -e; set -a; source $(ROOT)/versions.env; set +a; \
		ML4W_DEBIAN_ROOT=$(ROOT) bash $(ROOT)/build/$*/build.sh

# ---------- opt-in podman path (testing) ----------

image:
	podman build -t $(IMAGE) -f $(ROOT)/build/Containerfile $(ROOT)/build

build-debs-podman: image $(addprefix deb-podman-,$(PACKAGES))

$(addprefix deb-podman-,$(PACKAGES)): deb-podman-%:
	mkdir -p $(DIST)
	podman run --rm \
		-v $(ROOT):/ml4w-debian:Z \
		-w /work \
		-e ML4W_DEBIAN_ROOT=/ml4w-debian \
		-e WORK_DIR=/work/$* \
		$(IMAGE) bash -c 'set -e; set -a; source /ml4w-debian/versions.env; set +a; bash /ml4w-debian/build/$*/build.sh'

install-debs:
	@if ! ls $(DIST)/*.deb >/dev/null 2>&1; then \
		echo "no .debs in $(DIST) — run 'make build-debs' first"; exit 1; \
	fi
	sudo DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends $(DIST)/*.deb

clean:
	rm -rf $(DIST) $(ROOT)/build/work
