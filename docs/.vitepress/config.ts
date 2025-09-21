const nav = (lang = "", override = {}) => {
  let prefix = lang ? `/${lang}` : "";
  return [
    { text: override.home || "Home", link: `${prefix}/` },
    { text: override.about || "About", link: `${prefix}/getting-started/overview` },
    { text: override.showcases || "Showcases", link: `${prefix}/showcases`, activeMatch: `^${prefix}/showcases/` },
    {
      text: "2.9.9.2", items: [
        {
          text: override.changelog || 'Changelog',
          link: 'https://github.com/mylinuxforwork/dotfiles/blob/main/CHANGELOG.md'
        },
      ],
    },
    {
      text: override.more || "More",
      items: [
        {
          text: 'ML4W Dotfiles Installer',
          // we can define like this, see below in sidebar section for more info  
          // link: '/dots-installer/overview'
          link: 'https://mylinuxforwork.github.io/dotfiles-installer/'
        },
        {
          text: 'ML4W Hyprland Starter',
          link: 'https://github.com/mylinuxforwork/hyprland-starter'
        },
        {
          text: 'Wallpapers',
          link: 'https://github.com/mylinuxforwork/wallpaper'
        },
        {
          text: override["contributing-wiki"] || 'Contributing to wiki →',
          link: `${prefix}/development/wiki`
        },
        {
          text: override.troubleshooting || 'Troubleshooting →',
          link: `${prefix}/help/troubleshooting`
        },
      ],
    },
  ];
};

const sidebar = (lang = "", override = {}) => {
  // future feature may be needed: sep sidebar for dots-installer section or any other
  // basicallyy when user visits /dots-installer/ page it will only show dots-installer menu items
  // just like how vitepress docs sep "refrence" section https://vitepress.dev/

  // '/dots-installer/': [
  //   {
  //    text: "Dots Installer",
  //    items: [
  //       { text: "Overview", link: "/dots-installer/overview" },
  //       { text: "Installation", link: "/dots-installer/installation" },
  //       { text: "Dots Installation", link: "/dots-installer/dots-installation" },
  //       { text: "Dots File", link: "/dots-installer/dots-file" },
  //     ],
  //   },
  // ],

  const prefix = lang ? `/${lang}` : "";

  return [
    {
      text: override["getting-started"] || "Getting Started",
      // collapsed: false,
      items: [
        { text: override["getting-started/overview"] || "Overview", link: `${prefix}/getting-started/overview` },
        { text: override["getting-started/installation"] || "Installation", link: `${prefix}/getting-started/install` },
        { text: override["getting-started/launch-hyprland"] || "Launch Hyprland", link: `${prefix}/usage/launch` },
        { text: override["getting-started/update"] || "Update", link: `${prefix}/getting-started/update` },
        { text: override["getting-started/uninstall"] || "Uninstall", link: `${prefix}/getting-started/uninstall` },
        { text: override["getting-started/migration"] || "Migration", link: `${prefix}/getting-started/migrate` },
        { text: override["getting-started/dependencies"] || "Dependencies", link: `${prefix}/getting-started/dependencies` },
      ],
    },
    {
      text: override["configuration"] || "Configuration",
      items: [
        { text: override["configuration/monitor-setup"] || "Monitor Setup", link: `${prefix}/configuration/monitor-setup` },
        { text: override["configuration/input"] || "Keyboard, Mouse, Touchpad", link: `${prefix}/configuration/input` },
        { text: override["customization/shell"] || "Shell", link: `${prefix}/customization/shell` },
        { text: override["customization/terminal"] || "Default Terminal", link: `${prefix}/customization/terminal` },
        { text: override["customization/browser"] || "Default Browser", link: `${prefix}/customization/browser` },
        { text: override["customization/displaymanager"] || "Display Manager", link: `${prefix}/customization/displaymanager` },
        { text: override["configuration/hypr-nvidia"] || "Hyprland + NVIDIA", link: `${prefix}/configuration/hypr-nvidia` },
        { text: override["configuration/xwayland"] || "Switch SDL (X11/Wayland)", link: `${prefix}/configuration/xwayland` },
        { text: override["usage/keybindings"] || "Keybindings", link: `${prefix}/usage/keybindings` },
        { text: override["usage/sidepad"] || "Sidepad", link: `${prefix}/usage/sidepad` },
        { text: override["usage/screenshots"] || "Screenshots", link: `${prefix}/usage/screenshots` },
        { text: override["usage/game-mode"] || "Game Mode", link: `${prefix}/usage/game-mode` },
      ],
    },
    {
      text: override["customization"] || "Customization",
      collapsed: true,
      items: [
        { text: override["customization/dotfiles"] || "Dotfiles Customization", link: `${prefix}/customization/dotfiles` },
        { text: override["customization/wallpapers"] || "Wallpapers", link: `${prefix}/usage/wallpapers` },
        { text: override["customization/variants"] || "Config Variants", link: `${prefix}/customization/variants` },
        { text: override["customization/waybar"] || "Customize Waybar", link: `${prefix}/customization/waybar` },
        { text: override["configuration/preserve-config"] || "Preserve your Customization", link: `${prefix}/configuration/preserve-config` },
      ],
    },
    {
      text: "ML4W Apps",
      collapsed: true,
      items: [
        { text: override["ml4w-apps/welcome"] || "Welcome App", link: `${prefix}/ml4w-apps/welcome` },
        { text: override["ml4w-apps/sidebar"] || "Sidebar App", link: `${prefix}/ml4w-apps/sidebar` },
        { text: override["ml4w-apps/dotfiles-app"] || "Dotfiles Settings", link: `${prefix}/ml4w-apps/dotfiles-app` },
        { text: override["ml4w-apps/hyprland-app"] || "Hyprland Settings", link: `${prefix}/ml4w-apps/hyprland-app` },
      ],
    },
    {
      text: override["help"] || "Help",
      // collapsed: false,
      items: [
        { text: override["help/troubleshooting"] || "Troubleshooting", link: `${prefix}/help/troubleshooting` },
      ],
    },
    {
      text: override["development"] || "Development",
      collapsed: true,
      items: [
        { text: override["development/wiki"] || "Contributing to wiki", link: `${prefix}/development/wiki` },
      ]
    },
    {
      text: override["credentials"] || "Credentials",
      items: [
        { text: override["credentials/thankyou"] || "Special Thanks", link: `${prefix}/credentials/thankyou` },
      ]
    },
  ]
};

// .vitepress/config.ts
export default {
  title: 'ML4W Dotfiles for Hyprland Wiki',
  description: 'An advanced and full-featured configuration for the dynamic tiling window manager Hyprland',
  base: "/dotfiles/",
  lastUpdated: true,
  cleanUrls: true,

  head: [
    ["link", { rel: "icon", href: "ml4w.svg" }],
  ],

  locales: {
    root: {
      label: "English",
      lang: "en-US",
      title: 'ML4W Dotfiles for Hyprland Wiki',
      description: 'An advanced and full-featured configuration for the dynamic tiling window manager Hyprland',

      themeConfig: {
        siteTitle: "ML4W Hyprland Dotfiles ",
        logo: "/ml4w.svg",
        outline: "deep",
        docsDir: "/docs",
        editLink: {
          pattern: "https://github.com/mylinuxforwork/dotfiles/tree/main/docs/:path",
          text: "Edit this page on GitHub",
        },

        nav: nav("", {}),
        sidebar: sidebar("", {}),

        returnToTopLabel: 'Go to Top',
        sidebarMenuLabel: 'Menu',
      },
    },

    de: {
      label: "Deutsch",
      lang: "de-DE",
      title: 'ML4W Dotfiles für Hyprland Wiki',
      description: 'Eine fortschrittliche und voll ausgestattete Konfiguration für den dynamischen Tiling-Window-Manager Hyprland',

      themeConfig: {
        siteTitle: "ML4W Hyprland Dotfiles ",
        logo: "/ml4w.svg",
        outline: "deep",
        docsDir: "/docs",
        editLink: {
          pattern: "https://github.com/mylinuxforwork/dotfiles/tree/main/docs/:path",
          text: "Bearbeite diese Seite auf GitHub",
        },

        nav: nav("de", {
          home: "Startseite",
          about: "Über",
          showcases: "Showcases",
          more: "Mehr",
          changelog: "Änderungsprotokoll",
          "contributing-wiki": "Zur Wiki beitragen →",
          troubleshooting: "Fehlerbehebung →",
        }),

        sidebar: sidebar("de", {
          "getting-started": "Erste Schritte",
          "getting-started/overview": "Überblick",
          "getting-started/installation": "Installation",
          "getting-started/launch-hyprland": "Hyprland starten",
          "getting-started/update": "Aktualisieren",
          "getting-started/uninstall": "Deinstallieren",
          "getting-started/migration": "Migration",
          "getting-started/dependencies": "Abhängigkeiten",
          "configuration": "Konfiguration",
          "configuration/monitor-setup": "Monitor-Einrichtung",
          "configuration/input": "Tastatur, Maus, Touchpad",
          "customization/shell": "Shell",
          "customization/terminal": "Standard-Terminal",
          "customization/browser": "Standard-Browser",
          "customization/displaymanager": "Display Manager",
          "configuration/hypr-nvidia": "Hyprland + NVIDIA",
          "configuration/xwayland": "Wechsle SDL (X11/Wayland)",
          "usage/keybindings": "Tastenkombinationen",
          "usage/sidepad": "Sidepad",
          "usage/screenshots": "Screenshots",
          "usage/game-mode": "Spielmodus",
          "customization": "Anpassung",
          "customization/dotfiles": "Dotfiles-Anpassung",
          "customization/wallpapers": "Hintergrundbilder",
          "customization/variants": "Konfigurationsvarianten",
          "customization/waybar": "Waybar anpassen",
          "configuration/preserve-config": "Bewahre deine Anpassungen",
          "ml4w-apps/welcome": "Welcome App",
          "ml4w-apps/sidebar": "Sidebar App",
          "ml4w-apps/dotfiles-app": "Dotfiles Einstellungen",
          "ml4w-apps/hyprland-app": "Hyprland Einstellungen",
          "help": "Hilfe",
          "help/troubleshooting": "Fehlerbehebung",
          "development": "Entwicklung",
          "development/wiki": "Zur Wiki beitragen",
          "credentials": "Credits",
          "credentials/thankyou": "Besonderer Dank",
        }),

        returnToTopLabel: 'Gehe zu oben',
        sidebarMenuLabel: 'Menü',
      },
    },
  },

  themeConfig: {
    siteTitle: "ML4W Hyprland Dotfiles ",
    logo: "/ml4w.svg",
    outline: "deep",
    docsDir: "/docs",
    editLink: {
      pattern: "https://github.com/mylinuxforwork/dotfiles/tree/main/docs/:path",
      text: "Edit this page on GitHub",
    },

    socialLinks: [
      { icon: "discord", link: "https://discord.gg/c4fJK7Za3g" },
      { icon: "github", link: "https://github.com/mylinuxforwork" },
      {
        icon: {
          svg: '<img src="https://raw.githubusercontent.com/mylinuxforwork/dotfiles-installer/refs/heads/master/data/icons/hicolor/scalable/apps/com.ml4w.dotfilesinstaller.svg" width="24" height="24" alt="dots installer" />'
        },
        link: "https://github.com/mylinuxforwork/dotfiles-installer"
      },
    ],

    footer: {
      message: "Released under the GPL License",
      copyright: `<a href="https://ml4w.com" target="_blank">
        <img src="/dotfiles/ml4w.png" alt="ML4W" />
        Copyright © 2025 Stephan Raabe
      </a>`,
    },

    search: {
      provider: "local",
    },
  },
};
