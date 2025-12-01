#!/bin/bash
# HARVEST.SH - Collects current config into the dotfiles folder

DOTS="$HOME/dotfiles"
echo "🚜 Harvesting configs into $DOTS..."

# 1. Create Structure
mkdir -p $DOTS/.config/{hypr,kitty,nvim,qutebrowser,starship}
mkdir -p $DOTS/scripts
mkdir -p $DOTS/keyd
mkdir -p $DOTS/firefox-css

# 2. Copy Configs
cp ~/.config/hypr/hyprland.conf $DOTS/.config/hypr/
cp ~/.config/kitty/kitty.conf $DOTS/.config/kitty/
cp -r ~/.config/nvim/* $DOTS/.config/nvim/
cp -r ~/.config/qutebrowser/* $DOTS/.config/qutebrowser/
cp ~/.config/starship.toml $DOTS/.config/starship.toml

# 3. Copy Shell
cp ~/.bashrc $DOTS/.bashrc

# 4. Copy Scripts (Youtube App, Harvest, etc)
cp -r ~/.local/bin/* $DOTS/scripts/

# 5. Copy System Configs (Requires sudo permissions usually, but we copy content)
# We copy this to a local file so we can sudo cp it back later
cp /etc/keyd/default.conf $DOTS/keyd/default.conf

# 6. Copy Firefox CSS (Tricky part - assumes one default profile)
# We find the profile ending in 'default-release' or similar
FIREFOX_PROFILE=$(find ~/.mozilla/firefox -maxdepth 1 -type d -name "*.default-release" | head -n 1)
if [ -d "$FIREFOX_PROFILE/chrome" ]; then
    cp -r "$FIREFOX_PROFILE/chrome" $DOTS/firefox-css/
    echo "✅ Firefox Chrome CSS captured."
else
    echo "⚠️  Firefox Chrome folder not found."
fi

echo "✅ Harvest Complete. cd to ~/dotfiles and git push."
