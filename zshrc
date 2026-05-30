# PATH
export PATH="$HOME/.local/bin:$PATH"

# Homebrew (user-prefix on Mac; absent on beasts)
[ -x "$HOME/homebrew/bin/brew" ] && eval "$($HOME/homebrew/bin/brew shellenv)"

# History
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt append_history
setopt hist_ignore_dups
unsetopt inc_append_history
unsetopt share_history

# Completions
autoload -Uz compinit && compinit

# Theme
source ~/.zsh/themes/spaceship-prompt/spaceship.zsh
SPACESHIP_TIME_SHOW=true
SPACESHIP_NODE_SHOW=false
SPACESHIP_PACKAGE_SHOW=false
SPACESHIP_BATTERY_THRESHOLD=30

# Plugins
source ~/.zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Attach to the persistent claude tmux session on a beast, in its assigned
# project. Thin alias to `fleet attach` (chief's control plane — see
# ~/projects/chief/.claude/skills/fleet), so you and chief drive the same
# session the same way (parity). Falls back to a direct attach if fleet is absent.
# Usage: ssh-claude          → beast4 (default)
#        ssh-claude beast3   → beast3
ssh-claude() {
  if command -v fleet >/dev/null 2>&1; then fleet attach "${1:-beast4}"
  else ssh "${1:-beast4}" -t "tmux new -As claude 'bash -lc claude'"; fi
}

# Auto-trust the current dir before launching claude so the workspace-trust
# dialog never interrupts. Pairs with `"defaultMode": "bypassPermissions"`
# in ~/.claude/settings.json — together: zero prompts, anywhere.
# Safe-fails: if ~/.claude.json is missing or unreadable, just exec claude (claude
# itself will then prompt once — better than wiping the file with `{}`).
claude() {
  python3 - "$PWD" <<'PY' 2>/dev/null || true
import json, os, sys
p = os.path.expanduser("~/.claude.json")
if not os.path.exists(p):
    sys.exit(0)
d = json.load(open(p))   # let JSONDecodeError exit nonzero — DO NOT clobber
proj = d.setdefault("projects", {}).setdefault(sys.argv[1], {
  "allowedTools": [], "mcpContextUris": [], "mcpServers": {},
  "enabledMcpjsonServers": [], "disabledMcpjsonServers": [],
  "projectOnboardingSeenCount": 1,
  "hasClaudeMdExternalIncludesApproved": False,
  "hasClaudeMdExternalIncludesWarningShown": False,
})
proj["hasTrustDialogAccepted"] = True
json.dump(d, open(p, "w"), indent=2)
PY
  command claude "$@"
}

# chief — jump to the chief vault (the entry point to everything) and launch claude there.
chief() { cd ~/projects/chief && claude "$@"; }
