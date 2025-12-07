#!/bin/bash
# restructure.sh - Fixes the dotfiles layout for GNU Stow

# 1. Clean Garbage
echo "🧹 Cleaning legacy artifacts..."
rm -rf nvim/nvim              # The recursive symlink folder
rm -f nvim/harvest.sh         # Legacy script
rm -rf bash                   # We will move bashrc to 'shell' package

# 2. Prepare Stow Directories (The "Package" Layer)
echo "📂 Creating Stow directories..."
mkdir -p nvim/.config/nvim
mkdir -p hypr/.config/hypr
mkdir -p kitty/.config/kitty
mkdir -p qutebrowser/.config/qutebrowser
mkdir -p shell/.config
mkdir -p fontconfig/.config/fontconfig

# 3. Migrate Configs (The "Payload" Layer)
echo "🚚 Moving configurations..."

# Neovim (We will overwrite init.lua later, just moving for safety)
[ -f init.lua ] && mv init.lua nvim/.config/nvim/
[ -f nvim/init.lua ] && mv nvim/init.lua nvim/.config/nvim/

# Hyprland
mv hypr/hyprland.conf hypr/.config/hypr/ 2>/dev/null
mv hypr/hyprpaper.conf hypr/.config/hypr/ 2>/dev/null

# Kitty
mv kitty/kitty.conf kitty/.config/kitty/ 2>/dev/null

# Qutebrowser (Move everything except the .config folder we just made)
mv qutebrowser/autoconfig.yml qutebrowser/.config/qutebrowser/ 2>/dev/null
mv qutebrowser/config.py qutebrowser/.config/qutebrowser/ 2>/dev/null
mv qutebrowser/quickmarks qutebrowser/.config/qutebrowser/ 2>/dev/null
mv qutebrowser/greasemonkey qutebrowser/.config/qutebrowser/ 2>/dev/null
mv qutebrowser/bookmarks qutebrowser/.config/qutebrowser/ 2>/dev/null
mv qutebrowser/qsettings qutebrowser/.config/qutebrowser/ 2>/dev/null

# Shell (Consolidating bash, starship, and bin)
# Assuming .bashrc was in the root or bash folder based on your uploads
[ -f .bashrc ] && mv .bashrc shell/
[ -f bash/.bashrc ] && mv bash/.bashrc shell/
mv starship/starship.toml shell/.config/ 2>/dev/null

# Fonts
mv fontconfig/fonts.conf fontconfig/.config/fontconfig/ 2>/dev/null

echo "✅ Structure Fixed. Ready for Modularization."
