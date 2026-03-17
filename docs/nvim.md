# nvim

<!-- vim-md-toc format=bullets ignore=^TODO$ -->
* [General docs](#general-docs)
* [General usage](#general-usage)
* [Core plugins](#core-plugins)
  * [Git and workflow](#git-and-workflow)
  * [Search and navigation](#search-and-navigation)
* [Editor keymaps](#editor-keymaps)
  * [Core](#core)
  * [Files and tabs](#files-and-tabs)
  * [LSP](#lsp)
* [Config files in this setup](#config-files-in-this-setup)
<!-- vim-md-toc END -->

## General docs

- [neovim.io](https://neovim.io/)
- [neovim.io/doc](https://neovim.io/doc/)
- [neovim.io/doc/user/quickref.html](https://neovim.io/doc/user/quickref.html)
- [vimhelp.org](https://vimhelp.org/)

## General usage

- Search commands:
  - `:Commands`
  - or type `:` then press `Tab`
- View help:
  - `:help`
  - `:help <topic>`
  - `:Helptags`
- View keymaps:
  - `:map`
  - `:nmap`
  - `:imap`
  - `:verbose map <lhs>`
  - example: `:verbose map <leader>ff`

## Core plugins

### Git and workflow

- `vim-fugitive`
  - docs: [github.com/tpope/vim-fugitive](https://github.com/tpope/vim-fugitive)
  - Example Commands:
    - [`:Git`](https://github.com/tpope/vim-fugitive?tab=readme-ov-file#:Git)
    - [`:Git blame`](https://github.com/tpope/vim-fugitive?tab=readme-ov-file#:Git_blame)
    - [`:Gvdiffsplit`](https://github.com/tpope/vim-fugitive?tab=readme-ov-file#:Gdiffsplit)
  - Custom Keymaps:
    - `<leader>gg`: runs `:Git` and opens Fugitive status
    - `<leader>gs`: runs `:Git` and opens Fugitive status
    - `<leader>gb`: runs `:Git blame` and opens blame for the current buffer
    - `<leader>gd`: runs `:Gvdiffsplit` and opens a vertical Git diff split

### Search and navigation

- `fzf`
  - docs: [github.com/junegunn/fzf](https://github.com/junegunn/fzf)
- `fzf.vim`
  - docs: [github.com/junegunn/fzf.vim](https://github.com/junegunn/fzf.vim)
  - Example Commands:
    - [`:Files`](https://github.com/junegunn/fzf.vim?tab=readme-ov-file#files)
    - [`:GitFiles`](https://github.com/junegunn/fzf.vim?tab=readme-ov-file#gitfiles)
    - [`:Buffers`](https://github.com/junegunn/fzf.vim?tab=readme-ov-file#buffers)
    - [`:BLines`](https://github.com/junegunn/fzf.vim?tab=readme-ov-file#lines)
    - [`:History`](https://github.com/junegunn/fzf.vim?tab=readme-ov-file#history)
    - [`:Commands`](https://github.com/junegunn/fzf.vim?tab=readme-ov-file#commands)
    - [`:Helptags`](https://github.com/junegunn/fzf.vim?tab=readme-ov-file#helptags)
    - [`:Ag`](https://github.com/junegunn/fzf.vim?tab=readme-ov-file#ag-rg)
  - Custom Keymaps:
    - `<leader><space>`: prefers `:GitFiles`, falls back to `:Files`, and finds files in the current repo or directory
    - `<leader>ff`: prefers `:GitFiles`, falls back to `:Files`, and finds files in the current repo or directory
    - `<leader>fa`: runs `:Files` and finds all files
    - `<leader>fb`: runs `:Buffers` and searches open buffers
    - `<leader>fh`: runs `:Helptags` and searches Neovim help tags
    - `<leader>fl`: runs `:BLines` and searches lines in the current buffer
    - `<leader>fr`: runs `:History` and searches recent files
    - `<leader>fi`: runs `:Ag` and searches project contents
    - `<leader>/`: runs `:Ag` and searches project contents
    - `<leader>fc`: runs `:Commands` and searches available commands
    - `<leader>gc`: runs `:BCommits` and searches commits for the current buffer

## Editor keymaps

### Core

- `<leader>p`
  - format current buffer

### Files and tabs

- `<leader>e`
  - explore files
- `<leader>ev`
  - explore files in vsplit
- `<leader>eh`
  - explore files in split
- `<leader>et`
  - explore files in new tab
- `<leader>tn`
  - new tab
- `<leader>to`
  - close other tabs
- `<leader>tq`
  - close current tab
- `<leader>th`
  - previous tab
- `<leader>tl`
  - next tab
- `<leader>gx`
  - open lazygit in a new tab
- `<leader>gl`
  - open lazygit in a new tab

### LSP

- `gd`
  - go to definition
- `gr`
  - list references
- `K`
  - hover docs
- `<leader>rn`
  - rename symbol
- `<leader>ca`
  - code action
- `[d`
  - previous diagnostic
- `]d`
  - next diagnostic

## Config files in this setup

- config directory: [`dotfiles/.config/nvim`](/Users/osh/projects/mac/dotfiles/.config/nvim)
- plugin list: [`dotfiles/.config/nvim/lua/plugins/list.lua`](/Users/osh/projects/mac/dotfiles/.config/nvim/lua/plugins/list.lua)
