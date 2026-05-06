# Dotfiles

My personal dotfiles, macOS defaults, and Homebrew bundle. Designed for fast
bootstrap of a new MacBook (Apple Silicon).

## What's in here

| File / dir         | What it does                                           |
| ------------------ | ------------------------------------------------------ |
| `install.sh`       | Symlinks every config into `$HOME` and runs `macos.sh` |
| `macos.sh`         | Applies system preferences via `defaults write`        |
| `Brewfile`         | General-purpose Homebrew formulae and casks            |
| `zshrc`            | Interactive zsh config (oh-my-zsh, nvm, pnpm, bun, …)  |
| `zprofile`         | Login-shell env (PATH, prompt, aliases)                |
| `gitconfig`        | Git aliases, color, user identity                      |
| `gitignore_global` | Global git ignores (DS_Store, swap files, etc.)        |
| `vimrc`            | Vim config (Tomorrow-Night theme, indent, mappings)    |
| `vim/`             | Vim runtime (colorscheme, plugins, NERDTree, …)        |

## Bootstrap a new Mac

```sh
# 1. Install Xcode CLT and Homebrew
xcode-select --install
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 2. Clone this repo
mkdir -p ~/dev && cd ~/dev
git clone git@github.com:wylieconlon/dotfiles.git
cd dotfiles

# 3. Install all CLI tools and GUI apps
brew bundle --file=Brewfile

# 4. Install oh-my-zsh (it creates a default ~/.zshrc — remove it next so our
#    symlink can take its place)
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
rm -f ~/.zshrc

# 5. Symlink dotfiles + apply macOS defaults
sh install.sh

# 6. Install version managers (each manages their own runtimes)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash    # nvm
curl -fsSL https://bun.sh/install | bash                                            # bun
curl -fsSL https://pyenv.run | bash                                                 # pyenv
brew install jenv                                                                   # jenv (already in Brewfile)

# 7. Set up SSH key for GitHub
ssh-keygen -t ed25519 -C "wylie@superblockshq.com"
# then add ~/.ssh/id_ed25519.pub to GitHub
```

After step 5, log out and back in so all macOS defaults take effect.

## How `install.sh` works

`install.sh` walks every file in this repo and links it as `~/.${name}`
(e.g. `gitconfig` → `~/.gitconfig`). It skips itself, `macos.sh`, `Brewfile`,
`README.md`, and the `vim/` directory (which is symlinked to `~/.vim`
explicitly).

If a target already exists as a real file (not a symlink), the script warns
and skips it — back the file up and re-run.

After symlinking, `install.sh` invokes `macos.sh` to apply system preferences.

## macOS defaults applied by `macos.sh`

Captured from my current machine. Source of truth is `macos.sh`; this table
is here so I remember why I set them.

### Keyboard

| Setting                                | Value | Why                                        |
| -------------------------------------- | ----- | ------------------------------------------ |
| `ApplePressAndHoldEnabled`             | false | Hold key → repeat (no accent menu); vim    |
| `KeyRepeat`                            | 2     | Fastest practical repeat speed             |
| `InitialKeyRepeat`                     | 15    | Short delay before repeat starts           |
| `com.microsoft.VSCode` press-and-hold  | false | Per-app override for VS Code               |

The Apple System Preferences sliders only go down to 30/120; the values above
are below the GUI minimums and require `defaults write`.

### Text input (off)

`NSAutomaticCapitalizationEnabled`, `NSAutomaticDashSubstitutionEnabled`,
`NSAutomaticPeriodSubstitutionEnabled`, `NSAutomaticQuoteSubstitutionEnabled`
— all disabled so smart-quotes don't break code blocks.

### Appearance

- `AppleInterfaceStyle = Dark`
- `AppleMiniaturizeOnDoubleClick = false`

### Finder

- `AppleShowAllFiles = true` (show dotfiles)
- `ShowPathbar = true`
- `ShowStatusBar = true`

### Dock

- `autohide = true`
- `tilesize = 55`

## Shell layout

- `~/.zprofile` runs once at login. Contains `PATH`, prompt (`PS1`), and the
  `parse_git_branch` helper.
- `~/.zshrc` runs on every interactive shell. Loads oh-my-zsh, then version
  managers (nvm/pnpm/bun/jenv), `direnv`, and work-specific scripts (each
  guarded by an existence check so this repo stays portable).
- `~/.zshrc.local` (optional, gitignored) — for machine-specific overrides.

### Work / per-machine overrides

This repo is intentionally personal. Anything work-specific belongs in one of:

- `~/.zshrc.local` — extra exports, e.g. `export AWS_PROFILE=dev-sso`, work
  source-of-functions, etc. Already wired into `zshrc`.
- A local `Brewfile.work` next to this `Brewfile` (don't commit it). Install
  with `brew bundle --file=Brewfile.work`.
- Per-directory git identity via `includeIf` in `~/.gitconfig.local`:

  ```
  [includeIf "gitdir:~/dev/superblocks/"]
      path = ~/.gitconfig.work
  ```

  with `~/.gitconfig.work` containing the work email override.

### Auto Node version per directory

`zshrc` registers a `chpwd` hook that runs `nvm use` whenever you `cd` into
a directory containing a `.nvmrc`.

## Vim

- Theme: **Tomorrow-Night** (in `vim/colors/`).
- Plugins included as plain files: NERDTree, slime, jade syntax/indent.
- Leader is `,`. `jk` exits insert mode. Window movement via `Ctrl-h/j/k/l`.
- `set clipboard=unnamed` shares yank/paste with the macOS clipboard.
- `vim/bundle/ctrlp.vim/` is an empty placeholder — install with
  `git clone https://github.com/ctrlpvim/ctrlp.vim ~/dev/dotfiles/vim/bundle/ctrlp.vim`
  if you want fuzzy-find back.

## Git aliases

```
br = branch         co = checkout       st = status -sbu
ci = commit         cl = clone          fa = fetch --all
rh = reset --hard origin/master
la = log --graph --pretty=format:'%h - %d %s (%cr) <%an>' --abbrev-commit
```

## Adding a new dotfile

1. Drop it in this repo with no leading dot (e.g. `tmux.conf`).
2. Add it to the symlink loop's exclusion in `install.sh` only if it should
   *not* be symlinked.
3. Re-run `sh install.sh`.

Inspired by [thoughtbot/dotfiles](https://github.com/thoughtbot/dotfiles).
