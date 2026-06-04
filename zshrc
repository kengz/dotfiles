# PATH
export PATH="$HOME/.local/bin:$PATH"
# npm user-prefix (where claude-code installs on the boxes; absent/ignored on Mac)
[ -d "$HOME/.npm-global/bin" ] && export PATH="$HOME/.npm-global/bin:$PATH"

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

# Fleet control is the `claude-fleet` CLI (its own repo/plugin). `claude-fleet
# attach <host>` replaces the old ssh-claude helper — attach, status, send, up;
# driven the same way by you and by chief (parity). Put its bin on PATH directly
# (no symlink — reproducible across machines); takes whichever clone is present.
for d in "$HOME/projects/private-claude-fleet/bin" "$HOME/projects/claude-fleet/bin"; do
  [ -d "$d" ] && export PATH="$d:$PATH"
done

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
# Takes whichever clone is present (command center vs a box), so it's machine-agnostic.
chief() {
  for d in "$HOME/projects/private-chief" "$HOME/projects/chief"; do
    [ -d "$d" ] && { cd "$d" && claude "$@"; return; }
  done
  echo "chief: no vault found (~/projects/private-chief or ~/projects/chief)" >&2
}
