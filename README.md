# dotfiles

[dotbot](https://github.com/anishathalye/dotbot)-managed dotfiles for Mac + Linux beasts.
Source of truth for `~/.tmux.conf`, `~/.claude/settings.json`, `~/.agents/.skill-lock.json`,
shell config, git config.

## Usage

```bash
git clone https://github.com/kengz/dotfiles.git ~/projects/dotfiles
cd ~/projects/dotfiles
./install
```

Idempotent — re-run any time. Pulls submodules and installs fonts as part of the run.

## What gets installed

Symlinks (managed by dotbot — edits propagate via `git pull && ./install`):
- `~/.dotfiles` → repo root
- `~/.tmux.conf` → `tmux.conf` (login-shell default-command, `allow-passthrough` guarded behind tmux ≥ 3.3, Claude Code passthrough/extkeys)
- `~/.gitconfig` → `gitconfig` (credential helper `!gh auth git-credential` — portable, no `osxkeychain`)
- `~/.zsh` / `~/.zshrc` → `zsh/` / `zshrc` (shell config on Mac + beasts; `brew shellenv` is guarded so beasts skip it. Remote-session control moved out of here to the [`claude-fleet`](https://github.com/kengz/claude-fleet) CLI — `claude-fleet attach <host>` replaces the retired `ssh-claude` helper.)
- `~/.agents/.skill-lock.json` → `.agents/.skill-lock.json` (skill manifest — the **only** skill data tracked in the repo)

Per-machine copies (NOT symlinked — local edits stay local):
- `~/.claude/settings.json` ← copied from `.claude/settings.json` on first install.
  Claude writes `/theme`, `/model` etc. here; symlinking would push those edits
  back into the repo. To pick up upstream changes: `rm ~/.claude/settings.json &&
  ./install`.

Per-machine populated (NOT in repo):
- `~/.agents/skills/*` ← skill content is **un-vendored**. `./install` reads
  `~/.agents/.skill-lock.json` and runs `npx skills add -g <source> --skill <name>`
  for any skill **missing** locally (already-present skills are skipped, so re-runs
  are true no-ops with no git drift). To add a new skill fleet-wide: run
  `npx skills add -g <source> --skill <name>` on Mac → lock updates → commit + push
  → on each box `git pull && ./install` pulls just the new entry.

## Fleet workflow

After a Mac-side edit:
```bash
cd ~/projects/dotfiles && git add -A && git commit -m '…' && git push
for h in beast3 beast4 beast5; do
  ssh $h 'cd ~/projects/dotfiles && git pull && ./install'
done
```

## Fresh-box prereqs

- `git`, `python3` (for the skills restore loop), `node` + `npm` (for `npx skills`)
- `tmux` (the persistent `claude` session lives in tmux)
- On Mac: Homebrew (for fonts etc.)
- Skills install needs `gh auth login` to have happened so private/restricted
  source repos can be cloned by `npx skills`

The home-lab repo's `scripts/setup-beast.sh` handles all of this for fresh Ubuntu beasts.

## Manual Mac extras (one-time)

- [1Password](https://1password.com/downloads/mac/)
- [Bear](https://bear.app/)
- [Ghostty](https://ghostty.org/)
- VSCode (sign in to sync)
