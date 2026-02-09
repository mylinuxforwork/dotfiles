---
layout: home
pageClass: home-page

hero:
  name: ML4W OS<br>Dotfiles for Hyprland  
  image:
    src: /ml4w.svg
    alt: ML4W logo
    style: "width: 200px; height: auto;"
  tagline: An advanced and full-featured Operating System and Dotfiles Configuration based on the dynamic tiling window manager Hyprland.
  actions:
    - theme: brand
      text: Get Started 
      link: /getting-started/overview
    - theme: alt
      text: Install 
      link: /getting-started/install
    - theme: alt
      text: GitHub ↗
      link: https://github.com/mylinuxforwork/dotfiles

features:
  - icon: <img width="35" height="35" src="https://cdn-icons-png.flaticon.com/128/807/807262.png" alt="scripts"/>
    title: Easy Testing & Installation
    details: Install ML4W OS on your preferred Linux Distribution with the Dotfiles Installer. Or test (and install) by using the Live ISO. 

  - icon: <img width="35" height="35" src="https://cdn-icons-png.flaticon.com/128/16076/16076100.png" alt="theme"/>
    title: Dynamic Themes & Desktop
    details: Experience a complete desktop based on the Dynamic Tiling Window Manager Hyprland, adaptive material themes, dark & light mode.

  - icon: <img width="35" height="35" src="https://cdn-icons-png.flaticon.com/128/3815/3815573.png" alt="configuration"/>
    title: Many Customization Options
    details: Comes with helpful graphical apps and tools to configure your setup, change themes, and tweak your environment.

metaTitle: "The ML4W OS - Dotfiles for Hyprland"
description: An advanced and full-featured Operating System and configuration for the dynamic tiling window manager Hyprland including an easy to use Live ISO and installation procedure with the Dotfiles Installer script and full support for for Arch Linux, Fedora and openSuse.
---

<img
  src="/dotfiles2100.jpg"
  alt="preview"
  style="max-width: 900px; width: 100%; border-radius: 12px; margin: 2rem auto; display: block;"
/>

<div align="center">

### ML4W OS Live ISO

Run ML4W OS from a bootable USB Stick or directly in a KVM/Qemu virtual machine.<br>Run `sudo install-ml4w-os` in a terminal to install the ML4W OS with Arch Linux (BETA).

<a href="https://ml4w.com/iso/ml4w-os/ml4w-os-2.10.1-x86_64.iso" class="VPMyButton">Download the Live ISO </a>

### Installation on your Linux Distribution

You can install the ML4W OS Hyprland with the Dotfiles Installer available on Flathub.<br>Click on the badge below to install the app.

<a href="https://mylinuxforwork.github.io/dotfiles-installer/" target="_blank"><img src="https://mylinuxforwork.github.io/dotfiles-installer/dotfiles-installer-badge.png" style="border:0;margin-bottom:10px"></a>

Copy the following url into the Dotfiles Installer and start the installation.

::: code-group

```sh [Stable Release]
https://raw.githubusercontent.com/mylinuxforwork/dotfiles/main/hyprland-dotfiles-stable.dotinst
```
```sh [Rolling Release]
https://raw.githubusercontent.com/mylinuxforwork/dotfiles/main/hyprland-dotfiles.dotinst
```
:::

Setup scripts to install the required dependencies are included for <i class="devicon-archlinux-plain"></i> **Arch, <i class="devicon-opensuse-plain"></i> openSuse Tumbleweed** and <i class="devicon-fedora-plain"></i> Fedora.<br>
For other distros, please install <a href="/dotfiles/getting-started/dependencies">the dependencies</a> first.

</div>

<style>
:root {
  --vp-home-hero-name-color: transparent;
  --vp-home-hero-name-background: -webkit-linear-gradient(120deg, var(--vp-c-purple-3), var(--vp-c-brand-3));
  --vp-home-hero-image-filter: blur(44px);

  --overlay-gradient: color-mix(in srgb, var(--vp-c-brand-1), transparent 40%);
}

.dark {
  --overlay-gradient: color-mix(in srgb, var(--vp-c-brand-1), transparent 75%);
}

.home-page {
  background:
    linear-gradient(200deg, transparent 25%, var(--overlay-gradient) 55%, transparent 85%),
    radial-gradient(ellipse at 80% 180%, var(--overlay-gradient), transparent 60%),
    var(--vp-c-bg);
  background-repeat: no-repeat;
  background-size: cover;

  .VPFeature a {
    font-weight: bold;
    color: var(--vp-c-brand-2);
  }

  .VPFooter {
    background-color: transparent !important;
    border: none;
  }

  .VPMyButton {
    border-radius: 20px;
    padding: 10px 20px;
    line-height: 38px;
    font-size: 14px;
    text-decoration:none;    
    border-color: var(--vp-button-brand-border);
    color: var(--vp-button-brand-text);
    background-color: var(--vp-button-brand-bg);
  }

  .VPNavBar {
    background-color: transparent !important;
    -webkit-backdrop-filter: blur(16px);
    backdrop-filter: blur(16px);

    div.divider {
      display: none;
    }
  }
}

@media (min-width: 640px) {
  :root {
    --vp-home-hero-image-filter: blur(56px);
  }
}

@media (min-width: 960px) {
  :root {
    --vp-home-hero-image-filter: blur(68px);
  }
}
</style>
