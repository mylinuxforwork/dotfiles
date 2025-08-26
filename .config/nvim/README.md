<p align="center">
  <img src="https://readme-typing-svg.demolab.com?font=Fira+Code&size=24&pause=1000&color=B4BEFE&center=true&vCenter=true&width=435&lines=My+PDE+with+neovim" alt="Typing SVG" />
</p>

Personalized Development Environment(PDE)

* Transparency first.
* For coding `Rust`, `Vue3`, `Go`, `Python`.

> [!NOTE]
>
> manually install LSP, formatter and linter.
>
> use `direnv` and nix-shell to manage the lsps  formatters etc.(NixOS)

| Language  | LSP                 | Formatter         | Linter   |
| ---       | ---                 | ---               | ---      |
| Go        | gopls               | goimports & gopls | -        |
| Rust      | rust-analyzer       | rustfmt           | clippy   |
| Python    | pyright             | ruff              | ruff     |
| Vue/TS/JS | vue-language-server | eslint_d          | eslint_d |

## Preview

![image](https://github.com/emxxjnm/nvim/assets/54089360/8876a392-c803-42cf-9793-46101e94e15a)
![image](https://github.com/emxxjnm/nvim/assets/54089360/d715070d-dabf-468a-b242-d9233fad5008)
![image](https://github.com/emxxjnm/nvim/assets/54089360/4c7892d6-6a24-4e5e-8ccb-12270654ad61)
![image](https://github.com/emxxjnm/nvim/assets/54089360/c973ff75-d4b4-4fad-b485-c515a61728ae)
![image](https://github.com/emxxjnm/nvim/assets/54089360/44b31fc1-fb2c-4e47-bf7a-b756d16e0837)

## Prepare

### Terminal

* [Alacritty](https://alacritty.org/): my configuration [here](https://github.com/emxxjnm/dotfiles/tree/main/home/dot_config/alacritty)
* [Wezterm](https://wezfurlong.org/wezterm/): my configuration [here](https://github.com/emxxjnm/dotfiles/tree/main/home/dot_config/wezterm)

### Terminal Multiplexers

* [Tmux](https://github.com/tmux/tmux)
* [Zellij](https://github.com/zellij-org/zellij): My configuration [here](https://github.com/emxxjnm/dotfiles/tree/main/home/dot_config/zellij)

### Text to ASCII

* [ASCII Art Generator](https://patorjk.com/software/taag/#p=display&f=Soft&t=Type%20Something%20)

### Dependencies

* [x] make (download tiktoken_core library for `CopilotChat.nvim`)
* [x] cargo (build the fuzzy binary for `blink.cmp`)

* [x] nodejs > 18.x (`copilot`)

* [x] [fd](https://github.com/sharkdp/fd)
* [x] [fzf](https://github.com/junegunn/fzf)
* [x] [ripgrep](https://github.com/BurntSushi/ripgrep)
* [x] [lazygit](https://github.com/jesseduffield/lazygit)
* [x] [bat](https://github.com/sharkdp/bat)
* [x] [delta](https://github.com/dandavison/delta)

### Keymaps

#### General

| Key         | Description            | Mode                |
| ---         | ---                    | ---                 |
| H           | first char of the line | **n**, **v**        |
| L           | end of the line        | **n**, **v**        |
| jj          | exit insert mode       | **i**               |
| Up          | increase window height | **n**               |
| Down        | decrease window height | **n**               |
| Left        | decrease window width  | **n**               |
| Right       | increase window width  | **n**               |
| C-h         | left window            | **n**               |
| C-j         | lower window           | **n**               |
| C-k         | upper window           | **n**               |
| C-l         | right window           | **n**               |
| M-j         | move down              | **n**, **i**, **v** |
| M-k         | move up                | **n**, **i**, **v** |
| leader + w  | save file              | **n**               |
| leader + W  | save files             | **n**               |
| leader + q  | quit                   | **n**               |
| leader + Q  | force quit             | **n**               |
| leader + _  | split below            | **n**               |
| leader + \| | split right            | **n**               |


### LSP

| Key            | Description               | Mode         |
| -------------- | --------------            | -----------  |
| gd             | goto definition           | **n**        |
| gD             | goto declaration          | **n**        |
| gt             | goto type definition      | **n**        |
| K              | hover                     | **n**        |
| gri            | goto implementation       | **n**        |
| grr            | references                | **n**        |
| grn            | rename                    | **n**        |
| C-s            | signature help            | **n**        |
| C-s            | signature help            | **i**        |
| [d             | next diagnostic           | **n**        |
| ]d             | prev diagnostic           | **n**        |
| leader + ca    | [c]ode [a]ction           | **n**        |
| leader + cc    | [c]ode [c]odelens run     | **n**        |
| leader + cC    | [c]ode [C]odelens display | **n**        |
| leader + cd    | [c]ode [d]iagnostic       | **n**        |
| leader + cf    | [c]ode [f]ormat           | **n**, **v** |
| leader + ll    | [l]sp [l]og               | **n**        |
| leader + li    | [l]sp [i]nfo              | **n**        |
| leader + lr    | [l]sp [r]estart           | **n**        |


### Finder: leader + [f]ind

| Key            | Description               | Mode          |
| -------------- | --------------            | ------------- |
| leader + fb    | [b]uffers                 | **n**         |
| leader + fc    | [c]ontent in open buffers | **n**         |
| leader + fd    | [d]iagnostics             | **n**         |
| leader + ff    | [f]iles                   | **n**         |
| leader + fg    | [g]rep                    | **n**         |
| leader + fl    | [l]ines(buffer)           | **n**         |
| leader + fp    | [p]rojects                | **n**         |
| leader + fr    | [r]ecent files            | **n**         |
| leader + fR    | [R]esume                  | **n**         |
| leader + fs    | [s]ymbols                 | **n**         |
| leader + fS    | [S]ymbols(workspace)      | **n**         |
| leader + fT    | [T]odos                   | **n**         |
| leader + fu    | [u]ndo                    | **n**         |
| leader + fw    | [w]ord                    | **n**, **v**  |


### Buffer: leader + [b]uffer

| Key            | Description        | Mode           |
| -------------- | --------------     | -------------- |
| [b             | prev buffer        | **n**          |
| ]b             | next buffer        | **n**          |
| leader + bc    | pick [c]lose       | **n**          |
| leader + bd    | [d]elete buffer    | **n**          |
| leader + bD    | [D]elete other     | **n**          |
| leader + bp    | buffer [p]ick      | **n**          |
| leader + bH    | close to the left  | **n**          |
| leader + bL    | close to the right | **n**          |
| leader + b[    | buffer move prev   | **n**          |
| leader + b[    | buffer move next   | **n**          |


### Git: leader + [g]it

| Key            | Description    | Mode           |
| -------------- | -------------- | -------------- |
| [g             | prev hunk      | **n**          |
| ]g             | next hunk      | **n**          |
| leader + gb    | [b]lame line   | **n**          |
| leader + gd    | [d]iff this    | **n**          |
| leader + gg    | lazy[g]it      | **n**          |
| leader + gp    | [p]review hunk | **n**          |


### Debugger: leader + [d]ebug

| Key            | Description         | Mode           |
| -------------- | --------------      | -------------- |
| leader + db    | toggle [b]reakpoint | **n**          |
| leader + dc    | [c]ontinue          | **n**          |
| leader + dC    | run to [C]ursor     | **n**          |
| leader + dt    | [t]erminate         | **n**          |
| leader + dr    | [r]estart           | **n**          |
| leader + dp    | [p]ause             | **n**          |
| leader + dO    | step [O]ver         | **n**          |
| leader + di    | step [i]nto         | **n**          |
| leader + do    | step [o]ut          | **n**          |
| leader + du    | [u]i toggle         | **n**          |


### Options: leader + [o]ption

| Key            | Description            | Mode           |
| -------------- | --------------         | -------------- |
| leader + od    | [d]iagnostic           | **n**          |
| leader + of    | [f]ormat(Global)       | **n**          |
| leader + oF    | [F]ormat(Buffer)       | **n**          |
| leader + oh    | [h]ints                | **n**          |
| leader + ol    | [l]ine number          | **n**          |
| leader + oL    | relative [L]ine number | **n**          |
| leader + os    | [s]pell                | **n**          |
| leader + ot    | [t]reesitter           | **n**          |
| leader + ow    | [w]rap                 | **n**          |


### Explorer

| Key            | Description          | Mode           |
| -------------- | --------------       | -------------- |
| C-n            | toggle file explorer | **n**          |


### Tester: leader + [t]est

| Key            | Description      | Mode           |
| -------------- | --------------   | -------------- |
| leader + tr    | [r]un            | **n**          |
| leader + ta    | [a]ttach         | **n**          |
| leader + tf    | [f]ile run       | **n**          |
| leader + tl    | [l]ast run       | **n**          |
| leader + tx    | stop[x]          | **n**          |
| leader + to    | [o]utput toggle  | **n**          |
| leader + ts    | [s]ummary toggle | **n**          |
| leader + tp    | [p]anel toggle   | **n**          |
| [t             | prev failed test | **n**          |
| ]t             | next failed test | **n**          |
