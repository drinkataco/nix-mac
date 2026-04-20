HOST ?= $(shell scutil --get LocalHostName 2>/dev/null || hostname -s)

.PHONY: update dry-run

update:
	sudo darwin-rebuild switch --flake .#$(HOST)

dry-run:
	nix build --dry-run .#darwinConfigurations.$(HOST).system
