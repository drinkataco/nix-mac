HOST ?= $(shell scutil --get LocalHostName 2>/dev/null || hostname -s)
SYSTEM_PROFILE ?= /nix/var/nix/profiles/system

.PHONY: update dry-run compare

update:
	sudo darwin-rebuild switch --flake '.#$(HOST)'

dry-run:
	nix build --dry-run '.#darwinConfigurations.$(HOST).system'

compare:
	nix build '.#darwinConfigurations.$(HOST).system'
	nix store diff-closures '$(SYSTEM_PROFILE)' ./result
