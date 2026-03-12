# nix-mac

Nix-based macOS configuration for a MacBook Pro.

## Getting started

### Bootstrap

For a fresh Mac, use the following command to install prerequisites, clone this
repo, and run the first `nix-darwin` switch.

The bootstrap script installs upstream Nix, and this repo is configured so
`nix-darwin` manages Nix itself. The installer path follows the official macOS
instructions from `nix.dev`.


```bash
curl -fsSL https://raw.githubusercontent.com/drinkataco/nix-mac/main/scripts/bootstrap.sh | bash
```

### Installing

After the repo is on the machine, apply changes with:

```bash
sudo darwin-rebuild switch --flake .#watts
```

### Resetting Nix

If a machine already has a different Nix installation and you want to reset it
onto the repo's expected upstream Nix install, use:

```bash
curl -fsSL https://raw.githubusercontent.com/drinkataco/nix-mac/main/scripts/reset-nix.sh | bash
```

## Structure

- `flake.nix`: repository entrypoint and input wiring.
- `lib/`: small helpers for composing hosts.
- `hosts/`: machine-specific configuration.
- `modules/darwin/`: system-level macOS and `nix-darwin` modules.

## First host

The initial host is `watts` and assumes Apple Silicon (`aarch64-darwin`).
If you want a different hostname, rename the directory under `hosts/` and the
matching entry in `flake.nix`.

Current focus:

- Finder, Dock, Desktop: `modules/darwin/defaults/`
- host-specific names and hardware assumptions: `hosts/`
- applications and shell config later
