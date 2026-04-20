HOST ?= $(shell scutil --get LocalHostName 2>/dev/null || hostname -s)

.PHONY: update

update:
	sudo darwin-rebuild switch --flake .#$(HOST)
