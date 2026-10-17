# shellcheck shell=bash
# Module definitions. Each module has:
#   mod_<key>_label   text         (var)
#   mod_<key>_desc    text         (var)
#   mod_<key>_detect  function -> 0 if already present
#   mod_<key>_run     function     (install + link; must be idempotent)
#
# MODULES lists the keys in display order.
# $DOTFILES is the repo root, exported by setup.sh.

MODULES=(shell git gh starship fzf tools tmux neovim node vscode zed claude conda)

# ---- shell: zsh + oh-my-zsh + plugins + zshrc/aliases -------------------
mod_shell_label="Zsh shell + Oh My Zsh"
mod_shell_desc="zsh, oh-my-zsh, autosuggestions, syntax-highlighting, zshrc, aliases"
mod_shell_detect() { [ -d "$HOME/.oh-my-zsh" ] && have zsh; }
mod_shell_run() {
  have zsh || pkg_install zsh
  if [ ! -d "$HOME/.oh-my-zsh" ]; then
    info "Installing Oh My Zsh…"
    RUNZSH=no KEEP_ZSHRC=yes CHSH=no \
      sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
  fi
  local custom="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
  _clone_or_skip https://github.com/zsh-users/zsh-autosuggestions "$custom/plugins/zsh-autosuggestions"
  _clone_or_skip https://github.com/zsh-users/zsh-syntax-highlighting "$custom/plugins/zsh-syntax-highlighting"

  link_file "$DOTFILES/zshrc" "$HOME/.zshrc"

  # Make zsh the default shell if it isn't.
  if [ "${SHELL##*/}" != "zsh" ] && have chsh; then
    local zsh_path; zsh_path="$(command -v zsh)"
    grep -q "$zsh_path" /etc/shells 2>/dev/null || echo "$zsh_path" | sudo tee -a /etc/shells >/dev/null 2>&1 || true
    confirm "Set zsh as your default login shell?" && chsh -s "$zsh_path" || true
  fi
}

# ---- git: aliases + lfs (identity stays in ~/.gitconfig.local) ----------
mod_git_label="Git config"
mod_git_desc="git aliases (patch) + lfs filters; identity stays in ~/.gitconfig.local"
mod_git_detect() { have git; }
mod_git_run() {
  have git || pkg_install git
  link_file "$DOTFILES/gitconfig" "$HOME/.gitconfig"
}

# ---- GitHub CLI ------------------------------------------------------------
mod_gh_label="GitHub CLI (gh)"
mod_gh_desc="gh for PRs, issues, auth"
mod_gh_detect() { have gh; }
mod_gh_run() {
  have gh && { ok "gh already installed"; return 0; }
  if [ "$PKG" = apt ]; then
    sudo mkdir -p -m 755 /etc/apt/keyrings
    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg \
      | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg >/dev/null
    sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" \
      | sudo tee /etc/apt/sources.list.d/github-cli.list >/dev/null
    sudo apt-get update
  fi
  pkg_install gh
  warn "run 'gh auth login' to authenticate"
}

# ---- starship prompt -----------------------------------------------------
mod_starship_label="Starship prompt"
mod_starship_desc="cross-shell prompt + starship.toml"
mod_starship_detect() { have starship; }
mod_starship_run() {
  have starship || { [ "$PKG" = brew ] && pkg_install starship || \
    sh -c "$(curl -sS https://starship.rs/install.sh)" -- --yes; }
  link_file "$DOTFILES/starship.toml" "$HOME/.config/starship.toml"
}

# ---- fzf -----------------------------------------------------------------
mod_fzf_label="fzf fuzzy finder"
mod_fzf_desc="fzf + key bindings (config sourced from repo)"
mod_fzf_detect() { have fzf; }
mod_fzf_run() { have fzf || pkg_install fzf; }

# ---- CLI tools: bat, fd, ripgrep ----------------------------------------
mod_tools_label="CLI tools (bat, fd, ripgrep)"
mod_tools_desc="modern replacements for cat/find/grep"
mod_tools_detect() { have bat && have fd && have rg; }
mod_tools_run() {
  have bat || pkg_install bat
  have fd  || pkg_install fd fd-find
  have rg  || pkg_install ripgrep
}

# ---- tmux ----------------------------------------------------------------
mod_tmux_label="tmux + plugins"
mod_tmux_desc="tmux, tpm (plugin manager), tmux.conf"
mod_tmux_detect() { have tmux && [ -d "$HOME/.tmux/plugins/tpm" ]; }
mod_tmux_run() {
  have tmux || pkg_install tmux
  _clone_or_skip https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
  link_file "$DOTFILES/tmux.conf" "$HOME/.tmux.conf"
  have tic && tic -x "$DOTFILES/tmux.terminfo" 2>/dev/null || true
}

# ---- neovim --------------------------------------------------------------
mod_neovim_label="Neovim config"
mod_neovim_desc="neovim, vim-plug, init.vim/lua configs, CoC + treesitter"
mod_neovim_detect() { have nvim && [ -e "$HOME/.config/nvim/init.vim" ]; }
mod_neovim_run() {
  have nvim || pkg_install neovim
  # vim-plug
  local plug="${XDG_DATA_HOME:-$HOME/.local/share}/nvim/site/autoload/plug.vim"
  [ -f "$plug" ] || curl -fLo "$plug" --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  link_file "$DOTFILES/init.vim" "$HOME/.config/nvim/init.vim"
  link_file "$DOTFILES/coc-settings.json" "$HOME/.config/nvim/coc-settings.json"
  if confirm "Install neovim plugins now (PlugInstall + treesitter)?"; then
    nvim --headless +PlugInstall +qall 2>/dev/null || warn "PlugInstall had issues; run :PlugInstall in nvim"
  fi
}

# ---- node + bun ----------------------------------------------------------
mod_node_label="Node.js + Bun"
mod_node_desc="node, npm, bun runtimes"
mod_node_detect() { have node && have bun; }
mod_node_run() {
  have node || pkg_install node
  have bun  || { [ "$PKG" = brew ] && brew install oven-sh/bun/bun || \
    curl -fsSL https://bun.sh/install | bash; }
}

# ---- VS Code (the `c`/`code` aliases) -----------------------------------
mod_vscode_label="VS Code (code CLI)"
mod_vscode_desc="discover/install VS Code and put 'code' on PATH"
mod_vscode_detect() { have code; }   # a real `code` binary on PATH (aliases aren't visible here)
mod_vscode_run() {
  # Already a real binary on PATH? done.
  if have code; then ok "code already on PATH"; return 0; fi
  # Discover an installed app bundle and link its CLI into ~/.local/bin.
  local p
  for p in \
    "/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code" \
    "$HOME/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code" \
    "/usr/share/code/bin/code" "/snap/bin/code"; do
    if [ -x "$p" ]; then
      mkdir -p "$HOME/.local/bin"
      ln -sf "$p" "$HOME/.local/bin/code"
      ok "linked code -> $p"
      return 0
    fi
  done
  # Not installed — install it.
  info "VS Code not found; installing…"
  case "$PKG" in
    brew) brew install --cask visual-studio-code ;;
    apt)  if have snap; then sudo snap install code --classic
          else warn "Install VS Code from https://code.visualstudio.com/download"; fi ;;
    *)    warn "Install VS Code from https://code.visualstudio.com/download" ;;
  esac
  have code && ok "code installed" || warn "open VS Code → Cmd+Shift+P → 'Shell Command: Install code command in PATH'"
}

# ---- zed ------------------------------------------------------------------
mod_zed_label="Zed editor"
mod_zed_desc="zed + JetBrainsMono Nerd Font, settings.json, keymap.json"
mod_zed_detect() { have zed || [ -d "/Applications/Zed.app" ]; }
mod_zed_run() {
  if ! mod_zed_detect; then
    info "Installing Zed…"
    case "$PKG" in
      brew) brew install --cask zed ;;
      *)    curl -f https://zed.dev/install.sh | sh ;;
    esac
  fi
  # Nerd font used by settings.json (buffer_font_family) and starship.
  if [ "$PKG" = brew ]; then
    brew list --cask font-jetbrains-mono-nerd-font >/dev/null 2>&1 || brew install --cask font-jetbrains-mono-nerd-font
  elif [ ! -d "$HOME/.local/share/fonts/JetBrainsMonoNF" ]; then
    info "Installing JetBrainsMono Nerd Font…"
    local tmp; tmp="$(mktemp -d)"
    curl -fsSL -o "$tmp/f.tar.xz" https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz \
      && mkdir -p "$HOME/.local/share/fonts/JetBrainsMonoNF" \
      && tar -xJf "$tmp/f.tar.xz" -C "$HOME/.local/share/fonts/JetBrainsMonoNF" \
      && { have fc-cache && fc-cache -f >/dev/null; }
    rm -rf "$tmp"
  fi
  link_file "$DOTFILES/zed/settings.json" "$HOME/.config/zed/settings.json"
  link_file "$DOTFILES/zed/keymap.json"   "$HOME/.config/zed/keymap.json"
  [ -x /Applications/Zed.app/Contents/MacOS/cli ] && ! have zed && { mkdir -p "$HOME/.local/bin"; ln -sf /Applications/Zed.app/Contents/MacOS/cli "$HOME/.local/bin/zed"; ok "linked zed CLI"; }
  return 0
}

# ---- claude code ---------------------------------------------------------
mod_claude_label="Claude Code"
mod_claude_desc="Anthropic's CLI coding agent"
mod_claude_detect() { have claude; }
mod_claude_run() {
  if have claude; then
    info "updating claude to latest"
    claude update || curl -fsSL https://claude.ai/install.sh | bash
  else
    curl -fsSL https://claude.ai/install.sh | bash
  fi
}

# ---- conda (off by default) ---------------------------------------------
mod_conda_label="Miniconda (Python)"
mod_conda_desc="miniconda + condarc (heavy; opt-in)"
mod_conda_detect() { have conda || [ -d "$HOME/miniconda3" ]; }
mod_conda_run() {
  if ! have conda && [ ! -d "$HOME/miniconda3" ]; then
    local arch url tmp
    arch="$(uname -m)"
    case "$OS-$arch" in
      macos-arm64)  url="https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-arm64.sh" ;;
      macos-*)      url="https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-x86_64.sh" ;;
      linux-aarch64)url="https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-aarch64.sh" ;;
      *)            url="https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh" ;;
    esac
    tmp="$(mktemp).sh"
    curl -fsSL "$url" -o "$tmp" && bash "$tmp" -b && rm -f "$tmp"
  fi
  link_file "$DOTFILES/condarc" "$HOME/.condarc"
}

# ---- helpers -------------------------------------------------------------
_clone_or_skip() {  # _clone_or_skip <url> <dir>
  local url="$1" dir="$2"
  if [ -d "$dir/.git" ]; then log "present: $dir"; else
    git clone --depth=1 "$url" "$dir" >/dev/null 2>&1 && ok "cloned $(basename "$dir")"
  fi
}
