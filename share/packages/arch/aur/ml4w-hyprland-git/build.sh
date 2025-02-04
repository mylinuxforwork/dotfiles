#!/bin/bash
rm -rf src pkg *.tar.zst ml4w-*
makepkg $1
