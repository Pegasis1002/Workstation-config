# Precision Workstation

A minimal, keyboard-driven Arch Linux setup designed for deep work, Go development, and absolute focus.

## 🛠 Features
- **Window Manager:** Hyprland (No animations, minimal blur).
- **Terminal:** Kitty (Void Matrix Theme).
- **Editor:** Neovim (Primeagen-style, Harpoon, LSP, Treesitter).
- **Browser:** - **Qutebrowser:** For keyboard-driven research/Discord.
    - **Firefox App:** For YouTube (Shorts/Ads killed via uBlock).
- **Keyboard:** `keyd` layer remapping (Home row navigation).

## 🚀 Installation (Fresh Arch)

1. Clone the repo:
```bash
   git clone [https://github.com/YOUR_USERNAME/dotfiles.git](https://github.com/YOUR_USERNAME/dotfiles.git) ~/dotfiles
   cd ~/dotfiles
```

2. Run the installer:

```bash
    chmod +x setup.sh
    ./setup.sh
```

3. Post-Install Manual Steps:

- Firefox: Open Firefox once. Enable toolkit.legacyUserProfileCustomizations.stylesheets in about:config. Copy the firefox-css/chrome folder to your profile folder in ~/.mozilla/firefox/.
- uBlock: Import the filters from ublock_filters.txt (if you saved them) or see the script comments.

## Controls

### General
| Binding | Action |
| :--- | :--- |
| **Super + Enter** | Terminal (Kitty) |
| **Super + F** | Browser (Qutebrowser) |
| **Super + Y** | YouTube App (Firefox) |
| **Super + 1-5** | Workspaces |
| **Super + Shift + M** | Exit Hyprland |

### Keyboard Layers (keyd)
#### Global Modifier: Caps Lock (Tap for Esc)
| Key (While Holding Caps) | Action |
| :--- | :--- |
| **h** | Left Arrow |
| **j** | Down Arrow |
| **k** | Up Arrow |
| **l** | Right Arrow |
| **Space** | Backspace |
| **;** | Enter |

### Browser (Qutebrowser)
| Binding | Action |
| :--- | :--- |
| **ym** | Yank Markdown Link |
| **yy** | Yank URL |
| **xt** | Toggle Tabs |
| **v** | Enter Visual/Caret Mode (for copying text) |

### Media
| Binding | Action |
| :--- | :--- |
| **Tab + p** | Play/Pause |
| **Tab + j/k** | Volume Down/Up |
