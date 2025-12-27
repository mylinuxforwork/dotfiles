---
layout: home
pageClass: home-page

hero:
  name: Die ML4W Dotfiles für Hyprland  
  image:
    src: /ml4w.svg
    alt: ML4W logo
    style: "width: 200px; height: auto;"
  tagline: Eine leistungsfähige und umfassende Konfiguration für den dynamischen Tiling-Fenstermanager Hyprland.
  actions:
    - theme: brand
      text: Erste Schritte 
      link: /getting-started/overview
    - theme: alt
      text: Installieren
      link: /getting-started/install
    - theme: alt
      text: GitHub ↗
      link: https://github.com/mylinuxforwork/dotfiles

features:
  - icon: <img width="35" height="35" src="https://cdn-icons-png.flaticon.com/128/807/807262.png" alt="scripts"/>
    title: Einfache Installation
    details: Unterstützung durch den Dotfiles Installer und Installationsskripte, um alle Abhängigkeiten für Arch, Fedora und openSuse zu installieren.

  - icon: <img width="35" height="35" src="https://cdn-icons-png.flaticon.com/128/16076/16076100.png" alt="theme"/>
    title: Dynamische Designs & Desktop
    details: Erlebe einen vollständigen Desktop mit Hyprland, adaptiven Material-Design-Themes und umfangreichen Anpassungsmöglichkeiten via Dotfiles.

  - icon: <img width="35" height="35" src="https://cdn-icons-png.flaticon.com/128/3815/3815573.png" alt="configuration"/>
    title: Viele Anpassungsoptionen
    details: Inklusive nützlicher grafischer Apps zur Konfiguration, zum Wechseln von Themes und zum Feintuning deiner Umgebung.

metaTitle: "Die ML4W-Dotfiles für Hyprland"
description: Eine leistungsfähige und vollständige Konfiguration für den dynamischen Tiling-Fenstermanager Hyprland, inklusive einfacher Installation über den Dotfiles Installer und voller Unterstützung für Arch Linux, Fedora und openSuse.
---

<img
  src="/screen-2992.jpg"
  alt="preview"
  style="max-width: 900px; width: 100%; border-radius: 12px; margin: 2rem auto; display: block;"
/>

<div align="center">

### Installation

Du kannst die ML4W-Dotfiles für Hyprland über den Dotfiles Installer aus Flathub installieren.<br>Klicke auf das untenstehende Badge, um die App zu installieren.

<a href="https://mylinuxforwork.github.io/dotfiles-installer/" target="_blank"><img src="https://mylinuxforwork.github.io/dotfiles-installer/dotfiles-installer-badge.png" style="border:0;margin-bottom:10px"></a>

Kopiere die folgende URL in den Dotfiles Installer und starte die Installation.

#### Stabile Version

```sh
https://raw.githubusercontent.com/mylinuxforwork/dotfiles/main/hyprland-dotfiles-stable.dotinst
```
#### Rolling-Version

```sh
https://raw.githubusercontent.com/mylinuxforwork/dotfiles/main/hyprland-dotfiles.dotinst
```
Installationsskripte zur Einrichtung der benötigten Abhängigkeiten sind für <i class="devicon-archlinux-plain"></i> **Arch, <i class="devicon-fedora-plain"></i> Fedora und <i class="devicon-opensuse-plain"></i> openSuse Tumbleweed** enthalten.<br>
Für andere Distributionen installiere bitte zuerst die <a href="/dotfiles/de/getting-started/dependencies">Abhängigkeiten</a>.

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
