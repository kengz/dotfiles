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

# Attach to the persistent claude tmux session on a beast.
# Idempotent: attaches if the session exists, creates+starts claude if not
# (matches the systemd --user unit, but works even if that unit is down or
# the session was killed).
# Usage: ssh-claude          → beast4 (default)
#        ssh-claude beast3   → beast3
ssh-claude() {
  ssh "${1:-beast4}" -t "tmux new -As claude 'bash -lc claude'"
}
