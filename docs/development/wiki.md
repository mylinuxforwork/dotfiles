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

This is not planned yet. But in case someone in the future knows how to implement multi-lang support with Vitepress, you're more than welcome to contribute.

The first language we are expecting support for is German (`de`).

If you're interested in implementing multi-lang support, you can refer to [this docs](https://github.com/carch-org/docs), where multi-lang setup has already been done, for reference.

> Thank you for your support.
