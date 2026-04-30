#!/usr/bin/env bash
# Debian forky preflight: refresh the apt index once before per-package
# installs so we work against current metadata.

sudo apt-get update
