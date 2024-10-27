<p align="center">
  <img src="https://readme-typing-svg.demolab.com?font=Fira+Code&size=24&pause=1000&color=B4BEFE&center=true&vCenter=true&width=435&lines=My+PDE+with+neovim" alt="Typing SVG" />
</p>

Personal Neovim configuration, it's more delicious when paired with `Tmux` or `WezTerm`.

* Transparency first.
* For coding `Rust`, `Vue3`, `Go`, `Python`.

| Language  | LSP           | Formatter            | Linter               |
| ---       | ---           | ---                  | ---                  |
| Go        | gopls         | goimports & gopls    | -                    |
| Rust      | rust-analyzer | rustfmt              | clippy               |
| Python    | pyright       | ruff                 | ruff                 |
| Vue/TS/JS | Volar         | eslint_d & stylelint | eslint_d & stylelint |

## Preview

![image](https://github.com/emxxjnm/nvim/assets/54089360/8876a392-c803-42cf-9793-46101e94e15a)
![image](https://github.com/emxxjnm/nvim/assets/54089360/d715070d-dabf-468a-b242-d9233fad5008)
![image](https://github.com/emxxjnm/nvim/assets/54089360/4c7892d6-6a24-4e5e-8ccb-12270654ad61)
![image](https://github.com/emxxjnm/nvim/assets/54089360/c973ff75-d4b4-4fad-b485-c515a61728ae)
![image](https://github.com/emxxjnm/nvim/assets/54089360/44b31fc1-fb2c-4e47-bf7a-b756d16e0837)

## Try it with docker

```bash
docker run -w /root -it --rm alpine:edge sh -uelic '
  apk add git lazygit neovim ripgrep fd fzf sqlite-dev python3 go npm alpine-sdk --update
  git clone https://github.com/emxxjnm/nvim.git ~/.config/nvim
  cd ~/.config/nvim
  nvim
'
```

## Prepare

### Terminal

[Kitty](https://sw.kovidgoyal.net/kitty/) and [Alacritty](https://alacritty.org/) are both good. Kitty supports ligatures but Alacritty does not.

### Font
A few fonts that I personally like.

* [INPUT](https://input.djr.com/)

* [Monaspace](https://monaspace.githubnext.com/)

* [Recursive Sans & Mono](https://www.recursive.design/)

#### Patch the font(Nerd fonts)

```bash
docker run --rm \
    -v /path/to/font:/in \
    -v /path/for/output:/out \
    nerdfonts/patcher \
    --careful \
    --complete \
    --progressbars
```

### Text to ASCII

* [ASCII Art Generator](https://patorjk.com/software/taag/#p=display&f=Soft&t=Type%20Something%20)

### Dependencies

* [x] fd
* [x] fzf
* [x] ripgrep
* [x] lazygit

### Keymaps

#### General

| Key              | Description                   | Mode                |
| ------           | ---                           | ---                 |
| H                | To the first char of the line | **n**, **v**        |
| L                | To the end of the line        | **n**, **v**        |
| jj               | Exit insert mode              | **i**               |
| &lt;Up&gt;       | Increase window height        | **n**               |
| &lt;Down&gt;     | Decrease window height        | **n**               |
| &lt;Left&gt;     | Decrease window width         | **n**               |
| &lt;Right&gt;    | Increase window width         | **n**               |
| &lt;C-h&gt;      | Go to left window             | **n**               |
| &lt;C-j&gt;      | Go to lower window            | **n**               |
| &lt;C-k&gt;      | Go to upper window            | **n**               |
| &lt;C-l&gt;      | Go to right window            | **n**               |
| &lt;M-j&gt;      | Move down                     | **n**, **i**, **v** |
| &lt;M-k&gt;      | Move up                       | **n**, **i**, **v** |
| &lt;leader&gt;w  | Save file                     | **n**               |
| &lt;leader&gt;W  | Save files                    | **n**               |
| &lt;leader&gt;q  | Quit                          | **n**               |
| &lt;leader&gt;Q  | Force quit                    | **n**               |
| &lt;leader&gt;_  | Split below                   | **n**               |
| &lt;leader&gt;\| | Split right                   | **n**               |

### LSP

| Key              | Description           | Mode           |
| --------------   | --------------        | -------------- |
| gd               | Goto Definition       | **n**          |
| gD               | Goto Declaration      | **n**          |
| gr               | References            | **n**          |
| gi               | Goto Implementation   | **n**          |
| gt               | Goto Type Definition  | **n**          |
| K                | Hover                 | **n**          |
| gK               | Signature Help        | **n**          |
| &lt;C-k&gt;      | Signature Help        | **i**          |
| [d               | Next Diagnostic       | **n**          |
| ]d               | Prev Diagnostic       | **n**          |
| &lt;leader&gt;ca | Code Action           | **n**          |
| &lt;leader&gt;cr | Rename                | **n**          |
| &lt;leader&gt;cf | Format Document/Range | **n**, **v**   |
| &lt;leader&gt;ll | Lsp log               | **n**          |
| &lt;leader&gt;li | Lsp info              | **n**          |
| &lt;leader&gt;lr | Lsp restart           | **n**          |

### DAP

| Key              | Description       | Mode           |
| --------------   | --------------    | -------------- |
| &lt;leader&gt;db | Toggle breakpoint | **n**          |
| &lt;leader&gt;dc | Continue          | **n**          |
| &lt;leader&gt;dC | Run to cursor     | **n**          |
| &lt;leader&gt;dt | Terminate         | **n**          |
| &lt;leader&gt;dr | Restart           | **n**          |
| &lt;leader&gt;dp | Pause             | **n**          |
| &lt;leader&gt;dO | Step over         | **n**          |
| &lt;leader&gt;di | Step into         | **n**          |
| &lt;leader&gt;do | Step out          | **n**          |
| &lt;leader&gt;du | Toggle DAP UI     | **n**          |

### Neo-tree

| Key            | Description          | Mode           |
| -------------- | --------------       | -------------- |
| &lt;C-n&gt;    | Toggle file explorer | **n**          |

### Telescope

| Key              | Description          | Mode           |
| --------------   | --------------       | -------------- |
| &lt;leader&gt;ff | Find files           | **n**          |
| &lt;leader&gt;fg | Find in files (grep) | **n**          |
| &lt;leader&gt;fr | Recent files         | **n**          |
| &lt;leader&gt;fp | Recent projects      | **n**          |
| &lt;leader&gt;fc | Fuzzy search         | **n**          |
| &lt;leader&gt;fb | List buffers         | **n**          |
| &lt;leader&gt;fd | List diagnostics     | **n**          |
| &lt;leader&gt;fs | List symbols         | **n**          |
| &lt;leader&gt;fT | List todos           | **n**          |

### Gitsings

| Key              | Description    | Mode           |
| --------------   | -------------- | -------------- |
| [g               | Prev hunk      | **n**          |
| ]g               | Next hunk      | **n**          |
| &lt;leader&gt;gp | Preview hunk   | **n**          |
| ig               | Select hunk    | **o**, **x**   |

### LuaSnip

| Key            | Description     | Mode           |
| -------------- | --------------  | -------------- |
| &lt;C-o&gt;    | Select  options | **i**          |

### Bufferline

| Key              | Description        | Mode           |
| --------------   | --------------     | -------------- |
| [b               | Prev buffer        | **n**          |
| ]b               | Next buffer        | **n**          |
| &lt;leader&gt;bp | Buffer pick        | **n**          |
| &lt;leader&gt;bc | Pick close         | **n**          |
| &lt;leader&gt;bD | Close others       | **n**          |
| &lt;leader&gt;bH | Close to the left  | **n**          |
| &lt;leader&gt;bL | Close to the right | **n**          |

### Neotest

| Key              | Description         | Mode           |
| --------------   | --------------      | -------------- |
| &lt;leader&gt;tn | Run                 | **n**          |
| &lt;leader&gt;ta | Attach              | **n**          |
| &lt;leader&gt;tf | Run file            | **n**          |
| &lt;leader&gt;tl | Run last            | **n**          |
| &lt;leader&gt;tx | Stop                | **n**          |
| &lt;leader&gt;to | Toggle output       | **n**          |
| &lt;leader&gt;ts | Toggle summaryu     | **n**          |
| &lt;leader&gt;tp | Toggle output panel | **n**          |
| [t               | Prev failed test    | **n**          |
| ]t               | Next failed test    | **n**          |
