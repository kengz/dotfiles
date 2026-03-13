# Homebrew
eval "$(~/homebrew/bin/brew shellenv)"

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
