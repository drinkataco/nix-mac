# Default to the current macOS local hostname, but allow overrides with HOST=work.
HOST ?= $(shell scutil --get LocalHostName 2>/dev/null || hostname -s)

# Active nix-darwin system profile to compare against.
SYSTEM_PROFILE ?= /nix/var/nix/profiles/system

.PHONY: update dry-run compare

update:
	sudo darwin-rebuild switch --flake '.#$(HOST)'

dry-run:
	nix build --dry-run '.#darwinConfigurations.$(HOST).system'

# Compare the built system closure with the currently active nix-darwin profile.
compare:
	nix build '.#darwinConfigurations.$(HOST).system'
	nix store diff-closures '$(SYSTEM_PROFILE)' ./result
