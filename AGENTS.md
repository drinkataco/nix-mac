# AGENTS

## Purpose

This repo manages a personal macOS machine with `nix-darwin` and Home Manager.

The goals are:

- reproducibility: the machine should be rebuildable from the repo
- support: configuration should be easy to inspect and repair later
- efficiency: common tools, apps, and shell/editor workflows should come up quickly and predictably

This is not a "rewrite every config into Nix" repo. The preferred model is declarative where that pays off, and native config files where that remains the clearest interface.

## Repo shape

The repo is split into a few clear layers:

- `flake.nix`: top-level inputs and host outputs
- `hosts/`: host-specific entrypoints
- `modules/darwin/`: system-level macOS and package configuration
- `modules/home/`: Home Manager modules, file linking, and small activation hooks
- `dotfiles/`: native config files linked into `$HOME`
- `scripts/`: repo utilities and recovery helpers
- `docs/`: quick-reference documentation for the actual workflows in use

Current host assumptions:

- primary host: `watts`
- user: `osh`
- platform: `aarch64-darwin`

## Configuration style

Prefer the simplest layer that solves the problem cleanly.

- use Nix for packages, system settings, and reproducible machine setup
- use Home Manager to link dotfiles and run small user-level activation tasks
- keep app configuration in its native file format under `dotfiles/`
- only introduce custom Nix packaging when a tool or app cannot be managed cleanly through normal package sources

Avoid translating an existing native config into Nix unless there is a strong reason to do so.

## Dotfiles model

The repo is intentionally file-based.

- files under `dotfiles/` are the source of truth for shell, editor, terminal, tmux, and similar user configuration
- Home Manager links that tree into `$HOME`
- changes should usually be made in the repo, not in generated or copied locations

Examples:

- shell: `dotfiles/.zshrc`, `dotfiles/.zsh/`
- terminal: `dotfiles/.config/alacritty/`
- editor: `dotfiles/.config/nvim/`
- multiplexer: `dotfiles/.tmux.conf`, `dotfiles/.tmux/`

## Editing expectations

Keep changes small, coherent, and easy to reason about.

- preserve existing structure unless there is a clear improvement
- prefer straightforward solutions over clever abstractions
- add comments when they help a human understand intent, not to narrate obvious syntax
- keep shell scripts readable and boring
- keep documentation concise and task-focused

When changing config:

- keep the established style of the file
- avoid mixing unrelated cleanup into a functional change
- do not add speculative tooling or framework layers without a concrete use case

## Docs

Docs in this repo are quick references, not long-form tutorials.

Prefer:

- commands that are actually used
- keybindings that are easy to forget
- plugin links and command links that help extend or debug the setup

Avoid:

- generic product overviews
- long explanatory prose about background components
- documenting passive configuration that the user does not interact with directly

## Rebuild and recovery

Standard rebuild for the main host:

```bash
sudo darwin-rebuild switch --flake '.#watts'
```

Fallback when `darwin-rebuild` is not available on `PATH`:

```bash
sudo nix run nix-darwin/master#darwin-rebuild -- switch --flake '.#watts'
```

The repo also contains recovery helpers in `scripts/` for machine-state problems such as Nix daemon availability.

## Commit discipline

- use plain, specific commit messages
- keep commits scoped to one coherent change
- do not include unrelated working tree changes without intent
- check the working tree before committing, especially for local notes or draft docs
