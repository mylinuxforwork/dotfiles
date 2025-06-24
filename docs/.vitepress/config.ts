// .vitepress/config.ts
export default {
  title: 'ML4W-Hyprland',
  description: ' ML4W-Hypland Dotfiles wiki',
  base: "/dotfiles/",
  lastUpdated: true,
  cleanUrls: true,

  head: [
    ["link", { rel: "icon", href: "ml4w.png" }],
  ],

  themeConfig: {
    siteTitle: "ML4W-Hyprland",
    logo: "/ml4w.png",
    outline: "deep",
    docsDir: "/docs",
    editLink: {
      pattern: "https://github.com/mylinuxforwork/dotfiles/tree/main/docs/:path",
      text: "Edit this page on GitHub",
    },
    nav: [
      { text: "Home", link: "/" },
      { text: "About", link: "/getting-started/overview" },
      {
        text: "Showcases",
        link: "/showcases",
        activeMatch: "/showcases/",
      },
     {
        text: "2.9.8.6",
        items: [
          {
            text: 'Changelog',
            link: 'https://github.com/mylinuxforwork/dotfiles/blob/main/CHANGELOG.md'
          },
        ],
      },
      {
        text: "More",
        items: [
          {
            text: 'Dotfiles Installer',
//          we can define like this, see below in sidebar section for more info  
//          link: '/dots-installer/overview'
            link: 'https://github.com/mylinuxforwork/dotfiles-installer'
          },
          {
            text: 'Hyprland Starter',
            link: 'https://github.com/mylinuxforwork/hyprland-starter'
          },
          {
            text: 'Wallpapers',
            link: 'https://github.com/mylinuxforwork/wallpaper'
          },
          {
           text: 'Contributing to wiki →',
           link: '/development/wiki'
          },
          {
           text: 'Troubleshooting →',
           link: '/help/troubleshooting'
          },
        ],
      },
    ],

    sidebar: {
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

    // default sidebar '/' that shows for all pages except those with specific sidebar rules above...

      '/': [
        {
          text: "Getting Started",
          // collapsed: false,
          items: [
            { text: "Overview", link: "/getting-started/overview" },
            { text: "Install", link: "/getting-started/install" },
            { text: "Install Options", link: "/getting-started/options" },
            { text: "Install in VM (KVM)", link: "/getting-started/vm-install" },
            { text: "Update", link: "/getting-started/update" },
            { text: "Uninstall", link: "/getting-started/uninstall" },
          ],
        },
        {
          text: "Configuration",
          collapsed: true,
          items: [
            { text: "Preserve Config & Customize", link: "/configuration/preserve-config" },
            { text: "Auto Setup & Update", link: "/configuration/auto-setup" },
            { text: "Use on Other Distros", link: "/configuration/distros" },
            { text: "Monitor Setup", link: "/configuration/monitor-setup" },
            { text: "Hyprland + NVIDIA", link: "/configuration/hypr-nvidia" },
            { text: "Switch SDL (X11/Wayland)", link: "/configuration/xwayland" },
          ],
        },
        {
          text: "Usage",
          collapsed: true,
          items: [
            { text: "Launch Hyprland", link: "/usage/launch" },
            { text: "Keybindings", link: "/usage/keybindings" },
            { text: "Screenshots", link: "/usage/screenshots" },
            { text: "Game Mode", link: "/usage/game-mode" },
            { text: "Wallpapers", link: "/usage/wallpapers" },
            { text: "Power & Screenlock", link: "/usage/power-lock" },
          ],
        },
        {
          text: "Customization",
          collapsed: true,
          items: [
            { text: "Dotfiles Customization", link: "/customization/dotfiles" },
            { text: "Add Dock (nwg-dock)", link: "/customization/dock" },
            { text: "Customize Waybar", link: "/customization/waybar" },
            { text: "Shell (Zsh & Bash)", link: "/customization/shell" },
            { text: "Default Terminal", link: "/customization/terminal" },
            { text: "Default Browser", link: "/customization/browser" },
            { text: "Config Variants", link: "/customization/variants" },
          ],
        },
        {
          text: "ML4W Apps",
          collapsed: true,
          items: [
            { text: "Welcome App", link: "/ml4w-apps/welcome" },
            { text: "Sidebar App", link: "/ml4w-apps/sidebar" },
            { text: "Dotfiles Settings", link: "/ml4w-apps/dotfiles-app" },
            { text: "Hyprland Settings", link: "/ml4w-apps/hyprland-app" },
          ],
        },
        {
          text: "Qtile",
           collapsed: true,
          items: [
            { text: "Qtile Setup", link: "/qtile/qtile" },
          ],
        },
        {
          text: "Help",
          // collapsed: false,
          items: [
            { text: "Troubleshooting", link: "/help/troubleshooting" },
          ],
        },
        {
          text: "Development",
          collapsed: true,
          items: [
            { text: "Contributing to wiki", link: "development/wiki" },
          ]
        },
      ],
    },

    socialLinks: [
      { icon: "discord", link: "https://discord.gg/c4fJK7Za3g" },
      { icon: "github", link: "https://github.com/mylinuxforwork" },
    ],

    footer: {
      message: "Released under the GPL License.",
      copyright: "Copyright © 2025 Stephan Raabe",
    },

    search: {
      provider: "local",
    },

    returnToTopLabel: 'Go to Top',
    sidebarMenuLabel: 'Menu',
  },
};
