# cli

<!-- vim-md-toc format=bullets ignore=^TODO$ -->
* [fzf](#fzf)
  * [Docs](#docs)
  * [Commands](#commands)
  * [Keys](#keys)
* [fzf-tab](#fzf-tab)
  * [Docs](#docs)
  * [Keys](#keys)
  * [Notes](#notes)
* [oh-my-zsh git plugin](#oh-my-zsh-git-plugin)
  * [Docs](#docs)
  * [Commands](#commands)
* [Config files in this setup](#config-files-in-this-setup)
<!-- vim-md-toc END -->

## fzf

### Docs

- [github.com/junegunn/fzf](https://github.com/junegunn/fzf)

### Commands

- `fzf`
  - fuzzy-pick from stdin
- `git branch | fzf`
- `fd | fzf`
- `history 0 | fzf`
- `tmux ls | fzf`

### Keys

- `C-T`
  - pick files
- `C-R`
  - search shell history
- `A-C`
  - jump to directories

## fzf-tab

### Docs

- [github.com/Aloxaf/fzf-tab](https://github.com/Aloxaf/fzf-tab)

### Keys

- `<TAB>`
  - enhanced completion for commands like `cd`, `git checkout`, `git add`

### Notes

- loaded after `compinit`
- uses `bat` for file previews
- uses `eza` for directory previews
- Git completion previews are configured in [`dotfiles/.zsh/completions.zsh`](/Users/osh/projects/mac/dotfiles/.zsh/completions.zsh)

## oh-my-zsh git plugin

### Docs

- [github.com/ohmyzsh/ohmyzsh/tree/master/plugins/git](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/git)

### Commands

- `gst`
  - `git status`
- `gp`
  - `git push`
- `gcam "message"`
  - `git commit -a -m "message"`
- `gcmsg "message"`
  - `git commit -m "message"`
- `gaa`
  - `git add --all`
- `gl`
  - `git pull`
- `gco <branch>`
  - `git checkout <branch>`
- `gcb <branch>`
  - `git checkout -b <branch>`

## Config files in this setup

- shell entrypoint: [`dotfiles/.zshrc`](/Users/osh/projects/mac/dotfiles/.zshrc)
- completions: [`dotfiles/.zsh/completions.zsh`](/Users/osh/projects/mac/dotfiles/.zsh/completions.zsh)
- plugins: [`dotfiles/.zsh/plugins.zsh`](/Users/osh/projects/mac/dotfiles/.zsh/plugins.zsh)
- CLI init: [`dotfiles/.zsh/cli.zsh`](/Users/osh/projects/mac/dotfiles/.zsh/cli.zsh)
