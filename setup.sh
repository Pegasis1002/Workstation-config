#!/bin/bash
# SETUP.SH - The Precision Workstation Installer

echo "Initializing Precision Protocol..."

# --- 1. CORE PACKAGES ---
echo "📦 Installing Core Packages..."
sudo pacman -Syu --noconfirm
sudo pacman -S --noconfirm \
    hyprland kitty qutebrowser firefox \
    neovim git base-devel stow \
    starship zoxide eza bat ripgrep fd \
    playerctl brightnessctl pamixer \
    ttf-jetbrains-mono-nerd \
    wl-clipboard android-tools \
    python-adblock python-tldextract \
    keyd

# --- 2. AUR HELPER (Yay) ---
if ! command -v yay &> /dev/null; then
    echo "📦 Installing Yay..."
    git clone https://aur.archlinux.org/yay.git
    cd yay && makepkg -si --noconfirm && cd .. && rm -rf yay
fi

# --- 3. AUR PACKAGES ---
echo "📦 Installing AUR Tools..."
# Add other AUR packages here if needed (e.g., cataclysm-dda-git)
yay -S --noconfirm cataclysm-dda-git

# --- 4. LINKING CONFIGS (GNU Stow) ---
echo "🔗 Linking Dotfiles..."
# Ensure we are in the dotfiles directory
cd "$(dirname "$0")"

# Backup existing configs to avoid conflicts
mv ~/.bashrc ~/.bashrc.bak 2>/dev/null
mv ~/.config/hypr ~/.config/hypr.bak 2>/dev/null
mv ~/.config/kitty ~/.config/kitty.bak 2>/dev/null
mv ~/.config/nvim ~/.config/nvim.bak 2>/dev/null
mv ~/.config/qutebrowser ~/.config/qutebrowser.bak 2>/dev/null

# Stow commands (Maps folders in ./ to ~/)
# We need to restructure the dotfiles folder slightly for stow to work perfectly 
# but for now, we will do manual linking for precision.

mkdir -p ~/.config/hypr ~/.config/kitty ~/.config/nvim ~/.config/qutebrowser

ln -sf $(pwd)/.config/hypr/hyprland.conf ~/.config/hypr/hyprland.conf
ln -sf $(pwd)/.config/kitty/kitty.conf ~/.config/kitty/kitty.conf
ln -sf $(pwd)/.config/nvim/* ~/.config/nvim/
ln -sf $(pwd)/.config/qutebrowser/* ~/.config/qutebrowser/
ln -sf $(pwd)/.config/starship.toml ~/.config/starship.toml
ln -sf $(pwd)/.bashrc ~/.bashrc

# Scripts
mkdir -p ~/.local/bin
cp -r scripts/* ~/.local/bin/
chmod +x ~/.local/bin/*

# --- 5. SYSTEM LEVEL CONFIGS ---
echo "🔒 Applying System Configs (Sudo)..."

# Keyd (Keyboard Remapping)
sudo cp keyd/default.conf /etc/keyd/default.conf
sudo systemctl enable keyd --now

# Firefox CSS
echo "🦊 Setting up Firefox CSS..."
# This is tricky on a fresh install as the profile has random string names.
# We instruct the user to run Firefox once first.
echo "NOTE: Launch Firefox once to generate a profile, then copy firefox-css/chrome to ~/.mozilla/firefox/<profile>/"

echo "✅ Setup Complete. Reboot recommended."
