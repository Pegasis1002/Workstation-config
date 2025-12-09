#
# ~/.bashrc - The Precision Shell
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# --- 1. CORE BEHAVIOR (The "Third Arm") ---
# Enable Vi Mode - Navigate shell history with j/k, edit commands with vim keys
set -o vi

# History Control (Ignore duplicates and commands starting with space)
HISTCONTROL=ignoreboth:erasedups
HISTSIZE=10000
HISTFILESIZE=20000
shopt -s histappend

# --- 2. MODERN INITIALIZATION ---
# Initialize Starship (The HUD Prompt)
eval "$(starship init bash)"

# Initialize Zoxide (The Smart CD)
eval "$(zoxide init bash)"
alias cd="z"

# --- 3. PRECISION ALIASES ---
# ls -> eza (Grid view, icons, directories first)
alias ls='eza -l --icons --group-directories-first'
alias ll='eza -l --icons --group-directories-first --git' # List view + git
alias la='eza -la --icons --group-directories-first'      # All files
alias tree='eza --tree --icons'

# cat -> bat (Syntax highlighting + line numbers)
alias cat='bat --style=plain --paging=never'

# grep -> ripgrep (Faster, colorized)
alias grep='rg'

# Quick Navigation
alias c='clear'
alias nv='nvim'
alias q='exit'
alias dots='cd ~/dotfiles' 

# --- 4. ANDROID PRECISION TOOLS (Your Custom Functions) ---

# Send file to Phone Downloads
function push-phone() {
    if [ -z "$1" ]; then
        echo "Usage: push-phone <filename>"
    else
        echo "🚀 Sending $1 to Samsung F15..."
        adb push "$1" /sdcard/Download/
        echo "✅ Done."
    fi
}

# Pull file from Phone Downloads
function pull-phone() {
    echo "📱 Files on Samsung F15 (Download folder):"
    adb shell ls -1 /sdcard/Download/ | head -n 15
    echo "----------------------------------------"
    echo -n "Filename to pull (or press Enter to cancel): "
    read fname
    if [ ! -z "$fname" ]; then
        adb pull "/sdcard/Download/$fname" .
        echo "✅ Retrieved $fname"
    fi
}

# --- FORCE KEYBINDINGS ---
# Ensure Ctrl+L always clears the screen, even in Vi mode
bind -m vi-insert "\C-l":clear-screen
bind -m vi-command "\C-l":clear-screen

# Optional: Fix Ctrl+R (Reverse Search) in Vi mode if it feels weird
bind -m vi-insert "\C-r":reverse-search-history
bind -m vi-command "\C-r":reverse-search-history

# Database (Postgres) - Only run when coding
alias db-on="sudo systemctl start postgresql && echo '🐘 Database Online'"
alias db-off="sudo systemctl stop postgresql && echo 'zzz Database Sleeping'"

# Connectivity - toggle for "Deep Work"
alias wifi-off="nmcli radio wifi off && echo '🚫 Disconnected'"
alias wifi-on="nmcli radio wifi on && echo '🌐 Connected'"

# Bluetooth - usually a battery drain
alias blue-on="sudo systemctl start bluetooth"
alias blue-off="sudo systemctl stop bluetooth"

# The "Check" - See what is actually eating your RAM
alias check="btop"

# Clean unsued packages
alias sweep="sudo pacman -Rns $(pacman -Qtdq); sudo pacman -Sc"

alias cp='advcp -g'
alias mv='advmv -g'
. "$HOME/.cargo/env"
