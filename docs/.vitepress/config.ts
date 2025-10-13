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

  themeConfig: {
    siteTitle: "ML4W Hyprland Dotfiles ",
    logo: "/ml4w.svg",
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
        text: "2.9.9.3",
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
            text: 'ML4W Dotfiles Installer',
//          we can define like this, see below in sidebar section for more info  
//          link: '/dots-installer/overview'
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
            { text: "Installation", link: "/getting-started/install" },
            { text: "Launch Hyprland", link: "/usage/launch" },
            { text: "Update", link: "/getting-started/update" },
            { text: "Uninstall", link: "/getting-started/uninstall" },
            { text: "Migration", link: "/getting-started/migrate" },
            { text: "Dependencies", link: "/getting-started/dependencies" },
          ],
        },
        {
          text: "Configuration",
          items: [
            { text: "Monitor Setup", link: "/configuration/monitor-setup" },
            { text: "Keyboard, Mouse, Touchpad", link: "/configuration/input" },
            { text: "Shell", link: "/customization/shell" },
            { text: "Default Terminal", link: "/customization/terminal" },
            { text: "Default Browser", link: "/customization/browser" },
            { text: "Display Manager", link: "/customization/displaymanager" },
            { text: "Hyprland + NVIDIA", link: "/configuration/hypr-nvidia" },
            { text: "Switch SDL (X11/Wayland)", link: "/configuration/xwayland" },
            { text: "Keybindings", link: "/usage/keybindings" },
            { text: "Sidepad", link: "/usage/sidepad" },
            { text: "Screenshots", link: "/usage/screenshots" },
            { text: "Game Mode", link: "/usage/game-mode" },
            { text: "Activate Walker", link: "/configuration/walker" },
          ],
        },
        {
          text: "Customization",
          collapsed: true,
          items: [
            { text: "Dotfiles Customization", link: "/customization/dotfiles" },
            { text: "Wallpapers", link: "/usage/wallpapers" },
            { text: "Config Variants", link: "/customization/variants" },
            { text: "Customize Waybar", link: "/customization/waybar" },
            { text: "Preserve your Customization", link: "/configuration/preserve-config" },
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
        {
          text: "Credentials",
          items: [
            { text: "Special Thanks", link: "credentials/thankyou" },
          ]
        },      
      ],
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

    returnToTopLabel: 'Go to Top',
    sidebarMenuLabel: 'Menu',
  },
};
