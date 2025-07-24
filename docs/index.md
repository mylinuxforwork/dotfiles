---
layout: home
pageClass: home-page

hero:
  name: The ML4W Dotfiles for Hyprland  
  image:
    src: /ml4w.png
    alt: Linux logo
    style: "width: 200px; height: auto;"
  tagline: An advanced and full-featured configuration for the dynamic tiling window manager Hyprland.
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
    title: One Script to Rule Them All
    details: Includes a powerful installation script to automate everything on Arch or Fedora based systems. Or use the Dotfiles Installer for other distros.

  - icon: <img width="35" height="35" src="https://cdn-icons-png.flaticon.com/128/16076/16076100.png" alt="theme"/>
    title: Dynamic Themes & Desktop
    details: Experience a complete desktop with Hyprland, dynamic material themes, and deep customization via dotfiles.

  - icon: <img width="35" height="35" src="https://cdn-icons-png.flaticon.com/128/3815/3815573.png" alt="configuration"/>
    title: Easy to Customize
    details: Comes with helpful graphical apps to configure your setup, change themes, and tweak your environment.

metaTitle: "The ML4W Dotfiles for Hyprland"
description: An advanced and full-featured configuration for the dynamic tiling window manager Hyprland including an easy to use installation script for Arch and Fedora based Linux distributions.
---

<img
  src="/ml4w-preview.png"
  alt="preview"
  style="max-width: 900px; width: 100%; border-radius: 12px; margin: 2rem auto; display: block;"
/>

<div align="center">

### Installation

You can install the ML4W Dotfiles for Hyprland with the Dotfiles Installer from Flathub.<br>Click on the badge below to install the app.

<a href="https://mylinuxforwork.github.io/dotfiles-installer/" target="_blank"><img src="https://mylinuxforwork.github.io/dotfiles-installer/dotfiles-installer-badge.png" style="border:0;margin-bottom:10px"></a>

Copy the following url into the Dotfiles Installer and start the installation.

#### Stable Release

```sh
https://raw.githubusercontent.com/mylinuxforwork/dotfiles/main/hyprland-dotfiles-stable.dotinst
```
#### Rolling Release

```sh
https://raw.githubusercontent.com/mylinuxforwork/dotfiles/main/hyprland-dotfiles.dotinst
```
Setup scripts to install the required dependencies are included for <i class="devicon-archlinux-plain"></i> **Arch, <i class="devicon-fedora-plain"></i> Fedora and <i class="devicon-opensuse-plain"></i> openSuse Tumbleweed**.<br>
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
