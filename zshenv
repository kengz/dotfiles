# Tool PATH lives here, not in .zshrc: zsh reads .zshenv for EVERY shell —
# including the non-interactive ones behind `ssh host '<cmd>'`. A tool path set
# only in .zshrc is invisible to remote invocation, which silently falls back to
# whatever else happens to be on the default PATH.
typeset -U path PATH  # keep entries unique

export PATH="$HOME/.local/bin:$PATH"

# npm user-prefix — the single Claude Code install on the boxes.
# Never also install it system-wide (`sudo npm i -g`): /usr/bin/claude then
# shadows this one for non-login shells and the two drift out of version sync.
[ -d "$HOME/.npm-global/bin" ] && export PATH="$HOME/.npm-global/bin:$PATH"

# claude-fleet CLI (its own repo/plugin) — bin on PATH directly, no symlink, so
# it is reproducible across machines; takes whichever clone is present.
for d in "$HOME/projects/private-claude-fleet/bin" "$HOME/projects/claude-fleet/bin"; do
  [ -d "$d" ] && export PATH="$d:$PATH"
done
