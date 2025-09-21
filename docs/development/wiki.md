# Contributing to Wiki

This wiki is built with [Vitepress](https://vitepress.dev/).

You can find the wiki files in the [ml4w dotfiles](https://github.com/mylinuxforwork/dotfiles) repo.

If you want to contribute to this site, you can fork the repo, make your changes, and submit a PR.

## For building the docs locally:

You need to install `bun` from the [official Bun site](https://bun.sh).

First, install dependencies:

```sh
bun install
```

Initialize with Vitepress:

```sh
bun add -D vitepress
```

Run the dev server to view real-time changes:

```sh
bun run docs:dev
```

If you want to test the build, you can do:

```sh
bun run docs:build
```

To preview:

```sh
bun run docs:preview
```

Make sure your changes don’t introduce any errors. Test everything properly on your machine before submitting a PR.

## Guidelines

If your changes add something to the docs (like a new guide or a missing section), please make sure it's accurate and clearly written in clean Markdown.

Also, I request you not to rewrite or fully write things using LLMs.

Please we don't want to see `em dashes` here.

> We want the docs to be clean & minimal so please follow these guidelines.
## Multi-Lang Support

> [!WARNING]
>
> Documentation in languages other than English may not be up to date. Check the date and the ml4w version shown, and consult the English documentation if in doubt.

** To add a new language, follow these steps:**

1. Create a folder named with the language code (e.g., `docs/de/`) and put the translated Markdown files there.
2. Add the locale in `.vitepress/config.ts`. Minimal example:

```ts
// .vitepress/config.ts
export default {
  locales: {
    de: {
      label: "Deutsch",
      lang: "de-DE",
      title: 'ML4W Dotfiles für Hyprland Wiki',
      description: 'Eine fortschrittliche und voll ausgestattete Konfiguration für den dynamischen Tiling-Window-Manager Hyprland',
    }
  }
}
```

3. Verify routes and navigation use the language prefix (e.g., `/de/`) and update internal links accordingly.
4. In this section, indicate the date and the ml4w version corresponding to the last modification of the documentation in that language.

> Thank you for your support.
