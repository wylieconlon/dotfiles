# ~/.zprofile — login-shell environment
# Loaded once per login. Use for PATH and exports that don't depend on
# interactive features. Interactive setup lives in ~/.zshrc.

# --- Git branch helper (used by PS1 below) -----------------------------------
parse_git_branch() {
  git branch --no-color 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

# --- Prompt -------------------------------------------------------------------
blue=$(tput setaf 4)
reset=$(tput sgr0)
PS1="\\w\[$blue\]\$(parse_git_branch)\[$reset\] > "
PS2='> '

# --- Editor -------------------------------------------------------------------
export EDITOR='vim'

# --- Color output -------------------------------------------------------------
alias ls="ls -G"
export CLICOLOR=1
export LSCOLORS=gxBxhxDxfxhxhxhxhxcxcx

# --- Aliases ------------------------------------------------------------------
alias ..="cd .."
alias g=git
alias gs="git st"
alias gc="git commit"
alias gd="git diff"

# --- PATH ---------------------------------------------------------------------
export PATH="$HOME/bin:$PATH"
export PATH="/usr/local/sbin:$PATH"

# Go (system install — Homebrew is preferred and is set up in zshrc)
[ -d /usr/local/go/bin ] && export PATH="/usr/local/go/bin:$PATH"

# Postgres.app (if installed)
if [ -d "/Applications/Postgres.app/Contents/Versions/13/bin" ]; then
  export PATH="/Applications/Postgres.app/Contents/Versions/13/bin:$PATH"
fi

# --- Java / ANTLR (legacy; kept for reference) -------------------------------
if [ -d "$HOME/dev/jdk-16.0.2.jdk" ]; then
  export JAVA_HOME="$HOME/dev/jdk-16.0.2.jdk/Contents/Home"
fi
if [ -f "$HOME/dev/antlr-4.9-complete.jar" ]; then
  export CLASSPATH="$HOME/dev/antlr-4.9-complete.jar"
  alias antlr4='java -Xmx500M -cp "$CLASSPATH" org.antlr.v4.Tool'
fi

# --- Homebrew (Apple Silicon) -------------------------------------------------
if [ -x /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# --- OrbStack -----------------------------------------------------------------
[ -f "$HOME/.orbstack/shell/init.zsh" ] && source "$HOME/.orbstack/shell/init.zsh"
