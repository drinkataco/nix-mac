# nix-mac

A nix-based macOS setup for my machines.

This repo uses:

- [nix-darwin](https://github.com/nix-darwin/nix-darwin) for macOS system configuration
- [nix-homebrew](https://github.com/zhaofengli/nix-homebrew) for Homebrew installation
- [Home Manager](https://github.com/nix-community/home-manager) for symlinking file-based dotfiles from this repo into `$HOME`

## Getting started

### Bootstrap

For a fresh Mac, use this to prepare the machine, install Nix, clone this repo, and run the first `nix-darwin` provision.

The bootstrap script installs upstream Nix, and this repo is set up so `nix-darwin` manages Nix itself.

The installer path follows the official macOS instructions from [nix.dev](https://nix.dev/install-nix.html).

```bash
curl -fsSL
    https://raw.githubusercontent.com/drinkataco/nix-mac/main/bootstrap.sh \
    | bash
```

The bootstrap flow does this:

1. install Xcode Command Line Tools if needed
2. clone or update this repo into `~/projects/nix-mac`
3. run `scripts/install.sh` - install nix
4. run `scripts/provision.sh` - provision machine

Useful variants:

```bash
bash bootstrap.sh --no-provision
bash bootstrap.sh --no-install
bash scripts/install.sh
bash scripts/provision.sh --hostname watts
bash scripts/uninstall.sh
```

### Updating

Once the repo is on the machine, the normal update flow is:

```bash
make update
```

This does:

1. `git pull --ff-only` - ensures latest changes are pulled down
2. `sudo darwin-rebuild switch --flake .#watts`

If `darwin-rebuild` is not on your `PATH`, the fallback is:

```bash
sudo nix run nix-darwin/master#darwin-rebuild -- switch --flake .#watts
```

### Uninstalling Nix

If a machine already has a different Nix installation and I want to reset it back to the repo's expected upstream Nix install, run:

```bash
bash scripts/uninstall.sh
```

## Structure

- `hosts/`: host-specific config
- `modules/darwin/`: macOS system config
- `modules/home/`: Home Manager bits for user-level file linking and hooks
- `dotfiles/`: file-based dotfiles and config

The initial host is `watts` and assumes Apple Silicon (`aarch64-darwin`).
If you want a different hostname, rename the directory under `hosts/` and the
matching entry in `flake.nix`.

## Dotfiles

Dotfiles live in this repo as normal files and are symlinked into `$HOME` by Home Manager.

## Background

A new macbook, a brand new slate right?

It felt a good time to start a fresh installation that transcends just using my previous [dotfiles](https://github.com/drinkataco/dotfiles/) repository. How can I try and automate simple configuration of my mac, such as how the dock and finder behaves?

The goal is pretty simple:

- use Nix where it improves reproducibility
- keep dotfiles as normal files
- avoid rewriting file-based config into Nix unless there is a clear benefit
- Try and use AI, but with a benefit of driving learning, and steering it to use sensible defaults and to understand each change. AI fatigue is real, and natural language and prompt engineering can be very tiring.
