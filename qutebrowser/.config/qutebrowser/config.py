# ~/.config/qutebrowser/config.py

# 1. LOAD DEFAULT SETTINGS
config.load_autoconfig(False)

# 2. THE IRONCLAD ADBLOCK (Rust Engine)
# Enable the modern adblock method (required)
c.content.blocking.method = "both" # Uses adblock engine AND host list

# List of URLs for the adblock engine to download and use
c.content.blocking.adblock.lists = [
    "https://easylist.to/easylist/easylist.txt",
    "https://easylist.to/easylist/easyprivacy.txt",
    "https://secure.fanboy.co.nz/fanboy-annoyance.txt",
    "https://secure.fanboy.co.nz/fanboy-cookiemonster.txt",
    # You can add custom blocklist URLs here:
    # "https://raw.githubusercontent.com/Example/Blocklist/master/list.txt", 
]
# 3. QUIET MODE
# No tabs at the top (Use the status bar or 'b' to switch buffers)
# This saves vertical space and looks cleaner
c.tabs.show = 'multiple' 
c.tabs.position = 'left' # or 'top', but 'left' is unique and out of the way
c.tabs.width = '15%'     # Only show tabs if you really need them

# 'yy' -> Copy URL to system clipboard (for pasting in Discord/Notes)
config.bind('yy', 'yank selection')

# 4. KEYBINDINGS (The Fix)
# 'ym' -> Open Music (Safe, Mixes Only)
config.bind('ym', 'open https://music.youtube.com')

# 'yt' -> Open YouTube (Videos)
# Remember: Your GreaseMonkey script will block the feed here.
config.bind('yt', 'open https://www.youtube.com')

# 'gm' -> open Gemini
config.bind('gm', 'open https://gemini.google.com/app')

# Toggle TABS (Show/Hide) -> 'xt'
config.bind('xt', 'config-cycle tabs.show always never')

# 'xb' -> Quick toggle for the Status Bar (for full immersion)
config.bind('xb', 'config-cycle statusbar.show always never')

# Open current video in mpv
config.bind('m', 'spawn mpv {url}')
config.bind('M', 'hint links spawn mpv {hint-url}')

# 5. COLORS (Matching your Void Matrix Theme)
# Optional: Make qutebrowser dark and green to match Kitty
c.colors.webpage.darkmode.enabled = True # Forces dark mode on all sites
c.colors.webpage.darkmode.policy.images = 'never' # Don't invert images
