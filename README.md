# Dotfiles

Cross-platform (macOS + Linux) dotfiles with an opt-in setup wizard. It
**discovers what's already installed on the machine** and only installs/links
what you tick.

## Install

One command:

```sh
curl -fsSL https://raw.githubusercontent.com/elumixor/dotfiles/main/bootstrap.sh | bash
```

This installs `git` (if missing), clones the repo to `~/.dotfiles`, and launches
the wizard. You get a checkbox menu:

```
❯ ◉ Zsh shell + Oh My Zsh   (installed)
  ◉ Starship prompt
  ◉ fzf fuzzy finder        (installed)
  ◉ CLI tools (bat, fd, ripgrep)
  ◉ tmux + plugins
  ◉ Neovim config
  ◉ Node.js + Bun           (installed)
  ◉ Claude Code             (installed)
  ○ Miniconda (Python)
```

`↑/↓` move · `space` toggle · `a` all · `n` none · `enter` confirm.

Detected tools are tagged `(installed)` — installation is skipped, but the
config is still (re)linked. Existing real files are backed up to `*.bak.<ts>`,
never clobbered.

## Non-interactive

```sh
# accept the auto-detected defaults
curl -fsSL .../bootstrap.sh | bash -s -- --yes

# everything
curl -fsSL .../bootstrap.sh | bash -s -- --all

# only specific modules
curl -fsSL .../bootstrap.sh | bash -s -- shell starship nvim
```

Or, after cloning:

```sh
./setup.sh            # wizard
./setup.sh --list     # show module keys
./setup.sh shell tmux # just these
```

Env overrides: `DOTFILES_DIR` (clone target, default `~/.dotfiles`),
`DOTFILES_REPO` (source repo).

## Layout

| Path | What |
|------|------|
| `bootstrap.sh` | `curl \| bash` entrypoint — installs git, clones, runs `setup.sh` |
| `setup.sh` | the wizard: detect → select → install + link |
| `lib/common.sh` | logging, OS/pkg detection, idempotent symlinking |
| `lib/ui.sh` | the checkbox menu (reads `/dev/tty`) |
| `lib/modules.sh` | one block per module: label, detect, install + link |
| `zshrc`, `aliases.sh`, `fzf.sh`, `conda_init.sh` | shell config |
| `init.vim`, `*_config.vim`, `*.lua`, `coc-settings.json` | neovim config |
| `tmux.conf`, `starship.toml`, `condarc` | misc tool config |

Machine-specific shell settings go in `~/.zshrc.local` (sourced, not tracked).

## Adding a module

Add a block to `lib/modules.sh` and its key to the `MODULES` list:

```sh
mod_foo_label="My thing"
mod_foo_desc="what it does"
mod_foo_detect() { have foo; }            # 0 if already present
mod_foo_run()    { have foo || pkg_install foo; link_file "$DOTFILES/foo.conf" "$HOME/.foo.conf"; }
```
