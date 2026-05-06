#!/bin/sh
# macos.sh — apply system preferences captured from my current Mac.
# Safe to re-run. Re-applied values: see comments next to each line.
# Run after a fresh OS install: `sh macos.sh`

set -e

# =============================================================================
# Keyboard
# =============================================================================

# Disable press-and-hold accent menu so keys repeat when held (good for vim).
defaults write -g ApplePressAndHoldEnabled -bool false

# Fast key repeat (default 6, lowest practical 2).
defaults write -g KeyRepeat -int 2

# Short delay before key repeat begins (default 68, lowest practical 15).
defaults write -g InitialKeyRepeat -int 15

# Per-app overrides for editors that need their own ApplePressAndHold flag.
defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false
# Cursor (uncomment if installed; bundle id depends on install method):
# defaults write com.todesktop.230313mzl4w4u92 ApplePressAndHoldEnabled -bool false

# =============================================================================
# Text input — turn off "smart" auto-corrections that fight code/Markdown
# =============================================================================
defaults write -g NSAutomaticCapitalizationEnabled    -bool false
defaults write -g NSAutomaticDashSubstitutionEnabled  -bool false
defaults write -g NSAutomaticPeriodSubstitutionEnabled -bool false
defaults write -g NSAutomaticQuoteSubstitutionEnabled -bool false

# =============================================================================
# Appearance
# =============================================================================
defaults write -g AppleInterfaceStyle -string "Dark"
defaults write -g AppleMiniaturizeOnDoubleClick -bool false

# =============================================================================
# Finder
# =============================================================================
defaults write com.apple.finder AppleShowAllFiles  -bool true   # show dotfiles
defaults write com.apple.finder ShowPathbar        -bool true
defaults write com.apple.finder ShowStatusBar      -bool true

# =============================================================================
# Dock
# =============================================================================
defaults write com.apple.dock autohide  -bool true
defaults write com.apple.dock tilesize  -int  55

# =============================================================================
# Apply
# =============================================================================
killall Finder >/dev/null 2>&1 || true
killall Dock   >/dev/null 2>&1 || true
killall SystemUIServer >/dev/null 2>&1 || true
