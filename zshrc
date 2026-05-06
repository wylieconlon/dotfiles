# ~/.zshrc — interactive zsh configuration
# Loaded on every interactive shell. Pair with ~/.zprofile (login-only env vars).

# --- Oh My Zsh ----------------------------------------------------------------
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(git)
[ -s "$ZSH/oh-my-zsh.sh" ] && source "$ZSH/oh-my-zsh.sh"

# --- Homebrew (Apple Silicon) -------------------------------------------------
if [ -x /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# --- nvm ----------------------------------------------------------------------
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Auto-switch Node version when entering a directory with .nvmrc
autoload -U add-zsh-hook
load-nvmrc() {
  if [[ -f .nvmrc && -r .nvmrc ]]; then
    nvm use
  fi
}
add-zsh-hook chpwd load-nvmrc

# --- pnpm ---------------------------------------------------------------------
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# --- bun ----------------------------------------------------------------------
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
[ -s "$BUN_INSTALL/_bun" ] && source "$BUN_INSTALL/_bun"

# --- Go (for `air` and other Go tools) ---------------------------------------
if command -v go >/dev/null 2>&1; then
  export PATH="$PATH:$(go env GOPATH)/bin"
fi

# --- pyenv (uncomment on machines that use pyenv) -----------------------------
# eval "$(pyenv init --path)"
# eval "$(pyenv init -)"

# --- jenv ---------------------------------------------------------------------
if [ -d "$HOME/.jenv" ]; then
  export PATH="$HOME/.jenv/bin:$PATH"
  command -v jenv >/dev/null 2>&1 && eval "$(jenv init -)"
fi

# --- direnv -------------------------------------------------------------------
command -v direnv >/dev/null 2>&1 && eval "$(direnv hook zsh)"

# --- AWS ----------------------------------------------------------------------
# Set AWS_PROFILE in ~/.zshrc.local for work or personal accounts, e.g.:
#   export AWS_PROFILE=dev-sso

# --- uv (Python) --------------------------------------------------------------
[ -f "$HOME/.local/bin/env" ] && . "$HOME/.local/bin/env"

# --- Work-specific (Superblocks) — guarded so dotfiles stay portable ----------
[ -f "$HOME/dev/engineering/scripts/kubernetes_functions.sh" ] && \
  source "$HOME/dev/engineering/scripts/kubernetes_functions.sh"
[ -f "$HOME/dev/workspace/scripts/completions.zsh" ] && \
  source "$HOME/dev/workspace/scripts/completions.zsh"

# --- Local overrides (not checked in) -----------------------------------------
[ -f "$HOME/.zshrc.local" ] && source "$HOME/.zshrc.local"
