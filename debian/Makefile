SHELL := /bin/bash

ROOT := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))
DIST := $(ROOT)/dist
IMAGE := localhost/myml4w-builder:forky

PACKAGES := hyprsunset swaync nwg-dock-hyprland

.PHONY: help build-deps build-debs $(addprefix deb-,$(PACKAGES)) \
        image build-debs-podman $(addprefix deb-podman-,$(PACKAGES)) \
        install-debs install-installer install clean

help:
	@echo "Default (host) targets:"
	@echo "  build-deps         apt install build deps + fpm on the host"
	@echo "  build-debs         Build all .deb packages on the host into dist/"
	@echo "  deb-<pkg>          Build a single .deb on the host (pkg in: $(PACKAGES))"
	@echo "  install-debs       apt install the built .debs"
	@echo "  install-installer  Install thywyn/ml4w-dotfiles-installer to ~/.local"
	@echo "  install            Full flow (build-deps + build-debs + install-debs + installer + run profile)"
	@echo "  clean              Remove dist/ and build work dirs"
	@echo ""
	@echo "Opt-in podman targets (test/dev only):"
	@echo "  image              Build the podman build container"
	@echo "  build-debs-podman  Build all .debs inside the podman container"
	@echo "  deb-podman-<pkg>   Build a single .deb inside the podman container"

# ---------- host build path (default) ----------

build-deps:
	sudo DEBIAN_FRONTEND=noninteractive apt-get update
	sudo DEBIAN_FRONTEND=noninteractive apt-get install -y \
		$$(grep -vE '^\s*(#|$$)' $(ROOT)/build/build-deps.txt)
	@if ! command -v fpm >/dev/null 2>&1; then \
		echo ":: installing fpm via gem"; \
		sudo gem install --no-document fpm; \
	fi

build-debs: $(addprefix deb-,$(PACKAGES))

$(addprefix deb-,$(PACKAGES)): deb-%:
	mkdir -p $(DIST)
	set -e; set -a; source $(ROOT)/versions.env; set +a; \
		MYML4W_ROOT=$(ROOT) bash $(ROOT)/build/$*/build.sh

# ---------- opt-in podman path (testing) ----------

image:
	podman build -t $(IMAGE) -f $(ROOT)/build/Containerfile $(ROOT)/build

build-debs-podman: image $(addprefix deb-podman-,$(PACKAGES))

$(addprefix deb-podman-,$(PACKAGES)): deb-podman-%:
	mkdir -p $(DIST)
	podman run --rm \
		-v $(ROOT):/myml4w:Z \
		-w /work \
		-e MYML4W_ROOT=/myml4w \
		-e WORK_DIR=/work/$* \
		$(IMAGE) bash -c 'set -e; set -a; source /myml4w/versions.env; set +a; bash /myml4w/build/$*/build.sh'

# ---------- install / orchestration ----------

install-debs:
	@if ! ls $(DIST)/*.deb >/dev/null 2>&1; then \
		echo "no .debs in $(DIST) — run 'make build-debs' first"; exit 1; \
	fi
	sudo apt-get update
	sudo DEBIAN_FRONTEND=noninteractive apt-get install -y $(DIST)/*.deb

install-installer:
	bash $(ROOT)/install.sh --installer-only

install:
	bash $(ROOT)/install.sh

clean:
	rm -rf $(DIST) $(ROOT)/build/work
