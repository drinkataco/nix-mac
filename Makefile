HOST ?= watts

.PHONY: update

update:
	git pull --ff-only
	sudo darwin-rebuild switch --flake .#$(HOST)
