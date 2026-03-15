# tmux

<!-- vim-md-toc format=bullets ignore=^TODO$ -->
* [Commands](#commands)
* [Key bindings](#key-bindings)
  * [Built-in keys](#built-in-keys)
  * [Custom keys in this setup](#custom-keys-in-this-setup)
* [Plugins](#plugins)
  * [TPM](#tpm)
  * [tmux-resurrect](#tmux-resurrect)
  * [tmux-continuum](#tmux-continuum)
  * [vim-tmux-navigator](#vim-tmux-navigator)
  * [tmux-sessionx](#tmux-sessionx)
  * [tmux-yank](#tmux-yank)
  * [tmux-copycat](#tmux-copycat)
* [Config files in this setup](#config-files-in-this-setup)
<!-- vim-md-toc END -->

## Commands

- `tmux`
- `tmux ls`
- `tmux attach -t <name>`
- `tmux source-file ~/.tmux.conf`

## Key bindings

### Built-in keys

- Main docs: [github.com/tmux/tmux/wiki](https://github.com/tmux/tmux/wiki)
- Cheat sheet: [tmuxcheatsheet.com](https://tmuxcheatsheet.com/)

These are the built-in ones I actually use a lot:

- `prefix + c`
  - new window
- `prefix + d`
  - detach
- `prefix + ,`
  - rename window
- `prefix + %`
  - split horizontally
- `prefix + "`
  - split vertically
- `prefix + o`
  - move to next pane
- `prefix + w`
  - window list
- `prefix + q`
  - show pane numbers
- `prefix + x`
  - kill pane
- `prefix + z`
  - zoom pane
- `prefix + [`
  - enter copy mode
- `prefix + ]`
  - paste

### Custom keys in this setup

- `prefix + r`
  - reload config
- `prefix + O`
  - open `tmux-sessionx`
- `C-S-Left`
  - swap window left
- `C-S-Right`
  - swap window right
- `F12`
  - pass local tmux keys through to a remote tmux session

## Selected plugins and usage

### TPM

- Docs: [github.com/tmux-plugins/tpm](https://github.com/tmux-plugins/tpm)
- What it does:
  - installs and updates the plugins declared in [`dotfiles/.tmux/plugins.tmux`](/Users/osh/projects/mac/dotfiles/.tmux/plugins.tmux)
- Keys:
  - `prefix + I` install plugins
  - `prefix + U` update plugins
  - `prefix + A-u` clean removed plugins

### tmux-resurrect

- Docs: [github.com/tmux-plugins/tmux-resurrect](https://github.com/tmux-plugins/tmux-resurrect)
- What it does:
  - saves and restores tmux sessions, panes, and windows

### tmux-continuum

- Docs: [github.com/tmux-plugins/tmux-continuum](https://github.com/tmux-plugins/tmux-continuum)
- What it does:
  - automatically saves and restores tmux state using `tmux-resurrect`

### vim-tmux-navigator

- Docs: [github.com/christoomey/vim-tmux-navigator](https://github.com/christoomey/vim-tmux-navigator)
- What it does:
  - lets Vim/Neovim and tmux share pane navigation more cleanly
- Keys:
  - `C-h`
  - `C-j`
  - `C-k`
  - `C-l`
  - `C-\\`

### tmux-sessionx

- Docs: [github.com/omerxx/tmux-sessionx](https://github.com/omerxx/tmux-sessionx)
- What it does:
  - fuzzy session and project picker
- Key:
  - `prefix + O`

### tmux-yank

- Docs: [github.com/tmux-plugins/tmux-yank](https://github.com/tmux-plugins/tmux-yank)
- What it does:
  - copies from tmux into the system clipboard
- Keys:
  - `prefix + y`
    - copy text from the command line to the clipboard
  - `prefix + Y`
    - copy the current pane working directory to the clipboard
  - in copy mode, `y`
    - copy the current selection to the clipboard
- Typical usage:
  - `prefix + [` to enter copy mode
  - make a selection in copy mode
  - press `y` to send it to the macOS clipboard

### tmux-copycat

- Docs: [github.com/tmux-plugins/tmux-copycat](https://github.com/tmux-plugins/tmux-copycat)
- What it does:
  - searches and jumps through visible tmux output
- Keys:
  - `prefix + /`
    - regex or string search
  - `prefix + ctrl-f`
    - file path search
  - `prefix + ctrl-g`
    - git status file search
  - `prefix + A-h`
    - commit/hash search
  - `prefix + ctrl-u`
    - URL search
  - `prefix + ctrl-d`
    - number search
  - `prefix + A-i`
    - IP address search
  - in copycat mode:
    - `t` next match *(custom binding)*
    - `g` previous match *(custom binding)*
    - `Enter` copy highlighted match in vi mode
- Typical usage:
  - after `git status`, use `prefix + ctrl-g` to jump through changed files
  - after `git log`, use `prefix + A-h` to jump through commit hashes
  - on output with links, use `prefix + ctrl-u` to jump through URLs
  - pair it with `tmux-yank` when you want the match copied straight to the clipboard

## Config files in this setup

- main config: [`dotfiles/.tmux.conf`](/Users/osh/projects/mac/dotfiles/.tmux.conf)
- supporting config: [`dotfiles/.tmux`](/Users/osh/projects/mac/dotfiles/.tmux)
