#!/bin/bash
# install.sh - The Precision Deployer

set -e # Exit on error

DOTFILES="$HOME/dotfiles"

echo "🚀 Initiating Precision Workstation Deployment..."

# 1. Install System Dependencies (Arch Only)
if ! command -v stow &> /dev/null; then
    echo "📦 Installing Base Tools..."
    sudo pacman -Syu --noconfirm
    sudo pacman -S --noconfirm stow git neovim hyprland kitty qutebrowser starship ripgrep fd
fi

# 2. The STOW Loop (The Magic)
# This creates symlinks from ~/dotfiles/package/* to ~/*
echo "🔗 Stowing configurations..."
cd "$DOTFILES"
for folder in nvim hypr kitty qutebrowser shell scripts; do
    echo "   -> Stowing $folder"
    stow -R $folder
done

# 3. System Level Configs (Requires Root)
echo "🔒 Configuring System..."
if [ -f "$DOTFILES/system/etc/keyd/default.conf" ]; then
    sudo cp "$DOTFILES/system/etc/keyd/default.conf" /etc/keyd/default.conf
    sudo systemctl enable --now keyd
fi

# 4. Folder Creation
mkdir -p ~/notes/neorg
mkdir -p ~/projects

echo "✅ Deployment Complete. Restart shell."
