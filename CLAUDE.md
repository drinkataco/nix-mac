# nix-mac

Personal nix-darwin + home-manager configuration for my Macs. Flake-based.

## Hosts
- `watts` — personal machine
- `work` — work machine (`hosts/work/default.nix`)
- Host is auto-detected from `scutil --get LocalHostName`; override with `HOST=`.

## Rebuild / validate
- Dry build (validate, no changes): `make dry-run HOST=<host>`
- Full build + closure diff vs active system: `make compare HOST=<host>`
- Apply (needs sudo, my call): `make update HOST=<host>` → `darwin-rebuild switch --flake '.#<host>'`
- Update inputs: `make upgrade`

**Always validate `.nix` edits with `make dry-run` (or the `nix-checker` agent) before committing. A broken flake blocks the next `darwin-rebuild switch`.** Never run `make update`/`switch` yourself.

## Dotfiles are out-of-store symlinks
`modules/home/dotfiles.nix` recursively walks `dotfiles/` and links every file into `$HOME` via `mkOutOfStoreSymlink` (e.g. `dotfiles/.claude/settings.json` → `~/.claude/settings.json`). Consequences:
- New files under `dotfiles/` become live symlinks after the next rebuild — no per-file nix wiring needed.
- Edits to a linked file take effect immediately (it points back at the repo), so I can iterate without rebuilding.
- Directories are not managed as link targets; individual files are. Runtime-noisy dirs (karabiner, PCSX2) are `exceptions` with `force = true`.

## Layout
- `flake.nix` — entry; builds `darwinConfigurations` per host.
- `hosts/<host>/` — per-host config.
- `modules/darwin/` — system-level (homebrew, nix-core, apps).
- `modules/home/` — home-manager (incl. `dotfiles.nix`).
- `dotfiles/` — the actual dotfile sources that get symlinked, including `.claude/`.
- `scripts/` — provisioning/install helpers.

## Claude config lives here too
My global Claude Code setup is version-controlled under `dotfiles/.claude/` (settings, agents, this repo's guide). Editing those files here is editing my live `~/.claude/` config.
