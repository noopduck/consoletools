# consoletools

Personal dotfiles and terminal setup. Covers Neovim, tmux (with `mtmux`), shell, and window manager configs. Aimed at getting a productive, good-looking console environment up fast.

---

## Neovim

### `DOTFILES/.config/nvim/`

Targets **Neovim 0.12+**. Uses the new `vim.pack.add` API (no Lazy, no external plugin manager) and the built-in LSP client.

**Plugins installed via `vim.pack.add`:**

| Plugin | Purpose |
|---|---|
| `mason.nvim` | LSP/tool installer |
| `nvim-lspconfig` | LSP configuration helpers |
| `efmls-configs-nvim` | EFM language server configs |
| `nerdtree` | File tree |
| `catppuccin/nvim` | Colorscheme |

**LSP servers enabled:** `lua_ls`, `pyright`, `gopls`, `bashls`, `jsonls`, `ts_ls`, `yamlls`, `efm`

**EFM linters/formatters by language:**

| Language | Linter | Formatter |
|---|---|---|
| Python | flake8 | black, isort |
| Go | golangci-lint | gofmt |
| TypeScript/JavaScript | eslint | prettier |
| Shell/Bash | shellcheck | shfmt |
| YAML | yamllint | prettier |
| JSON | jsonlint | prettier |
| Lua | luacheck | stylua |
| Markdown | markdownlint | prettier |

**Key bindings (normal mode):**

| Key | Action |
|---|---|
| `gd` / `gD` | Go to definition / declaration |
| `gr` | References |
| `gi` | Go to implementation |
| `K` | Hover docs |
| `<leader>rn` | Rename symbol |
| `<leader>ca` | Code action |
| `<leader>d` | Diagnostic float |
| `[d` / `]d` | Prev / next diagnostic |
| `<leader>e` | Toggle NERDTree |
| `<leader>f` | Find current file in NERDTree |
| `<leader>F` | Format buffer |

**Copy config:**

```shell
cp -r DOTFILES/.config/nvim ~/.config/nvim
```

---

## Tmux

### Config (`DOTFILES/.tmux.conf`)

Catppuccin-themed setup via [TPM](https://github.com/tmux-plugins/tpm).

**Plugins:**

| Plugin | Purpose |
|---|---|
| `catppuccin/tmux` | Status bar theme |
| `tmux-sensible` | Sensible defaults |
| `tmux-yank` | System clipboard yank |
| `tmux-continuum` | Session persistence / auto-restore |
| `tmux-thumbs` | Hint-mode text picker |
| `tmux-fzf` | Fuzzy finder integration |
| `tmux-fzf-url` | Open URLs via fzf |
| `tmux-sessionx` | Session manager (bound to `prefix + o`) |
| `tmux-floax` | Floating pane (bound to `prefix + p`) |

**Keybindings (vi-mode pane navigation):**

| Key | Action |
|---|---|
| `prefix + h/j/k/l` | Select pane (vim directions) |
| `Alt + h/j/k/l` | Resize pane by 5 (no prefix) |
| `prefix + o` | Open sessionx session manager |
| `prefix + p` | Toggle floating pane (floax) |

Status bar shows: session name (left) — directory, time (right). Sessions persist across reboots via `tmux-continuum`.

**Install:**

```shell
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
cp DOTFILES/.tmux.conf ~/.tmux.conf
# Inside tmux: prefix + I  (capital i) to install plugins
```

Or use the setup script (Debian/Fedora/Manjaro):

```shell
./shell_customizations/tmux_setup.sh
```

---

### `mtmux` — session launcher

A script that manages a persistent named tmux session (named after the current user). Run it instead of `tmux` to start or reattach.

**What it does:**

1. Manages `ssh-agent` — starts one if needed, reuses an existing one, and propagates `SSH_AUTH_SOCK` into the tmux environment so it stays available across detach/reattach.
2. Attaches to an existing session if one is running.
3. Creates a new session with three named windows if none exists:
   - `0: Chat`
   - `1: Main`
   - `2: Code`
4. On Linux (non-WSL), launches the session under `systemd-run --scope` so it survives the login session.

**Install:**

```shell
cp mtmux ~/.local/bin/mtmux
chmod +x ~/.local/bin/mtmux
```

Or let `tmux_setup.sh` do it. Then just run:

```shell
mtmux
```

---

## Other dotfiles

| Path | Notes |
|---|---|
| `DOTFILES/.config/ghostty/` | Ghostty terminal config + Catppuccin Mocha theme |
| `DOTFILES/.config/alacritty/` | Alacritty config |
| `DOTFILES/.config/zsh/` | ZSH config (oh-my-zsh, p10k) |
| `DOTFILES/.config/fish/` | Fish shell config + nvm integration |
| `DOTFILES/.config/i3/` | i3 window manager config |
| `DOTFILES/.config/sway/` | Sway config + wofi CSS |
| `DOTFILES/.bashrc` | Bash config |
| `DOTFILES/.Xresources` | X resources |

---

## Nerd Fonts

Required for the status bar icons and NERDTree glyphs:

```shell
wget https://github.com/ryanoasis/nerd-fonts/blob/master/src/glyphs/PowerlineExtraSymbols.otf?raw=true
```

Or install any [Nerd Font](https://www.nerdfonts.com/) and set it as your terminal font.
